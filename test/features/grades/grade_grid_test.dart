import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/grades/data/mock_api/grade_entry_mock_handlers.dart';
import 'package:erp_global/features/grades/data/mock_api/grades_mock_handlers.dart';
import 'package:erp_global/features/grades/domain/grade_entry_repository.dart';
import 'package:erp_global/features/grades/presentation/providers/grades_providers.dart';
import 'package:erp_global/features/grades/presentation/widgets/grade_grid.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = GradeSheetKey(classroomId: 'c1', subjectId: 's1', termId: 't1');

StudentModel _student(String id, String name) => StudentModel(
  id: id,
  institutionId: 'i',
  createdAt: DateTime.utc(2026),
  updatedAt: DateTime.utc(2026),
  processNumber: id,
  fullName: name,
  birthDate: DateTime.utc(2012),
  gender: Gender.female,
);

Future<void> _pump(
  WidgetTester tester,
  List<String> permissions, {
  bool closed = false,
}) async {
  tester.view.physicalSize = const Size(2000, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith(
        (ref) => [
          GradesMockHandlers(termLookup: (_) => GradeTermInfo(closed: closed)),
        ],
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
      classroomRosterProvider('c1').overrideWith(
        (ref) async => [
          _student('a1', 'Ana Silva'),
          _student('a2', 'Rui Costa'),
        ],
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
        home: const Scaffold(body: GradeGrid(sheetKey: _key)),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('valida o intervalo, calcula a MT e guarda', (tester) async {
    await _pump(tester, ['grades.entry.write']);
    expect(find.text('Ana Silva'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('grade_a1_MAC')), '25');
    await tester.pumpAndSettle();
    expect(find.text('Nota entre 0 e 20'), findsOneWidget);
    final save = find.widgetWithText(FilledButton, 'Guardar notas');
    expect(tester.widget<FilledButton>(save).onPressed, isNull);

    await tester.enterText(find.byKey(const Key('grade_a1_MAC')), '10');
    await tester.enterText(find.byKey(const Key('grade_a1_NPP')), '12');
    await tester.enterText(find.byKey(const Key('grade_a1_NPT')), '15,5');
    await tester.pumpAndSettle();
    // 10*0,3 + 12*0,3 + 15,5*0,4 = 12,8 → 13
    String mt(String id) =>
        tester.widget<Text>(find.byKey(Key('mt_$id'))).data ?? '';
    expect(mt('a1'), '13');
    expect(mt('a2'), '—');

    await tester.tap(save);
    await tester.pumpAndSettle();
    expect(find.text('Notas guardadas.'), findsOneWidget);
  });

  testWidgets('trimestre fechado: professor só vê, sem guardar', (
    tester,
  ) async {
    await _pump(tester, ['grades.entry.write'], closed: true);
    expect(find.text('Trimestre fechado'), findsOneWidget);
    expect(find.textContaining('Só leitura'), findsOneWidget);
    expect(find.text('Guardar notas'), findsNothing);
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('grade_a1_MAC')))
          .enabled,
      isFalse,
    );
  });

  testWidgets('trimestre fechado: aprovador edita com justificação', (
    tester,
  ) async {
    await _pump(tester, ['grades.entry.approve'], closed: true);
    await tester.enterText(find.byKey(const Key('grade_a1_NPT')), '9');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar notas'));
    await tester.pumpAndSettle();

    // Sem justificação o diálogo não confirma.
    await tester.tap(find.byKey(const Key('justification_confirm')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('justification_field')), findsOneWidget);

    await tester.enterText(
      find.byKey(const Key('justification_field')),
      'Correcção de pauta',
    );
    await tester.tap(find.byKey(const Key('justification_confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Notas guardadas.'), findsOneWidget);

    await tester.tap(find.text('Histórico'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Correcção de pauta'), findsOneWidget);
    expect(find.textContaining('Ana Silva · NPT: — → 9'), findsOneWidget);
  });
}
