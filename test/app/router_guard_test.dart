import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/features/auth/presentation/providers/active_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/auth_test_helpers.dart';

Future<GoRouter> _boot(
  WidgetTester tester, {
  List<Override> overrides = const [],
  String? at,
}) async {
  tester.view.physicalSize = const Size(1280, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: Consumer(
        builder: (context, ref, _) => MaterialApp.router(
          theme: AppTheme.light(),
          routerConfig: ref.watch(appRouterProvider),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final router = container.read(appRouterProvider);
  if (at != null) {
    router.go(at);
    await tester.pumpAndSettle();
  }
  return router;
}

void main() {
  test('safeRedirectTarget só aceita caminhos internos', () {
    expect(safeRedirectTarget(null), '/dashboard');
    expect(safeRedirectTarget('/students/1'), '/students/1');
    expect(safeRedirectTarget('https://evil.com'), '/dashboard');
    expect(safeRedirectTarget('//evil.com'), '/dashboard');
    expect(safeRedirectTarget('/login'), '/dashboard');
    expect(safeRedirectTarget('/forbidden'), '/dashboard');
  });

  group('sem sessão só existe /login', () {
    testWidgets('qualquer rota redirecciona para /login', (tester) async {
      final router = await _boot(
        tester,
        overrides: signedOutOverrides(),
        at: '/students',
      );
      expect(router.state.uri.path, '/login');
      expect(router.state.uri.queryParameters['from'], '/students');
      expect(find.text('Entre na sua conta'), findsOneWidget);
    });

    testWidgets('rota inexistente ou de módulo também', (tester) async {
      final router = await _boot(
        tester,
        overrides: signedOutOverrides(),
        at: '/billing/invoices',
      );
      expect(router.state.uri.path, '/login');
    });
  });

  group('com sessão', () {
    testWidgets('super_admin acede a todos os módulos', (tester) async {
      final router = await _boot(tester, overrides: signedInOverrides());
      for (final m in moduleCatalog) {
        router.go(m.path);
        await tester.pumpAndSettle();
        expect(router.state.uri.path, m.path, reason: m.code);
      }
    });

    testWidgets('encarregado não acede a rotas de admin', (tester) async {
      final router = await _boot(
        tester,
        overrides: signedInOverrides(
          roles: ['encarregado'],
          permissions: ['portal.child.read'],
        ),
      );
      for (final path in ['/settings', '/students', '/billing', '/hr']) {
        router.go(path);
        await tester.pumpAndSettle();
        expect(router.state.uri.path, '/forbidden', reason: path);
        expect(find.text('Sem permissão'), findsOneWidget);
      }
      router.go('/portal');
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/portal');
    });

    testWidgets('menu só mostra o que o perfil pode aceder', (tester) async {
      await _boot(
        tester,
        overrides: signedInOverrides(
          roles: ['encarregado'],
          permissions: ['portal.child.read'],
        ),
      );
      expect(find.text('Portal'), findsWidgets);
      expect(find.text('Alunos'), findsNothing);
      expect(find.text('Financeiro'), findsNothing);
    });

    testWidgets('autenticado em /login vai para o destino seguro', (
      tester,
    ) async {
      final router = await _boot(tester, overrides: signedInOverrides());
      router.go('/login?from=%2Fstudents');
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/students');
      router.go('/login?from=https%3A%2F%2Fevil.com');
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/dashboard');
    });

    testWidgets('vários perfis: fica em /login até escolher o activo', (
      tester,
    ) async {
      final router = await _boot(
        tester,
        overrides: signedInOverrides(
          roles: ['professor', 'coordenacao'],
          permissions: ['academic.class.read'],
        ),
        at: '/academic',
      );
      expect(router.state.uri.path, '/login');
      expect(find.text('Escolha o perfil'), findsOneWidget);

      await tester.tap(find.text('Coordenação'));
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/academic');
      final container = ProviderScope.containerOf(
        tester.element(find.byType(MaterialApp)),
      );
      expect(container.read(activeRoleProvider), 'coordenacao');
    });
  });
}
