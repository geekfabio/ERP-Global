import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/billing/presentation/pages/cash_page.dart';
import 'package:erp_global/features/billing/presentation/providers/cash_providers.dart';
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
        (ref) => [ref.watch(cashMockHandlersProvider)],
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
        home: const Scaffold(body: CashPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('abre o caixa, faz sangria e fecha com conferência', (
    tester,
  ) async {
    await _pump(tester, ['billing.*']);
    expect(find.text('Sem sessões de caixa'), findsOneWidget);

    await tester.tap(find.text('Abrir caixa'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field_opening')), '10000');
    await tester.tap(find.text('Abrir'));
    await tester.pumpAndSettle();
    expect(find.text('Aberta'), findsOneWidget);

    await tester.ensureVisible(find.byTooltip('Acções').last);
    await tester.tap(find.byTooltip('Acções').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Movimentos'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sangria'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field_amount')), '4000');
    await tester.tap(find.text('Registar'));
    await tester.pumpAndSettle();
    expect(find.text('Sem movimentos'), findsNothing);

    await tester.tap(find.text('Fechar caixa'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('close_expected')), findsOneWidget);
    await tester.enterText(find.byKey(const Key('field_counted')), '5500');
    await tester.tap(find.text('Fechar caixa').last);
    await tester.pumpAndSettle();
    expect(find.text('Justifique a diferença de conferência'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('field_notes')), 'Troco');
    await tester.tap(find.text('Fechar caixa').last);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('session_closing')), findsOneWidget);
    expect(find.text('Relatório em PDF'), findsOneWidget);
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('sem permissão de escrita não mostra a abertura', (tester) async {
    await _pump(tester, ['billing.cash.read']);
    expect(find.text('Abrir caixa'), findsNothing);
  });
}
