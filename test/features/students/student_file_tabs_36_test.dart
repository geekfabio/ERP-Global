import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/audit/audit_log_model.dart';
import 'package:erp_global/core/audit/audit_mock_handlers.dart';
import 'package:erp_global/core/audit/audit_providers.dart';
import 'package:erp_global/core/audit/audit_service.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/students/data/data_mocks/student_summaries_seed.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_summaries_model.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/student_file_rules.dart';
import 'package:erp_global/features/students/presentation/pages/student_file_page.dart';
import 'package:erp_global/features/students/presentation/providers/student_file_providers.dart';
import 'package:erp_global/features/students/presentation/widgets/student_file/tabs/timeline_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

final _student = buildStudentsSeed(seed: 42, count: 20).students.first;

const _allPermissions = [
  'students.*',
  'grades.entry.read',
  'attendance.record.read',
  'billing.invoice.read',
  'cards.card.read',
];

const _allModules = {'students', 'grades', 'attendance', 'billing', 'cards'};

const _actor = AuditActor(
  id: 'u1',
  name: 'Secretaria Teste',
  institutionId: 'mock',
);

class _Env {
  _Env() {
    registry
      ..addModule(StudentsMockHandlers(count: 20))
      ..addModule(AuditMockHandlers(count: 0));
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
  }

  final registry = MockApiRegistry();
  late final ApiClient client;
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('regras', () {
    test('médias ignoram trimestres sem nota', () {
      const s = SubjectGrades(subject: 'M', term1: 10, term2: 14);
      expect(subjectAverage(s), 12);
      expect(subjectAverage(const SubjectGrades(subject: 'x')), isNull);
      expect(
        overallAverage([s, const SubjectGrades(subject: 'P', term1: 16)]),
        14,
      );
      expect(overallAverage(const []), isNull);
    });

    test('presenças e dívidas (dinheiro em int)', () {
      final records = [
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 2),
          kind: AttendanceKind.late,
        ),
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 3),
          kind: AttendanceKind.late,
        ),
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 4),
          kind: AttendanceKind.present,
        ),
      ];
      final counts = attendanceCounts(records);
      expect(counts[AttendanceKind.late], 2);
      expect(counts[AttendanceKind.justified], 0);

      StudentChargeLine charge(int amount, int paid, StudentChargeStatus s) =>
          StudentChargeLine(
            id: '$amount$s',
            description: 'x',
            dueOn: DateTime.utc(2026, 1, 5),
            amountMinor: amount,
            paidMinor: paid,
            status: s,
          );
      final charges = [
        charge(100000, 100000, StudentChargeStatus.paid),
        charge(100000, 25000, StudentChargeStatus.overdue),
        charge(50000, 0, StudentChargeStatus.open),
      ];
      expect(outstandingMinor(charges), 125000);
      expect(overdueMinor(charges), 75000);
    });
  });

  group('API mock', () {
    test('vistas são determinísticas e 404 para aluno inexistente', () async {
      final repo = ApiStudentSummaryRepository(_Env().client);
      final a = (await repo.grades(_student.id)).getOrThrow();
      final b = (await repo.grades(_student.id)).getOrThrow();
      expect(a, b);
      expect(a.subjects, isNotEmpty);
      expect(
        (await repo.attendance(_student.id)).getOrThrow().records,
        hasLength(40),
      );
      expect(
        (await repo.finance(_student.id)).getOrThrow().charges,
        hasLength(6),
      );
      expect((await repo.card(_student.id)).getOrThrow().cardNumber, isNotNull);
      expect((await repo.finance('nope')).failureOrNull, isNotNull);
    });

    test('seed do cartão e financeiro: valores inteiros', () {
      final seed = StudentSummariesSeed(now: DateTime.utc(2026, 5, 10));
      final f = seed.finance('abc');
      expect(f.charges.every((c) => c.amountMinor > 0), isTrue);
      expect(seed.finance('abc'), f);
      expect(seed.finance('abd'), isNot(f)); // outro aluno, outros dados
    });
  });

  group('separadores', () {
    Future<ProviderContainer> pump(
      WidgetTester tester, {
      String tab = 'grades',
      Set<String> modules = _allModules,
      List<String> permissions = _allPermissions,
    }) async {
      tester.view.physicalSize = const Size(2600, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final env = _Env();
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          licenseGateProvider.overrideWithValue(
            LicenseGate(enabledModules: modules),
          ),
          apiClientProvider.overrideWithValue(env.client),
          auditActorProvider.overrideWithValue(_actor),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            scaffoldMessengerKey: rootMessengerKey,
            builder: (context, child) => ToastHost(child: child!),
            home: Scaffold(
              body: StudentFilePage(studentId: _student.id, initialTab: tab),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    Finder tabKey(String id) => find.byKey(Key('student_tab_$id'));

    testWidgets('módulos licenciados mostram os 5 separadores', (tester) async {
      await pump(tester);
      for (final id in [
        'grades',
        'attendance',
        'finance',
        'card',
        'timeline',
      ]) {
        expect(tabKey(id), findsOneWidget, reason: id);
      }
    });

    testWidgets('tab oculta se o módulo não está licenciado', (tester) async {
      await pump(tester, tab: 'timeline', modules: {'students'});
      for (final id in ['grades', 'attendance', 'finance', 'card']) {
        expect(tabKey(id), findsNothing, reason: id);
      }
      // O histórico é do próprio módulo `students`.
      expect(tabKey('timeline'), findsOneWidget);
    });

    testWidgets('licenciar só `billing` mostra só o Financeiro', (
      tester,
    ) async {
      await pump(tester, tab: 'finance', modules: {'students', 'billing'});
      expect(tabKey('finance'), findsOneWidget);
      expect(tabKey('grades'), findsNothing);
      expect(tabKey('card'), findsNothing);
    });

    testWidgets('sem permissão de leitura o separador não aparece', (
      tester,
    ) async {
      await pump(tester, permissions: const ['students.record.read']);
      expect(tabKey('grades'), findsNothing);
      expect(tabKey('finance'), findsNothing);
      expect(tabKey('timeline'), findsNothing);
    });

    testWidgets('Notas: disciplinas, média geral e boletins', (tester) async {
      await pump(tester);
      expect(find.text('Língua Portuguesa'), findsOneWidget);
      expect(find.byKey(const Key('grades_overall')), findsOneWidget);
      expect(find.text('1.º trimestre'), findsOneWidget);
    });

    testWidgets('Assiduidade: totais e registos', (tester) async {
      await pump(tester, tab: 'attendance');
      expect(find.text('Falta justificada'), findsWidgets);
      expect(find.text('Presente'), findsWidgets);
    });

    testWidgets('Financeiro: dívida e cobranças', (tester) async {
      await pump(tester, tab: 'finance');
      expect(find.text('Total em dívida'), findsOneWidget);
      expect(find.textContaining('Propina'), findsWidgets);
    });

    testWidgets('Cartão: número, saldo e acessos', (tester) async {
      await pump(tester, tab: 'card');
      expect(find.text('Saldo do refeitório'), findsOneWidget);
      expect(find.text('Entrada'), findsWidgets);
    });

    testWidgets('Histórico: mostra só a auditoria deste aluno', (tester) async {
      final c = await pump(tester, tab: 'timeline');
      expect(find.text('Sem histórico'), findsOneWidget);

      final audit = c.read(auditServiceProvider);
      // O mock usa Futures reais: fora do relógio falso do testWidgets.
      await tester.runAsync(() async {
        await audit.record(
          entity: 'student',
          entityId: _student.id,
          action: AuditAction.update,
          before: {'phone': '1', 'email': 'a'},
          after: {'phone': '2', 'email': 'a'},
        );
        await audit.record(
          entity: 'student',
          entityId: 'outro-aluno',
          action: AuditAction.update,
        );
      });
      c.invalidate(studentTimelineProvider(_student.id));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();

      expect(find.text('Alterado por Secretaria Teste'), findsOneWidget);
      expect(find.textContaining('Campos: phone'), findsOneWidget);
      expect(find.textContaining('email'), findsNothing);
    });

    test('changedFields só devolve nomes dos campos alterados', () {
      final log = AuditLogModel(
        id: '1',
        institutionId: 'mock',
        createdAt: DateTime.utc(2026, 1, 1),
        actorId: 'u',
        actorName: 'U',
        entity: 'student',
        action: AuditAction.update,
        before: {'a': 1, 'b': 2},
        after: {'a': 1, 'b': 3, 'c': 4},
      );
      expect(changedFields(log), ['b', 'c']);
    });
  });
}
