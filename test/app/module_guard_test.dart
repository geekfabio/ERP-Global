import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/modules/module_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/widgets/layout/nav_item.dart';
import 'package:erp_global/core/widgets/license/license_widgets.dart';
import 'package:erp_global/core/widgets/permissions/can.dart';
import 'package:erp_global/features/license/domain/license_service.dart';
import 'package:erp_global/features/license/domain/license_status.dart';
import 'package:erp_global/features/license/domain/license_verifier.dart';
import 'package:erp_global/features/license/data/data_mocks/dev_license.dart';
import 'package:erp_global/features/license/data/models/license_model.dart';
import 'package:erp_global/features/license/presentation/providers/license_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/auth_test_helpers.dart';

Future<(GoRouter, ProviderContainer)> _boot(
  WidgetTester tester,
  List<Override> overrides, {
  bool settle = true,
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
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    // /splash tem um spinner infinito: não "assenta".
    await tester.pump(const Duration(milliseconds: 200));
  }
  return (container.read(appRouterProvider), container);
}

LicenseSnapshot _snap(LicenseState s, {int? days}) => LicenseSnapshot(
  LicenseStatus(s, daysLeft: days),
  const {'core', 'students'},
);

void main() {
  group('gateFor (estado → aviso e modo só leitura)', () {
    test('activa longe do fim: sem aviso nem só leitura', () {
      final g = gateFor(_snap(LicenseState.active, days: 200));
      expect(g.banner, isNull);
      expect(g.readOnly, isFalse);
    });

    test('a expirar: aviso informativo, continua a escrever', () {
      final g = gateFor(_snap(LicenseState.active, days: 10));
      expect(g.banner?.level, LicenseBannerLevel.info);
      expect(g.banner?.message, contains('10 dias'));
      expect(g.readOnly, isFalse);
    });

    test('graça: aviso, escrita permitida', () {
      final g = gateFor(_snap(LicenseState.grace, days: 1));
      expect(g.banner?.level, LicenseBannerLevel.warning);
      expect(g.banner?.message, contains('1 dia '));
      expect(g.readOnly, isFalse);
    });

    test('só leitura, relógio recuado, sem licença e inválida', () {
      for (final s in [
        LicenseState.readOnly,
        LicenseState.clockTampered,
        LicenseState.missing,
        LicenseState.invalid,
      ]) {
        final g = gateFor(_snap(s));
        expect(g.readOnly, isTrue, reason: s.name);
        expect(g.banner?.level, LicenseBannerLevel.danger, reason: s.name);
      }
    });
  });

  test('a licença de desenvolvimento embebida é válida e completa', () async {
    final license = LicenseModel.parse(devLicenseJson);
    expect(await LicenseVerifier().verify(license), isTrue);
    expect(license.modules.toSet(), {for (final m in moduleCatalog) m.code});
  });

  test('sem licença só os módulos obrigatórios estão disponíveis', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(enabledModulesProvider), {'core'});
  });

  test('LicenseController activa a licença dev em modo mock', () async {
    final c = ProviderContainer(
      overrides: [
        licenseStoreProvider.overrideWithValue(InMemoryLicenseStore()),
      ],
    );
    addTearDown(c.dispose);
    final snap = await c.read(licenseControllerProvider.future);
    expect(snap.status.state, LicenseState.active);
    expect(snap.enabledModules, containsAll(['students', 'billing', 'core']));
    final gate = c.read(licenseGateFromServiceProvider);
    expect(gate.loading, isFalse);
    expect(gate.enabledModules, isNotEmpty);
  });

  group('ModuleGuard no router', () {
    testWidgets('módulo fora da licença → ecrã "não licenciado"', (t) async {
      final (router, _) = await _boot(
        t,
        signedInOverrides(
          gate: const LicenseGate(enabledModules: {'core', 'students'}),
        ),
      );
      router.go('/billing');
      await t.pumpAndSettle();
      expect(router.state.uri.path, '/not-licensed');
      expect(router.state.uri.queryParameters['module'], 'billing');
      expect(find.text('Módulo não licenciado'), findsOneWidget);
      expect(find.textContaining('"Financeiro"'), findsOneWidget);
      expect(find.text('Contactar equipa comercial'), findsOneWidget);

      router.go('/students');
      await t.pumpAndSettle();
      expect(router.state.uri.path, '/students');
    });

    testWidgets('menu só mostra módulos licenciados', (t) async {
      final (_, c) = await _boot(
        t,
        signedInOverrides(
          gate: const LicenseGate(enabledModules: {'core', 'students'}),
        ),
      );
      final paths = c.read(navItemsProvider).map((i) => i.path).toList();
      expect(paths, ['/dashboard', '/students', '/settings']);
    });

    testWidgets('licença em falta: core continua acessível para activar', (
      t,
    ) async {
      final (router, _) = await _boot(
        t,
        signedInOverrides(gate: LicenseGate.none),
      );
      router.go('/settings');
      await t.pumpAndSettle();
      expect(router.state.uri.path, '/settings');
      router.go('/students');
      await t.pumpAndSettle();
      expect(router.state.uri.path, '/not-licensed');
    });

    testWidgets('durante a validação da licença fica em /splash', (t) async {
      final (router, _) = await _boot(
        t,
        signedInOverrides(gate: LicenseGate.loadingGate),
        settle: false,
      );
      expect(router.state.uri.path, '/splash');
    });

    testWidgets('banner de licença aparece no shell', (t) async {
      await _boot(
        t,
        signedInOverrides(
          gate: LicenseGate(
            enabledModules: {for (final m in moduleCatalog) m.code},
            banner: const LicenseBanner(
              LicenseBannerLevel.warning,
              'Licença expirada: restam 5 dias de período de graça.',
            ),
          ),
        ),
      );
      expect(find.byType(LicenseBannerBar), findsOneWidget);
      expect(find.textContaining('período de graça'), findsOneWidget);
    });

    testWidgets(
      'permissões vs licença: sem licença mesmo o super_admin é barrado',
      (t) async {
        final (router, _) = await _boot(
          t,
          signedInOverrides(gate: const LicenseGate(enabledModules: {'core'})),
        );
        router.go('/hr');
        await t.pumpAndSettle();
        expect(router.state.uri.path, '/not-licensed');
      },
    );
  });

  group('modo só leitura', () {
    testWidgets('nega acções de escrita mas mantém a consulta', (t) async {
      await _boot(
        t,
        signedInOverrides(
          gate: LicenseGate(
            enabledModules: {for (final m in moduleCatalog) m.code},
            readOnly: true,
          ),
        ),
      );
      final c = ProviderScope.containerOf(t.element(find.byType(MaterialApp)));
      final perms = c.read(permissionServiceProvider);
      expect(perms.can('students.record.read'), isTrue);
      expect(perms.can('billing.invoice.export'), isTrue);
      expect(perms.can('students.record.update'), isFalse);
      expect(perms.can('billing.invoice.void'), isFalse);
      expect(perms.canAccessNamespace('students'), isTrue);
    });

    testWidgets('Can esconde botões de escrita em só leitura', (t) async {
      await t.pumpWidget(
        ProviderScope(
          overrides: permissionsOnly([
            '*',
          ], gate: const LicenseGate(readOnly: true)),
          child: const MaterialApp(
            home: Column(
              children: [
                Can(
                  permission: 'students.record.update',
                  child: Text('EDITAR'),
                ),
                Can(permission: 'students.record.read', child: Text('VER')),
              ],
            ),
          ),
        ),
      );
      expect(find.text('EDITAR'), findsNothing);
      expect(find.text('VER'), findsOneWidget);
    });
  });

  testWidgets('a app arranca com cada módulo desligado', (t) async {
    final registry = container0();
    for (final m in registry.all.where((m) => !m.required)) {
      // Desliga o módulo e quem depende dele (a licença exige dependências).
      final off = {
        for (final x in registry.all)
          if (registry.closure([x.code]).contains(m.code)) x.code,
      };
      final enabled = {
        for (final x in registry.all)
          if (!off.contains(x.code)) x.code,
      };
      final (router, c) = await _boot(
        t,
        signedInOverrides(gate: LicenseGate(enabledModules: enabled)),
      );
      expect(router.state.uri.path, '/dashboard', reason: m.code);
      expect(
        c.read(navItemsProvider).map((i) => i.path),
        isNot(contains(m.path)),
        reason: m.code,
      );
      router.go(m.path);
      await t.pumpAndSettle();
      expect(router.state.uri.path, '/not-licensed', reason: m.code);
      expect(find.text('Módulo não licenciado'), findsOneWidget);
    }
  });
}

/// Registry do catálogo padrão.
ModuleRegistry container0() {
  final c = ProviderContainer();
  addTearDown(c.dispose);
  return c.read(moduleRegistryProvider);
}
