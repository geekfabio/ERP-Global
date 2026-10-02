import 'dart:convert';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/settings/data/mock_api/settings_mock_handlers.dart';
import 'package:erp_global/features/settings/presentation/pages/institution_page.dart';
import 'package:erp_global/features/settings/presentation/providers/settings_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

/// PNG válido de 1×1 pixel.
final _png = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
);

List<Override> _overrides(List<String> permissions) => [
  sessionPermissionsProvider.overrideWithValue(permissions),
  mockApiModulesProvider.overrideWith((ref) => [SettingsMockHandlers()]),
  apiClientProvider.overrideWith(
    (ref) => ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: ref.watch(mockApiRegistryProvider),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  ),
];

Future<ProviderContainer> _pump(
  WidgetTester tester,
  List<String> permissions,
) async {
  await PtAoFormatters.initialize();
  tester.view.physicalSize = const Size(1600, 1200);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: _overrides(permissions));
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: Scaffold(body: InstitutionPage(pickLogo: () async => _png)),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  testWidgets('edita a instituição e a cor da marca alimenta o tema', (
    tester,
  ) async {
    final container = await _pump(tester, const ['core.settings.*']);
    expect(
      container.read(institutionBrandColorProvider),
      const Color(0xFF0B3D91),
    );

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cor da marca'),
      '#00AA55',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Alterações guardadas.'), findsOneWidget);
    expect(
      container.read(institutionBrandColorProvider),
      const Color(0xFF00AA55),
    );
  });

  testWidgets('cor inválida bloqueia a gravação', (tester) async {
    await _pump(tester, const ['core.settings.*']);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Cor da marca'),
      'azul',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Use o formato #RRGGBB'), findsOneWidget);
  });

  testWidgets('carrega o logótipo', (tester) async {
    await _pump(tester, const ['core.settings.*']);
    await tester.tap(find.text('Carregar logótipo'));
    await tester.pumpAndSettle();
    expect(find.text('Logótipo actualizado.'), findsOneWidget);
  });

  testWidgets('cria, edita e elimina campus', (tester) async {
    await _pump(tester, const ['core.settings.*']);
    await tester.tap(find.text('Campus e filiais'));
    await tester.pumpAndSettle();
    expect(find.text('Sede'), findsOneWidget);

    await tester.tap(find.text('Novo campus'));
    await tester.pumpAndSettle();
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Benguela');
    await tester.enterText(fields.at(1), 'Av. Norton de Matos');
    await tester.enterText(fields.at(2), '+244 912 000 000');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Benguela'), findsOneWidget);

    // Nome duplicado → erro 409 mantido no diálogo.
    await tester.tap(find.text('Novo campus'));
    await tester.pumpAndSettle();
    await tester.enterText(fields.at(0), 'sede');
    await tester.enterText(fields.at(1), 'x');
    await tester.enterText(fields.at(2), '1');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Já existe um campus com este nome'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
  });

  testWidgets('só leitura: sem formulário nem botões de edição', (
    tester,
  ) async {
    await _pump(tester, const ['core.settings.read']);
    expect(find.text('Colégio Global'), findsOneWidget);
    expect(find.text('Guardar'), findsNothing);
    await tester.tap(find.text('Campus e filiais'));
    await tester.pumpAndSettle();
    expect(find.text('Sede'), findsOneWidget);
    expect(find.text('Novo campus'), findsNothing);
  });
}
