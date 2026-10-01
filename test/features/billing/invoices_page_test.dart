import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/billing/data/mock_api/billing_mock_handlers.dart';
import 'package:erp_global/features/billing/presentation/pages/invoices_page.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/invoice_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(2600, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final billing = BillingMockHandlers();
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      billingMockHandlersProvider.overrideWithValue(billing),
      mockApiModulesProvider.overrideWith(
        (ref) => [billing, ref.watch(invoiceMockHandlersProvider)],
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
        home: const Scaffold(body: InvoicesPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('emite uma factura a partir das cobranças', (tester) async {
    await _pump(tester, ['billing.*']);
    expect(find.text('Sem facturas emitidas'), findsOneWidget);

    await tester.tap(find.text('Emitir factura'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Emitir'));
    await tester.pumpAndSettle();
    expect(find.text('Seleccione pelo menos uma cobrança'), findsOneWidget);

    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Emitir'));
    await tester.pumpAndSettle();
    expect(find.textContaining('/000001'), findsWidgets);
    expect(find.text('Emitida'), findsOneWidget);
  });

  testWidgets('sem permissão não mostra a emissão', (tester) async {
    await _pump(tester, ['billing.invoice.read']);
    expect(find.text('Emitir factura'), findsNothing);
  });
}
