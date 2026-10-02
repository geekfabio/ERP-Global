import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/library/data/mock_api/library_mock_handlers.dart';
import 'package:erp_global/features/library/presentation/pages/library_page.dart';
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
      mockApiModulesProvider.overrideWith((ref) => [LibraryMockHandlers()]),
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
        home: const Scaffold(body: LibraryPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('acervo lista obras e regista nova (validação + sucesso)', (
    tester,
  ) async {
    await _pump(tester, ['library.*']);
    expect(find.text('Biblioteca'), findsOneWidget);
    expect(find.text('Mayombe'), findsOneWidget);

    await tester.tap(find.text('Nova obra'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('field_isbn')), '978-0-1');
    await tester.enterText(find.byKey(const Key('field_title')), 'Livro X');
    await tester.enterText(find.byKey(const Key('field_author')), 'Autora');
    await tester.enterText(find.byKey(const Key('field_category')), 'Romance');
    await tester.enterText(find.byKey(const Key('field_copies')), '2');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Obra registada'), findsOneWidget);
  });

  testWidgets('empréstimos mostram atrasos; multas e reservas listadas', (
    tester,
  ) async {
    await _pump(tester, ['library.*']);
    await tester.tap(find.text('Empréstimos'));
    await tester.pumpAndSettle();
    expect(find.text('Em atraso'), findsWidgets);
    expect(find.text('Novo empréstimo'), findsOneWidget);

    await tester.tap(find.text('Multas'));
    await tester.pumpAndSettle();
    expect(find.text('Por pagar'), findsWidgets);

    await tester.tap(find.text('Reservas'));
    await tester.pumpAndSettle();
    expect(find.text('Em espera'), findsWidgets);
  });

  testWidgets('só leitura: sem botões de criação', (tester) async {
    await _pump(tester, ['library.loan.read']);
    expect(find.text('Nova obra'), findsNothing);
    await tester.tap(find.text('Empréstimos'));
    await tester.pumpAndSettle();
    expect(find.text('Novo empréstimo'), findsNothing);
  });
}
