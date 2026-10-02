import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/assignment_rules.dart';
import '../data_mocks/academic_seed.dart';
import '../data_mocks/assignment_seed.dart';
import '../data_mocks/classroom_seed.dart';
import '../data_mocks/teacher_seed.dart';
import '../models/assignment_models.dart';
import '../models/classroom_models.dart';
import '../models/teacher_models.dart';

/// Handlers de `/v1/teaching-assignments` e `/v1/homerooms`
/// (docs/07-mock-api.md). Estado em memória; `POST /__mock/reset` repõe o seed.
///
/// Os professores criados em runtime não são conhecidos aqui (o estado vive no
/// módulo de professores): para esses só se valida o que não depende da ficha.
class AssignmentMockHandlers implements MockApiModule {
  AssignmentMockHandlers() {
    _reset();
  }

  late SeedGenerator _ids;
  final Map<String, TeachingAssignmentModel> _assignments = {};
  final Map<String, HomeroomModel> _homerooms = {};
  final Map<String, TeacherModel> _teachers = {};
  final Map<String, ClassroomModel> _classrooms = {};
  final Set<String> _curriculum = {};

  static final _assignmentSpec = MockListSpec<TeachingAssignmentModel>(
    sortable: {
      'classroomId': (a) => a.classroomId,
      'subjectId': (a) => a.subjectId,
    },
    filterable: {
      'teacherId': (a) => a.teacherId,
      'classroomId': (a) => a.classroomId,
      'subjectId': (a) => a.subjectId,
      'academicYearId': (a) => a.academicYearId,
      'role': (a) => a.role.name,
    },
    defaultSort: const ['classroomId', 'subjectId'],
  );

  static final _homeroomSpec = MockListSpec<HomeroomModel>(
    sortable: {'classroomId': (h) => h.classroomId},
    filterable: {
      'teacherId': (h) => h.teacherId,
      'classroomId': (h) => h.classroomId,
    },
    defaultSort: const ['classroomId'],
  );

  void _reset() {
    final academic = buildAcademicSeed();
    final classes = buildClassroomSeed(academic);
    final teachers = buildTeacherSeed(academic: academic, classrooms: classes);
    final seed = buildAssignmentSeed(
      academic: academic,
      classrooms: classes,
      teachers: teachers,
    );
    _ids = SeedGenerator(430);
    _assignments
      ..clear()
      ..addEntries(seed.assignments.map((a) => MapEntry(a.id, a)));
    _homerooms
      ..clear()
      ..addEntries(seed.homerooms.map((h) => MapEntry(h.id, h)));
    _teachers
      ..clear()
      ..addEntries(teachers.map((t) => MapEntry(t.id, t)));
    _classrooms
      ..clear()
      ..addEntries(classes.classrooms.map((c) => MapEntry(c.id, c)));
    _curriculum
      ..clear()
      ..addAll(
        academic.curriculum.map(
          (c) => '${c.courseId}/${c.gradeId}/${c.subjectId}',
        ),
      );
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get(
        '/v1/teaching-assignments',
        (req) => mockPaginate(
          _assignments.values,
          req,
          toJson: (a) => a.toJson(),
          spec: _assignmentSpec,
        ),
      )
      ..get(
        '/v1/teaching-assignments/{id}',
        (req) => MockResponse.ok(_findAssignment(req).toJson()),
      )
      ..post('/v1/teaching-assignments', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildAssignment({...req.jsonBody, 'id': id});
        _assignments[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/teaching-assignments/{id}', (req) {
        final current = _findAssignment(req);
        final row = _buildAssignment({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _assignments[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/teaching-assignments/{id}', (req) {
        final row = _findAssignment(req);
        final dependants = _assignments.values.where(
          (a) =>
              a.role == AssignmentRole.substitute &&
              a.classroomId == row.classroomId &&
              a.subjectId == row.subjectId,
        );
        if (row.role == AssignmentRole.titular && dependants.isNotEmpty) {
          throw const MockApiException.conflict(
            'Retire primeiro os substitutos desta disciplina',
          );
        }
        _assignments.remove(row.id);
        return MockResponse.ok(null);
      })
      ..get(
        '/v1/homerooms',
        (req) => mockPaginate(
          _homerooms.values,
          req,
          toJson: (h) => h.toJson(),
          spec: _homeroomSpec,
        ),
      )
      ..post('/v1/homerooms', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _buildHomeroom({...req.jsonBody, 'id': id});
        _homerooms[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/homerooms/{id}', (req) {
        final current = _findHomeroom(req);
        final row = _buildHomeroom({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _homerooms[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/homerooms/{id}', (req) {
        _homerooms.remove(_findHomeroom(req).id);
        return MockResponse.ok(null);
      });
  }

  TeachingAssignmentModel _findAssignment(MockRequest req) =>
      _assignments[req.params['id']] ??
      (throw const MockApiException.notFound());

  HomeroomModel _findHomeroom(MockRequest req) =>
      _homerooms[req.params['id']] ?? (throw const MockApiException.notFound());

  void _checkTeacher(Map<String, dynamic> body) {
    final teacher = _teachers['${body['teacherId']}'];
    if (teacher != null && !teacher.isActive) {
      throw const MockApiException.validation({
        'teacherId': 'O professor está inactivo',
      });
    }
  }

  TeachingAssignmentModel _buildAssignment(Map<String, dynamic> raw) {
    final body = {
      for (final e in raw.entries)
        e.key: e.value is String ? (e.value as String).trim() : e.value,
    };
    final classroom = _classrooms['${body['classroomId']}'];
    MockValidator(body)
      ..required('teacherId')
      ..required('classroomId')
      ..required('subjectId')
      ..check('classroomId', classroom != null, 'Turma inválida')
      ..throwIfInvalid();
    _checkTeacher(body);
    final teacher = _teachers['${body['teacherId']}'];
    if (teacher != null && !teacher.subjectIds.contains(body['subjectId'])) {
      throw const MockApiException.validation({
        'subjectId': 'O professor não lecciona esta disciplina',
      });
    }
    if (!_curriculum.contains(
      '${classroom!.courseId}/${classroom.gradeId}/${body['subjectId']}',
    )) {
      throw const MockApiException.validation({
        'subjectId': 'A disciplina não consta do currículo da turma',
      });
    }
    final TeachingAssignmentModel row;
    try {
      row = TeachingAssignmentModel.fromJson({
        ...body,
        'academicYearId': classroom.academicYearId,
      });
    } on Object {
      throw const MockApiException.validation({'body': 'Dados inválidos'});
    }
    final candidate = row.role == AssignmentRole.titular
        ? row.copyWith(validFrom: null, validUntil: null)
        : row;
    final issue = validateAssignment(
      candidate,
      _assignments.values.where(
        (a) =>
            a.id != candidate.id &&
            a.academicYearId == candidate.academicYearId,
      ),
    );
    if (issue != null) {
      throw issue.kind == AssignmentIssueKind.validation
          ? MockApiException.validation({issue.field: issue.message})
          : MockApiException.conflict(issue.message);
    }
    return candidate;
  }

  HomeroomModel _buildHomeroom(Map<String, dynamic> body) {
    MockValidator(body)
      ..required('classroomId')
      ..required('teacherId')
      ..check(
        'classroomId',
        _classrooms.containsKey(body['classroomId']),
        'Turma inválida',
      )
      ..throwIfInvalid();
    _checkTeacher(body);
    if (_homerooms.values.any(
      (h) => h.id != body['id'] && h.classroomId == body['classroomId'],
    )) {
      throw const MockApiException.conflict('A turma já tem director de turma');
    }
    return HomeroomModel.fromJson(body);
  }
}
