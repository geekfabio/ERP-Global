import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/billing/data/mock_api/billing_mock_handlers.dart';
import 'package:erp_global/features/billing/presentation/pages/billing_page.dart';
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
      mockApiModulesProvider.overrideWith((ref) => [BillingMockHandlers()]),
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
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: const Scaffold(body: BillingPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('lista preços e regista um novo', (tester) async {
    await _pump(tester, ['billing.*']);
    expect(find.text('Tabela de preços'), findsOneWidget);
    expect(find.text('Propina'), findsWidgets);

    await tester.tap(find.text('Novo preço'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).last, '8 000,00');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    // Propina da 1.ª classe já existe para o campus: conflito mostrado.
    expect(find.text('Preço registado'), findsNothing);
  });

  testWidgets('sem permissão não mostra acções', (tester) async {
    await _pump(tester, ['billing.invoice.read']);
    expect(find.text('Novo preço'), findsNothing);
    expect(find.text('Aplicar multas e juros'), findsNothing);
  });

  testWidgets('aplicar multas sem atrasos informa o utilizador', (
    tester,
  ) async {
    await _pump(tester, ['billing.*']);
    await tester.tap(find.text('Aplicar multas e juros'));
    await tester.pumpAndSettle();
    expect(find.text('Sem cobranças em atraso'), findsOneWidget);
  });
}
