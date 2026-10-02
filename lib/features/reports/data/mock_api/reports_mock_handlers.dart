import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import 'academic_overview_mock_handlers.dart';
import 'finance_overview_mock_handlers.dart';
import 'operations_overview_mock_handlers.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/report_catalog.dart';
import '../models/report_models.dart';

/// Intervalo [min, max] do valor simulado de cada widget (dinheiro em cêntimos,
/// percentagens em pontos). O prefixo do id é o código do módulo.
const _ranges = <String, (int, int)>{
  'students.enrolled': (280, 340),
  'students.class_occupancy': (72, 96),
  'academic.approval_rate': (68, 94),
  'attendance.rate': (84, 98),
  'billing.revenue': (18000000, 32000000),
  'billing.expected': (30000000, 36000000),
  'billing.debt': (2000000, 9000000),
  'billing.default_rate': (6, 24),
  'cafeteria.meals': (2400, 4200),
  'cafeteria.prepaid_balance': (800000, 2400000),
  'access_control.entries': (1800, 5200),
  'hr.active_staff': (52, 68),
  'library.active_loans': (18, 64),
};

/// FNV-1a: valores estáveis para o mesmo widget + filtros (seed determinístico).
int _hash(String text) {
  var h = 0x811c9dc5;
  for (final unit in text.codeUnits) {
    h = ((h ^ unit) * 0x01000193) & 0x7fffffff;
  }
  return h;
}

/// Handlers de `/v1/reports/*` (docs/07-mock-api.md). Sem estado mutável: os
/// valores derivam do widget e dos filtros.
class ReportsMockHandlers implements MockApiModule {
  ReportsMockHandlers({this.enabledModules, DateTime Function()? now})
    : _now = now ?? (() => DateTime.now().toUtc());

  final DateTime Function() _now;
  final _schedules = <String, Map<String, Object?>>{};
  var _ids = SeedGenerator(890);

  /// Módulos licenciados; `null` = sem verificação de licença no servidor.
  final Set<String> Function()? enabledModules;

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(() {
        _schedules.clear();
        _ids = SeedGenerator(890);
      })
      ..get('/v1/reports/dashboard', _dashboard)
      ..get('/v1/reports/catalog/{id}/run', _run)
      ..get('/v1/reports/schedules', _listSchedules)
      ..post('/v1/reports/schedules', _createSchedule)
      ..patch('/v1/reports/schedules/{id}', _patchSchedule)
      ..delete('/v1/reports/schedules/{id}', _deleteSchedule);
    AcademicOverviewMockHandlers(enabledModules: enabledModules).register(r);
    FinanceOverviewMockHandlers(enabledModules: enabledModules).register(r);
    OperationsOverviewMockHandlers(enabledModules: enabledModules).register(r);
  }

  ReportDefinition _definition(String id) {
    final report = reportById(id);
    if (report == null) throw const MockApiException.notFound();
    final licensed = enabledModules?.call();
    if (licensed != null && !licensed.contains(report.moduleCode)) {
      throw const MockApiException.moduleNotLicensed();
    }
    return report;
  }

  /// Linhas determinísticas do relatório. Só existe um campus no seed: pedir
  /// outro devolve vazio (o servidor filtra por âmbito).
  MockResponse _run(MockRequest q) {
    final report = _definition(q.params['id']!);
    final campusId = q.query['campusId'];
    final inScope = campusId == null || campusId == MockRef.campusId;
    return MockResponse.ok({
      'reportId': report.id,
      'columns': [for (final c in report.columns) c.key],
      'rows': [
        if (inScope)
          for (var i = 1; i <= 12; i++) _row(report.id, i),
      ],
    });
  }

  List<String> _row(String reportId, int i) {
    final h = _hash('$reportId|$i');
    final person = 'Aluno ${i.toString().padLeft(3, '0')}';
    final room = '${1 + h % 9}.ª ${'ABC'[h % 3]}';
    const campus = 'Campus principal';
    return switch (reportId) {
      'students.roster' => [
        '$i',
        person,
        room,
        campus,
        h % 4 == 0 ? 'Asma' : '',
      ],
      'billing.debtors' => [
        person,
        campus,
        '${1 + h % 4}',
        '${(10000 + h % 90000) * 100}',
      ],
      'attendance.summary' => [room, campus, '${84 + h % 15}', '${h % 40}'],
      'academic.approvals' => [
        '${1 + i}.ª classe',
        campus,
        '${20 + h % 20}',
        '${h % 8}',
      ],
      _ => [
        'Livro ${i.toString().padLeft(2, '0')}',
        campus,
        'Leitor ${1 + h % 30}',
        h % 5 == 0 ? 'Em atraso' : 'Activo',
      ],
    };
  }

  DateTime _nextRun(String frequency) {
    final now = _now();
    return switch (frequency) {
      'daily' => now.add(const Duration(days: 1)),
      'weekly' => now.add(const Duration(days: 7)),
      _ => DateTime.utc(now.year, now.month + 1, now.day),
    };
  }

  Map<String, Object?> _json(Map<String, Object?> s) => {
    ...s,
    'nextRunAt': (s['nextRunAt']! as DateTime).toUtc().toIso8601String(),
  };

  MockResponse _listSchedules(MockRequest q) =>
      MockResponse.ok([for (final s in _schedules.values) _json(s)]);

  MockResponse _createSchedule(MockRequest q) {
    final body = q.jsonBody;
    MockValidator(body)
      ..required('reportId')
      ..required('frequency')
      ..required('format')
      ..check(
        'frequency',
        ScheduleFrequency.values.any((f) => f.name == body['frequency']),
        'Frequência inválida',
      )
      ..check(
        'format',
        const ['csv', 'xlsx', 'pdf'].contains(body['format']),
        'Formato inválido',
      )
      ..throwIfInvalid();
    _definition(body['reportId']! as String);
    final id = _ids.ulid(_now());
    final schedule = <String, Object?>{
      'id': id,
      'reportId': body['reportId'],
      'frequency': body['frequency'],
      'format': body['format'],
      'campusId': body['campusId'],
      'active': true,
      'nextRunAt': _nextRun(body['frequency']! as String),
    };
    _schedules[id] = schedule;
    return MockResponse.created(_json(schedule));
  }

  MockResponse _patchSchedule(MockRequest q) {
    final s = _schedules[q.params['id']];
    if (s == null) throw const MockApiException.notFound();
    final active = q.jsonBody['active'];
    if (active is! bool) {
      throw const MockApiException.validation({'active': 'Campo obrigatório'});
    }
    s['active'] = active;
    if (active) s['nextRunAt'] = _nextRun(s['frequency']! as String);
    return MockResponse.ok(_json(s));
  }

  MockResponse _deleteSchedule(MockRequest q) {
    if (_schedules.remove(q.params['id']) == null) {
      throw const MockApiException.notFound();
    }
    return MockResponse.ok(null);
  }

  int _value(String widgetId, String year, String term, String campus) {
    final (min, max) = _ranges[widgetId]!;
    return min + _hash('$widgetId|$year|$term|$campus') % (max - min + 1);
  }

  MockResponse _dashboard(MockRequest q) {
    final yearId = q.query['yearId'];
    if (yearId == null || yearId.isEmpty) {
      throw const MockApiException.validation({'yearId': 'Campo obrigatório'});
    }
    final termId = q.query['termId'] ?? '';
    final campusId = q.query['campusId'] ?? '';
    final compareYear = q.query['compareYearId'];
    final compareTerm = q.query['compareTermId'];
    final ids = (q.query['widgets'] ?? '')
        .split(',')
        .where((id) => id.isNotEmpty);
    final licensed = enabledModules?.call();
    final metrics = <Map<String, Object?>>[];
    for (final id in ids) {
      if (!_ranges.containsKey(id)) {
        throw const MockApiException.badRequest('Widget desconhecido');
      }
      if (licensed != null && !licensed.contains(id.split('.').first)) {
        throw const MockApiException.moduleNotLicensed();
      }
      metrics.add({
        'widgetId': id,
        'value': _value(id, yearId, termId, campusId),
        if (compareYear != null)
          'previous': _value(id, compareYear, compareTerm ?? '', campusId),
      });
    }
    return MockResponse.ok(metrics);
  }
}
