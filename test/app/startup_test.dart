import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erp_global/app/app.dart';
import 'package:erp_global/app/provider_overrides.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/import_export/presentation/providers/import_providers.dart';

/// Regressão: o arranque real (`main`) falhava com "provider em estado de
/// erro" por um ciclo entre providers. Nenhum teste monta o grafo completo.
void main() {
  setUpAll(PtAoFormatters.initialize);

  test('o grafo de providers de main() resolve sem ciclos', () {
    final container = ProviderContainer(overrides: buildAppOverrides());
    addTearDown(container.dispose);

    expect(() => container.read(apiClientProvider), returnsNormally);
    expect(() => container.read(mockApiModulesProvider), returnsNormally);
    expect(() => container.read(importMockHandlersProvider), returnsNormally);
    expect(() => container.read(importTermLookupProvider), returnsNormally);
  });

  testWidgets('a app arranca no login com os overrides reais', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: buildAppOverrides(),
        child: const ErpGlobalApp(),
      ),
    );
    await tester.pumpAndSettle(const Duration(milliseconds: 200));
    expect(tester.takeException(), isNull);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
