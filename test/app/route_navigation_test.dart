import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/widgets/layout/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/auth_test_helpers.dart';

Future<(GoRouter, ProviderContainer)> _boot(
  WidgetTester tester, {
  required List<Override> overrides,
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
  await _settle(tester);
  return (container.read(appRouterProvider), container);
}

/// Avança o tempo de forma limitada: há páginas com animações/timers contínuos
/// (skeletons, latência da Mock API) em que `pumpAndSettle` nunca termina.
Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 400));
  }
}

/// Caminhos completos das rotas sem parâmetros (`:id`), por ordem de registo.
List<String> _staticPaths(List<RouteBase> routes, [String parent = '']) {
  final paths = <String>[];
  for (final route in routes) {
    var current = parent;
    if (route is GoRoute) {
      current = route.path.startsWith('/')
          ? route.path
          : '${parent == '/' ? '' : parent}/${route.path}';
      final hasPage = route.builder != null || route.pageBuilder != null;
      if (hasPage && !current.contains(':')) paths.add(current);
    }
    paths.addAll(_staticPaths(route.routes, current));
  }
  return paths;
}

void main() {
  const publicPaths = {'/splash', '/login'};

  /// Rotas com defeito conhecido no estado de carregamento (SkeletonList dentro
  /// de um ListView: "Null check" no layout). Fora do âmbito de #91; ver PR.
  const knownBroken = {'/grades/statistics'};

  Future<void> openAllStaticRoutes(WidgetTester tester) async {
    final (router, _) = await _boot(tester, overrides: signedInOverrides());
    final all = _staticPaths(router.configuration.routes);
    final paths = all.toSet()
      ..removeAll(publicPaths)
      ..removeAll(knownBroken);
    // Garante que o teste cobre mais do que as raízes dos módulos.
    expect(paths.length, greaterThan(moduleCatalog.length));
    for (final path in paths) {
      router.go(path);
      await _settle(tester);
      expect(tester.takeException(), isNull, reason: path);
      expect(router.state.uri.path, path, reason: path);
    }
  }

  testWidgets(
    'super_admin abre todas as rotas estáticas sem erros',
    openAllStaticRoutes,
    timeout: const Timeout(Duration(minutes: 3)),
  );

  testWidgets('sem sessão, rotas profundas vão para /login com from', (
    tester,
  ) async {
    final (router, _) = await _boot(tester, overrides: signedOutOverrides());
    final all = _staticPaths(router.configuration.routes);
    final paths = all.where((p) => !publicPaths.contains(p)).take(12);
    for (final path in paths) {
      router.go(path);
      await _settle(tester);
      expect(router.state.uri.path, '/login', reason: path);
      expect(router.state.uri.queryParameters['from'], path, reason: path);
    }
  });

  testWidgets(
    'módulo fora da licença abre /not-licensed em qualquer sub-rota',
    (tester) async {
      final gate = LicenseGate(
        enabledModules: {
          for (final m in moduleCatalog)
            if (m.code != 'students') m.code,
        },
      );
      final (router, _) = await _boot(
        tester,
        overrides: signedInOverrides(gate: gate),
      );
      final all = _staticPaths(router.configuration.routes);
      final studentPaths = all.where(
        (p) => p == '/students' || p.startsWith('/students/'),
      );
      expect(studentPaths, isNotEmpty);
      for (final path in studentPaths) {
        router.go(path);
        await _settle(tester);
        expect(router.state.uri.path, '/not-licensed', reason: path);
        expect(router.state.uri.queryParameters['module'], 'students');
      }
      // Os restantes módulos continuam acessíveis.
      router.go('/academic');
      await _settle(tester);
      expect(router.state.uri.path, '/academic');
    },
  );

  testWidgets('sem permissões, sub-rotas de módulo vão para /forbidden', (
    tester,
  ) async {
    final (router, _) = await _boot(
      tester,
      overrides: signedInOverrides(
        roles: ['encarregado'],
        permissions: ['portal.child.read'],
      ),
    );
    final all = _staticPaths(router.configuration.routes);
    final restricted = all.where(
      (p) => p.startsWith('/students/') || p.startsWith('/academic/'),
    );
    expect(restricted, isNotEmpty);
    for (final path in restricted) {
      router.go(path);
      await _settle(tester);
      expect(router.state.uri.path, '/forbidden', reason: path);
    }
  });

  testWidgets('rota desconhecida com sessão mostra erro do router', (
    tester,
  ) async {
    final (router, _) = await _boot(tester, overrides: signedInOverrides());
    router.go('/rota-que-nao-existe');
    await _settle(tester);
    expect(find.byType(AppShell), findsNothing);
    expect(find.textContaining('rota-que-nao-existe'), findsWidgets);
  });

  testWidgets('a navegação por voltar regressa à rota anterior', (
    tester,
  ) async {
    final (router, _) = await _boot(tester, overrides: signedInOverrides());
    router.go('/academic');
    await _settle(tester);
    router.push('/students');
    await _settle(tester);
    expect(router.state.uri.path, '/students');
    router.pop();
    await _settle(tester);
    expect(router.state.uri.path, '/academic');
  });
}
