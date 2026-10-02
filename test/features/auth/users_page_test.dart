import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/auth/presentation/pages/user_form_page.dart';
import 'package:erp_global/features/auth/presentation/pages/users_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

Future<void> _pump(
  WidgetTester tester, {
  List<String> permissions = const ['*'],
  String initial = '/settings/users',
}) async {
  tester.view.physicalSize = const Size(2600, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [AuthMockHandlers()]),
      apiClientProvider.overrideWith(
        (ref) => ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: ref.watch(mockApiRegistryProvider),
          mockConfig: const MockApiConfig.instant(),
          tokens: PersistentTokenStore(InMemorySessionStorage()),
          logging: false,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  // Sessão do administrador no cliente mock (o servidor valida o Bearer).
  await tester.runAsync(
    () => ApiAuthRepository(
      container.read(apiClientProvider),
      InMemorySessionStorage(),
    ).login(identifier: 'admin@erp-global.local', password: 'Admin@12345'),
  );

  final router = GoRouter(
    initialLocation: initial,
    routes: [
      GoRoute(
        path: '/settings/users',
        builder: (_, _) => const Scaffold(body: UsersPage()),
        routes: [
          GoRoute(
            path: 'new',
            builder: (_, _) => const Scaffold(body: UserFormPage()),
          ),
          GoRoute(
            path: ':id',
            builder: (_, s) =>
                Scaffold(body: UserFormPage(userId: s.pathParameters['id'])),
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
  testWidgets('super_admin vê a lista de contas com perfis e estado', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('Utilizadores'), findsOneWidget);
    expect(find.text('Super Administrador'), findsWidgets);
    expect(find.text('admin@erp-global.local'), findsOneWidget);
    expect(find.text('Activo'), findsWidgets);
    expect(find.text('Nova conta'), findsOneWidget);
  });

  testWidgets('sem a permissão não mostra a lista', (tester) async {
    await _pump(tester, permissions: const ['grades.entry.write']);
    expect(find.text('Sem permissão'), findsOneWidget);
    expect(find.text('admin@erp-global.local'), findsNothing);
  });

  testWidgets('pesquisa filtra no servidor', (tester) async {
    await _pump(tester);
    await tester.enterText(find.byType(TextField).first, 'bibliotecario');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(find.text('bibliotecario@erp-global.local'), findsOneWidget);
    expect(find.text('admin@erp-global.local'), findsNothing);
  });

  testWidgets('criar conta: passos, validação e password temporária', (
    tester,
  ) async {
    await _pump(tester, initial: '/settings/users/new');
    // Passo 1 inválido não avança.
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome completo'),
      'Rui Professor',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'E-mail (identificador de acesso)'),
      'rui@escola.ao',
    );
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();

    // Sem perfil não avança.
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('Atribua pelo menos um perfil'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilterChip, 'Professor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
    expect(find.text('Nome: Rui Professor'), findsOneWidget);
    expect(find.text('Perfis: Professor'), findsOneWidget);

    await tester.tap(find.text('Criar conta'));
    await tester.pumpAndSettle();
    expect(find.text('Palavra-passe temporária'), findsOneWidget);
    final temp = tester
        .widget<SelectableText>(find.byKey(const Key('temporary_password')))
        .data!;
    expect(temp, startsWith('Tmp@'));

    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    // Volta à lista, que já inclui a nova conta.
    expect(find.text('rui@escola.ao'), findsOneWidget);
  });

  testWidgets('desactivar conta pede confirmação e actualiza o estado', (
    tester,
  ) async {
    await _pump(tester);
    await tester.enterText(find.byType(TextField).first, 'aluno@');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(PopupMenuButton<int>).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Estado').last);
    await tester.pumpAndSettle();
    expect(find.text('Desactivar conta'), findsOneWidget);
    await tester.tap(find.widgetWithText(FilledButton, 'Desactivar'));
    await tester.pumpAndSettle();
    expect(find.text('Inactivo'), findsWidgets);
  });
}
