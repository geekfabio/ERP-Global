import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/modules/module_descriptor.dart';
import 'package:erp_global/core/modules/module_registry.dart';
import 'package:erp_global/core/widgets/layout/nav_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/auth_test_helpers.dart';

ModuleDescriptor _m(String code, [List<String> deps = const []]) =>
    ModuleDescriptor(
      code: code,
      name: code,
      icon: Icons.abc,
      path: '/$code',
      dependencies: deps,
    );

void main() {
  final registry = ModuleRegistry(moduleCatalog);

  test('catálogo tem os 20 módulos e core é obrigatório', () {
    expect(registry.all, hasLength(20));
    expect(registry.requiredCodes, {'core'});
    expect(registry.byCode('cafeteria')?.dependencies, ['students', 'cards']);
  });

  test('fecho transitivo de dependências', () {
    expect(registry.closure(['cafeteria']), {
      'core',
      'students',
      'cards',
      'cafeteria',
    });
    expect(registry.closure(['accounting']), {
      'core',
      'students',
      'billing',
      'accounting',
    });
    expect(registry.closure(const []), {'core'});
    expect(registry.closure(['inexistente']), {'core'});
  });

  test('dependências em falta são reportadas', () {
    final missing = registry.missingDependencies([
      'core',
      'students',
      'cafeteria',
    ]);
    expect(missing, {
      'cafeteria': ['cards'],
    });
    expect(
      registry.missingDependencies(['core', 'students', 'cards', 'cafeteria']),
      isEmpty,
    );
  });

  test('ordem topológica coloca dependências primeiro', () {
    final order = registry.topologicalOrder().map((m) => m.code).toList();
    for (final m in registry.all) {
      for (final d in m.dependencies) {
        expect(order.indexOf(d), lessThan(order.indexOf(m.code)));
      }
    }
    expect(
      registry.topologicalOrder(['grades']).map((m) => m.code),
      containsAllInOrder(['core', 'students', 'academic', 'grades']),
    );
  });

  test('rejeita duplicados, dependências inexistentes e ciclos', () {
    expect(
      () => ModuleRegistry([_m('a'), _m('a')]),
      throwsA(isA<ModuleConfigError>()),
    );
    expect(
      () => ModuleRegistry([
        _m('a', ['x']),
      ]),
      throwsA(isA<ModuleConfigError>()),
    );
    expect(
      () => ModuleRegistry([
        _m('a', ['b']),
        _m('b', ['a']),
      ]),
      throwsA(
        isA<ModuleConfigError>().having(
          (e) => e.message,
          'message',
          contains('Ciclo'),
        ),
      ),
    );
  });

  test(
    'menu mostra só módulos registados, Painel primeiro, Definições último',
    () {
      final small = ModuleRegistry([
        const ModuleDescriptor(
          code: 'core',
          name: 'Definições',
          icon: Icons.settings,
          path: '/settings',
          required: true,
        ),
        _m('students', ['core']),
      ]);
      final c = ProviderContainer(
        overrides: [
          moduleRegistryProvider.overrideWithValue(small),
          ...permissionsOnly(['*']),
        ],
      );
      addTearDown(c.dispose);
      final labels = c.read(navItemsProvider).map((i) => i.label).toList();
      expect(labels, ['Painel', 'students', 'Definições']);
    },
  );

  test('menu por omissão inclui os 20 módulos + Painel', () {
    final c = ProviderContainer(overrides: permissionsOnly(['*']));
    addTearDown(c.dispose);
    expect(c.read(navItemsProvider), hasLength(21));
  });

  testWidgets('cada módulo tem rota placeholder navegável', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(overrides: signedInOverrides());
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
    final router = container.read(appRouterProvider);
    for (final m in registry.all) {
      router.go(m.path);
      await tester.pumpAndSettle();
      expect(
        find.text('Módulo em construção.'),
        findsOneWidget,
        reason: m.code,
      );
    }
  });
}
