import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/menu_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/wallet_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/presentation/pages/cafeteria_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [WalletMockHandlers(), MenuMockHandlers()],
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
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: const Scaffold(body: CafeteriaPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('menu semanal mostra pratos e alergénios e permite editar', (
    tester,
  ) async {
    await _pump(tester, ['cafeteria.*']);
    await tester.tap(find.text('Menu semanal'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Segunda-feira,'), findsOneWidget);
    expect(find.textContaining('Pão com ovo — Glúten, Ovos'), findsWidgets);

    await tester.tap(find.byTooltip('Editar menu de Lanche').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byType(CheckboxListTile).first);
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Menu guardado'), findsOneWidget);

    await tester.tap(find.byTooltip('Semana seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('Sem menu'), findsWidgets);
  });

  testWidgets('separador Refeições lista tipos e cria um novo', (tester) async {
    await _pump(tester, ['cafeteria.*']);
    await tester.tap(find.text('Refeições'));
    await tester.pumpAndSettle();
    expect(find.text('Almoço'), findsOneWidget);
    expect(find.text('12:00 – 14:00'), findsOneWidget);

    await tester.tap(find.text('Novo tipo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byType(TextFormField).at(0), 'Ceia');
    await tester.enterText(find.byType(TextFormField).at(1), '19:00');
    await tester.enterText(find.byType(TextFormField).at(2), '20:00');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Tipo de refeição guardado'), findsOneWidget);
    expect(find.text('Ceia'), findsOneWidget);
  });

  testWidgets('sem permissão não há botões de edição', (tester) async {
    await _pump(tester, ['cafeteria.wallet.read']);
    await tester.tap(find.text('Pratos'));
    await tester.pumpAndSettle();
    expect(find.text('Novo prato'), findsNothing);
    expect(find.text('Funge com peixe'), findsOneWidget);
  });
}
