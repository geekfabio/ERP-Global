import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../domain/enrollment_flow.dart';
import '../data_mocks/enrollment_rules_seed.dart';
import '../models/enrollment_model.dart';
import '../models/enrollment_rules_model.dart';
import '../models/student_document_model.dart';
import '../models/student_enums.dart';
import '../models/student_model.dart';

/// Fluxo de matrícula: `/v1/enrollments/{id}/transition`, `/assign-classroom`,
/// `/v1/enrollment-rules` e `/v1/enrollment-vacancies`. Partilha o estado em
/// memória de [StudentsMockHandlers] (alunos, matrículas e documentos).
class EnrollmentFlowMockHandlers {
  EnrollmentFlowMockHandlers({
    required this.students,
    required this.enrollments,
    required this.documents,
  });

  final Map<String, StudentModel> Function() students;
  final Map<String, EnrollmentModel> Function() enrollments;
  final Map<String, StudentDocumentModel> Function() documents;

  EnrollmentRulesModel _rules = defaultEnrollmentRules;

  void reset() => _rules = defaultEnrollmentRules;

  void register(MockApiRegistry r) {
    r
      ..post('/v1/enrollments/{id}/transition', _transition)
      ..post('/v1/enrollments/{id}/assign-classroom', _assign)
      ..get('/v1/enrollment-rules', (_) => MockResponse.ok(_rules.toJson()))
      ..put('/v1/enrollment-rules', _saveRules)
      ..get('/v1/enrollment-vacancies', _vacancies);
  }

  EnrollmentModel _find(MockRequest req) {
    final e = enrollments()[req.params['id']];
    if (e == null || e.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    return e;
  }

  /// Turmas da classe `[gradeId]` (ids de referência partilhados).
  List<String> _rooms(String gradeId) {
    for (var i = 0; i < MockRef.gradeCount; i++) {
      if (MockRef.gradeId(i) != gradeId) continue;
      return [
        for (var l = 0; l < MockRef.classroomLetters.length; l++)
          MockRef.classroomId(i, l),
      ];
    }
    return const [];
  }

  Iterable<EnrollmentModel> _seated(EnrollmentModel e) =>
      enrollments().values.where(
        (x) =>
            x.deletedAt == null &&
            x.id != e.id &&
            x.academicYearId == e.academicYearId &&
            occupiesSeat(x.status),
      );

  int _occupied(EnrollmentModel e, String classroomId) =>
      _seated(e).where((x) => x.classroomId == classroomId).length;

  bool _roomHasSeat(EnrollmentModel e, String classroomId) =>
      _rules.capacityPerClassroom == 0 ||
      _occupied(e, classroomId) < _rules.capacityPerClassroom;

  /// Vaga na classe: lugares livres nas turmas menos aprovados sem turma.
  bool _gradeHasSeat(EnrollmentModel e) {
    if (_rules.capacityPerClassroom == 0) return true;
    final rooms = _rooms(e.gradeId);
    if (rooms.isEmpty) return true;
    final inGrade = _seated(e).where((x) => x.gradeId == e.gradeId);
    final total = rooms.length * _rules.capacityPerClassroom;
    return inGrade.length < total;
  }

  void _checkRoom(EnrollmentModel e, String classroomId) {
    if (!_rooms(e.gradeId).contains(classroomId)) {
      throw const MockApiException.validation({
        'classroomId': 'A turma não pertence à classe da matrícula',
      });
    }
    if (!_roomHasSeat(e, classroomId)) {
      throw const MockApiException.validation({
        'classroomId': 'A turma não tem vagas',
      });
    }
  }

  EnrollmentModel _withRoom(EnrollmentModel e, String classroomId) {
    final roll =
        enrollments().values
            .where((x) => x.deletedAt == null && x.classroomId == classroomId)
            .map((x) => x.rollNumber ?? 0)
            .fold(0, (a, b) => a > b ? a : b) +
        1;
    return e.copyWith(classroomId: classroomId, rollNumber: roll);
  }

  MockResponse _assign(MockRequest req) {
    final e = _find(req);
    final room = req.jsonBody['classroomId'];
    if (room is! String || room.isEmpty) {
      throw const MockApiException.validation({
        'classroomId': 'Campo obrigatório',
      });
    }
    if (e.status != EnrollmentStatus.approved &&
        e.status != EnrollmentStatus.confirmed) {
      throw const MockApiException.conflict(
        'Só matrículas aprovadas ou confirmadas têm turma',
      );
    }
    if (e.classroomId != room) _checkRoom(e, room);
    final updated = (e.classroomId == room ? e : _withRoom(e, room)).copyWith(
      updatedAt: DateTime.now().toUtc(),
    );
    enrollments()[e.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _transition(MockRequest req) {
    final e = _find(req);
    final to = EnrollmentStatus.values.asNameMap()[_camel(req.jsonBody['to'])];
    if (to == null) {
      throw const MockApiException.validation({'to': 'Estado inválido'});
    }
    final room = req.jsonBody['classroomId'] as String?;
    final student = students()[e.studentId];
    if (student == null) {
      throw const MockApiException.notFound('Aluno inexistente');
    }
    final target = room ?? e.classroomId;
    final seats = to == EnrollmentStatus.confirmed && target != null
        ? _roomHasSeat(e, target) || target == e.classroomId
        : _gradeHasSeat(e);
    final violations = enrollmentViolations(
      enrollment: e,
      to: to,
      birthDate: student.birthDate,
      documents: [
        for (final d in documents().values)
          if (d.studentId == e.studentId) d,
      ],
      rules: _rules,
      seatsFree: seats,
      classroomId: room,
    );
    if (violations.containsKey('status')) {
      throw MockApiException.conflict(violations['status']!);
    }
    if (violations.isNotEmpty) {
      throw MockApiException.validation(violations);
    }
    var updated = e;
    if (to == EnrollmentStatus.confirmed &&
        room != null &&
        room != e.classroomId) {
      _checkRoom(e, room);
      updated = _withRoom(e, room);
    }
    updated = updated.copyWith(status: to, updatedAt: DateTime.now().toUtc());
    enrollments()[e.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _saveRules(MockRequest req) {
    final EnrollmentRulesModel rules;
    try {
      rules = EnrollmentRulesModel.fromJson(req.jsonBody);
    } on Object {
      throw const MockApiException.badRequest();
    }
    final fields = <String, String>{
      if (rules.minAgeYears < 0 || rules.minAgeYears > 30)
        'minAgeYears': 'Entre 0 e 30',
      if (rules.capacityPerClassroom < 0 || rules.capacityPerClassroom > 200)
        'capacityPerClassroom': 'Entre 0 e 200',
    };
    if (fields.isNotEmpty) throw MockApiException.validation(fields);
    _rules = rules;
    return MockResponse.ok(_rules.toJson());
  }

  MockResponse _vacancies(MockRequest req) {
    final gradeId = req.query['gradeId'];
    final yearId = req.query['academicYearId'];
    if (gradeId == null || yearId == null) {
      throw const MockApiException.validation({'gradeId': 'Campo obrigatório'});
    }
    final seated = enrollments().values.where(
      (x) =>
          x.deletedAt == null &&
          x.academicYearId == yearId &&
          occupiesSeat(x.status),
    );
    return MockResponse.ok([
      for (final room in _rooms(gradeId))
        ClassroomVacancy(
          classroomId: room,
          capacity: _rules.capacityPerClassroom,
          occupied: seated.where((x) => x.classroomId == room).length,
        ).toJson(),
    ]);
  }

  /// `under_review` → `underReview`.
  static String? _camel(Object? wire) => wire is! String
      ? null
      : wire.replaceAllMapped(RegExp('_([a-z])'), (m) => m[1]!.toUpperCase());
}
