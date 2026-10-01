import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/cards/data/mock_api/cards_mock_handlers.dart';
import 'package:erp_global/features/cards/presentation/pages/cards_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(2600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [CardsMockHandlers()]),
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
        home: const Scaffold(body: CardsPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('lista cartões e emite um novo', (tester) async {
    await _pump(tester, ['cards.*']);
    expect(find.text('Cartões escolares'), findsOneWidget);
    expect(find.text('RFID-1024'), findsOneWidget);

    await tester.tap(find.text('Emitir cartão'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('card_uid')), 'NOVO-1');
    await tester.enterText(find.byKey(const Key('card_holder_name')), 'Ana');
    await tester.enterText(
      find.byKey(const Key('card_holder_id')),
      '01JKHMPQT000000000000000A1',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Cartão emitido'), findsOneWidget);
  });

  testWidgets('só leitura: sem botão de emitir', (tester) async {
    await _pump(tester, ['cards.card.read']);
    expect(find.text('Emitir cartão'), findsNothing);
    expect(find.text('RFID-1024'), findsOneWidget);
  });
}
