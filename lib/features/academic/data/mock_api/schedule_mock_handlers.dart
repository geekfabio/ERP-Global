import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/schedule_rules.dart';
import '../data_mocks/academic_seed.dart';
import '../data_mocks/assignment_seed.dart';
import '../data_mocks/classroom_seed.dart';
import '../data_mocks/schedule_seed.dart';
import '../data_mocks/teacher_seed.dart';
import '../models/classroom_models.dart';
import '../models/schedule_models.dart';
import '../models/teacher_models.dart';

/// Handlers de `/v1/schedule-slots` (docs/07-mock-api.md). Estado em memória;
/// `POST /__mock/reset` repõe o seed. Conflitos de professor, sala ou turma
/// devolvem 409 e nada é gravado; campos inválidos devolvem 422.
///
/// Turmas, salas e professores criados em runtime vivem noutros módulos e não
/// são conhecidos aqui: só se valida o que o seed permite verificar.
class ScheduleMockHandlers implements MockApiModule {
  ScheduleMockHandlers() {
    _reset();
  }

  late SeedGenerator _ids;
  final Map<String, ScheduleSlotModel> _slots = {};
  final Map<String, ClassroomModel> _classrooms = {};
  final Map<String, ShiftModel> _shifts = {};
  final Set<String> _rooms = {};
  final Map<String, TeacherModel> _teachers = {};

  static final _spec = MockListSpec<ScheduleSlotModel>(
    sortable: {
      'weekday': (s) => s.weekday,
      'startTime': (s) => s.startTime,
      'classroomId': (s) => s.classroomId,
    },
    filterable: {
      'classroomId': (s) => s.classroomId,
      'teacherId': (s) => s.teacherId,
      'roomId': (s) => s.roomId,
      'subjectId': (s) => s.subjectId,
      'academicYearId': (s) => s.academicYearId,
      'weekday': (s) => '${s.weekday}',
    },
    defaultSort: const ['weekday', 'startTime'],
  );

  void _reset() {
    final academic = buildAcademicSeed();
    final classes = buildClassroomSeed(academic);
    final teachers = buildTeacherSeed(academic: academic, classrooms: classes);
    final assignments = buildAssignmentSeed(
      academic: academic,
      classrooms: classes,
      teachers: teachers,
    ).assignments;
    _ids = SeedGenerator(440);
    _slots
      ..clear()
      ..addEntries(
        buildScheduleSeed(
          classrooms: classes,
          assignments: assignments,
        ).map((s) => MapEntry(s.id, s)),
      );
    _classrooms
      ..clear()
      ..addEntries(classes.classrooms.map((c) => MapEntry(c.id, c)));
    _shifts
      ..clear()
      ..addEntries(classes.shifts.map((s) => MapEntry(s.id, s)));
    _rooms
      ..clear()
      ..addAll(classes.rooms.map((r) => r.id));
    _teachers
      ..clear()
      ..addEntries(teachers.map((t) => MapEntry(t.id, t)));
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get(
        '/v1/schedule-slots',
        (req) => mockPaginate(
          _slots.values,
          req,
          toJson: (s) => s.toJson(),
          spec: _spec,
        ),
      )
      ..get(
        '/v1/schedule-slots/{id}',
        (req) => MockResponse.ok(_find(req).toJson()),
      )
      ..post('/v1/schedule-slots', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = _build({...req.jsonBody, 'id': id});
        _slots[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/schedule-slots/{id}', (req) {
        final current = _find(req);
        final row = _build({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
        });
        _slots[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/schedule-slots/{id}', (req) {
        _slots.remove(_find(req).id);
        return MockResponse.ok(null);
      });
  }

  ScheduleSlotModel _find(MockRequest req) =>
      _slots[req.params['id']] ?? (throw const MockApiException.notFound());

  ScheduleSlotModel _build(Map<String, dynamic> raw) {
    final body = {
      for (final e in raw.entries)
        e.key: e.value is String ? (e.value as String).trim() : e.value,
    };
    final classroom = _classrooms['${body['classroomId']}'];
    MockValidator(body)
      ..required('classroomId')
      ..required('subjectId')
      ..required('teacherId')
      ..required('roomId')
      ..required('startTime')
      ..required('endTime')
      ..check('classroomId', classroom != null, 'Turma inválida')
      ..throwIfInvalid();
    final teacher = _teachers['${body['teacherId']}'];
    if (teacher != null && !teacher.isActive) {
      throw const MockApiException.validation({
        'teacherId': 'O professor está inactivo',
      });
    }
    if (_rooms.isNotEmpty && !_rooms.contains(body['roomId'])) {
      throw const MockApiException.validation({'roomId': 'Sala inválida'});
    }
    final ScheduleSlotModel row;
    try {
      row = ScheduleSlotModel.fromJson({
        ...body,
        'academicYearId': classroom!.academicYearId,
      });
    } on Object {
      throw const MockApiException.validation({'body': 'Dados inválidos'});
    }
    final shift = _shifts[classroom.shiftId];
    final issue = validateScheduleSlot(
      row,
      _slots.values.where(
        (s) => s.id != row.id && s.academicYearId == row.academicYearId,
      ),
      shiftStart: shift?.startTime,
      shiftEnd: shift?.endTime,
    );
    if (issue != null) {
      throw issue.kind == ScheduleIssueKind.validation
          ? MockApiException.validation({issue.field: issue.message})
          : MockApiException.conflict(issue.message);
    }
    return row;
  }
}
