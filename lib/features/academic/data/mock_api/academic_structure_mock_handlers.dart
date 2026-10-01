import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/academic_seed.dart';
import '../models/academic_models.dart';

/// Colecção em memória de um recurso, com as regras do "servidor".
class _Collection<T> {
  _Collection({
    required this.fromJson,
    required this.toJson,
    required this.spec,
    required this.validate,
    this.guardDelete,
  });

  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  final MockListSpec<T> spec;

  /// Valida o corpo já fundido (422/409); `body['id']` identifica o próprio.
  final void Function(Map<String, dynamic> body) validate;

  /// Lança 409 se o registo ainda estiver em uso.
  final void Function(T row)? guardDelete;

  final Map<String, T> rows = {};

  T find(MockRequest req) =>
      rows[req.params['id']] ?? (throw const MockApiException.notFound());

  T build(Map<String, dynamic> body) {
    validate(body);
    try {
      return fromJson(body);
    } on Object {
      throw const MockApiException.validation({'body': 'Dados inválidos'});
    }
  }
}

/// Handlers de `/v1/levels`, `/v1/grades`, `/v1/courses`, `/v1/subjects` e
/// `/v1/curriculum-items` (docs/07-mock-api.md). Estado mutável em memória;
/// `POST /__mock/reset` repõe o seed angolano.
class AcademicStructureMockHandlers implements MockApiModule {
  AcademicStructureMockHandlers() {
    _reset();
  }

  late SeedGenerator _ids;

  late final _Collection<LevelModel> _levels = _Collection<LevelModel>(
    fromJson: LevelModel.fromJson,
    toJson: (v) => v.toJson(),
    spec: MockListSpec<LevelModel>(
      searchText: (l) => '${l.code} ${l.name}',
      sortable: {'order': (l) => l.order, 'name': (l) => foldText(l.name)},
      defaultSort: const ['order'],
    ),
    validate: (b) {
      _validateNamed(b, _levels.rows.values, 'ciclo', (l) => l.code);
      _requireInt(b, 'order', min: 0);
    },
    guardDelete: (l) {
      if (_grades.rows.values.any((g) => g.levelId == l.id)) {
        throw const MockApiException.conflict(
          'O ciclo tem classes; elimine-as primeiro',
        );
      }
      if (_courses.rows.values.any((c) => c.levelIds.contains(l.id))) {
        throw const MockApiException.conflict(
          'O ciclo é usado por cursos; retire-o primeiro',
        );
      }
    },
  );

  late final _Collection<GradeModel> _grades = _Collection<GradeModel>(
    fromJson: GradeModel.fromJson,
    toJson: (v) => v.toJson(),
    spec: MockListSpec<GradeModel>(
      searchText: (g) => g.name,
      sortable: {'order': (g) => g.order, 'name': (g) => foldText(g.name)},
      filterable: {'levelId': (g) => g.levelId},
      defaultSort: const ['order'],
    ),
    validate: (b) {
      MockValidator(b)
        ..required('name')
        ..required('levelId')
        ..check(
          'levelId',
          b['levelId'] == null || _levels.rows.containsKey(b['levelId']),
          'Ciclo inválido',
        )
        ..throwIfInvalid();
      _requireInt(b, 'order', min: 0);
      final taken = _grades.rows.values.any(
        (g) =>
            g.id != b['id'] &&
            (foldText(g.name) == foldText('${b['name']}') ||
                g.order == b['order']),
      );
      if (taken) {
        throw const MockApiException.conflict(
          'Já existe uma classe com este nome ou número',
        );
      }
    },
    guardDelete: (g) {
      if (_curriculum.rows.values.any((i) => i.gradeId == g.id)) {
        throw const MockApiException.conflict(
          'A classe tem disciplinas no currículo',
        );
      }
    },
  );

  late final _Collection<CourseModel> _courses = _Collection<CourseModel>(
    fromJson: CourseModel.fromJson,
    toJson: (v) => v.toJson(),
    spec: MockListSpec<CourseModel>(
      searchText: (c) => '${c.code} ${c.name}',
      sortable: {'code': (c) => c.code, 'name': (c) => foldText(c.name)},
      filterable: {'isActive': (c) => c.isActive},
      defaultSort: const ['code'],
    ),
    validate: (b) {
      _validateNamed(b, _courses.rows.values, 'curso', (c) => c.code);
      final levelIds = b['levelIds'];
      MockValidator(b)
        ..check(
          'levelIds',
          levelIds is List && levelIds.isNotEmpty,
          'Indique pelo menos um ciclo',
        )
        ..check(
          'levelIds',
          levelIds is! List ||
              levelIds.every((id) => _levels.rows.containsKey(id)),
          'Ciclo inválido',
        )
        ..throwIfInvalid();
      // Não retirar um ciclo que ainda tem currículo neste curso.
      final inUse = _curriculum.rows.values.any((i) {
        final level = _grades.rows[i.gradeId]?.levelId;
        return i.courseId == b['id'] && !(levelIds as List).contains(level);
      });
      if (inUse) {
        throw const MockApiException.conflict(
          'O curso tem currículo num ciclo que quer retirar',
        );
      }
    },
    guardDelete: (c) {
      if (_curriculum.rows.values.any((i) => i.courseId == c.id)) {
        throw const MockApiException.conflict('O curso tem currículo definido');
      }
    },
  );

  late final _Collection<SubjectModel> _subjects = _Collection<SubjectModel>(
    fromJson: SubjectModel.fromJson,
    toJson: (v) => v.toJson(),
    spec: MockListSpec<SubjectModel>(
      searchText: (s) => '${s.code} ${s.name}',
      sortable: {'code': (s) => s.code, 'name': (s) => foldText(s.name)},
      filterable: {'isActive': (s) => s.isActive},
      defaultSort: const ['name'],
    ),
    validate: (b) =>
        _validateNamed(b, _subjects.rows.values, 'disciplina', (s) => s.code),
    guardDelete: (s) {
      if (_curriculum.rows.values.any((i) => i.subjectId == s.id)) {
        throw const MockApiException.conflict(
          'A disciplina faz parte de um currículo',
        );
      }
    },
  );

  late final _Collection<CurriculumItemModel> _curriculum =
      _Collection<CurriculumItemModel>(
        fromJson: CurriculumItemModel.fromJson,
        toJson: (v) => v.toJson(),
        spec: MockListSpec<CurriculumItemModel>(
          sortable: {
            'grade': (i) => _grades.rows[i.gradeId]?.order ?? 0,
            'subject': (i) => foldText(_subjects.rows[i.subjectId]?.name ?? ''),
            'weeklyHours': (i) => i.weeklyHours,
          },
          filterable: {
            'courseId': (i) => i.courseId,
            'gradeId': (i) => i.gradeId,
            'subjectId': (i) => i.subjectId,
          },
          defaultSort: const ['grade', 'subject'],
        ),
        validate: (b) {
          final course = _courses.rows[b['courseId']];
          final grade = _grades.rows[b['gradeId']];
          MockValidator(b)
            ..check('courseId', course != null, 'Curso inválido')
            ..check('gradeId', grade != null, 'Classe inválida')
            ..check(
              'subjectId',
              _subjects.rows.containsKey(b['subjectId']),
              'Disciplina inválida',
            )
            ..throwIfInvalid();
          if (!course!.levelIds.contains(grade!.levelId)) {
            throw const MockApiException.validation({
              'gradeId': 'A classe não pertence aos ciclos do curso',
            });
          }
          _requireInt(b, 'weeklyHours', min: 1, max: 40);
          final duplicate = _curriculum.rows.values.any(
            (i) =>
                i.id != b['id'] &&
                i.courseId == b['courseId'] &&
                i.gradeId == b['gradeId'] &&
                i.subjectId == b['subjectId'],
          );
          if (duplicate) {
            throw const MockApiException.conflict(
              'A disciplina já consta neste curso e classe',
            );
          }
        },
      );

  void _reset() {
    final s = buildAcademicSeed();
    _ids = SeedGenerator(280);
    for (final c in [_levels, _grades, _courses, _subjects, _curriculum]) {
      c.rows.clear();
    }
    for (final v in s.levels) {
      _levels.rows[v.id] = v;
    }
    for (final v in s.grades) {
      _grades.rows[v.id] = v;
    }
    for (final v in s.courses) {
      _courses.rows[v.id] = v;
    }
    for (final v in s.subjects) {
      _subjects.rows[v.id] = v;
    }
    for (final v in s.curriculum) {
      _curriculum.rows[v.id] = v;
    }
  }

  @override
  void register(MockApiRegistry r) {
    r.onReset(_reset);
    _mount(r, '/v1/levels', _levels);
    _mount(r, '/v1/grades', _grades);
    _mount(r, '/v1/courses', _courses);
    _mount(r, '/v1/subjects', _subjects);
    _mount(r, '/v1/curriculum-items', _curriculum);
  }

  void _mount<T>(MockApiRegistry r, String path, _Collection<T> c) {
    r
      ..get(
        path,
        (req) => mockPaginate(
          c.rows.values,
          req,
          toJson: (v) => c.toJson(v),
          spec: c.spec,
        ),
      )
      ..post(path, (req) {
        final id = _ids.ulid(DateTime.now().toUtc());
        final row = c.build(_prepare({...req.jsonBody, 'id': id}));
        c.rows[id] = row;
        return MockResponse.created(c.toJson(row));
      })
      ..patch('$path/{id}', (req) {
        final current = c.find(req);
        final id = req.params['id']!;
        final row = c.build(
          _prepare({...c.toJson(current), ...req.jsonBody, 'id': id}),
        );
        c.rows[id] = row;
        return MockResponse.ok(c.toJson(row));
      })
      ..delete('$path/{id}', (req) {
        final row = c.find(req);
        c.guardDelete?.call(row);
        c.rows.remove(req.params['id']);
        return MockResponse.ok(null);
      });
  }

  /// Apara textos; os códigos ficam em maiúsculas.
  Map<String, dynamic> _prepare(Map<String, dynamic> body) => {
    for (final e in body.entries)
      e.key: e.value is String
          ? (e.key == 'code'
                ? (e.value as String).trim().toUpperCase()
                : (e.value as String).trim())
          : e.value,
  };

  /// `code` e `name` obrigatórios; `code` único na colecção.
  void _validateNamed<T>(
    Map<String, dynamic> body,
    Iterable<T> rows,
    String what,
    String Function(T) codeOf,
  ) {
    MockValidator(body)
      ..required('code')
      ..required('name')
      ..throwIfInvalid();
    if (rows.any((r) => codeOf(r) == body['code'] && _idOf(r) != body['id'])) {
      throw MockApiException.conflict('Já existe um $what com este código');
    }
  }

  String _idOf(Object? row) => switch (row) {
    LevelModel(:final id) => id,
    CourseModel(:final id) => id,
    SubjectModel(:final id) => id,
    _ => '',
  };

  void _requireInt(
    Map<String, dynamic> body,
    String field, {
    required int min,
    int? max,
  }) {
    final v = body[field];
    MockValidator(body)
      ..check(
        field,
        v is int && v >= min && (max == null || v <= max),
        max == null ? 'Mínimo $min' : 'Entre $min e $max',
      )
      ..throwIfInvalid();
  }
}
