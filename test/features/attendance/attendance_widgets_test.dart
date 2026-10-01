import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/models/academic_models.dart';
import 'package:erp_global/features/academic/data/models/classroom_models.dart';
import 'package:erp_global/features/academic/data/models/schedule_models.dart';
import 'package:erp_global/features/academic/data/models/teacher_models.dart';
import 'package:erp_global/features/academic/presentation/providers/academic_structure_providers.dart';
import 'package:erp_global/features/academic/presentation/providers/assignment_providers.dart';
import 'package:erp_global/features/academic/presentation/providers/schedule_providers.dart';
import 'package:erp_global/features/attendance/data/mock_api/attendance_mock_handlers.dart';
import 'package:erp_global/features/attendance/data/models/attendance_models.dart';
import 'package:erp_global/features/attendance/domain/attendance_repository.dart';
import 'package:erp_global/features/attendance/presentation/pages/attendance_page.dart';
import 'package:erp_global/features/attendance/presentation/providers/attendance_providers.dart';
import 'package:erp_global/features/attendance/presentation/widgets/attendance_alerts_tab.dart';
import 'package:erp_global/features/attendance/presentation/widgets/attendance_justify_tab.dart';
import 'package:erp_global/features/attendance/presentation/widgets/attendance_sheet_tab.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

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

const _classroom = ClassroomModel(
  id: 'c1',
  academicYearId: 'y',
  gradeId: 'g',
  courseId: 'co',
  shiftId: 's',
  roomId: 'r',
  name: 'A',
  capacity: 30,
);

final _slot = ScheduleSlotModel(
  id: 'slot1',
  classroomId: 'c1',
  subjectId: 'math',
  teacherId: 't',
  roomId: 'r',
  weekday: DateTime.now().weekday,
  startTime: '08:00',
  endTime: '09:00',
);

Future<ProviderContainer> _pump(
  WidgetTester tester,
  Widget home,
  List<String> permissions, {
  AttendanceMockHandlers? handlers,
}) async {
  tester.view.physicalSize = const Size(1400, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final h =
      handlers ??
      AttendanceMockHandlers(
        withSeed: false,
        permissions: null,
        now: DateTime.now,
      );
  final container = ProviderContainer(
    overrides: [
      sessionPermissionsProvider.overrideWithValue(permissions),
      mockApiModulesProvider.overrideWith((ref) => [h]),
      apiClientProvider.overrideWith(
        (ref) => ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: ref.watch(mockApiRegistryProvider),
          mockConfig: const MockApiConfig.instant(),
          logging: false,
        ),
      ),
      attendanceRosterProvider('c1').overrideWith(
        (ref) async => [
          _student('a1', 'Ana Silva'),
          _student('a2', 'Rui Costa'),
        ],
      ),
      scheduleListProvider.overrideWith((ref) async => [_slot]),
      myTeacherProvider.overrideWith(
        (ref) async =>
            const TeacherModel(id: 't', fullName: 'Prof', email: 'p@x'),
      ),
      subjectListProvider.overrideWith(
        (ref) async => [
          const SubjectModel(id: 'math', code: 'MAT', name: 'Matemática'),
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
        home: Scaffold(body: home),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('regista o dia: marca falta, guarda e fica persistido', (
    tester,
  ) async {
    final container = await _pump(
      tester,
      const AttendanceSheetTab(
        option: (classroom: _classroom, canDaily: true, canLesson: false),
      ),
      ['attendance.record.write'],
    );
    expect(find.text('1. Ana Silva'), findsOneWidget);

    await tester.tap(
      find.descendant(
        of: find.byKey(const Key('attendance_status_a2')),
        matching: find.text('Falta'),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar presenças'));
    await tester.pumpAndSettle();
    expect(find.text('Presenças guardadas.'), findsOneWidget);

    final records = (await tester.runAsync(
      () => container
          .read(attendanceRepositoryProvider)
          .records(classroomId: 'c1'),
    ))!.getOrThrow().items;
    expect(
      {for (final r in records) r.studentId: r.status},
      {'a1': AttendanceStatus.present, 'a2': AttendanceStatus.absent},
    );
  });

  testWidgets('por aula: pede a aula do horário antes de mostrar a lista', (
    tester,
  ) async {
    await _pump(
      tester,
      const AttendanceSheetTab(
        option: (classroom: _classroom, canDaily: false, canLesson: true),
      ),
      ['attendance.record.write'],
    );
    expect(find.text('Escolha a aula'), findsOneWidget);
    await tester.tap(find.byKey(const Key('attendance_slot')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('08:00–09:00 · Matemática').last);
    await tester.pumpAndSettle();
    expect(find.text('1. Ana Silva'), findsOneWidget);
  });

  testWidgets('registo do dia só para o director de turma', (tester) async {
    await _pump(
      tester,
      const AttendanceSheetTab(
        option: (classroom: _classroom, canDaily: false, canLesson: true),
      ),
      ['attendance.record.write'],
    );
    await tester.tap(find.text('Por dia'));
    await tester.pumpAndSettle();
    expect(find.text('Só o director de turma regista o dia'), findsOneWidget);
    expect(find.text('Guardar presenças'), findsNothing);
  });

  testWidgets('alertas: limite configurável e lista de alunos', (tester) async {
    final handlers = AttendanceMockHandlers(withSeed: false);
    final container = await _pump(
      tester,
      const AttendanceAlertsTab(classroomId: 'c1', canConfigure: true),
      ['attendance.record.all'],
      handlers: handlers,
    );
    expect(find.text('Sem alertas'), findsOneWidget);

    final repo = container.read(attendanceRepositoryProvider);
    await tester.runAsync(() async {
      for (final day in ['2026-09-28', '2026-09-29']) {
        await repo.save(AttendanceSheetKey(classroomId: 'c1', date: day), [
          AttendanceRecordModel(
            classroomId: 'c1',
            studentId: 'a1',
            date: day,
            status: AttendanceStatus.absent,
          ),
        ]);
      }
    });
    await tester.enterText(find.byKey(const Key('attendance_limit')), '0');
    await tester.tap(find.byKey(const Key('attendance_limit_save')));
    await tester.pumpAndSettle();
    expect(find.text('Limite entre 1 e 100'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('attendance_limit')), '2');
    await tester.tap(find.byKey(const Key('attendance_limit_save')));
    await tester.pumpAndSettle();
    expect(find.text('Limite actualizado.'), findsOneWidget);
    expect(find.text('Ana Silva'), findsOneWidget);
    expect(find.text('2 faltas injustificadas (limite 2)'), findsOneWidget);
  });

  testWidgets('justifica uma falta e ela sai da lista', (tester) async {
    final container = await _pump(
      tester,
      const AttendanceJustifyTab(classroomId: 'c1'),
      ['attendance.record.all'],
    );
    expect(find.text('Sem faltas por justificar'), findsOneWidget);

    final repo = container.read(attendanceRepositoryProvider);
    final day = DateTime.now();
    final date =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    await tester.runAsync(
      () => repo.save(AttendanceSheetKey(classroomId: 'c1', date: date), [
        AttendanceRecordModel(
          classroomId: 'c1',
          studentId: 'a2',
          date: date,
          status: AttendanceStatus.absent,
        ),
      ]),
    );
    container.invalidate(unjustifiedAbsencesProvider('c1'));
    await tester.pumpAndSettle();
    expect(find.text('Rui Costa'), findsOneWidget);

    await tester.tap(find.text('Justificar'));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('attendance_reason')),
      'Doença',
    );
    await tester.tap(find.byKey(const Key('attendance_reason_confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Falta justificada.'), findsOneWidget);
    expect(find.text('Sem faltas por justificar'), findsOneWidget);
  });

  testWidgets('a página abre sem transbordar', (tester) async {
    await _pump(tester, const AttendancePage(), ['attendance.record.all']);
    expect(find.text('Presenças e faltas'), findsOneWidget);
  });
}
