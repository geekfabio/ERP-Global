import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erp_global/app/app.dart';
import 'package:erp_global/app/provider_overrides.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:erp_global/features/license/domain/license_service.dart';
import 'package:erp_global/features/license/presentation/providers/license_providers.dart';

/// Regressão: "Terminar sessão" no menu do utilizador não fazia nada (o
/// `PopupMenuButton` não tinha `onSelected`).
void main() {
  setUpAll(PtAoFormatters.initialize);

  Future<ProviderContainer> signIn(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          ...buildAppOverrides(),
          licenseStoreProvider.overrideWithValue(InMemoryLicenseStore()),
        ],
        child: const ErpGlobalApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 300));
    final fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'admin@erp-global.local');
    await tester.enterText(fields.at(1), 'Admin@12345');
    await tester.tap(find.text('Entrar'));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }
    return ProviderScope.containerOf(tester.element(find.byType(MaterialApp)));
  }

  testWidgets('Terminar sessão pede confirmação, sai e volta ao login', (
    tester,
  ) async {
    final container = await signIn(tester);
    expect(container.read(authStateProvider).value, isNotNull);

    await tester.tap(find.byTooltip('Menu do utilizador'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terminar sessão'));
    await tester.pumpAndSettle();

    // Confirmação: cancelar mantém a sessão.
    expect(find.text('Quer mesmo sair da sua conta?'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(container.read(authStateProvider).value, isNotNull);

    // Confirmar termina a sessão e o router volta ao login.
    await tester.tap(find.byTooltip('Menu do utilizador'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Terminar sessão'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Terminar sessão'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    expect(container.read(authStateProvider).value, isNull);
    expect(find.text('Entrar'), findsOneWidget);
    expect(find.byTooltip('Menu do utilizador'), findsNothing);
    await tester.pump(const Duration(seconds: 2));
  });
}
