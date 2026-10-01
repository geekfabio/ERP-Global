import '../errors/failure.dart';
import '../errors/result.dart';
import 'conflict_resolver.dart';
import 'outbox_store.dart';
import 'sync_binding.dart';
import 'sync_models.dart';
import 'sync_repository.dart';

/// Conflito resolvido durante uma sincronização.
class ResolvedConflict {
  const ResolvedConflict({
    required this.entity,
    required this.entityId,
    required this.policy,
    required this.acceptedServer,
    this.clashedFields = const [],
  });

  final String entity;
  final String entityId;
  final ConflictPolicy policy;

  /// `true` = a alteração local caiu; `false` = foi enviada fundida.
  final bool acceptedServer;
  final List<String> clashedFields;
}

/// Resultado de uma execução do motor.
class SyncReport {
  const SyncReport({
    this.synced = 0,
    this.failed = 0,
    this.blocked = 0,
    this.conflicts = const [],
    this.offline = false,
    this.authRequired = false,
  });

  final int synced;
  final int failed;

  /// Registos ignorados por terem uma entrada anterior em erro.
  final int blocked;
  final List<ResolvedConflict> conflicts;

  /// A execução parou por falta de rede (nada foi marcado como erro).
  final bool offline;

  /// A execução parou por sessão inválida.
  final bool authRequired;
}

/// Motor de sincronização: esvazia a outbox por ordem, resolve conflitos
/// segundo [ConflictPolicies] e marca erros para o utilizador tratar.
class SyncEngine {
  SyncEngine({
    required this._outbox,
    required SyncRepository repository,
    required Iterable<SyncEntityBinding> bindings,
    this.policies = const ConflictPolicies(),
  }) : _repo = repository,
       _bindings = {for (final b in bindings) b.entity: b};

  final OutboxStore _outbox;
  final SyncRepository _repo;
  final Map<String, SyncEntityBinding> _bindings;
  final ConflictPolicies policies;

  bool _running = false;

  /// Uma execução de cada vez; chamadas concorrentes devolvem um relatório vazio.
  bool get isRunning => _running;

  Future<SyncReport> run() async {
    if (_running) return const SyncReport();
    _running = true;
    try {
      return await _run();
    } finally {
      _running = false;
    }
  }

  Future<SyncReport> _run() async {
    final entries = await _outbox.all();
    final (:batches, :dropped) = coalesceOutbox(entries);
    final blocked =
        entries.map((e) => '${e.entity}/${e.entityId}').toSet().length -
        batches.length -
        dropped.length;

    var synced = 0;
    var failed = 0;
    final conflicts = <ResolvedConflict>[];
    SyncReport stop({bool offline = false, bool auth = false}) => SyncReport(
      synced: synced,
      failed: failed,
      blocked: blocked,
      conflicts: conflicts,
      offline: offline,
      authRequired: auth,
    );

    for (final d in dropped) {
      await _bindings[d.entity]?.purge(d.entityId);
      await _outbox.remove(d.seqs);
    }

    for (final batch in batches) {
      final binding = _bindings[batch.entity];
      if (binding == null) {
        await _fail(batch, 'Entidade "${batch.entity}" sem ligação de sync.');
        failed++;
        continue;
      }
      switch (await _process(batch, binding, conflicts)) {
        case _Outcome.synced:
          synced++;
        case _Outcome.failed:
          failed++;
        case _Outcome.offline:
          return stop(offline: true);
        case _Outcome.auth:
          return stop(auth: true);
      }
    }
    return stop();
  }

  Future<_Outcome> _process(
    OutboxBatch batch,
    SyncEntityBinding binding,
    List<ResolvedConflict> conflicts,
  ) async {
    final result = await _repo.push(batch);
    switch (result) {
      case Ok(:final value):
        await binding.markSynced(batch.entityId, value.record);
        await _outbox.remove(batch.seqs);
        return _Outcome.synced;
      case Err(:final failure):
        return _onFailure(batch, binding, failure, conflicts);
    }
  }

  Future<_Outcome> _onFailure(
    OutboxBatch batch,
    SyncEntityBinding binding,
    Failure failure,
    List<ResolvedConflict> conflicts,
  ) async {
    switch (failure) {
      case NetworkFailure():
        return _Outcome.offline;
      case AuthFailure():
        return _Outcome.auth;
      case UnknownFailure(code: 'CONFLICT'):
        return _resolve(batch, binding, failure, conflicts);
      default:
        await _fail(batch, failure.message);
        return _Outcome.failed;
    }
  }

  Future<_Outcome> _resolve(
    OutboxBatch batch,
    SyncEntityBinding binding,
    Failure original,
    List<ResolvedConflict> conflicts,
  ) async {
    final fetched = await _repo.fetch(batch.entity, batch.entityId);
    final Map<String, dynamic> server;
    switch (fetched) {
      case Ok(:final value):
        server = value;
      case Err(:final failure):
        if (failure is NetworkFailure) return _Outcome.offline;
        if (failure is AuthFailure) return _Outcome.auth;
        await _fail(
          batch,
          failure.code == 'NOT_FOUND' ? original.message : failure.message,
        );
        return _Outcome.failed;
    }

    final resolution = resolveConflict(
      policy: policies.of(batch.entity),
      localIsDelete: batch.operation == SyncOperation.delete,
      local: batch.payload,
      server: server,
      base: batch.base,
    );
    final logged = ResolvedConflict(
      entity: batch.entity,
      entityId: batch.entityId,
      policy: resolution.policy,
      acceptedServer: resolution.acceptServer,
      clashedFields: resolution.clashedFields,
    );

    if (resolution.acceptServer) {
      await binding.applyServer(batch.entityId, server);
      await _outbox.remove(batch.seqs);
      conflicts.add(logged);
      return _Outcome.synced;
    }

    // Reenvia a versão fundida contra o `updatedAt` que acabámos de ler.
    final retry = OutboxBatch(
      entity: batch.entity,
      entityId: batch.entityId,
      operation: SyncOperation.update,
      payload: resolution.merged,
      base: server,
      seqs: batch.seqs,
    );
    switch (await _repo.push(retry)) {
      case Ok(:final value):
        await binding.markSynced(batch.entityId, value.record);
        await _outbox.remove(batch.seqs);
        conflicts.add(logged);
        return _Outcome.synced;
      case Err(:final failure):
        if (failure is NetworkFailure) return _Outcome.offline;
        if (failure is AuthFailure) return _Outcome.auth;
        await _fail(
          batch,
          failure.code == 'CONFLICT'
              ? 'O registo continua a mudar noutro dispositivo. Tente de novo.'
              : failure.message,
        );
        return _Outcome.failed;
    }
  }

  /// Descarta as alterações locais de um registo e repõe a versão do servidor
  /// (ou apaga o registo se o servidor nunca o recebeu). Falha sem rede.
  Future<Result<void>> discard(String entity, String entityId) async {
    final binding = _bindings[entity];
    final all = await _outbox.all();
    final mine = all
        .where((e) => e.entity == entity && e.entityId == entityId)
        .toList();
    if (mine.isEmpty) return const Ok(null);
    final neverSynced = mine.first.operation == SyncOperation.create;
    if (!neverSynced) {
      switch (await _repo.fetch(entity, entityId)) {
        case Ok(:final value):
          await binding?.applyServer(entityId, value);
        case Err(:final failure):
          if (failure.code != 'NOT_FOUND') return Err(failure);
          await binding?.purge(entityId);
      }
    } else {
      await binding?.purge(entityId);
    }
    await _outbox.discard(entity, entityId);
    return const Ok(null);
  }

  Future<void> _fail(OutboxBatch batch, String message) =>
      _outbox.markError(batch.seqs, message);
}

enum _Outcome { synced, failed, offline, auth }
