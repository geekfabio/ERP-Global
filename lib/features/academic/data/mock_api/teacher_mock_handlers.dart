import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/academic_seed.dart';
import '../data_mocks/classroom_seed.dart';
import '../data_mocks/teacher_seed.dart';
import '../models/teacher_models.dart';

/// Handlers de `/v1/teachers` (docs/07-mock-api.md). Estado em memória;
/// `POST /__mock/reset` repõe o seed.
class TeacherMockHandlers implements MockApiModule {
  TeacherMockHandlers() {
    _reset();
  }

  late SeedGenerator _ids;
  final Map<String, TeacherModel> _rows = {};
  final Set<String> _subjectIds = {};
  final Set<String> _classroomIds = {};
  int _nextNumber = 1;

  static final _spec = MockListSpec<TeacherModel>(
    searchText: (t) => '${t.employeeNumber} ${t.fullName} ${t.email}',
    sortable: {
      'fullName': (t) => foldText(t.fullName),
      'employeeNumber': (t) => t.employeeNumber,
    },
    filterable: {'isActive': (t) => t.isActive},
    defaultSort: const ['fullName'],
  );

  void _reset() {
    final academic = buildAcademicSeed();
    final classes = buildClassroomSeed(academic);
    final seed = buildTeacherSeed(academic: academic, classrooms: classes);
    _ids = SeedGenerator(290);
    _rows
      ..clear()
      ..addEntries(seed.map((t) => MapEntry(t.id, t)));
    _subjectIds
      ..clear()
      ..addAll(academic.subjects.map((s) => s.id));
    _classroomIds
      ..clear()
      ..addAll(classes.classrooms.map((c) => c.id));
    _nextNumber = seed.length + 1;
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get(
        '/v1/teachers',
        (req) => mockPaginate(
          _byClassroom(req.query['filter[classroomId]']),
          MockRequest(
            method: req.method,
            path: req.path,
            query: {
              for (final e in req.query.entries)
                if (e.key != 'filter[classroomId]') e.key: e.value,
            },
          ),
          toJson: (t) => t.toJson(),
          spec: _spec,
        ),
      )
      ..get('/v1/teachers/{id}', (req) => MockResponse.ok(_find(req).toJson()))
      ..post('/v1/teachers', (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final built = _build({...req.jsonBody, 'id': id, 'employeeNumber': ''});
        final number = 'F${(_nextNumber++).toString().padLeft(4, '0')}';
        final row = built.copyWith(employeeNumber: number);
        _rows[id] = row;
        return MockResponse.created(row.toJson());
      })
      ..patch('/v1/teachers/{id}', (req) {
        final current = _find(req);
        final row = _build({
          ...current.toJson(),
          ...req.jsonBody,
          'id': current.id,
          'employeeNumber': current.employeeNumber,
        });
        _rows[current.id] = row;
        return MockResponse.ok(row.toJson());
      })
      ..delete('/v1/teachers/{id}', (req) {
        final row = _find(req);
        if (row.classroomIds.isNotEmpty) {
          throw const MockApiException.conflict(
            'O professor tem turmas atribuídas; retire-as primeiro',
          );
        }
        _rows.remove(row.id);
        return MockResponse.ok(null);
      });
  }

  Iterable<TeacherModel> _byClassroom(String? classroomId) =>
      classroomId == null
      ? _rows.values
      : _rows.values.where((t) => t.classroomIds.contains(classroomId));

  TeacherModel _find(MockRequest req) =>
      _rows[req.params['id']] ?? (throw const MockApiException.notFound());

  TeacherModel _build(Map<String, dynamic> raw) {
    final body = {
      for (final e in raw.entries)
        e.key: e.value is String ? (e.value as String).trim() : e.value,
    };
    final subjects = body['subjectIds'];
    final classrooms = body['classroomIds'] ?? const <String>[];
    MockValidator(body)
      ..required('fullName')
      ..required('email')
      ..email('email')
      ..check(
        'subjectIds',
        subjects is List && subjects.isNotEmpty,
        'Indique pelo menos uma disciplina',
      )
      ..check(
        'subjectIds',
        subjects is! List || subjects.every(_subjectIds.contains),
        'Disciplina inválida',
      )
      ..check(
        'classroomIds',
        classrooms is List && classrooms.every(_classroomIds.contains),
        'Turma inválida',
      )
      ..throwIfInvalid();
    final email = foldText('${body['email']}');
    if (_rows.values.any(
      (t) => t.id != body['id'] && foldText(t.email) == email,
    )) {
      throw const MockApiException.conflict(
        'Já existe um professor com este email',
      );
    }
    return TeacherModel.fromJson(body);
  }
}
