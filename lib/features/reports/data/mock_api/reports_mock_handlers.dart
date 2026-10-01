import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import 'academic_overview_mock_handlers.dart';
import 'finance_overview_mock_handlers.dart';
import 'operations_overview_mock_handlers.dart';

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
  ReportsMockHandlers({this.enabledModules});

  /// Módulos licenciados; `null` = sem verificação de licença no servidor.
  final Set<String> Function()? enabledModules;

  @override
  void register(MockApiRegistry r) {
    r.get('/v1/reports/dashboard', _dashboard);
    AcademicOverviewMockHandlers(enabledModules: enabledModules).register(r);
    FinanceOverviewMockHandlers(enabledModules: enabledModules).register(r);
    OperationsOverviewMockHandlers(enabledModules: enabledModules).register(r);
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
