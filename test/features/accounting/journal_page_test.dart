import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/accounting/data/mock_api/accounting_mock_handlers.dart';
import 'package:erp_global/features/accounting/data/mock_api/journal_mock_handlers.dart';
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
      mockApiModulesProvider.overrideWith((ref) {
        final accounting = AccountingMockHandlers();
        return [accounting, JournalMockHandlers(accounting)];
      }),
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

Future<void> _openTab(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('diário lista o seed e só deixa lançar com D = C', (
    tester,
  ) async {
    await _pump(tester, ['accounting.*']);
    await _openTab(tester, 'Diário');
    expect(find.byKey(const Key('entry_1')), findsOneWidget);

    await tester.tap(find.text('Novo lançamento'));
    await tester.pumpAndSettle();
    FilledButton save() =>
        tester.widget<FilledButton>(find.byKey(const Key('entry_save')));
    expect(save().onPressed, isNull);

    await tester.enterText(find.byKey(const Key('field_description')), 'Teste');
    await tester.enterText(find.byKey(const Key('line_0_debit')), '100');
    await tester.enterText(find.byKey(const Key('line_1_credit')), '90');
    await tester.pump();
    expect(find.textContaining('Diferença'), findsOneWidget);
    expect(save().onPressed, isNull);
  });

  testWidgets('balancete mostra totais iguais', (tester) async {
    await _pump(tester, ['accounting.*']);
    await _openTab(tester, 'Balancete');
    final debit = tester.widget<Text>(find.byKey(const Key('tb_total_debit')));
    final credit = tester.widget<Text>(
      find.byKey(const Key('tb_total_credit')),
    );
    expect(debit.data, credit.data);
    expect(find.byKey(const Key('tb_45')), findsOneWidget);
  });

  testWidgets('pagar/receber: listagem e separação por tipo', (tester) async {
    await _pump(tester, ['accounting.*']);
    await _openTab(tester, 'Pagar/receber');
    expect(
      find.byKey(const Key('open_item_Propinas de Fevereiro')),
      findsOneWidget,
    );
    expect(find.text('Receber'), findsOneWidget);
    await tester.tap(find.text('A pagar'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const Key('open_item_Material didáctico')),
      findsOneWidget,
    );
    expect(find.text('Pagar'), findsOneWidget);
  });

  testWidgets('só leitura: sem botão de lançamento', (tester) async {
    await _pump(tester, ['accounting.ledger.read']);
    await _openTab(tester, 'Diário');
    expect(find.text('Novo lançamento'), findsNothing);
    expect(find.byKey(const Key('reverse_1')), findsNothing);
  });
}
