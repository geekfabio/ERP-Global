import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/audit/api_audit_repository.dart';
import 'package:erp_global/core/audit/audit_log_model.dart';
import 'package:erp_global/core/audit/audit_mock_handlers.dart';
import 'package:erp_global/core/audit/audit_page.dart';
import 'package:erp_global/core/audit/audit_providers.dart';
import 'package:erp_global/core/audit/audit_repository.dart';
import 'package:erp_global/core/audit/audit_service.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

const _actor = AuditActor(id: 'U1', name: 'Ana Silva', institutionId: 'mock');

ApiClient _client(MockApiRegistry registry) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: registry,
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

({ApiAuditRepository repo, AuditService service}) _env({
  AuditActor? actor = _actor,
}) {
  final registry = MockApiRegistry()..addModule(AuditMockHandlers());
  final repo = ApiAuditRepository(_client(registry));
  final service = AuditService(
    repository: repo,
    actor: () => actor,
    now: () => DateTime.utc(2030, 1, 1, 10),
  );
  return (repo: repo, service: service);
}

void main() {
  group('AuditLogModel', () {
    test('serializa o enum em snake_case e datas em UTC', () {
      final log = AuditLogModel(
        id: 'X',
        institutionId: 'mock',
        createdAt: DateTime.utc(2026, 3, 1, 8),
        actorId: 'U1',
        actorName: 'Ana',
        entity: 'student',
        action: AuditAction.reopen,
        before: const {'a': 1},
      );
      final json = log.toJson();
      expect(json['action'], 'reopen');
      expect(json['createdAt'], '2026-03-01T08:00:00.000Z');
      expect(AuditLogModel.fromJson(json), log);
    });
  });

  group('seed', () {
    test('é determinístico', () {
      expect(
        buildAuditSeed(seed: 3, count: 30),
        buildAuditSeed(seed: 3, count: 30),
      );
    });
  });

  group('AuditService + API mock', () {
    test('record grava utilizador, entidade, antes e depois', () async {
      final e = _env();
      final r = await e.service.record(
        entity: 'invoice',
        action: AuditAction.cancel,
        entityId: 'INV1',
        before: const {'status': 'paid'},
        after: const {'status': 'cancelled'},
      );
      final saved = r.valueOrNull!;
      expect(saved.actorId, 'U1');
      expect(saved.actorName, 'Ana Silva');
      expect(saved.createdAt, DateTime.utc(2030, 1, 1, 10));

      final page = (await e.repo.list(
        const AuditQuery(entity: 'invoice', action: AuditAction.cancel),
      )).valueOrNull!;
      expect(page.items.where((l) => l.entityId == 'INV1'), hasLength(1));
      expect(page.items.firstWhere((l) => l.entityId == 'INV1').after, {
        'status': 'cancelled',
      });
    });

    test('sem sessão devolve AuthFailure e não grava', () async {
      final e = _env(actor: null);
      final before = (await e.repo.list(const AuditQuery())).valueOrNull!;
      final r = await e.service.record(
        entity: 'student',
        action: AuditAction.delete,
      );
      expect(r.failureOrNull, isA<AuthFailure>());
      final after = (await e.repo.list(const AuditQuery())).valueOrNull!;
      expect(after.meta.total, before.meta.total);
    });

    test('lista: mais recentes primeiro, paginada', () async {
      final e = _env();
      final p = (await e.repo.list(
        const AuditQuery(pageSize: 10),
      )).valueOrNull!;
      expect(p.items, hasLength(10));
      expect(p.meta.total, 120);
      final dates = p.items.map((l) => l.createdAt).toList();
      expect([...dates]..sort((a, b) => b.compareTo(a)), dates);
    });

    test('filtra por recurso, acção e utilizador', () async {
      final e = _env();
      final byEntity = (await e.repo.list(
        const AuditQuery(entity: 'grade', pageSize: 100),
      )).valueOrNull!;
      expect(byEntity.items, isNotEmpty);
      expect(byEntity.items.every((l) => l.entity == 'grade'), isTrue);

      final byAction = (await e.repo.list(
        const AuditQuery(action: AuditAction.delete, pageSize: 100),
      )).valueOrNull!;
      expect(
        byAction.items.every((l) => l.action == AuditAction.delete),
        isTrue,
      );

      final actorId = byEntity.items.first.actorId;
      final byActor = (await e.repo.list(
        AuditQuery(actorId: actorId, pageSize: 100),
      )).valueOrNull!;
      expect(byActor.items.every((l) => l.actorId == actorId), isTrue);
    });

    test('filtra por intervalo de datas (to exclusivo)', () async {
      final e = _env();
      final from = DateTime.utc(2026, 1, 10);
      final to = DateTime.utc(2026, 1, 20);
      final p = (await e.repo.list(
        AuditQuery(from: from, to: to, pageSize: 100),
      )).valueOrNull!;
      expect(p.items, isNotEmpty);
      expect(
        p.items.every(
          (l) => !l.createdAt.isBefore(from) && l.createdAt.isBefore(to),
        ),
        isTrue,
      );
    });

    test('pesquisa por texto ignora acentos e maiúsculas', () async {
      final e = _env();
      final p = (await e.repo.list(
        const AuditQuery(q: 'SECRETARIA'),
      )).valueOrNull!;
      expect(p.items, isNotEmpty);
      expect(p.items.every((l) => l.actorName.contains('Secretaria')), isTrue);
    });

    test('entrada inválida → 422', () async {
      final registry = MockApiRegistry()..addModule(AuditMockHandlers());
      final r = await ApiAuditRepository(_client(registry)).record(
        AuditLogModel(
          id: 'X',
          institutionId: 'mock',
          createdAt: DateTime.utc(2026),
          actorId: '',
          actorName: '',
          entity: '',
          action: AuditAction.create,
        ),
      );
      expect(r.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('AuditPage', () {
    List<Override> overrides(List<String> permissions) => [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [AuditMockHandlers()]),
      apiClientProvider.overrideWith(
        (ref) => _client(ref.watch(mockApiRegistryProvider)),
      ),
    ];

    Future<ProviderContainer> pump(
      WidgetTester tester,
      List<String> permissions,
    ) async {
      await PtAoFormatters.initialize();
      tester.view.physicalSize = const Size(2600, 1200);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(overrides: overrides(permissions));
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: AuditPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('mostra registos e filtra por acção', (tester) async {
      final c = await pump(tester, const ['core.audit.read']);
      expect(find.text('Auditoria'), findsOneWidget);
      expect(
        tester.widget<DataTable>(find.byType(DataTable)).rows,
        hasLength(20),
      );

      await tester.tap(find.byKey(const Key('audit_filter_action')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remoção').last);
      await tester.pumpAndSettle();
      expect(c.read(auditQueryProvider).action, AuditAction.delete);
      expect(find.text('Limpar filtros'), findsOneWidget);

      await tester.tap(find.text('Limpar filtros'));
      await tester.pumpAndSettle();
      expect(c.read(auditQueryProvider).hasFilters, isFalse);
    });

    testWidgets('abre o detalhe com antes/depois', (tester) async {
      await pump(tester, const ['*']);
      await tester.tap(find.text('Tesouraria').first);
      await tester.pumpAndSettle();
      expect(find.text('Antes'), findsOneWidget);
      expect(find.text('Depois'), findsOneWidget);
    });

    testWidgets('sem permissão não mostra a auditoria', (tester) async {
      await pump(tester, const ['students.*']);
      expect(find.text('Sem permissão'), findsOneWidget);
      expect(find.byType(DataTable), findsNothing);
    });
  });
}
