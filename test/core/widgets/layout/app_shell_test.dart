import 'package:erp_global/core/widgets/layout/app_shell.dart';
import 'package:erp_global/core/widgets/layout/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../helpers/auth_test_helpers.dart';

Widget _app() {
  final router = GoRouter(
    initialLocation: '/students/123',
    routes: [
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/students/:id',
            builder: (_, _) => const Text('ficha'),
          ),
          GoRoute(path: '/dashboard', builder: (_, _) => const Text('painel')),
        ],
      ),
    ],
  );
  return ProviderScope(
    overrides: permissionsOnly(['*']),
    child: MaterialApp.router(routerConfig: router),
  );
}

Future<void> _pumpAt(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_app());
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('expanded mostra rail estendida', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isTrue);
    expect(find.byType(NavigationDrawer), findsNothing);
  });

  testWidgets('medium mostra rail compacta', (tester) async {
    await _pumpAt(tester, const Size(800, 800));
    final rail = tester.widget<NavigationRail>(find.byType(NavigationRail));
    expect(rail.extended, isFalse);
  });

  testWidgets('compact usa drawer e navega', (tester) async {
    await _pumpAt(tester, const Size(400, 800));
    expect(find.byType(NavigationRail), findsNothing);
    await tester.tap(find.byTooltip('Abrir menu'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Painel').last);
    await tester.pumpAndSettle();
    expect(find.text('painel'), findsOneWidget);
  });

  testWidgets('breadcrumbs reflectem o caminho', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    expect(find.text('Alunos'), findsWidgets);
    expect(find.text('123'), findsOneWidget);
  });

  test('navIndexFor faz correspondência por prefixo', () {
    const items = [
      NavItem(label: 'A', icon: Icons.abc, path: '/a'),
      NavItem(label: 'B', icon: Icons.abc, path: '/b'),
    ];
    expect(navIndexFor(items, '/b/1'), 1);
    expect(navIndexFor(items, '/ab'), -1);
  });
}
