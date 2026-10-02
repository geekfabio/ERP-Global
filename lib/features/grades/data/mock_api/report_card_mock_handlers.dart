import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../domain/grade_entry_repository.dart';
import '../models/report_card_models.dart';

/// Handlers de `/v1/report-cards`: observações do director de turma e envio
/// do boletim ao encarregado (as notas vêm de `/v1/grade-sheets`).
class ReportCardMockHandlers implements MockApiModule {
  ReportCardMockHandlers({this.permissions, DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final PermissionService Function()? permissions;
  final DateTime Function() _now;

  /// `studentId|termId → estado`.
  final Map<String, ReportCardStateModel> _rows = {};

  static const _maxRemarks = 500;

  void reset() => _rows.clear();

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(reset)
      ..get('/v1/report-cards', _get)
      ..put('/v1/report-cards/remarks', _remarks)
      ..post('/v1/report-cards/send', _send);
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

  void _requireWrite() {
    if (!_can(gradeEntryWritePermission) &&
        !_can(gradeEntryApprovePermission)) {
      throw const MockApiException.forbidden();
    }
  }

  static (String, String) _key(Map<String, dynamic> m) {
    final errors = {
      for (final f in ['studentId', 'termId'])
        if ('${m[f] ?? ''}'.isEmpty) f: 'Campo obrigatório',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    return (m['studentId'] as String, m['termId'] as String);
  }

  ReportCardStateModel _current(String studentId, String termId) =>
      _rows['$studentId|$termId'] ??
      ReportCardStateModel(studentId: studentId, termId: termId);

  MockResponse _get(MockRequest q) {
    _requireRead();
    final (student, term) = _key(q.query);
    return MockResponse.ok(_current(student, term).toJson());
  }

  MockResponse _remarks(MockRequest q) {
    _requireWrite();
    final body = q.jsonBody;
    final (student, term) = _key(body);
    final text = '${body['remarks'] ?? ''}'.trim();
    if (text.length > _maxRemarks) {
      throw const MockApiException.validation({
        'remarks': 'No máximo $_maxRemarks caracteres',
      });
    }
    final next = _current(student, term).copyWith(remarks: text);
    _rows['$student|$term'] = next;
    return MockResponse.ok(next.toJson());
  }

  MockResponse _send(MockRequest q) {
    _requireWrite();
    final body = q.jsonBody;
    final (student, term) = _key(body);
    final ids = [
      for (final id in body['guardianIds'] as List<dynamic>? ?? const [])
        id as String,
    ];
    if (ids.isEmpty) {
      throw const MockApiException.validation({
        'guardianIds': 'O aluno não tem encarregado para receber o boletim',
      });
    }
    final next = _current(
      student,
      term,
    ).copyWith(sentAt: _now().toUtc(), sentToGuardianIds: ids);
    _rows['$student|$term'] = next;
    return MockResponse.ok(next.toJson());
  }
}
