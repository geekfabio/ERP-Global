import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../data_mocks/students_seed.dart';
import '../models/enrollment_model.dart';
import '../models/guardian_model.dart';
import '../models/student_model.dart';

/// Handlers de `/v1/students`, `/v1/guardians`, `/v1/enrollments` (docs/07-mock-api.md).
/// Estado mutável em memória; `POST /__mock/reset` repõe o seed.
class StudentsMockHandlers implements MockApiModule {
  StudentsMockHandlers({this.seed = 42, this.count = 300}) {
    _reset();
  }

  final int seed;
  final int count;

  late Map<String, StudentModel> _students;
  late Map<String, GuardianModel> _guardians;
  late Map<String, GuardianLinkModel> _links;
  late Map<String, EnrollmentModel> _enrollments;

  void _reset() {
    final s = buildStudentsSeed(seed: seed, count: count);
    _students = {for (final x in s.students) x.id: x};
    _guardians = {for (final x in s.guardians) x.id: x};
    _links = {for (final x in s.links) x.id: x};
    _enrollments = {for (final x in s.enrollments) x.id: x};
  }

  /// Matrícula mais recente (não cancelada) do aluno, para filtros por classe/turma.
  EnrollmentModel? _current(String studentId) {
    EnrollmentModel? best;
    for (final e in _enrollments.values) {
      if (e.studentId != studentId || e.deletedAt != null) continue;
      if (best == null || e.enrolledOn.isAfter(best.enrolledOn)) best = e;
    }
    return best;
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/students', _listStudents)
      ..get('/v1/students/{id}', (q) => MockResponse.ok(_student(q).toJson()))
      ..post('/v1/students', _createStudent)
      ..patch('/v1/students/{id}', _updateStudent)
      ..delete('/v1/students/{id}', _deleteStudent)
      ..get('/v1/students/{id}/guardians', _studentGuardians)
      ..get('/v1/guardians', _listGuardians)
      ..post('/v1/guardians', _createGuardian)
      ..post('/v1/guardian-links', _createLink)
      ..delete('/v1/guardian-links/{id}', _deleteLink)
      ..get('/v1/enrollments', _listEnrollments)
      ..post('/v1/enrollments', _createEnrollment)
      ..patch('/v1/enrollments/{id}', _updateEnrollment);
  }

  // ---- Alunos ---------------------------------------------------------

  late final _studentSpec = MockListSpec<StudentModel>(
    sortable: {
      'fullName': (s) => foldText(s.fullName),
      'processNumber': (s) => s.processNumber,
      'birthDate': (s) => s.birthDate,
      'createdAt': (s) => s.createdAt,
    },
    filterable: {
      'status': (s) => _wire(s.status),
      'gender': (s) => _wire(s.gender),
      'gradeId': (s) => _current(s.id)?.gradeId,
      'classroomId': (s) => _current(s.id)?.classroomId,
    },
    searchText: (s) => '${s.fullName} ${s.processNumber} ${s.idNumber ?? ''}',
    defaultSort: const ['fullName'],
  );

  /// `snake_case` como no JSON (`StudentStatus.dropout` → `dropout`).
  static String _wire(Enum e) => e.name.replaceAllMapped(
    RegExp('[A-Z]'),
    (m) => '_${m[0]!.toLowerCase()}',
  );

  MockResponse _listStudents(MockRequest req) => mockPaginate(
    _students.values.where((s) => s.deletedAt == null),
    req,
    toJson: (s) => s.toJson(),
    spec: _studentSpec,
  );

  StudentModel _student(MockRequest req) {
    final s = _students[req.params['id']];
    if (s == null || s.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    return s;
  }

  void _validateStudent(Map<String, dynamic> body, {bool partial = false}) {
    final v = MockValidator(body);
    if (!partial) {
      v
        ..required('fullName')
        ..required('birthDate')
        ..required('gender');
    }
    v.check(
      'fullName',
      body['fullName'] is! String ||
          (body['fullName'] as String).trim().length >= 3,
      'Indique o nome completo',
    );
    v.check(
      'gender',
      !body.containsKey('gender') ||
          body['gender'] == 'male' ||
          body['gender'] == 'female',
      'Valor inválido',
    );
    v.check(
      'birthDate',
      !body.containsKey('birthDate') ||
          RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch('${body['birthDate']}'),
      'Data inválida (yyyy-MM-dd)',
    );
    v.throwIfInvalid();
  }

  /// BI único entre alunos activos (409 `CONFLICT`).
  void _assertUniqueId(String? idNumber, {String? exceptId}) {
    if (idNumber == null || idNumber.isEmpty) return;
    final clash = _students.values.any(
      (s) => s.deletedAt == null && s.id != exceptId && s.idNumber == idNumber,
    );
    if (clash) {
      throw const MockApiException.conflict('Já existe um aluno com este BI');
    }
  }

  MockResponse _createStudent(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    _validateStudent(body);
    final now = DateTime.now().toUtc().toIso8601String();
    body.putIfAbsent('id', () => _newId());
    body['institutionId'] ??= 'mock';
    body['createdAt'] = now;
    body['updatedAt'] = now;
    // O n.º de processo é gerado no servidor (vazio/ausente no cliente).
    if ('${body['processNumber'] ?? ''}'.isEmpty) {
      body['processNumber'] =
          '2026/${(_students.length + 1).toString().padLeft(4, '0')}';
    }
    final student = StudentModel.fromJson(body);
    if (_students.containsKey(student.id)) {
      throw const MockApiException.conflict('Identificador já existe');
    }
    _assertUniqueId(student.idNumber);
    _students[student.id] = student;
    return MockResponse.created(student.toJson());
  }

  MockResponse _updateStudent(MockRequest req) {
    final current = _student(req);
    final patch = req.jsonBody;
    _validateStudent(patch, partial: true);
    final merged = {
      ...current.toJson(),
      ...patch,
      'id': current.id,
      'createdAt': current.createdAt.toIso8601String(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };
    final updated = StudentModel.fromJson(merged);
    _assertUniqueId(updated.idNumber, exceptId: current.id);
    _students[current.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _deleteStudent(MockRequest req) {
    final s = _student(req);
    _students[s.id] = s.copyWith(deletedAt: DateTime.now().toUtc());
    return MockResponse.ok({'deleted': true});
  }

  // ---- Encarregados -----------------------------------------------------

  MockResponse _studentGuardians(MockRequest req) {
    final s = _student(req);
    final items = [
      for (final l in _links.values)
        if (l.studentId == s.id &&
            l.deletedAt == null &&
            _guardians[l.guardianId] != null)
          {'guardian': _guardians[l.guardianId]!.toJson(), 'link': l.toJson()},
    ];
    return MockResponse.ok(items);
  }

  MockResponse _listGuardians(MockRequest req) => mockPaginate(
    _guardians.values.where((g) => g.deletedAt == null),
    req,
    toJson: (g) => g.toJson(),
    spec: MockListSpec<GuardianModel>(
      sortable: {'fullName': (g) => foldText(g.fullName)},
      searchText: (g) => '${g.fullName} ${g.phone} ${g.idNumber ?? ''}',
      defaultSort: const ['fullName'],
    ),
  );

  MockResponse _createGuardian(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    MockValidator(body)
      ..required('fullName')
      ..required('phone')
      ..throwIfInvalid();
    final now = DateTime.now().toUtc().toIso8601String();
    body
      ..putIfAbsent('id', _newId)
      ..putIfAbsent('institutionId', () => 'mock')
      ..['createdAt'] = now
      ..['updatedAt'] = now;
    final g = GuardianModel.fromJson(body);
    if (_guardians.containsKey(g.id)) throw const MockApiException.conflict();
    _guardians[g.id] = g;
    return MockResponse.created(g.toJson());
  }

  MockResponse _createLink(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    MockValidator(body)
      ..required('studentId')
      ..required('guardianId')
      ..required('relationship')
      ..throwIfInvalid();
    if (!_students.containsKey(body['studentId']) ||
        !_guardians.containsKey(body['guardianId'])) {
      throw const MockApiException.notFound('Aluno ou encarregado inexistente');
    }
    final duplicate = _links.values.any(
      (l) =>
          l.deletedAt == null &&
          l.studentId == body['studentId'] &&
          l.guardianId == body['guardianId'],
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'Encarregado já ligado a este aluno',
      );
    }
    final now = DateTime.now().toUtc().toIso8601String();
    body
      ..putIfAbsent('id', _newId)
      ..putIfAbsent('institutionId', () => 'mock')
      ..['createdAt'] = now
      ..['updatedAt'] = now;
    final link = GuardianLinkModel.fromJson(body);
    _links[link.id] = link;
    return MockResponse.created(link.toJson());
  }

  MockResponse _deleteLink(MockRequest req) {
    final link = _links[req.params['id']];
    if (link == null || link.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    _links[link.id] = link.copyWith(deletedAt: DateTime.now().toUtc());
    return MockResponse.ok({'deleted': true});
  }

  // ---- Matrículas --------------------------------------------------------

  MockResponse _listEnrollments(MockRequest req) => mockPaginate(
    _enrollments.values.where((e) => e.deletedAt == null),
    req,
    toJson: (e) => e.toJson(),
    spec: MockListSpec<EnrollmentModel>(
      sortable: {
        'enrolledOn': (e) => e.enrolledOn,
        'createdAt': (e) => e.createdAt,
      },
      filterable: {
        'studentId': (e) => e.studentId,
        'academicYearId': (e) => e.academicYearId,
        'gradeId': (e) => e.gradeId,
        'status': (e) => _wire(e.status),
      },
      defaultSort: const ['-enrolledOn'],
    ),
  );

  MockResponse _createEnrollment(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    MockValidator(body)
      ..required('studentId')
      ..required('academicYearId')
      ..required('gradeId')
      ..required('type')
      ..required('enrolledOn')
      ..throwIfInvalid();
    if (!_students.containsKey(body['studentId'])) {
      throw const MockApiException.notFound('Aluno inexistente');
    }
    final duplicate = _enrollments.values.any(
      (e) =>
          e.deletedAt == null &&
          e.studentId == body['studentId'] &&
          e.academicYearId == body['academicYearId'] &&
          e.status.name != 'cancelled',
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'O aluno já tem matrícula neste ano lectivo',
      );
    }
    final now = DateTime.now().toUtc().toIso8601String();
    body
      ..putIfAbsent('id', _newId)
      ..putIfAbsent('institutionId', () => 'mock')
      ..['createdAt'] = now
      ..['updatedAt'] = now;
    final e = EnrollmentModel.fromJson(body);
    _enrollments[e.id] = e;
    return MockResponse.created(e.toJson());
  }

  MockResponse _updateEnrollment(MockRequest req) {
    final current = _enrollments[req.params['id']];
    if (current == null || current.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    final merged = {
      ...current.toJson(),
      ...req.jsonBody,
      'id': current.id,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    };
    final updated = EnrollmentModel.fromJson(merged);
    _enrollments[current.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  int _seq = 0;
  String _newId() =>
      '01JMOCK${DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase().padLeft(9, '0')}${(_seq++).toString().padLeft(11, '0')}'
          .substring(0, 26);
}
