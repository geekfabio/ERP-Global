import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/wallet_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/presentation/pages/wallets_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ProviderContainer> _pump(
  WidgetTester tester,
  List<String> permissions,
) async {
  tester.view.physicalSize = const Size(2600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [WalletMockHandlers()]),
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
        home: const Scaffold(body: WalletsPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('lista carteiras e carrega saldo publicando o evento', (
    tester,
  ) async {
    final container = await _pump(tester, ['cafeteria.*']);
    expect(find.text('Carteiras'), findsOneWidget);
    expect(find.text('Abrir'), findsOneWidget);

    final events = <WalletToppedUp>[];
    final sub = container
        .read(domainEventBusProvider)
        .on<WalletToppedUp>()
        .listen(events.add);
    addTearDown(sub.cancel);

    await tester.tap(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Carregar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Carregar').last);
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).first, '1000');
    await tester.tap(find.text('Carregar').last);
    await tester.pumpAndSettle();
    expect(find.text('Carregamento registado'), findsOneWidget);
    expect(events.single.amountMinor, 100000);
  });

  testWidgets('só leitura: sem botão de abrir', (tester) async {
    await _pump(tester, ['cafeteria.wallet.read']);
    expect(find.text('Abrir'), findsNothing);
    expect(find.text('Carteiras'), findsOneWidget);
  });
}
