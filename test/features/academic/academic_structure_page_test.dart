import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/presentation/pages/academic_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(WidgetTester tester, List<String> permissions) async {
  tester.view.physicalSize = const Size(2600, 1800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [AcademicStructureMockHandlers()],
      ),
      apiClientProvider.overrideWith(
        (ref) => ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: ref.watch(mockApiRegistryProvider),
          mockConfig: const MockApiConfig.instant(),
          logging: false,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: const Scaffold(body: AcademicPage()),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('ciclos: lista o seed e cria um ciclo', (tester) async {
    await _pump(tester, ['academic.*']);
    expect(find.text('Ensino Primário'), findsOneWidget);

    await tester.tap(find.text('Novo ciclo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('field_code')), 'ESP');
    await tester.enterText(find.byKey(const Key('field_name')), 'Especial');
    await tester.enterText(find.byKey(const Key('field_order')), '9');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Especial'), findsOneWidget);
  });

  testWidgets('sem permissões não há acções de escrita', (tester) async {
    await _pump(tester, ['academic.class.read']);
    expect(find.text('Novo ciclo'), findsNothing);
  });

  testWidgets('currículo: escolher curso e classe mostra as disciplinas', (
    tester,
  ) async {
    await _pump(tester, ['academic.*']);
    await tester.tap(find.text('Currículo'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha um curso e uma classe'), findsOneWidget);

    await tester.tap(find.byKey(const Key('curriculum_course')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ciências Físicas e Biológicas').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Classe'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('12.ª classe').last);
    await tester.pumpAndSettle();
    expect(find.text('Física'), findsOneWidget);
    expect(find.text('Química'), findsOneWidget);
    expect(find.byKey(const Key('curriculum_total')), findsOneWidget);
    expect(find.text('Adicionar disciplina'), findsOneWidget);
  });
}
