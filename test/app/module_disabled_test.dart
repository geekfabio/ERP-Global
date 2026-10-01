import 'package:erp_global/app/router/app_router.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/modules/module_catalog.dart';
import 'package:erp_global/core/modules/module_registry.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/auth_test_helpers.dart';

void main() {
  final registry = ModuleRegistry(moduleCatalog);

  for (final off in moduleCatalog.where((m) => !m.required)) {
    testWidgets('módulo ${off.code} desligado: app arranca sem erros', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      // Licença sem o módulo nem os que dependem dele (já com dependências).
      final enabled = {
        for (final m in moduleCatalog)
          if (!registry.closure([m.code]).contains(off.code)) m.code,
      };
      final container = ProviderContainer(
        overrides: signedInOverrides(
          gate: LicenseGate(enabledModules: enabled),
        ),
      );
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
      expect(router.state.uri.path, '/dashboard');
      expect(tester.takeException(), isNull);
      // Menu: o módulo desligado não aparece.
      expect(find.text(off.name), findsNothing);

      // Rota do módulo desligado → ecrã "não licenciado", mesmo para super_admin.
      router.go(off.path);
      await tester.pumpAndSettle();
      expect(router.state.uri.path, '/not-licensed');
      expect(router.state.uri.queryParameters['module'], off.code);
      expect(tester.takeException(), isNull);

      // Os restantes módulos licenciados continuam acessíveis.
      for (final m in moduleCatalog.where((m) => enabled.contains(m.code))) {
        router.go(m.path);
        await tester.pumpAndSettle();
        expect(router.state.uri.path, m.path, reason: m.code);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
