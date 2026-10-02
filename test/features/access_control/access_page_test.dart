import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/access_control/data/mock_api/access_mock_handlers.dart';
import 'package:erp_global/features/access_control/presentation/pages/access_control_page.dart';
import 'package:erp_global/features/cards/data/mock_api/cards_mock_handlers.dart';
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
        (ref) => [AccessMockHandlers(), CardsMockHandlers()],
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
        home: const Scaffold(body: AccessControlPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('zonas: lista seed e valida formulário de nova zona', (
    tester,
  ) async {
    await _pump(tester, ['access.*']);
    expect(find.text('Controlo de acessos'), findsOneWidget);
    expect(find.text('Portaria principal'), findsOneWidget);

    await tester.tap(find.text('Nova zona'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);
  });

  testWidgets('regras e dispositivos aparecem nos separadores', (tester) async {
    await _pump(tester, ['access.*']);
    await tester.tap(find.text('Regras'));
    await tester.pumpAndSettle();
    expect(find.text('Laboratório — aulas'), findsOneWidget);
    await tester.tap(find.text('Dispositivos'));
    await tester.pumpAndSettle();
    expect(find.text('Torniquete 1'), findsOneWidget);
  });

  testWidgets('testar acesso: valida localmente e nega sem regra', (
    tester,
  ) async {
    await _pump(tester, ['access.*']);
    await tester.tap(find.text('Testar acesso'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('sim_zone')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Secretaria').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Validar acesso'));
    await tester.pumpAndSettle();
    // Secretaria está inactiva no seed.
    expect(find.text('Negado'), findsOneWidget);
    expect(find.text('Zona inactiva'), findsOneWidget);

    // Mudar um campo invalida o resultado anterior.
    await tester.tap(find.byKey(const Key('sim_student_active')));
    await tester.pumpAndSettle();
    expect(find.text('Negado'), findsNothing);
  });

  testWidgets('só leitura: sem botões de criação', (tester) async {
    await _pump(tester, ['access.zone.read']);
    expect(find.text('Nova zona'), findsNothing);
  });

  testWidgets('portaria: cartão desconhecido é negado e fica registado', (
    tester,
  ) async {
    await _pump(tester, ['access.*']);
    await tester.tap(find.text('Portaria'));
    await tester.pumpAndSettle();
    expect(find.text('Sem registos de acesso'), findsOneWidget);

    await tester.tap(find.byKey(const Key('gate_device')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Torniquete 1 · Portaria principal').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('gate_uid')), 'NAO-EXISTE');
    await tester.tap(find.text('Simular leitura'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('gate_result')), findsOneWidget);
    expect(find.textContaining('Cartão desconhecido'), findsWidgets);
    expect(find.text('Sem registos de acesso'), findsNothing);
    expect(find.byKey(const Key('gate_logs')), findsOneWidget);
  });
}
