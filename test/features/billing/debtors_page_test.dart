import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/billing/presentation/pages/debtors_page.dart';
import 'package:erp_global/features/billing/presentation/providers/billing_providers.dart';
import 'package:erp_global/features/billing/presentation/providers/debt_providers.dart';
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
          ref.watch(debtMockHandlersProvider),
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
            occurredAt: DateTime.utc(2024, 9, 1),
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
        home: const Scaffold(body: DebtorsPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('lista devedores, envia avisos e cria acordo', (tester) async {
    await _pump(tester, ['billing.*']);
    expect(find.text('Devedores'), findsOneWidget);
    expect(find.text('3.ª classe A'), findsOneWidget);

    await tester.tap(find.byTooltip('Enviar avisos'));
    await tester.pumpAndSettle();
    expect(find.textContaining('aviso(s) enviado(s)'), findsOneWidget);

    await tester.tap(find.byTooltip('Avisos enviados'));
    await tester.pumpAndSettle();
    expect(find.textContaining('em atraso desde'), findsWidgets);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Criar acordo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Criar acordo').last);
    await tester.pumpAndSettle();
    expect(find.text('Acordo criado'), findsOneWidget);

    await tester.tap(find.byTooltip('Acordos'));
    await tester.pumpAndSettle();
    expect(find.text('Em curso'), findsWidgets);
  });

  testWidgets('sem permissão de gestão não mostra acções', (tester) async {
    await _pump(tester, ['billing.debtor.read']);
    expect(find.text('Devedores'), findsOneWidget);
    expect(find.byTooltip('Enviar avisos'), findsNothing);
  });

  testWidgets('filtro por turma sem devedores mostra estado vazio', (
    tester,
  ) async {
    await _pump(tester, ['billing.*']);
    await tester.tap(find.byKey(const Key('filter_classroom')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('5.ª classe B').last);
    await tester.pumpAndSettle();
    expect(find.text('Sem devedores'), findsWidgets);
  });
}
