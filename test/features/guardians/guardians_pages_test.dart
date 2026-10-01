import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/guardians/presentation/pages/guardian_file_page.dart';
import 'package:erp_global/features/guardians/presentation/pages/guardians_list_page.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _pump(
  WidgetTester tester, {
  String location = '/guardians',
  List<String> permissions = const ['students.*'],
}) async {
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [StudentsMockHandlers(count: 20)],
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
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(
        path: '/guardians',
        builder: (_, _) => const Scaffold(body: GuardiansListPage()),
        routes: [
          GoRoute(
            path: ':id',
            builder: (_, s) => Scaffold(
              body: GuardianFilePage(guardianId: s.pathParameters['id']!),
            ),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('lista encarregados e abre a ficha com os educandos', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('Encarregados'), findsOneWidget);
    final tiles = find.byWidgetPredicate(
      (w) => w is ListTile && w.key.toString().contains('guardian_'),
    );
    expect(tiles, findsWidgets);

    await tester.tap(tiles.first);
    await tester.pumpAndSettle();
    expect(find.text('Educandos'), findsOneWidget);
    expect(find.byTooltip('Editar vínculo'), findsWidgets);
    expect(find.text('Sem fim de validade'), findsWidgets);
  });

  testWidgets('sem permissão de edição não mostra acções de vínculo', (
    tester,
  ) async {
    await _pump(tester, permissions: const ['students.record.read']);
    await tester.tap(find.byIcon(Icons.chevron_right).first);
    await tester.pumpAndSettle();
    expect(find.byTooltip('Editar vínculo'), findsNothing);
    expect(find.text('Associar educando'), findsNothing);
  });

  testWidgets('define a validade do vínculo', (tester) async {
    await _pump(tester);
    await tester.tap(find.byIcon(Icons.chevron_right).first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Editar vínculo').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Válido até'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Vínculo actualizado'), findsOneWidget);
    expect(find.textContaining('Sem fim de validade'), findsNothing);
  });
}
