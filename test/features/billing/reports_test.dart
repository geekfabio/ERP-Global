import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/charge.dart';
import 'package:erp_global/features/billing/data/models/payment.dart';
import 'package:erp_global/features/billing/data/models/report_rows.dart';
import 'package:erp_global/features/billing/domain/payments.dart';
import 'package:erp_global/features/billing/domain/reports.dart';
import 'package:erp_global/features/billing/presentation/pages/reports_page.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/payment_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/report_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Charge _charge(
  String id,
  DateTime due, {
  int amount = 1000,
  int discount = 0,
  String? campus,
  ChargeStatus status = ChargeStatus.pending,
}) => Charge(
  id: id,
  institutionId: 'i',
  campusId: campus,
  createdAt: DateTime.utc(2025, 9),
  updatedAt: DateTime.utc(2025, 9),
  studentId: 's',
  feeItemId: id,
  dueDate: due,
  amountMinor: amount,
  discountMinor: discount,
  status: status,
);

Payment _payment(
  String id,
  DateTime paidAt,
  Map<String, int> allocations, {
  PaymentStatus status = PaymentStatus.completed,
}) => Payment(
  id: id,
  institutionId: 'i',
  createdAt: paidAt,
  updatedAt: paidAt,
  studentId: 's',
  method: PaymentMethod.cash,
  amountMinor: allocations.values.fold(0, (a, b) => a + b),
  paidAt: paidAt,
  status: status,
  allocations: [
    for (final e in allocations.entries)
      PaymentAllocation(chargeId: e.key, amountMinor: e.value),
  ],
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  final charges = [
    _charge('a', DateTime.utc(2025, 9, 5), amount: 3000, campus: 'c1'),
    _charge('b', DateTime.utc(2025, 10, 5), discount: 200, campus: 'c2'),
    _charge('x', DateTime.utc(2025, 10, 6), status: ChargeStatus.cancelled),
  ];
  final payments = [
    _payment('p1', DateTime.utc(2025, 9, 10), {'a': 2000}),
    _payment('p2', DateTime.utc(2025, 10, 2), {'a': 500, 'b': 800}),
    _payment('p3', DateTime.utc(2025, 10, 3), {
      'a': 400,
    }, status: PaymentStatus.reversed),
  ];
  FeeType typeOf(Charge c) => c.id == 'a' ? FeeType.tuition : FeeType.exam;

  group('receita', () {
    List<RevenueRow> run(
      RevenueGroup g, {
      DateTime? from,
      DateTime? to,
      String? campus,
    }) => buildRevenue(
      charges: charges,
      payments: payments,
      feeTypeOf: typeOf,
      group: g,
      from: from,
      to: to,
      campusId: campus,
    );

    test('por período, cronológico, ignora pagamentos estornados', () {
      final rows = run(RevenueGroup.period);
      expect(rows.map((r) => r.key), ['2025-09', '2025-10']);
      expect(rows.map((r) => r.receivedMinor), [2000, 1300]);
      expect(rows.last.allocationCount, 2);
    });

    test('por rubrica, do maior para o menor', () {
      final rows = run(RevenueGroup.feeType);
      expect(rows.map((r) => r.key), ['tuition', 'exam']);
      expect(rows.map((r) => r.receivedMinor), [2500, 800]);
    });

    test('por campus e filtro de campus', () {
      expect(run(RevenueGroup.campus).map((r) => r.key), ['c1', 'c2']);
      final only = run(RevenueGroup.period, campus: 'c2');
      expect(only.single.receivedMinor, 800);
    });

    test('intervalo inclusivo por dia', () {
      final rows = run(
        RevenueGroup.period,
        from: DateTime.utc(2025, 10),
        to: DateTime.utc(2025, 10, 2, 23),
      );
      expect(rows.single.receivedMinor, 1300);
      expect(run(RevenueGroup.period, to: DateTime.utc(2025, 9, 9)), isEmpty);
    });
  });

  group('previsto vs recebido', () {
    test('agrupa por mês de vencimento, líquido e sem canceladas', () {
      final rows = buildForecast(
        charges: charges,
        allocated: allocatedByCharge(payments),
      );
      expect(rows.map((r) => r.period), ['2025-09', '2025-10']);
      expect(rows[0].expectedMinor, 3000);
      expect(rows[0].receivedMinor, 2500);
      expect(rows[1].expectedMinor, 800);
      expect(rows[1].receivedMinor, 800);
      expect(rows[1].chargeCount, 1);
    });

    test('taxa de cobrança', () {
      expect(collectionRatePercent(3000, 2500), 83);
      expect(collectionRatePercent(0, 0), 0);
    });

    test('recebido não excede o previsto', () {
      final rows = buildForecast(
        charges: [_charge('a', DateTime.utc(2025, 9, 5))],
        allocated: {'a': 5000},
      );
      expect(rows.single.receivedMinor, 1000);
    });
  });

  group('rótulos', () {
    test('período e rubrica', () {
      expect(periodLabel('2025-09'), 'Setembro 2025');
      expect(periodLabel('lixo'), 'lixo');
      expect(revenueKeyLabel(RevenueGroup.feeType, 'tuition'), 'Propina');
      expect(
        revenueKeyLabel(RevenueGroup.campus, MockRef.campusId),
        'Campus principal',
      );
    });
  });

  group('API mock', () {
    ProviderContainer container() {
      final c = ProviderContainer(
        overrides: [
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(billingMockHandlersProvider),
              ref.watch(paymentMockHandlersProvider),
              ref.watch(reportMockHandlersProvider),
            ],
          ),
          apiClientProvider.overrideWith(
            (ref) => ApiClient.create(
              baseUrl: 'https://api.test',
              useMockApi: true,
              registry: ref.watch(mockApiRegistryProvider),
              mockConfig: const MockApiConfig.instant(),
              logging: false,
            ),
          ),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    Future<void> seed(ProviderContainer c) async {
      await c
          .read(billingPlanRepositoryProvider)
          .generateForEnrollment(
            EnrollmentConfirmed(
              enrollmentId: 'enr-1',
              studentId: 'stu-1',
              academicYearId: MockRef.academicYearId,
              gradeId: MockRef.gradeId(3),
              classroomId: MockRef.classroomId(3, 0),
              type: 'new_enrollment',
              feeMinor: 1700000,
              occurredAt: DateTime.utc(2024, 9),
            ),
          );
      (await c
              .read(paymentRepositoryProvider)
              .create(
                studentId: 'stu-1',
                method: PaymentMethod.cash,
                amountMinor: 1700000,
              ))
          .getOrThrow();
    }

    test('receita e previsto coerentes com os pagamentos', () async {
      final c = container();
      await seed(c);
      final repo = c.read(reportRepositoryProvider);
      final byType = (await repo.revenue(
        group: RevenueGroup.feeType,
      )).getOrThrow();
      expect(byType.fold<int>(0, (s, r) => s + r.receivedMinor), 1700000);
      final byPeriod = (await repo.revenue(
        group: RevenueGroup.period,
      )).getOrThrow();
      expect(byPeriod, hasLength(1));
      final forecast = (await repo.forecast()).getOrThrow();
      expect(forecast, isNotEmpty);
      expect(forecast.fold<int>(0, (s, r) => s + r.receivedMinor), 1700000);
    });

    test('intervalo invertido dá 422', () async {
      final c = container();
      final r = await c
          .read(reportRepositoryProvider)
          .revenue(
            group: RevenueGroup.period,
            from: DateTime.utc(2025, 10),
            to: DateTime.utc(2025, 9),
          );
      expect(r.isOk, isFalse);
    });
  });

  test('reportFrom conta meses a partir do mês corrente', () {
    final now = DateTime.utc(2025, 2, 15);
    expect(reportFrom(null, now), isNull);
    expect(reportFrom(1, now), DateTime.utc(2025, 2));
    expect(reportFrom(3, now), DateTime.utc(2024, 12));
  });

  group('página', () {
    Future<void> pump(
      WidgetTester tester,
      List<String> permissions, {
      ExportHandler? exporter,
    }) async {
      tester.view.physicalSize = const Size(2600, 1400);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          if (exporter != null) ...[
            exportHandlerProvider.overrideWithValue(exporter),
            licenseGateProvider.overrideWithValue(
              const LicenseGate(enabledModules: {'import_export'}),
            ),
          ],
          mockApiModulesProvider.overrideWith(
            (ref) => [
              ref.watch(billingMockHandlersProvider),
              ref.watch(paymentMockHandlersProvider),
              ref.watch(reportMockHandlersProvider),
            ],
          ),
          apiClientProvider.overrideWith(
            (ref) => ApiClient.create(
              baseUrl: 'https://api.test',
              useMockApi: true,
              registry: ref.watch(mockApiRegistryProvider),
              mockConfig: const MockApiConfig.instant(),
              logging: false,
            ),
          ),
        ],
      );
      addTearDown(container.dispose);
      await tester.runAsync(() async {
        await container
            .read(billingPlanRepositoryProvider)
            .generateForEnrollment(
              EnrollmentConfirmed(
                enrollmentId: 'enr-1',
                studentId: 'stu-1',
                academicYearId: MockRef.academicYearId,
                gradeId: MockRef.gradeId(3),
                classroomId: MockRef.classroomId(3, 0),
                type: 'new_enrollment',
                feeMinor: 1700000,
                occurredAt: DateTime.utc(2024, 9),
              ),
            );
        await container
            .read(paymentRepositoryProvider)
            .create(
              studentId: 'stu-1',
              method: PaymentMethod.cash,
              amountMinor: 500000,
            );
      });
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: ReportsPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('mostra receita, alterna para previsto e exporta', (
      tester,
    ) async {
      ExportDataset? got;
      ExportFormat? fmt;
      await pump(
        tester,
        ['billing.*'],
        exporter: (d, f) async {
          got = d;
          fmt = f;
        },
      );
      expect(find.text('Relatórios financeiros'), findsOneWidget);
      expect(find.byKey(const Key('revenue_total')), findsOneWidget);
      expect(find.textContaining('Total recebido'), findsOneWidget);

      await tester.tap(find.byTooltip('Exportar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('CSV'));
      await tester.pumpAndSettle();
      expect(fmt, ExportFormat.csv);
      expect(got!.permission, reportExportPermission);
      expect(got!.columns.map((c) => c.label), contains('Recebido'));

      await tester.tap(find.text('Previsto vs. recebido'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('forecast_total')), findsOneWidget);
      expect(find.text('Mês de vencimento'), findsOneWidget);
    });

    testWidgets('sem permissão de exportação não há botão', (tester) async {
      await pump(tester, [reportReadPermission], exporter: (d, f) async {});
      expect(find.text('Relatórios financeiros'), findsOneWidget);
      expect(find.byTooltip('Exportar'), findsNothing);
    });
  });
}
