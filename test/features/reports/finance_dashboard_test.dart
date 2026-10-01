import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/data/repositories/api_reports_repository.dart';
import 'package:erp_global/features/reports/presentation/pages/finance_dashboard_page.dart';
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

const _all = {'billing', 'accounting'};

({
  String yearId,
  String? termId,
  String? campusId,
  String? compareYearId,
  String? compareTermId,
})
_q({String? compareYear, String? campus, String? term = 't1'}) => (
  yearId: 'y26',
  termId: term,
  campusId: campus,
  compareYearId: compareYear,
  compareTermId: compareYear == null ? null : term,
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('finance overview API', () {
    test('agrega por mês e os totais batem certo', () async {
      final repo = ApiReportsRepository(_client());
      final o = (await repo.financeOverview(_q())).getOrThrow();
      expect(o.rows, hasLength(4));
      expect(o.totals.expected, o.rows.fold<int>(0, (s, r) => s + r.expected));
      expect(
        o.totals.collected,
        o.rows.fold<int>(0, (s, r) => s + r.collected),
      );
      expect(o.totals.debt, o.totals.expected - o.totals.collected);
      expect(o.totals.defaultRate, inInclusiveRange(0, 100));
      expect(o.totals.receivables, o.totals.debt);
      expect(o.totals.result, o.totals.collected - o.totals.payables!);
      expect(o.previous, isNull);
      expect((await repo.financeOverview(_q())).getOrThrow(), o);
    });

    test('sem trimestre devolve o ano todo', () async {
      final repo = ApiReportsRepository(_client());
      final o = (await repo.financeOverview(_q(term: null))).getOrThrow();
      expect(o.rows, hasLength(11));
    });

    test(
      'comparação devolve totais anteriores e campus altera valores',
      () async {
        final repo = ApiReportsRepository(_client());
        final base = (await repo.financeOverview(_q())).getOrThrow();
        final cmp = (await repo.financeOverview(
          _q(compareYear: 'y25'),
        )).getOrThrow();
        expect(cmp.previous, isNotNull);
        expect(cmp.previous, isNot(base.totals));
        final other = (await repo.financeOverview(
          _q(campus: 'c2'),
        )).getOrThrow();
        expect(other.totals, isNot(base.totals));
      },
    );

    test('sem contabilidade omite os campos contabilísticos', () async {
      final repo = ApiReportsRepository(_client(licensed: {'billing'}));
      final o = (await repo.financeOverview(_q())).getOrThrow();
      expect(o.totals.receivables, isNull);
      expect(o.totals.payables, isNull);
      expect(o.totals.result, isNull);
    });

    test('sem facturação falha com módulo não licenciado', () async {
      final repo = ApiReportsRepository(_client(licensed: {'accounting'}));
      final r = await repo.financeOverview(_q());
      expect(r.failureOrNull, isA<Failure>());
    });
  });

  group('FinanceDashboardPage', () {
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
            home: const Scaffold(body: FinanceDashboardPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('mostra os KPIs financeiros, contabilísticos e a tabela', (
      tester,
    ) async {
      await pump(tester);
      for (final k in [
        'kpi_collected',
        'kpi_expected',
        'kpi_debt',
        'kpi_default_rate',
        'kpi_receivables',
        'kpi_payables',
        'kpi_result',
      ]) {
        expect(find.byKey(ValueKey(k)), findsOneWidget, reason: k);
      }
      expect(find.byKey(const ValueKey('finance_table')), findsOneWidget);
      expect(find.text('Set'), findsWidgets);
    });

    testWidgets('esconde KPIs de contabilidade sem o módulo', (tester) async {
      await pump(tester, modules: {'billing'});
      expect(find.byKey(const ValueKey('kpi_result')), findsNothing);
      expect(find.byKey(const ValueKey('kpi_payables')), findsNothing);
      expect(find.byKey(const ValueKey('kpi_collected')), findsOneWidget);
    });

    testWidgets('alternar a série do gráfico', (tester) async {
      await pump(tester);
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('chart_metric')),
          matching: find.text('Recebido'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const ValueKey('chart_collected')), findsOneWidget);
    });
  });
}
