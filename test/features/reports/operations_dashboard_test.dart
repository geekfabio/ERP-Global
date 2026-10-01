import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/data/repositories/api_reports_repository.dart';
import 'package:erp_global/features/reports/presentation/pages/operations_dashboard_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _all = {'students', 'cafeteria', 'access_control', 'hr'};

ApiClient _client({Set<String>? licensed}) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(ReportsMockHandlers(enabledModules: () => licensed ?? _all)),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

({String yearId, String? termId, String? campusId}) _q({String? campus}) =>
    (yearId: 'y26', termId: 't1', campusId: campus);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('operations overview API', () {
    test('agrega as quatro secções com totais coerentes', () async {
      final repo = ApiReportsRepository(_client());
      final o = (await repo.operationsOverview(_q())).getOrThrow();
      expect(
        o.cafeteria!.meals,
        o.cafeteria!.byMeal.fold<int>(0, (s, e) => s + e.count),
      );
      expect(
        o.access!.entries,
        o.access!.byHour.fold<int>(0, (s, e) => s + e.entries),
      );
      expect(
        o.hr!.activeStaff,
        o.hr!.byRole.fold<int>(0, (s, e) => s + e.count),
      );
      expect(
        o.secretariat!.totalPending,
        o.secretariat!.items.fold<int>(0, (s, e) => s + e.count),
      );
      expect((await repo.operationsOverview(_q())).getOrThrow(), o);
      final other = (await repo.operationsOverview(
        _q(campus: 'c2'),
      )).getOrThrow();
      expect(other.cafeteria, isNot(o.cafeteria));
    });

    test('omite secções não licenciadas; sem módulos falha', () async {
      final partial = ApiReportsRepository(_client(licensed: {'hr'}));
      final o = (await partial.operationsOverview(_q())).getOrThrow();
      expect(o.hr, isNotNull);
      expect(o.cafeteria, isNull);
      expect(o.access, isNull);
      expect(o.secretariat, isNull);
      final none = ApiReportsRepository(_client(licensed: {'billing'}));
      expect(
        (await none.operationsOverview(_q())).failureOrNull,
        isA<Failure>(),
      );
    });
  });

  group('OperationsDashboardPage', () {
    Future<void> pump(WidgetTester tester, {Set<String> modules = _all}) async {
      tester.view.physicalSize = const Size(2000, 2400);
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
            home: const Scaffold(body: OperationsDashboardPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    Future<void> select(WidgetTester tester, String label) async {
      await tester.tap(
        find.descendant(
          of: find.byKey(const ValueKey('operations_section')),
          matching: find.text(label),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('percorre as quatro secções', (tester) async {
      await pump(tester);
      expect(find.byKey(const ValueKey('kpi_prepaid')), findsOneWidget);
      expect(find.byKey(const ValueKey('operations_table')), findsOneWidget);
      await select(tester, 'Catracas');
      expect(find.byKey(const ValueKey('kpi_entries')), findsOneWidget);
      expect(find.text('07:00'), findsWidgets);
      await select(tester, 'RH');
      expect(find.byKey(const ValueKey('kpi_staff')), findsOneWidget);
      await select(tester, 'Secretaria');
      expect(find.byKey(const ValueKey('kpi_pending')), findsOneWidget);
      expect(find.text('Matrículas por validar'), findsWidgets);
    });

    testWidgets('só mostra secções de módulos licenciados', (tester) async {
      await pump(tester, modules: {'hr', 'cafeteria'});
      expect(find.text('Refeitório'), findsOneWidget);
      expect(find.text('RH'), findsOneWidget);
      expect(find.text('Catracas'), findsNothing);
      expect(find.text('Secretaria'), findsNothing);
    });
  });
}
