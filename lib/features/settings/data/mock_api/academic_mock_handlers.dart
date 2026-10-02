import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/academic_rules.dart';
import '../data_mocks/academic_seed.dart';
import '../models/academic_year_model.dart';
import '../models/term_model.dart';

/// Handlers de `/v1/academic-years` e `/v1/terms` (docs/07-mock-api.md).
/// As regras vivem aqui, como no servidor: transições só para a frente, 1 ano
/// activo por campus, ano encerrado congelado, reabrir período exige `approve`.
/// Estado mutável em memória; `POST /__mock/reset` repõe o seed.
class AcademicMockHandlers implements MockApiModule {
  AcademicMockHandlers({this.permissions, DateTime Function()? now})
    : _now = now ?? DateTime.now {
    _reset();
  }

  final PermissionService Function()? permissions;
  final DateTime Function() _now;

  late Map<String, Map<String, dynamic>> _years;
  late Map<String, Map<String, dynamic>> _terms;
  late SeedGenerator _ids;

  static const _date = DateOnlyConverter();

  void _reset() {
    _years = {for (final y in academicYearSeed()) y['id']! as String: y};
    _terms = {for (final t in termSeed()) t['id']! as String: t};
    _ids = SeedGenerator(27);
  }

  /// Sem [permissions] configuradas o handler não restringe (testes de contrato).
  MockHandler _guard(String permission, MockHandler handler) => (request) {
    final service = permissions?.call();
    if (service != null && !service.can(permission)) {
      throw const MockApiException.forbidden();
    }
    return handler(request);
  };

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/academic-years', _listYears)
      ..post('/v1/academic-years', _guard(academicUpdatePermission, _create))
      ..patch(
        '/v1/academic-years/{id}',
        _guard(academicUpdatePermission, _updateYear),
      )
      ..post(
        '/v1/academic-years/{id}/transition',
        _guard(academicUpdatePermission, _transition),
      )
      ..get('/v1/academic-years/{id}/terms', _listTerms)
      ..patch('/v1/terms/{id}', _guard(academicUpdatePermission, _updateTerm))
      ..post('/v1/terms/{id}/open', _guard(academicUpdatePermission, _open))
      ..post('/v1/terms/{id}/close', _guard(academicUpdatePermission, _close));
  }

  Map<String, dynamic> _year(String? id) =>
      _years[id] ?? (throw const MockApiException.notFound());

  Map<String, dynamic> _term(String? id) =>
      _terms[id] ?? (throw const MockApiException.notFound());

  AcademicYearStatus _status(Map<String, dynamic> year) =>
      AcademicYearStatus.values.byName(year['status']! as String);

  DateTime? _parse(Object? value) {
    if (value is! String) return null;
    try {
      return _date.fromJson(value);
    } on FormatException {
      return null;
    }
  }

  Iterable<Map<String, dynamic>> _termsOf(String yearId) =>
      _terms.values.where((t) => t['academicYearId'] == yearId);

  void _ensureNotFrozen(Map<String, dynamic> year) {
    if (isFrozen(_status(year))) {
      throw const MockApiException.conflict(
        'O ano lectivo está encerrado e é só de leitura',
      );
    }
  }

  MockResponse _listYears(MockRequest q) => mockPaginate(
    _years.values,
    q,
    toJson: (y) => y,
    spec: MockListSpec<Map<String, dynamic>>(
      sortable: {
        'code': (y) => y['code']! as String,
        'startDate': (y) => y['startDate']! as String,
      },
      filterable: {
        'status': (y) => y['status'],
        'campusId': (y) => y['campusId'],
      },
      searchText: (y) => y['code']! as String,
      defaultSort: const ['-code'],
    ),
  );

  MockResponse _listTerms(MockRequest q) {
    final year = _year(q.params['id']);
    return mockPaginate(
      _termsOf(year['id']! as String),
      q,
      toJson: (t) => t,
      spec: MockListSpec<Map<String, dynamic>>(
        sortable: {'order': (t) => t['order']! as int},
        defaultSort: const ['order'],
      ),
    );
  }

  /// Valida o intervalo `[start, end]` de [data] e devolve-o; lança 422.
  (DateTime, DateTime) _validRange(Map<String, dynamic> data) {
    final s = _parse(data['startDate']);
    final e = _parse(data['endDate']);
    final v = MockValidator(data)
      ..check('startDate', s != null, 'Data inválida')
      ..check('endDate', e != null, 'Data inválida');
    if (s != null && e != null) {
      v.check(
        'endDate',
        e.isAfter(s),
        'A data de fim deve ser posterior à de início',
      );
    }
    v.throwIfInvalid();
    return (s!, e!);
  }

  MockResponse _create(MockRequest q) {
    final body = q.jsonBody;
    final code = (body['code'] as String?)?.trim() ?? '';
    final count = body['termCount'] ?? 3;
    MockValidator(body)
      ..required('campusId')
      ..check(
        'code',
        isValidAcademicYearCode(code),
        'Use o formato 2026/2027 (anos consecutivos)',
      )
      ..check(
        'termCount',
        count is int && count >= minTermCount && count <= maxTermCount,
        'Escolha entre $minTermCount e $maxTermCount períodos',
      )
      ..throwIfInvalid();
    final (start, end) = _validRange(body);
    final campusId = body['campusId']! as String;
    if (_years.values.any(
      (y) => y['campusId'] == campusId && y['code'] == code,
    )) {
      throw const MockApiException.conflict(
        'Já existe este ano lectivo no campus',
      );
    }
    final id = _ids.ulid(_now().toUtc());
    final year = {
      'id': id,
      'institutionId': MockRef.institutionId,
      'campusId': campusId,
      'code': code,
      'startDate': _date.toJson(start),
      'endDate': _date.toJson(end),
      'status': AcademicYearStatus.planned.name,
    };
    _years[id] = year;
    final ranges = splitYear(start, end, count as int);
    for (var i = 0; i < ranges.length; i++) {
      final termId = _ids.ulid(_now().toUtc());
      _terms[termId] = {
        'id': termId,
        'academicYearId': id,
        'name': defaultTermName(i, ranges.length),
        'order': i + 1,
        'startDate': _date.toJson(ranges[i].start),
        'endDate': _date.toJson(ranges[i].end),
        'gradesDeadline': _date.toJson(ranges[i].end),
        'status': TermStatus.closed.name,
        'closedAt': null,
      };
    }
    return MockResponse.created(year);
  }

  /// Ajusta as datas do ano (não de um ano encerrado); mudar o código só
  /// enquanto está planeado. As datas têm de continuar a conter os períodos.
  MockResponse _updateYear(MockRequest q) {
    final year = _year(q.params['id']);
    _ensureNotFrozen(year);
    final next = {
      ...year,
      for (final k in ['startDate', 'endDate', 'code'])
        if (q.jsonBody.containsKey(k)) k: q.jsonBody[k],
    };
    if (next['code'] != year['code']) {
      if (_status(year) != AcademicYearStatus.planned) {
        throw const MockApiException.conflict(
          'O código só pode mudar enquanto o ano está planeado',
        );
      }
      MockValidator(next)
        ..check(
          'code',
          isValidAcademicYearCode('${next['code']}'),
          'Use o formato 2026/2027 (anos consecutivos)',
        )
        ..throwIfInvalid();
    }
    final (start, end) = _validRange(next);
    for (final t in _termsOf(year['id']! as String)) {
      if (_parse(t['startDate'])!.isBefore(start) ||
          _parse(t['endDate'])!.isAfter(end)) {
        throw const MockApiException.validation({
          'startDate': 'Os períodos têm de ficar dentro do ano lectivo',
        });
      }
    }
    _years[year['id']! as String] = next;
    return MockResponse.ok(next);
  }

  MockResponse _transition(MockRequest q) {
    final year = _year(q.params['id']);
    final to = AcademicYearStatus.values
        .where((s) => s.name == q.jsonBody['to'])
        .firstOrNull;
    if (to == null) {
      throw const MockApiException.validation({'to': 'Estado inválido'});
    }
    final from = _status(year);
    if (!canTransition(from, to)) {
      throw MockApiException.conflict(
        'Transição inválida: ${from.name} → ${to.name}',
      );
    }
    final id = year['id']! as String;
    if (to == AcademicYearStatus.active) {
      final clash = _years.values.any(
        (y) =>
            y['id'] != id &&
            y['campusId'] == year['campusId'] &&
            y['status'] == AcademicYearStatus.active.name,
      );
      if (clash) {
        throw const MockApiException.conflict(
          'Já existe um ano lectivo activo neste campus',
        );
      }
    }
    if (to == AcademicYearStatus.closed &&
        _termsOf(id).any((t) => t['status'] == TermStatus.open.name)) {
      throw const MockApiException.conflict(
        'Feche todos os períodos antes de encerrar o ano lectivo',
      );
    }
    final next = {...year, 'status': to.name};
    _years[id] = next;
    return MockResponse.ok(next);
  }

  /// Datas e prazo de notas de um período: dentro do ano, sem sobrepor os
  /// vizinhos, e com prazo não anterior ao início.
  MockResponse _updateTerm(MockRequest q) {
    final term = _term(q.params['id']);
    final year = _year(term['academicYearId'] as String?);
    _ensureNotFrozen(year);
    final next = {
      ...term,
      for (final k in ['startDate', 'endDate', 'gradesDeadline'])
        if (q.jsonBody.containsKey(k)) k: q.jsonBody[k],
    };
    final (start, end) = _validRange(next);
    final deadline = _parse(next['gradesDeadline']);
    final v = MockValidator(next)
      ..check('gradesDeadline', deadline != null, 'Data inválida');
    v.throwIfInvalid();
    v.check(
      'gradesDeadline',
      !deadline!.isBefore(start),
      'O prazo não pode ser anterior ao início do período',
    );
    v.check(
      'startDate',
      !start.isBefore(_parse(year['startDate'])!) &&
          !end.isAfter(_parse(year['endDate'])!),
      'O período tem de ficar dentro do ano lectivo',
    );
    final overlaps = _termsOf(year['id']! as String).any(
      (t) =>
          t['id'] != term['id'] &&
          !start.isAfter(_parse(t['endDate'])!) &&
          !end.isBefore(_parse(t['startDate'])!),
    );
    v.check('startDate', !overlaps, 'O período sobrepõe-se a outro');
    v.throwIfInvalid();
    _terms[term['id']! as String] = next;
    return MockResponse.ok(next);
  }

  MockResponse _open(MockRequest q) {
    final term = _term(q.params['id']);
    final year = _year(term['academicYearId'] as String?);
    _ensureNotFrozen(year);
    if (term['status'] == TermStatus.open.name) {
      throw const MockApiException.conflict('O período já está aberto');
    }
    if (!canOpenTerms(_status(year))) {
      throw const MockApiException.conflict(
        'Só é possível abrir períodos de um ano lectivo activo ou em fecho',
      );
    }
    final reopen = term['closedAt'] != null;
    final service = permissions?.call();
    if (reopen && service != null && !service.can(academicApprovePermission)) {
      throw const MockApiException.forbidden(
        'Reabrir um período exige aprovação',
      );
    }
    final next = {...term, 'status': TermStatus.open.name};
    _terms[term['id']! as String] = next;
    return MockResponse.ok(next);
  }

  MockResponse _close(MockRequest q) {
    final term = _term(q.params['id']);
    _ensureNotFrozen(_year(term['academicYearId'] as String?));
    if (term['status'] != TermStatus.open.name) {
      throw const MockApiException.conflict('O período já está fechado');
    }
    final next = {
      ...term,
      'status': TermStatus.closed.name,
      'closedAt': _now().toUtc().toIso8601String(),
    };
    _terms[term['id']! as String] = next;
    return MockResponse.ok(next);
  }
}
