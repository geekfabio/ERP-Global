import 'dart:async';

import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/security/permission_service.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/attendance_rules.dart';
import '../data_mocks/attendance_seed.dart';
import '../models/attendance_models.dart';

/// Diz se o utilizador pode registar presenças na turma (o servidor real
/// resolve-o pelas atribuições do professor). [daily] = registo do dia, que
/// exige ser director de turma.
typedef AttendanceAccess =
    FutureOr<bool> Function(String classroomId, {required bool daily});

/// Handlers de `/v1/attendance-*`: folhas por dia/aula, registos, justificação,
/// limite configurável e alertas. Estado em memória; `POST /__mock/reset`
/// repõe o seed.
class AttendanceMockHandlers implements MockApiModule {
  AttendanceMockHandlers({
    this.permissions,
    this.access,
    DateTime Function()? now,
    this.withSeed = true,
  }) : _now = now ?? DateTime.now {
    reset();
  }

  final PermissionService Function()? permissions;

  /// Restrição por turma atribuída; `null` = sem restrição.
  final AttendanceAccess? access;
  final DateTime Function() _now;

  /// Com `false` começa vazio (testes).
  final bool withSeed;

  final Map<String, AttendanceRecordModel> _records = {};
  AttendanceSettingsModel _settings = const AttendanceSettingsModel();
  late SeedGenerator _ids;

  static final _spec = MockListSpec<AttendanceRecordModel>(
    sortable: {'date': (r) => r.date, 'studentId': (r) => r.studentId},
    filterable: {
      'classroomId': (r) => r.classroomId,
      'studentId': (r) => r.studentId,
      'status': (r) => r.status.name,
      'date': (r) => r.date,
    },
    defaultSort: const ['-date', 'studentId'],
  );

  static final _alertSpec = MockListSpec<AttendanceAlertModel>(
    filterable: {'classroomId': (a) => a.classroomId},
  );

  void reset() {
    _ids = SeedGenerator(450);
    _settings = AttendanceSettingsModel(
      absenceLimit: withSeed ? attendanceSeedLimit : 10,
    );
    _records
      ..clear()
      ..addEntries(
        (withSeed ? buildAttendanceSeed(now: _now()) : const []).map(
          (r) => MapEntry(r.id, r),
        ),
      );
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(reset)
      ..get('/v1/attendance-sheets', _getSheet)
      ..put('/v1/attendance-sheets', _putSheet)
      ..get('/v1/attendance-records', (q) {
        _requireAny();
        return mockPaginate(
          _records.values,
          q,
          toJson: (a) => a.toJson(),
          spec: _spec,
        );
      })
      ..put('/v1/attendance-records/{id}/justification', _justify)
      ..get('/v1/attendance-settings', (q) {
        _requireAny();
        return MockResponse.ok(_settings.toJson());
      })
      ..put('/v1/attendance-settings', _putSettings)
      ..get('/v1/attendance-alerts', (q) {
        _requireAny();
        return mockPaginate(
          buildAlerts(_records.values, _settings.absenceLimit),
          q,
          toJson: (a) => a.toJson(),
          spec: _alertSpec,
        );
      });
  }

  bool _can(String permission) =>
      permissions?.call().canAny(permission) ?? true;

  bool get _all => _can(attendanceRecordAllPermission);

  void _requireAny() {
    if (!_all && !_can(attendanceRecordWritePermission)) {
      throw const MockApiException.forbidden();
    }
  }

  Future<void> _requireClassroom(Map<String, dynamic> key) async {
    final errors = {
      for (final f in ['classroomId', 'date'])
        if ('${key[f] ?? ''}'.isEmpty) f: 'Campo obrigatório',
    };
    if (errors.isEmpty && DateTime.tryParse('${key['date']}') == null) {
      errors['date'] = 'Data inválida';
    }
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    _requireAny();
    if (_all || access == null) return;
    final daily = (key['lessonSlotId'] as String?) == null;
    if (!await access!('${key['classroomId']}', daily: daily)) {
      throw MockApiException.forbidden(
        daily
            ? 'Só o director de turma regista o dia desta turma'
            : 'Turma não atribuída ao professor',
      );
    }
  }

  bool _inSheet(AttendanceRecordModel r, Map<String, dynamic> k) =>
      r.classroomId == k['classroomId'] &&
      r.date == k['date'] &&
      r.lessonSlotId == (k['lessonSlotId'] as String?);

  AttendanceSheetModel _sheet(Map<String, dynamic> k) => AttendanceSheetModel(
    classroomId: '${k['classroomId']}',
    date: '${k['date']}',
    lessonSlotId: k['lessonSlotId'] as String?,
    rows: [
      for (final r in _records.values)
        if (_inSheet(r, k)) r,
    ]..sort((a, b) => a.studentId.compareTo(b.studentId)),
  );

  Future<MockResponse> _getSheet(MockRequest q) async {
    await _requireClassroom(q.query);
    return MockResponse.ok(_sheet(q.query).toJson());
  }

  Future<MockResponse> _putSheet(MockRequest q) async {
    final body = q.jsonBody;
    if (!_all && !_can(attendanceRecordWritePermission)) {
      throw const MockApiException.forbidden();
    }
    await _requireClassroom(body);
    final date = DateTime.parse('${body['date']}');
    // A data vem do fuso do cliente (ex.: UTC+1): "hoje" local pode já ser
    // amanhã em UTC. Tolera até um dia à frente da data UTC do servidor.
    final today = _now().toUtc();
    final latest = DateTime.utc(today.year, today.month, today.day + 1);
    if (date.isAfter(latest)) {
      throw const MockApiException.validation({
        'date': 'Não é possível registar presenças em dias futuros',
      });
    }
    final List<AttendanceRecordModel> rows;
    try {
      rows = [
        for (final r in body['rows'] as List<dynamic>? ?? const [])
          AttendanceRecordModel.fromJson(r as Map<String, dynamic>),
      ];
    } on Object {
      throw const MockApiException.validation({'rows': 'Dados inválidos'});
    }
    final errors = <String, String>{
      for (final r in rows)
        if (r.studentId.isEmpty) 'studentId': 'Campo obrigatório',
    };
    if (errors.isNotEmpty) throw MockApiException.validation(errors);

    final stamp = _now().toUtc();
    for (final row in rows) {
      final existing = _records.values
          .where((r) => _inSheet(r, body) && r.studentId == row.studentId)
          .firstOrNull;
      final id = existing?.id ?? _ids.ulid(stamp);
      _records[id] = AttendanceRecordModel(
        id: id,
        classroomId: '${body['classroomId']}',
        studentId: row.studentId,
        date: '${body['date']}',
        lessonSlotId: body['lessonSlotId'] as String?,
        status: row.status,
        justification: row.status == AttendanceStatus.absent
            ? (row.justification ?? existing?.justification)
            : null,
      );
    }
    return MockResponse.ok(_sheet(body).toJson());
  }

  MockResponse _justify(MockRequest q) {
    if (!_all) throw const MockApiException.forbidden();
    final record =
        _records[q.params['id']] ?? (throw const MockApiException.notFound());
    final reason = '${q.jsonBody['reason'] ?? ''}'.trim();
    if (reason.isEmpty) {
      throw const MockApiException.validation({'reason': 'Campo obrigatório'});
    }
    if (record.status != AttendanceStatus.absent) {
      throw const MockApiException.conflict('Só as faltas se justificam');
    }
    final next = record.copyWith(justification: reason);
    _records[record.id] = next;
    return MockResponse.ok(next.toJson());
  }

  MockResponse _putSettings(MockRequest q) {
    if (!_all) throw const MockApiException.forbidden();
    final limit = q.jsonBody['absenceLimit'];
    if (limit is! int || limit < 1 || limit > 100) {
      throw const MockApiException.validation({
        'absenceLimit': 'Limite entre 1 e 100',
      });
    }
    _settings = AttendanceSettingsModel(absenceLimit: limit);
    return MockResponse.ok(_settings.toJson());
  }
}
