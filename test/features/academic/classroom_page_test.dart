import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/presentation/pages/academic_page.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
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
        (ref) => [AcademicStructureMockHandlers(), AcademicMockHandlers()],
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

  testWidgets('salas: lista o seed e cria uma sala', (tester) async {
    await _pump(tester, ['academic.*']);
    await tester.tap(find.text('Salas'));
    await tester.pumpAndSettle();
    expect(find.text('Laboratório de Informática'), findsOneWidget);

    await tester.tap(find.text('Nova sala'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);

    await tester.enterText(find.byKey(const Key('field_code')), 'BIB');
    await tester.enterText(find.byKey(const Key('field_name')), 'Biblioteca');
    await tester.enterText(find.byKey(const Key('field_capacity')), '50');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Biblioteca'), findsOneWidget);
  });

  testWidgets('turnos: horário inválido mostra o erro do servidor', (
    tester,
  ) async {
    await _pump(tester, ['academic.*']);
    await tester.tap(find.text('Turnos'));
    await tester.pumpAndSettle();
    expect(find.text('Manhã'), findsOneWidget);

    await tester.tap(find.text('Novo turno'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('field_name')), 'Extra');
    await tester.enterText(find.byKey(const Key('field_startTime')), '10:00');
    await tester.enterText(find.byKey(const Key('field_endTime')), '09:00');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Extra'), findsNothing);
  });

  testWidgets('turmas: lista com ano, vagas e sem escrita sem permissão', (
    tester,
  ) async {
    await _pump(tester, ['academic.classroom.read']);
    await tester.tap(find.text('Turmas'));
    await tester.pumpAndSettle();
    expect(find.text('2025/2026'), findsWidgets);
    expect(find.text('Nova turma'), findsNothing);
  });
}
