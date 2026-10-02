import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erp_global/app/app.dart';
import 'package:erp_global/app/provider_overrides.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/license/domain/license_service.dart';
import 'package:erp_global/features/license/presentation/providers/license_providers.dart';

/// Regressão (#201): o Painel do admin aparecia vazio porque `/dashboard`
/// era um placeholder. Login real (mock API) com a licença de desenvolvimento.
void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('super_admin entra e o Painel mostra o dashboard da direcção', (
    tester,
  ) async {
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
    for (var i = 0; i < 60; i++) {
      await tester.pump(const Duration(milliseconds: 250));
    }

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Dashboard ·'), findsOneWidget);
    expect(find.textContaining('Alunos matriculados'), findsWidgets);
  });
}
