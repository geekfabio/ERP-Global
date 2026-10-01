import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/accounting/data/mock_api/accounting_mock_handlers.dart';
import 'package:erp_global/features/accounting/presentation/pages/accounting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(2600, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [AccountingMockHandlers()]),
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
        home: const Scaffold(body: AccountingPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('plano de contas: árvore e criação de conta raiz', (
    tester,
  ) async {
    await _pump(tester, ['accounting.*']);
    expect(find.byKey(const Key('account_1')), findsOneWidget);
    expect(find.byKey(const Key('account_721')), findsOneWidget);

    await tester.tap(find.text('Nova conta'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('field_code')), '9');
    await tester.enterText(find.byKey(const Key('field_name')), 'Extra');
    await tester.tap(find.byKey(const Key('field_type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Custos').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Conta criada'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const Key('account_9')),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.byKey(const Key('account_9')), findsOneWidget);
  });

  testWidgets('exercícios e centros de custo listados', (tester) async {
    await _pump(tester, ['accounting.*']);
    await tester.tap(find.text('Exercícios'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('year_Exercício 2026')), findsOneWidget);
    expect(find.text('Fechar'), findsOneWidget);

    await tester.tap(find.text('Centros de custo'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('center_ADM')), findsOneWidget);
  });

  testWidgets('só leitura: sem botões de criação', (tester) async {
    await _pump(tester, ['accounting.account.read']);
    expect(find.text('Nova conta'), findsNothing);
    await tester.tap(find.text('Exercícios'));
    await tester.pumpAndSettle();
    expect(find.text('Novo exercício'), findsNothing);
    expect(find.text('Fechar'), findsNothing);
  });
}
