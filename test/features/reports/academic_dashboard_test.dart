import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/data/repositories/api_reports_repository.dart';
import 'package:erp_global/features/reports/presentation/pages/academic_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client({Set<String>? licensed}) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(ReportsMockHandlers(enabledModules: () => licensed ?? _all)),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

const _all = {'students', 'academic', 'attendance'};

({
  String yearId,
  String? termId,
  String? campusId,
  String? compareYearId,
  String? compareTermId,
})
_q({String? compareYear, String? campus}) => (
  yearId: 'y26',
  termId: 't1',
  campusId: campus,
  compareYearId: compareYear,
  compareTermId: compareYear == null ? null : 't1',
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('academic overview API', () {
    test('agrega por classe e os totais batem certo', () async {
      final repo = ApiReportsRepository(_client());
      final o = (await repo.academicOverview(_q())).getOrThrow();
      expect(o.rows, hasLength(14));
      expect(o.totals.enrolled, o.rows.fold<int>(0, (s, r) => s + r.enrolled));
      expect(o.totals.active, o.rows.fold<int>(0, (s, r) => s + r.active));
      expect(o.totals.active, lessThanOrEqualTo(o.totals.enrolled));
      expect(o.rows.every((r) => r.enrolled <= r.capacity), isTrue);
      expect(o.previous, isNull);
      final again = (await repo.academicOverview(_q())).getOrThrow();
      expect(again, o);
    });

    test(
      'comparação devolve totais anteriores e campus altera valores',
      () async {
        final repo = ApiReportsRepository(_client());
        final base = (await repo.academicOverview(_q())).getOrThrow();
        final cmp = (await repo.academicOverview(
          _q(compareYear: 'y25'),
        )).getOrThrow();
        expect(cmp.previous, isNotNull);
        expect(cmp.previous, isNot(base.totals));
        final other = (await repo.academicOverview(
          _q(campus: 'c2'),
        )).getOrThrow();
        expect(other.totals, isNot(base.totals));
      },
    );

    test('sem módulo licenciado omite métricas; sem alunos falha', () async {
      final partial = ApiReportsRepository(_client(licensed: {'students'}));
      final o = (await partial.academicOverview(_q())).getOrThrow();
      expect(o.totals.approvalRate, isNull);
      expect(o.totals.attendanceRate, isNull);
      expect(o.rows.first.approvalRate, isNull);
      final none = ApiReportsRepository(_client(licensed: {'billing'}));
      final r = await none.academicOverview(_q());
      expect(r.failureOrNull, isA<Failure>());
    });
  });

  group('AcademicDashboardPage', () {
    Future<void> pump(WidgetTester tester, {Set<String> modules = _all}) async {
      tester.view.physicalSize = const Size(2000, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.runAsync(() async {});
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            periodChoicesProvider.overrideWith(
              (ref) async => const PeriodChoices([
                PeriodYear(
                  id: 'y26',
                  label: '2025/2026',
                  isActive: true,
                  terms: [PeriodTerm(id: 't1', label: '1.º Trimestre')],
                ),
              ]),
            ),
            apiClientProvider.overrideWith((ref) => _client(licensed: modules)),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: AcademicDashboardPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('mostra os cinco KPIs e a tabela por classe', (tester) async {
      await pump(tester);
      for (final k in [
        'kpi_enrolled',
        'kpi_active',
        'kpi_approval',
        'kpi_attendance',
        'kpi_occupancy',
      ]) {
        expect(find.byKey(ValueKey(k)), findsOneWidget, reason: k);
      }
      expect(find.byKey(const ValueKey('academic_table')), findsOneWidget);
      expect(find.text('Iniciação'), findsWidgets);
    });

    testWidgets('esconde KPIs de módulos não licenciados', (tester) async {
      await pump(tester, modules: {'students'});
      expect(find.byKey(const ValueKey('kpi_approval')), findsNothing);
      expect(find.byKey(const ValueKey('kpi_attendance')), findsNothing);
      expect(find.byKey(const ValueKey('kpi_enrolled')), findsOneWidget);
    });

    testWidgets('alternar o indicador do gráfico', (tester) async {
      await pump(tester);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('chart_metric')),
          matching: find.text('Aprovação'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('chart_approval')), findsOneWidget);
    });
  });
}
