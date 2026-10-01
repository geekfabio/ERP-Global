import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/inventory/data/mock_api/inventory_mock_handlers.dart';
import 'package:erp_global/features/inventory/presentation/pages/inventory_page.dart';
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
      mockApiModulesProvider.overrideWith((ref) => [InventoryMockHandlers()]),
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
        home: const Scaffold(body: InventoryPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('bens: lista e regista novo bem (validação + sucesso)', (
    tester,
  ) async {
    await _pump(tester, ['inventory.*']);
    expect(find.text('Inventário e património'), findsOneWidget);
    expect(find.text('PAT-1000'), findsOneWidget);

    await tester.tap(find.text('Novo bem'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('field_tag')), 'PAT-9999');
    await tester.enterText(find.byKey(const Key('field_name')), 'Mesa');
    await tester.enterText(find.byKey(const Key('field_category')), 'Mobília');
    await tester.enterText(find.byKey(const Key('field_location')), 'Sala 3');
    await tester.enterText(find.byKey(const Key('field_custodian')), 'Ana');
    // Data de aquisição pelo seletor nativo.
    await tester.tap(find.byKey(const Key('field_acquiredOn')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Bem registado'), findsOneWidget);
  });

  testWidgets('consumíveis: alerta de stock mínimo visível', (tester) async {
    await _pump(tester, ['inventory.*']);
    await tester.tap(find.text('Consumíveis'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('low_stock_banner')), findsOneWidget);
    expect(find.text('Stock baixo'), findsWidgets);
  });

  testWidgets('só leitura: sem botões de criação', (tester) async {
    await _pump(tester, ['inventory.asset.read']);
    expect(find.text('Novo bem'), findsNothing);
    await tester.tap(find.text('Consumíveis'));
    await tester.pumpAndSettle();
    expect(find.text('Novo consumível'), findsNothing);
  });
}
