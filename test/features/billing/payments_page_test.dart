import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/billing/presentation/pages/payments_page.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/payment_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(2600, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [
          ref.watch(billingMockHandlersProvider),
          ref.watch(paymentMockHandlersProvider),
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
  await tester.runAsync(
    () => container
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
            occurredAt: DateTime.utc(2025, 9, 1),
          ),
        ),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: const Scaffold(body: PaymentsPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('regista um pagamento e vê a conta corrente', (tester) async {
    await _pump(tester, ['billing.*']);
    expect(find.text('Sem pagamentos registados'), findsOneWidget);

    await tester.tap(find.text('Registar pagamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registar'));
    await tester.pumpAndSettle();
    expect(find.text('Seleccione o aluno'), findsOneWidget);

    await tester.tap(find.byKey(const Key('field_student')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Aluno ').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('account_hint')), findsOneWidget);

    await tester.enterText(find.byKey(const Key('field_amount')), '5000');
    await tester.tap(find.text('Registar'));
    await tester.pumpAndSettle();
    expect(find.text('Numerário'), findsOneWidget);
  });

  testWidgets('sem permissão não mostra o registo', (tester) async {
    await _pump(tester, ['billing.payment.read']);
    expect(find.text('Registar pagamento'), findsNothing);
  });
}
