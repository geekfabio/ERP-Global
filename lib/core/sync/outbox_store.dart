import 'package:drift/drift.dart';

import '../database/app_database.dart';
import 'sync_models.dart';

/// Acesso à fila `sync_outbox` (Drift). Quem escreve entradas são os
/// repositories locais; o motor de sync lê, marca erros e remove o enviado.
class OutboxStore {
  const OutboxStore(this._db);

  final AppDatabase _db;

  $SyncOutboxTable get _t => _db.syncOutbox;

  /// Todas as entradas por ordem de criação.
  Future<List<OutboxEntry>> all() async => _map(
    await (_db.select(_t)..orderBy([(t) => OrderingTerm.asc(t.seq)])).get(),
  );

  Stream<List<OutboxEntry>> watchAll() => (_db.select(
    _t,
  )..orderBy([(t) => OrderingTerm.asc(t.seq)])).watch().map(_map);

  Future<OutboxCounts> counts() async => _counts(await all());

  Stream<OutboxCounts> watchCounts() => watchAll().map(_counts);

  /// Estado de um registo: `error` se alguma entrada falhou, `pending` se há
  /// alterações por enviar, `ok` caso contrário.
  Future<SyncStatus> statusOf(String entity, String entityId) async {
    final rows =
        await (_db.select(_t)..where(
              (t) => t.entity.equals(entity) & t.entityId.equals(entityId),
            ))
            .get();
    if (rows.isEmpty) return SyncStatus.ok;
    return rows.any((r) => r.status == 'error')
        ? SyncStatus.error
        : SyncStatus.pending;
  }

  /// Marca as entradas como falhadas (conta uma tentativa).
  Future<void> markError(Iterable<int> seqs, String message) async {
    await _db.customUpdate(
      'UPDATE sync_outbox SET status = ?, last_error = ?, attempts = attempts + 1 '
      'WHERE seq IN (${seqs.map((_) => '?').join(',')})',
      variables: [
        Variable.withString('error'),
        Variable.withString(message),
        for (final s in seqs) Variable.withInt(s),
      ],
      updates: {_t},
    );
  }

  /// Volta a pôr em `pending` as entradas em erro de um registo.
  Future<void> retry(String entity, String entityId) =>
      (_db.update(_t)..where(
            (t) => t.entity.equals(entity) & t.entityId.equals(entityId),
          ))
          .write(
            const SyncOutboxCompanion(
              status: Value('pending'),
              lastError: Value(null),
            ),
          );

  Future<void> retryAll() =>
      (_db.update(_t)..where((t) => t.status.equals('error'))).write(
        const SyncOutboxCompanion(
          status: Value('pending'),
          lastError: Value(null),
        ),
      );

  /// Remove entradas enviadas (ou descartadas pelo utilizador).
  Future<void> remove(Iterable<int> seqs) =>
      (_db.delete(_t)..where((t) => t.seq.isIn(seqs.toList()))).go();

  Future<void> discard(String entity, String entityId) => (_db.delete(
    _t,
  )..where((t) => t.entity.equals(entity) & t.entityId.equals(entityId))).go();

  static List<OutboxEntry> _map(List<OutboxRow> rows) =>
      rows.map(OutboxEntry.fromRow).toList();

  static OutboxCounts _counts(List<OutboxEntry> all) {
    // Conta registos, não linhas: várias edições do mesmo aluno valem uma.
    final pending = <String>{};
    final error = <String>{};
    for (final e in all) {
      (e.status == OutboxStatus.error ? error : pending).add(
        '${e.entity}/${e.entityId}',
      );
    }
    pending.removeAll(error);
    return OutboxCounts(pending: pending.length, error: error.length);
  }
}
