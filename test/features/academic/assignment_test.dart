import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/assignment_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/teacher_mock_handlers.dart';
import 'package:erp_global/features/academic/data/models/assignment_models.dart';
import 'package:erp_global/features/academic/data/models/classroom_models.dart';
import 'package:erp_global/features/academic/data/repositories/api_academic_repositories.dart';
import 'package:erp_global/features/academic/domain/assignment_rules.dart';
import 'package:erp_global/features/academic/presentation/pages/academic_page.dart';
import 'package:erp_global/features/academic/presentation/providers/assignment_providers.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/data/models/user_model.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ClassroomModel _classroom(String id) => ClassroomModel(
  id: id,
  academicYearId: 'y',
  gradeId: 'g',
  courseId: 'k',
  shiftId: 's',
  roomId: 'r',
  name: id,
  capacity: 30,
);

TeachingAssignmentModel _a(
  String id, {
  String teacher = 't1',
  String classroom = 'c1',
  String subject = 's1',
  int hours = 4,
  AssignmentRole role = AssignmentRole.titular,
  String? from,
  String? until,
}) => TeachingAssignmentModel(
  id: id,
  teacherId: teacher,
  classroomId: classroom,
  subjectId: subject,
  weeklyHours: hours,
  role: role,
  validFrom: from,
  validUntil: until,
);

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(AssignmentMockHandlers())
    ..addModule(TeacherMockHandlers())
    ..addModule(AcademicStructureMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('validateAssignment', () {
    test('aceita titular válido', () {
      expect(validateAssignment(_a('x', subject: 's2'), [_a('1')]), isNull);
    });

    test('horas devem ser positivas', () {
      expect(
        validateAssignment(_a('x', hours: 0), const [])?.field,
        'weeklyHours',
      );
    });

    test('titular único por turma × disciplina', () {
      final issue = validateAssignment(_a('x', teacher: 't2'), [_a('1')]);
      expect(issue?.kind, AssignmentIssueKind.conflict);
      expect(issue?.field, 'role');
    });

    test('carga máxima semanal', () {
      final others = [_a('1', hours: 20, subject: 's9')];
      expect(
        validateAssignment(_a('x', hours: 4, classroom: 'c2'), others),
        isNull,
      );
      final over = validateAssignment(
        _a('x', hours: 5, classroom: 'c2'),
        others,
      );
      expect(over?.kind, AssignmentIssueKind.conflict);
      expect(over?.field, 'weeklyHours');
    });

    test('substituto exige titular, outro professor e validade coerente', () {
      TeachingAssignmentModel sub({String? f, String? u, String t = 't2'}) =>
          _a(
            'x',
            teacher: t,
            role: AssignmentRole.substitute,
            from: f,
            until: u,
          );
      final titular = [_a('1')];
      expect(
        validateAssignment(sub(u: '2026-03-01'), titular)?.field,
        'validFrom',
      );
      expect(
        validateAssignment(sub(f: '2026-03-01'), titular)?.field,
        'validUntil',
      );
      expect(
        validateAssignment(
          sub(f: '2026-03-10', u: '2026-03-01'),
          titular,
        )?.field,
        'validUntil',
      );
      expect(
        validateAssignment(
          sub(f: '2026-03-01', u: '2026-03-10'),
          const [],
        )?.field,
        'role',
      );
      expect(
        validateAssignment(
          sub(f: '2026-03-01', u: '2026-03-10', t: 't1'),
          titular,
        )?.field,
        'teacherId',
      );
      expect(
        validateAssignment(sub(f: '2026-03-01', u: '2026-03-10'), titular),
        isNull,
      );
    });

    test('mesmo professor não repete a disciplina', () {
      final issue = validateAssignment(
        _a(
          'x',
          role: AssignmentRole.substitute,
          from: '2026-01-01',
          until: '2026-01-02',
        ),
        [
          _a('1', teacher: 't2'),
          _a(
            '2',
            role: AssignmentRole.substitute,
            from: '2026-01-01',
            until: '2026-01-05',
          ),
        ],
      );
      expect(issue?.kind, AssignmentIssueKind.conflict);
    });
  });

  group('Mock API', () {
    test('seed respeita as regras e cada turma tem director único', () async {
      final c = _client();
      final repo = apiTeachingAssignmentRepository(c);
      final all = (await repo.list(pageSize: 100)).getOrThrow();
      expect(all.items, isNotEmpty);
      final homerooms = (await apiHomeroomRepository(
        c,
      ).list(pageSize: 100)).getOrThrow().items;
      expect(
        homerooms.map((h) => h.classroomId).toSet().length,
        homerooms.length,
      );
    });

    test('filtra por professor e valida titular, carga e director', () async {
      final c = _client();
      final repo = apiTeachingAssignmentRepository(c);
      final first = (await repo.list(pageSize: 100)).getOrThrow().items.first;

      final mine = (await repo.list(
        filters: {'teacherId': first.teacherId},
      )).getOrThrow().items;
      expect(mine.every((a) => a.teacherId == first.teacherId), isTrue);

      // Segundo titular na mesma turma × disciplina: 409.
      final dup = await repo.create(first.copyWith(id: '', teacherId: 'outro'));
      expect(dup.failureOrNull?.code, anyOf('CONFLICT', 'VALIDATION_ERROR'));

      // Substituto sem validade: 422.
      final noDates = await repo.create(
        first.copyWith(id: '', role: AssignmentRole.substitute),
      );
      expect(noDates.failureOrNull?.code, 'VALIDATION_ERROR');

      // Director de turma único.
      final homeRepo = apiHomeroomRepository(c);
      final home = (await homeRepo.list()).getOrThrow().items.first;
      final again = await homeRepo.create(
        HomeroomModel(
          id: '',
          classroomId: home.classroomId,
          teacherId: home.teacherId,
        ),
      );
      expect(again.failureOrNull?.code, 'CONFLICT');
    });

    test('professor sem lista só vê as suas turmas', () {
      final mine = buildMyClassrooms(
        teacherId: 't1',
        assignments: [
          _a('1'),
          _a('2', teacher: 't2', classroom: 'c2'),
        ],
        homerooms: const [
          HomeroomModel(id: 'h', classroomId: 'c3', teacherId: 't1'),
        ],
        classrooms: [
          for (final id in ['c1', 'c2', 'c3']) _classroom(id),
        ],
      );
      expect(mine.map((m) => m.classroom.id), ['c1', 'c3']);
      expect(mine.last.isHomeroom, isTrue);
    });
  });

  group('UI', () {
    Future<ProviderContainer> pump(
      WidgetTester tester, {
      required List<String> permissions,
      String? email,
    }) async {
      tester.view.physicalSize = const Size(2600, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          if (email != null)
            currentSessionProvider.overrideWithValue(
              AuthSession(
                user: UserModel(
                  id: 'u',
                  institutionId: 'i',
                  createdAt: DateTime.utc(2026),
                  updatedAt: DateTime.utc(2026),
                  name: 'Prof',
                  email: email,
                ),
                roles: const ['professor'],
                permissions: permissions,
                license: const {},
              ),
            ),
          mockApiModulesProvider.overrideWith(
            (ref) => [
              AcademicStructureMockHandlers(),
              AcademicMockHandlers(),
              TeacherMockHandlers(),
              AssignmentMockHandlers(),
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
      await tester.tap(find.text('Atribuições'));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('matriz: abre uma célula e mostra o titular', (tester) async {
      final container = await pump(tester, permissions: ['academic.*']);
      expect(find.text('Director'), findsOneWidget);
      final first = (await container.read(assignmentListProvider.future)).first;
      await tester.ensureVisible(
        find.byKey(Key('cell_${first.classroomId}_${first.subjectId}')),
      );
      await tester.tap(
        find.byKey(Key('cell_${first.classroomId}_${first.subjectId}')),
      );
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('assignment_cell_dialog')), findsOneWidget);
      expect(find.text('Titular'), findsOneWidget);
      expect(find.text('Adicionar substituto'), findsOneWidget);
    });

    testWidgets('professor vê só as suas turmas', (tester) async {
      final (email, expected) = (await tester.runAsync(() async {
        final c = _client();
        final all = (await apiTeachingAssignmentRepository(
          c,
        ).list(pageSize: 100)).getOrThrow().items;
        final teacherId = all.first.teacherId;
        final own = (await apiTeachingAssignmentRepository(
          c,
        ).list(pageSize: 100, filters: {'teacherId': teacherId})).getOrThrow();
        final teachers = (await apiTeacherRepository(
          c,
        ).list(pageSize: 100)).getOrThrow().items;
        return (
          teachers.firstWhere((t) => t.id == teacherId).email,
          own.items.map((a) => a.classroomId).toSet().length,
        );
      }))!;
      await pump(tester, permissions: ['academic.class.read'], email: email);
      expect(find.text('Director'), findsNothing);
      expect(find.byType(Card), findsNWidgets(expected));
    });
  });
}
