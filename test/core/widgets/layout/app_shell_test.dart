import 'package:erp_global/core/widgets/layout/app_shell.dart';
import 'package:erp_global/core/widgets/layout/app_sidebar.dart';
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
          GoRoute(
            path: '/guardians',
            builder: (_, _) => const Text('encarregados'),
          ),
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
  testWidgets('expanded mostra a sidebar e navega', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    expect(find.byType(AppSidebar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(find.byType(NavigationDrawer), findsNothing);
    await tester.tap(
      find.descendant(
        of: find.byType(AppSidebar),
        matching: find.text('Painel'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('painel'), findsOneWidget);
  });

  testWidgets('sidebar marca o item da rota actual como seleccionado', (
    tester,
  ) async {
    await _pumpAt(tester, const Size(1280, 800));
    final alunos = find.descendant(
      of: find.byType(AppSidebar),
      matching: find.text('Alunos'),
    );
    expect(
      tester.getSemantics(alunos),
      isSemantics(isSelected: true, isButton: true),
    );
  });

  testWidgets('medium mostra a sidebar acordeão mais estreita', (tester) async {
    await _pumpAt(tester, const Size(800, 800));
    expect(find.byType(NavigationRail), findsNothing);
    final sidebar = tester.widget<AppSidebar>(find.byType(AppSidebar));
    expect(sidebar.width, appSidebarWidthMedium);
  });

  testWidgets('o grupo da rota actual abre-se e os outros ficam fechados', (
    tester,
  ) async {
    await _pumpAt(tester, const Size(1280, 800));
    final sidebar = find.byType(AppSidebar);
    // Rota /students/123 → grupo "Pessoas" aberto com os seus módulos.
    expect(
      find.descendant(of: sidebar, matching: find.text('Pessoas')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sidebar, matching: find.text('Encarregados')),
      findsOneWidget,
    );
    // "Finanças" está fechado: o cabeçalho aparece, os filhos não.
    expect(
      find.descendant(of: sidebar, matching: find.text('Finanças')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sidebar, matching: find.text('Contabilidade')),
      findsNothing,
    );
  });

  testWidgets('abrir um grupo fecha o anterior (acordeão)', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    final sidebar = find.byType(AppSidebar);
    await tester.tap(
      find.descendant(of: sidebar, matching: find.text('Finanças')),
    );
    await tester.pumpAndSettle();
    expect(
      find.descendant(of: sidebar, matching: find.text('Contabilidade')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: sidebar, matching: find.text('Encarregados')),
      findsNothing,
    );
  });

  testWidgets('navega a partir de um item dentro de um grupo', (tester) async {
    await _pumpAt(tester, const Size(1280, 800));
    await tester.tap(
      find.descendant(
        of: find.byType(AppSidebar),
        matching: find.text('Encarregados'),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('encarregados'), findsOneWidget);
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

  test('buildNavSections agrupa os módulos e deixa os soltos em secções', () {
    const items = [
      NavItem(label: 'Painel', icon: Icons.abc, path: '/dashboard'),
      NavItem(label: 'Alunos', icon: Icons.abc, path: '/students'),
      NavItem(label: 'Encarregados', icon: Icons.abc, path: '/guardians'),
      NavItem(label: 'Definições', icon: Icons.abc, path: '/settings'),
    ];
    final sections = buildNavSections(items);
    expect(sections, hasLength(3));
    expect((sections[0] as NavLink).item.label, 'Painel');
    final group = sections[1] as NavGroup;
    expect(group.label, 'Pessoas');
    expect(group.links.map((l) => l.index), [1, 2]);
    expect((sections[2] as NavLink).index, 3);
    expect(navGroupLabelFor(sections, 2), 'Pessoas');
    expect(navGroupLabelFor(sections, 0), isNull);
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
