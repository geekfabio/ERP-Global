import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/communication/data/mock_api/communication_mock_handlers.dart';
import 'package:erp_global/features/communication/presentation/pages/communication_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

List<Override> _overrides(List<String> permissions) => [
  sessionPermissionsProvider.overrideWithValue(permissions),
  mockApiModulesProvider.overrideWith((ref) => [CommunicationMockHandlers()]),
  apiClientProvider.overrideWith(
    (ref) => ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: ref.watch(mockApiRegistryProvider),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  ),
];

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  await PtAoFormatters.initialize();
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: _overrides(permissions),
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: const Scaffold(body: CommunicationPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('mostra comunicados e confirmação de leitura', (tester) async {
    await _pump(tester, const ['communication.*']);
    expect(find.text('Início do 2.º trimestre'), findsOneWidget);
    expect(find.text('Propinas de Fevereiro'), findsOneWidget);
    expect(find.text('Confirmar leitura'), findsWidgets);
  });

  testWidgets('sem permissão não mostra "Novo comunicado"', (tester) async {
    await _pump(tester, const ['communication.announcement.read']);
    expect(find.text('Novo comunicado'), findsNothing);
  });

  testWidgets('cria um comunicado e valida campos obrigatórios', (
    tester,
  ) async {
    await _pump(tester, const ['communication.*']);
    await tester.tap(find.text('Novo comunicado'));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('announcement_send')));
    await tester.pumpAndSettle();
    expect(find.text('Indique o título'), findsOneWidget);
    expect(find.text('Indique a mensagem'), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('announcement_title')),
      'Feriado escolar',
    );
    await tester.enterText(
      find.byKey(const Key('announcement_body')),
      'Não há aulas na sexta.',
    );
    await tester.tap(find.byKey(const Key('announcement_send')));
    await tester.pumpAndSettle();

    expect(find.text('Feriado escolar'), findsOneWidget);
  });

  testWidgets('separador Agenda lista eventos', (tester) async {
    await _pump(tester, const ['communication.*']);
    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.text('Provas do 2.º trimestre'), findsOneWidget);
    expect(find.text('Avaliação'), findsOneWidget);
  });
}
