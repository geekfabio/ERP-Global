import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../domain/grade_entry_repository.dart';
import '../models/council_models.dart';

/// Handlers de `/v1/class-councils`: decisões do conselho de turma e
/// aprovação da pauta (que a congela).
class CouncilMockHandlers implements MockApiModule {
  CouncilMockHandlers({this.permissions, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final PermissionService Function()? permissions;
  final DateTime Function() _now;

  /// `classroomId|yearId → conselho`.
  final Map<String, CouncilModel> _rows = {};

  void reset() => _rows.clear();

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(reset)
      ..get('/v1/class-councils', _get)
      ..put('/v1/class-councils/decisions', _decide)
      ..post('/v1/class-councils/approve', _approve);
  }

  bool _can(String permission) =>
      permissions?.call().canAny(permission) ?? true;

  void _requireRead() {
    if (!_can(gradeEntryReadPermission) &&
        !_can(gradeEntryWritePermission) &&
        !_can(gradeEntryApprovePermission)) {
      throw const MockApiException.forbidden();
    }
  }

  void _requireApprove() {
    if (!_can(gradeEntryApprovePermission)) {
      throw const MockApiException.forbidden();
    }
  }

  static (String, String) _key(Map<String, dynamic> m) {
    final errors = {
      for (final f in ['classroomId', 'yearId'])
        if ('${m[f] ?? ''}'.isEmpty) f: 'Campo obrigatório',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    return (m['classroomId'] as String, m['yearId'] as String);
  }

  CouncilModel _current(String classroom, String year) =>
      _rows['$classroom|$year'] ??
      CouncilModel(classroomId: classroom, yearId: year);

  void _requireOpen(CouncilModel council) {
    if (council.approved) {
      throw const MockApiException.conflict(
        'A pauta já foi aprovada e está congelada',
      );
    }
  }

  static FinalResult _result(Object? raw, String field) {
    final value = FinalResult.values.where((r) => r.name == raw).firstOrNull;
    if (value == null || value == FinalResult.pending) {
      throw MockApiException.validation({field: 'Resultado inválido'});
    }
    return value;
  }

  MockResponse _get(MockRequest q) {
    _requireRead();
    final (classroom, year) = _key(q.query);
    return MockResponse.ok(_current(classroom, year).toJson());
  }

  MockResponse _decide(MockRequest q) {
    _requireApprove();
    final body = q.jsonBody;
    final (classroom, year) = _key(body);
    final current = _current(classroom, year);
    _requireOpen(current);
    final student = '${body['studentId'] ?? ''}';
    final justification = '${body['justification'] ?? ''}'.trim();
    final errors = {
      if (student.isEmpty) 'studentId': 'Campo obrigatório',
      if (justification.isEmpty)
        'justification': 'Indique a justificação da decisão',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final result = _result(body['result'], 'result');
    final next = current.copyWith(
      decisions: [
        for (final d in current.decisions)
          if (d.studentId != student) d,
        CouncilDecisionModel(
          studentId: student,
          result: result,
          justification: justification,
          decidedAt: _now().toUtc(),
        ),
      ],
    );
    _rows['$classroom|$year'] = next;
    return MockResponse.ok(next.toJson());
  }

  MockResponse _approve(MockRequest q) {
    _requireApprove();
    final body = q.jsonBody;
    final (classroom, year) = _key(body);
    final current = _current(classroom, year);
    _requireOpen(current);
    final raw = body['results'];
    if (raw is! Map<String, dynamic> || raw.isEmpty) {
      throw const MockApiException.validation({
        'results': 'A pauta não tem alunos para aprovar',
      });
    }
    final results = {
      for (final e in raw.entries) e.key: _result(e.value, 'results'),
    };
    final next = current.copyWith(approvedAt: _now().toUtc(), results: results);
    _rows['$classroom|$year'] = next;
    return MockResponse.ok(next.toJson());
  }
}
