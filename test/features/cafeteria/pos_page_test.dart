import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/menu_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/wallet_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/presentation/pages/cafeteria_page.dart';
import 'package:erp_global/features/cafeteria/presentation/providers/menu_providers.dart';
import 'package:erp_global/features/cafeteria/presentation/providers/wallet_providers.dart';
import 'package:erp_global/features/cards/data/mock_api/cards_mock_handlers.dart';
import 'package:erp_global/features/cards/data/models/card_model.dart';
import 'package:erp_global/features/cards/presentation/providers/card_providers.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Aluno com alergia a lactose, carteira com saldo, cartão `POS-1` e o menu
/// de hoje (almoço: Gelado e Arroz com frango).
Future<void> _seed(ProviderContainer container) async {
  final students = await container
      .read(apiClientProvider)
      .dio
      .get<dynamic>('/v1/students', queryParameters: {'pageSize': 100});
  final student = (students.data['data'] as List)
      .cast<Map<String, dynamic>>()
      .firstWhere(
        (s) => ((s['health'] as Map)['allergies'] as List).contains('lactose'),
      );
  final wallets = container.read(walletRepositoryProvider);
  final wallet = (await wallets.open(
    holderId: '${student['id']}',
    holderName: '${student['fullName'] ?? 'Aluno'}',
  )).getOrThrow();
  (await wallets.topUp(
    wallet.id,
    amountMinor: 500000,
    method: 'cash',
  )).getOrThrow();
  (await container
          .read(cardRepositoryProvider)
          .issue(
            uid: 'POS-1',
            holderId: wallet.holderId,
            holderName: wallet.holderName,
            holderType: CardHolderType.student,
          ))
      .getOrThrow();
  final menus = container.read(menuRepositoryProvider);
  final items = (await menus.items.list()).getOrThrow().items;
  final lunch = items.firstWhere((i) => i.name == 'Gelado').mealTypeId;
  (await menus.saveMenu(
    date: dateKey(DateTime.now()),
    mealTypeId: lunch,
    itemIds: [
      for (final i in items)
        if (i.name == 'Gelado' || i.name == 'Arroz com frango') i.id,
    ],
  )).getOrThrow();
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  List<String> permissions,
) async {
  tester.view.physicalSize = const Size(1600, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [
          WalletMockHandlers(),
          MenuMockHandlers(),
          CardsMockHandlers(),
          StudentsMockHandlers(count: 120),
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

  // A preparação usa a rede mock (timers reais): fora do relógio falso.
  await tester.runAsync(() => _seed(container));

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
  await tester.tap(find.text('POS'));
  await tester.pumpAndSettle();
  final lunchChip = find.widgetWithText(ChoiceChip, 'Almoço');
  if (lunchChip.evaluate().isNotEmpty) {
    await tester.tap(lunchChip);
    await tester.pumpAndSettle();
  }
  return container;
}

Future<void> _readCard(WidgetTester tester, String uid) async {
  await tester.enterText(find.byType(TextField).first, uid);
  await tester.tap(find.text('Ler cartão'));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('cartão desconhecido mostra erro e nada é cobrado', (
    tester,
  ) async {
    await _pump(tester, ['cafeteria.*']);
    await _readCard(tester, 'NAO-EXISTE');
    expect(find.text('Cartão não reconhecido'), findsOneWidget);
    expect(find.byKey(const Key('pos_balance')), findsNothing);
  });

  testWidgets('alerta de alergia, débito, confirmação e estorno', (
    tester,
  ) async {
    await _pump(tester, ['cafeteria.*']);
    await _readCard(tester, 'pos-1');
    expect(find.byKey(const Key('pos_allergy_banner')), findsOneWidget);
    expect(find.textContaining('Alergias: lactose'), findsOneWidget);
    expect(
      find.textContaining(PtAoFormatters.currency(500000)),
      findsOneWidget,
    );

    await tester.tap(find.text('Arroz com frango'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ALERGIA'), findsNothing);
    await tester.tap(find.text('Gelado'));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('ALERGIA: o pedido contém Lactose'),
      findsOneWidget,
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('pos_total'))).data,
      PtAoFormatters.currency(135000),
    );

    await tester.tap(find.text('Cobrar'));
    await tester.pumpAndSettle();
    expect(find.text('Alerta de alergia'), findsOneWidget);
    await tester.tap(find.text('Cobrar mesmo assim'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('pos_confirmation')), findsOneWidget);
    expect(find.text('Venda registada'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('pos_balance'))).data,
      PtAoFormatters.currency(365000),
    );

    await tester.tap(find.text('Estornar'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Estornar'));
    await tester.pumpAndSettle();
    expect(find.text('Estornado'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('pos_balance'))).data,
      PtAoFormatters.currency(500000),
    );
  });

  testWidgets('saldo insuficiente bloqueia o botão Cobrar', (tester) async {
    final container = await _pump(tester, ['cafeteria.*']);
    await _readCard(tester, 'POS-1');
    // Gasta o saldo todo directamente na carteira (fora do POS).
    await tester.runAsync(() async {
      final repository = container.read(walletRepositoryProvider);
      final wallet = (await repository.list(
        pageSize: 100,
      )).getOrThrow().items.firstWhere((w) => w.balanceMinor == 500000);
      (await repository.purchase(wallet.id, amountMinor: 490000)).getOrThrow();
    });
    await _readCard(tester, 'POS-1');
    await tester.tap(find.text('Arroz com frango'));
    await tester.pumpAndSettle();
    expect(find.text('Saldo insuficiente'), findsOneWidget);
    final button = tester.widget<ButtonStyleButton>(
      find.ancestor(
        of: find.text('Cobrar'),
        matching: find.bySubtype<ButtonStyleButton>(),
      ),
    );
    expect(button.onPressed, isNull);
  });

  testWidgets('sem permissão de leitura não mostra o POS', (tester) async {
    await _pump(tester, ['cafeteria.wallet.read']);
    expect(find.text('Sem permissão'), findsOneWidget);
    expect(find.text('Ler cartão'), findsNothing);
  });
}
