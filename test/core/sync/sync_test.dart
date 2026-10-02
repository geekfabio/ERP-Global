import 'dart:convert';

import 'package:drift/drift.dart' hide isNull;
import 'package:drift/native.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/database/app_database.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/sync/api_sync_repository.dart';
import 'package:erp_global/core/sync/conflict_resolver.dart';
import 'package:erp_global/core/sync/outbox_store.dart';
import 'package:erp_global/core/sync/sync_binding.dart';
import 'package:erp_global/core/sync/sync_engine.dart';
import 'package:erp_global/core/sync/sync_mock_handlers.dart';
import 'package:erp_global/core/sync/sync_models.dart';
import 'package:erp_global/core/sync/sync_page.dart';
import 'package:erp_global/core/sync/sync_providers.dart';
import 'package:erp_global/core/sync/sync_repository.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _id = '01SYNC00000000000000000001';
const _t0 = '2030-01-01T10:00:00.000Z';
const _t1 = '2030-01-01T11:00:00.000Z';
const _t2 = '2030-01-01T12:00:00.000Z';

Map<String, dynamic> _student({
  String name = 'Ana',
  String phone = '900',
  String updatedAt = _t0,
}) => {
  'id': _id,
  'institutionId': 'mock',
  'fullName': name,
  'phone': phone,
  'health': {'allergies': 'nenhuma'},
  'updatedAt': updatedAt,
};

class _FakeBinding implements SyncEntityBinding {
  _FakeBinding(this.entity);

  @override
  final String entity;
  final synced = <String, Map<String, dynamic>?>{};
  final applied = <String, Map<String, dynamic>>{};
  final purged = <String>[];

  @override
  Future<void> markSynced(String id, Map<String, dynamic>? record) async =>
      synced[id] = record;

  @override
  Future<void> applyServer(String id, Map<String, dynamic> server) async =>
      applied[id] = server;

  @override
  Future<void> purge(String id) async => purged.add(id);
}

/// Repositório que falha sempre com [failure].
class _FailingRepo implements SyncRepository {
  _FailingRepo(this.failure);

  final Failure failure;
  var calls = 0;

  @override
  Future<Result<PushResult>> push(OutboxBatch batch) async {
    calls++;
    return Err(failure);
  }

  @override
  Future<Result<Map<String, dynamic>>> fetch(String e, String id) async =>
      Err(failure);
}

ApiClient _client(MockApiRegistry registry) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: registry,
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

class _Env {
  _Env() {
    db = AppDatabase(NativeDatabase.memory());
    store = OutboxStore(db);
    server = SyncMockHandlers(now: () => DateTime.utc(2030, 1, 1, 20));
    repo = ApiSyncRepository(_client(MockApiRegistry()..addModule(server)));
  }

  late final AppDatabase db;
  late final OutboxStore store;
  late final SyncMockHandlers server;
  late final ApiSyncRepository repo;
  final binding = _FakeBinding('student');

  SyncEngine engine({
    SyncRepository? repository,
    ConflictPolicies policies = const ConflictPolicies(),
    String entity = 'student',
  }) => SyncEngine(
    outbox: store,
    repository: repository ?? repo,
    bindings: [entity == 'student' ? binding : _FakeBinding(entity)],
    policies: policies,
  );

  Future<void> enqueue(
    SyncOperation op,
    Map<String, dynamic> payload, {
    Map<String, dynamic>? base,
    String entity = 'student',
    String id = _id,
  }) => db
      .into(db.syncOutbox)
      .insert(
        SyncOutboxCompanion.insert(
          entity: entity,
          entityId: id,
          operation: op.name,
          payload: Value(jsonEncode(payload)),
          baseJson: Value(base == null ? null : jsonEncode(base)),
          createdAt: DateTime.utc(2030, 1, 1, 9),
        ),
      );

  Future<void> close() => db.close();
}

void main() {
  group('resolveConflict', () {
    test('fusão por campo: cada lado mantém o que alterou face à base', () {
      final r = resolveConflict(
        policy: ConflictPolicy.fieldMerge,
        localIsDelete: false,
        base: _student(),
        local: _student(name: 'Ana Maria', updatedAt: _t1),
        server: _student(phone: '911', updatedAt: _t2),
      );
      expect(r.acceptServer, isFalse);
      expect(r.merged['fullName'], 'Ana Maria');
      expect(r.merged['phone'], '911');
      expect(r.clashedFields, isEmpty);
    });

    test('mesmo campo nos dois lados: ganha o mais recente', () {
      Map<String, dynamic> run(String localAt, String serverAt) {
        return resolveConflict(
          policy: ConflictPolicy.fieldMerge,
          localIsDelete: false,
          base: _student(),
          local: _student(phone: '922', updatedAt: localAt),
          server: _student(phone: '911', updatedAt: serverAt),
        ).merged;
      }

      expect(run(_t2, _t1)['phone'], '922'); // local mais recente
      expect(run(_t1, _t2)['phone'], '911'); // servidor mais recente
      expect(run(_t1, _t1)['phone'], '911'); // empate: servidor
    });

    test('choque regista os campos e, se o servidor ganha, nada se envia', () {
      final r = resolveConflict(
        policy: ConflictPolicy.fieldMerge,
        localIsDelete: false,
        base: _student(),
        local: _student(phone: '922', updatedAt: _t1),
        server: _student(phone: '911', updatedAt: _t2),
      );
      expect(r.clashedFields, ['phone']);
      expect(r.acceptServer, isTrue);
    });

    test('sem base, campos diferentes são choques (mais recente ganha)', () {
      final r = resolveConflict(
        policy: ConflictPolicy.fieldMerge,
        localIsDelete: false,
        local: _student(name: 'Local', updatedAt: _t2),
        server: _student(name: 'Servidor', updatedAt: _t1),
      );
      expect(r.merged['fullName'], 'Local');
      expect(r.clashedFields, ['fullName']);
    });

    test('compara objectos aninhados por valor', () {
      final r = resolveConflict(
        policy: ConflictPolicy.fieldMerge,
        localIsDelete: false,
        base: _student(),
        local: {
          ..._student(updatedAt: _t1),
          'health': {'allergies': 'nenhuma'},
        },
        server: _student(updatedAt: _t2),
      );
      expect(r.acceptServer, isTrue);
      expect(r.clashedFields, isEmpty);
    });

    test('financeiro: o servidor decide e a alteração local cai', () {
      final server = _student(phone: '911', updatedAt: _t2);
      final r = resolveConflict(
        policy: ConflictPolicy.serverWins,
        localIsDelete: false,
        base: _student(),
        local: _student(name: 'Outro', updatedAt: _t2),
        server: server,
      );
      expect(r.acceptServer, isTrue);
      expect(r.merged, server);
    });

    test('remoção local em conflito: aceita o servidor', () {
      final r = resolveConflict(
        policy: ConflictPolicy.fieldMerge,
        localIsDelete: true,
        local: _student(),
        server: _student(phone: '911', updatedAt: _t2),
      );
      expect(r.acceptServer, isTrue);
    });

    test('ConflictPolicies: financeiro é serverWins, resto fieldMerge', () {
      const p = ConflictPolicies();
      expect(p.of('invoice'), ConflictPolicy.serverWins);
      expect(p.of('payment'), ConflictPolicy.serverWins);
      expect(p.of('student'), ConflictPolicy.fieldMerge);
      expect(
        const ConflictPolicies(
          overrides: {'student': ConflictPolicy.serverWins},
        ).of('student'),
        ConflictPolicy.serverWins,
      );
    });
  });

  group('coalesceOutbox', () {
    OutboxEntry e(
      int seq,
      SyncOperation op, {
      String id = _id,
      OutboxStatus status = OutboxStatus.pending,
      Map<String, dynamic> payload = const {'v': 1},
    }) => OutboxEntry(
      seq: seq,
      entity: 'student',
      entityId: id,
      operation: op,
      payload: payload,
      createdAt: DateTime.utc(2030),
      status: status,
    );

    test('create + updates → um create com o último payload', () {
      final r = coalesceOutbox([
        e(1, SyncOperation.create),
        e(2, SyncOperation.update, payload: const {'v': 2}),
        e(3, SyncOperation.update, payload: const {'v': 3}),
      ]);
      expect(r.batches, hasLength(1));
      expect(r.batches.single.operation, SyncOperation.create);
      expect(r.batches.single.payload, {'v': 3});
      expect(r.batches.single.seqs, [1, 2, 3]);
    });

    test('updates + delete → delete; create + delete → descartado', () {
      final r = coalesceOutbox([
        e(1, SyncOperation.update),
        e(2, SyncOperation.delete, payload: const {}),
        e(3, SyncOperation.create, id: 'B'),
        e(4, SyncOperation.delete, id: 'B', payload: const {}),
      ]);
      expect(r.batches.single.operation, SyncOperation.delete);
      expect(r.dropped.single.entityId, 'B');
    });

    test('registo com entrada em erro fica bloqueado', () {
      final r = coalesceOutbox([
        e(1, SyncOperation.update, status: OutboxStatus.error),
        e(2, SyncOperation.update),
        e(3, SyncOperation.update, id: 'B'),
      ]);
      expect(r.batches.map((b) => b.entityId), ['B']);
    });
  });

  group('SyncEngine', () {
    late _Env env;
    setUp(() => env = _Env());
    tearDown(() => env.close());

    test('envia create e limpa a outbox', () async {
      await env.enqueue(SyncOperation.create, _student());
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(await env.store.all(), isEmpty);
      expect(env.server.record('student', _id)!['fullName'], 'Ana');
      expect(env.binding.synced[_id]!['syncState'], 'synced');
    });

    test('create repetido é idempotente', () async {
      env.server.putRecord('student', _student());
      await env.enqueue(SyncOperation.create, _student(name: 'Outra'));
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(env.server.record('student', _id)!['fullName'], 'Ana');
    });

    test('várias edições do mesmo registo viram um só envio', () async {
      await env.enqueue(SyncOperation.create, _student());
      await env.enqueue(SyncOperation.update, _student(name: 'Ana B'));
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(env.server.record('student', _id)!['fullName'], 'Ana B');
      expect(await env.store.all(), isEmpty);
    });

    test('create seguido de delete nunca chega ao servidor', () async {
      await env.enqueue(SyncOperation.create, _student());
      await env.enqueue(SyncOperation.delete, const {});
      final report = await env.engine().run();
      expect(report.synced, 0);
      expect(env.server.record('student', _id), isNull);
      expect(env.binding.purged, [_id]);
      expect(await env.store.all(), isEmpty);
    });

    test('sem rede: pára, mantém pendente e não conta como erro', () async {
      await env.enqueue(SyncOperation.update, _student(), base: _student());
      final repo = _FailingRepo(NetworkFailure());
      final report = await env.engine(repository: repo).run();
      expect(report.offline, isTrue);
      final left = await env.store.all();
      expect(left.single.status, OutboxStatus.pending);
      expect(left.single.attempts, 0);
    });

    test('sessão inválida: pára sem marcar erro', () async {
      await env.enqueue(SyncOperation.update, _student(), base: _student());
      final report = await env
          .engine(repository: _FailingRepo(AuthFailure()))
          .run();
      expect(report.authRequired, isTrue);
      expect((await env.store.all()).single.status, OutboxStatus.pending);
    });

    test('conflito de baixo risco: funde por campo e reenvia', () async {
      env.server.putRecord('student', _student(phone: '911', updatedAt: _t1));
      await env.enqueue(
        SyncOperation.update,
        _student(name: 'Ana Maria', updatedAt: _t2),
        base: _student(),
      );
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(report.conflicts.single.acceptedServer, isFalse);
      final saved = env.server.record('student', _id)!;
      expect(saved['fullName'], 'Ana Maria');
      expect(saved['phone'], '911');
      expect(env.binding.synced[_id]!['fullName'], 'Ana Maria');
      expect(await env.store.all(), isEmpty);
    });

    test('conflito financeiro: servidor decide, local é descartado', () async {
      final serverRecord = {
        ..._student(phone: '911', updatedAt: _t1),
        'amount': 5000,
      };
      env.server.putRecord('invoice', serverRecord);
      await env.enqueue(
        SyncOperation.update,
        {..._student(updatedAt: _t2), 'amount': 1},
        base: {..._student(), 'amount': 5000},
        entity: 'invoice',
      );
      final engine = env.engine(entity: 'invoice');
      final report = await engine.run();
      expect(report.conflicts.single.policy, ConflictPolicy.serverWins);
      expect(report.conflicts.single.acceptedServer, isTrue);
      expect(env.server.record('invoice', _id)!['amount'], 5000);
      expect(await env.store.all(), isEmpty);
    });

    test('update sem base conflita e resolve pelo mais recente', () async {
      env.server.putRecord('student', _student(phone: '911', updatedAt: _t1));
      await env.enqueue(
        SyncOperation.update,
        _student(phone: '922', updatedAt: _t2),
      );
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(env.server.record('student', _id)!['phone'], '922');
    });

    test('remoção em conflito aceita o servidor', () async {
      env.server.putRecord('student', _student(phone: '911', updatedAt: _t1));
      await env.enqueue(SyncOperation.delete, const {}, base: _student());
      final report = await env.engine().run();
      expect(report.conflicts.single.acceptedServer, isTrue);
      expect(env.binding.applied[_id]!['phone'], '911');
      expect(env.server.record('student', _id)!['deletedAt'], isNull);
    });

    test('registo removido no servidor: erro para o utilizador', () async {
      await env.enqueue(SyncOperation.update, _student(), base: _student());
      final report = await env.engine().run();
      expect(report.failed, 1);
      final e = (await env.store.all()).single;
      expect(e.status, OutboxStatus.error);
      expect(e.attempts, 1);
      expect(e.lastError, isNotEmpty);
    });

    test('erro bloqueia o registo até repetir; repetir envia', () async {
      await env.enqueue(SyncOperation.update, _student(), base: _student());
      await env.engine().run();
      await env.enqueue(SyncOperation.update, _student(name: 'Ana C'));
      expect(await env.store.statusOf('student', _id), SyncStatus.error);

      final blocked = await env.engine().run();
      expect(blocked.blocked, 1);
      expect(blocked.synced, 0);

      env.server.putRecord('student', _student(updatedAt: _t1));
      await env.store.retry('student', _id);
      final report = await env.engine().run();
      expect(report.synced, 1);
      expect(env.server.record('student', _id)!['fullName'], 'Ana C');
      expect(await env.store.statusOf('student', _id), SyncStatus.ok);
    });

    test('entidade sem ligação fica em erro', () async {
      await env.enqueue(SyncOperation.create, _student(), entity: 'grade');
      final report = await env.engine().run();
      expect(report.failed, 1);
      expect((await env.store.all()).single.status, OutboxStatus.error);
    });

    test('descartar repõe a versão do servidor e limpa a outbox', () async {
      env.server.putRecord('student', _student(phone: '911', updatedAt: _t1));
      await env.enqueue(SyncOperation.update, _student(phone: '1'));
      final result = await env.engine().discard('student', _id);
      expect(result.isOk, isTrue);
      expect(env.binding.applied[_id]!['phone'], '911');
      expect(await env.store.all(), isEmpty);
    });

    test('descartar um create nunca enviado apaga o registo local', () async {
      await env.enqueue(SyncOperation.create, _student());
      await env.engine().discard('student', _id);
      expect(env.binding.purged, [_id]);
      expect(await env.store.all(), isEmpty);
    });

    test('descartar sem rede falha e mantém a outbox', () async {
      await env.enqueue(SyncOperation.update, _student());
      final result = await env
          .engine(repository: _FailingRepo(NetworkFailure()))
          .discard('student', _id);
      expect(result.failureOrNull, isA<NetworkFailure>());
      expect(await env.store.all(), hasLength(1));
    });
  });

  group('OutboxStore', () {
    test('conta registos por estado (não linhas)', () async {
      final env = _Env();
      addTearDown(env.close);
      await env.enqueue(SyncOperation.update, _student());
      await env.enqueue(SyncOperation.update, _student());
      await env.enqueue(SyncOperation.update, _student(), id: 'B');
      await env.store.markError([3], 'falhou');
      final c = await env.store.counts();
      expect((c.pending, c.error), (1, 1));
      await env.store.retryAll();
      expect((await env.store.counts()).error, 0);
    });
  });

  group('SyncPage', () {
    Future<_Env> pump(
      WidgetTester tester,
      List<String> permissions, {
      Future<void> Function(_Env env)? seed,
    }) async {
      await PtAoFormatters.initialize();
      tester.view.physicalSize = const Size(1600, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final env = _Env();
      if (seed != null) await tester.runAsync(() => seed(env));
      addTearDown(() async {
        await tester.pumpWidget(const SizedBox());
        await tester.pump(const Duration(milliseconds: 10));
        await tester.runAsync(env.close);
      });
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          outboxStoreProvider.overrideWithValue(env.store),
          syncRepositoryProvider.overrideWithValue(env.repo),
          syncBindingsProvider.overrideWithValue([env.binding]),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: SyncPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return env;
    }

    testWidgets('sem permissão não mostra a fila', (tester) async {
      await pump(tester, const []);
      expect(find.text('Sem permissão'), findsOneWidget);
    });

    testWidgets('vazio mostra "Tudo sincronizado"', (tester) async {
      await pump(tester, const [syncManagePermission]);
      expect(find.text('Tudo sincronizado'), findsOneWidget);
    });

    testWidgets('lista pendentes e erros e permite repetir', (tester) async {
      await pump(
        tester,
        const [syncManagePermission],
        seed: (env) async {
          await env.enqueue(SyncOperation.update, _student(), base: _student());
          await env.enqueue(SyncOperation.create, _student(), id: 'B');
          await env.store.markError([1], 'Registo não encontrado.');
        },
      );
      expect(find.text('Erro'), findsOneWidget);
      expect(find.text('Pendente'), findsOneWidget);
      expect(find.textContaining('Registo não encontrado.'), findsOneWidget);
      expect(find.byKey(const Key('sync_retry_$_id')), findsOneWidget);
    });
  });
}
