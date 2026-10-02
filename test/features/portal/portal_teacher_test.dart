import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/features/academic/data/data_mocks/academic_seed.dart';
import 'package:erp_global/features/academic/data/data_mocks/assignment_seed.dart';
import 'package:erp_global/features/academic/data/data_mocks/classroom_seed.dart';
import 'package:erp_global/features/academic/data/data_mocks/teacher_seed.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/assignment_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/teacher_mock_handlers.dart';
import 'package:erp_global/features/portal/data/models/portal_teacher_models.dart';
import 'package:erp_global/features/portal/data/repositories/api_portal_teacher_repository.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_teacher_page.dart';
import 'package:erp_global/features/portal/presentation/providers/portal_teacher_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiPortalTeacherRepository _repo() => ApiPortalTeacherRepository(
  ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(AcademicStructureMockHandlers())
      ..addModule(TeacherMockHandlers())
      ..addModule(AssignmentMockHandlers()),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  ),
);

void main() {
  test('myClasses devolve só as turmas atribuídas ao professor', () async {
    final academic = buildAcademicSeed();
    final classes = buildClassroomSeed(academic);
    final teachers = buildTeacherSeed(academic: academic, classrooms: classes);
    final seed = buildAssignmentSeed(
      academic: academic,
      classrooms: classes,
      teachers: teachers,
    );
    final teacher = teachers.firstWhere(
      (t) => seed.assignments.any((a) => a.teacherId == t.id),
    );
    final homeroomIds = {
      for (final h in seed.homerooms)
        if (h.teacherId == teacher.id) h.classroomId,
    };
    final expected = {
      for (final a in seed.assignments)
        if (a.teacherId == teacher.id) a.classroomId,
      ...homeroomIds,
    };

    final mine = (await _repo().myClasses(
      email: teacher.email.toUpperCase(),
    )).getOrThrow();

    expect({for (final c in mine) c.classroomId}, expected);
    expect(mine.length, lessThan(classes.classrooms.length));
    for (final c in mine) {
      expect(c.gradeName, isNotEmpty);
      final subjects = {
        for (final a in seed.assignments)
          if (a.teacherId == teacher.id && a.classroomId == c.classroomId)
            a.subjectId,
      };
      expect({for (final s in c.subjects) s.id}, subjects);
    }
    expect({
      for (final c in mine)
        if (c.isHomeroom) c.classroomId,
    }, homeroomIds);
  });

  test('conta sem ficha de professor não tem turmas', () async {
    final unknown = await _repo().myClasses(email: 'ninguem@x.local');
    expect(unknown.getOrThrow(), isEmpty);
    expect((await _repo().myClasses(email: '')).getOrThrow(), isEmpty);
  });

  group('página', () {
    Future<void> pump(
      WidgetTester tester, {
      required List<TeacherClass> classes,
      Set<String> modules = const {'attendance', 'grades', 'guardian_portal'},
    }) async {
      tester.view.physicalSize = const Size(360, 740);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            portalTeacherClassesProvider.overrideWith((ref) async => classes),
            licenseGateProvider.overrideWithValue(
              LicenseGate(enabledModules: {'core', ...modules}),
            ),
            sessionPermissionsProvider.overrideWithValue(const [
              'attendance.record.write',
              'grades.entry.write',
            ]),
          ],
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: PortalTeacherPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    const sample = TeacherClass(
      classroomId: 'c1',
      name: 'A',
      gradeName: '10.ª Classe',
      shiftName: 'Manhã',
      enrolledCount: 28,
      isHomeroom: true,
      subjects: [TeacherSubject(id: 's1', name: 'Matemática')],
    );

    testWidgets('mostra a turma e os atalhos em ecrã pequeno', (tester) async {
      await pump(tester, classes: [sample]);
      expect(find.text('10.ª Classe A'), findsOneWidget);
      expect(find.text('Manhã · 28 alunos'), findsOneWidget);
      expect(find.text('Director de turma'), findsOneWidget);
      expect(find.text('Matemática'), findsOneWidget);
      expect(find.text('Presenças'), findsOneWidget);
      expect(find.text('Notas'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('esconde atalhos de módulos não licenciados', (tester) async {
      await pump(tester, classes: [sample], modules: {'grades'});
      expect(find.text('Presenças'), findsNothing);
      expect(find.text('Notas'), findsOneWidget);
    });

    testWidgets('sem turmas mostra estado vazio', (tester) async {
      await pump(tester, classes: const []);
      expect(find.text('Sem turmas atribuídas'), findsOneWidget);
    });
  });
}
