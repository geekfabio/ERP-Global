import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';

int _hash(String text) {
  var h = 0x811c9dc5;
  for (final unit in text.codeUnits) {
    h = ((h ^ unit) * 0x01000193) & 0x7fffffff;
  }
  return h;
}

int _n(String seed, int min, int max) => min + _hash(seed) % (max - min + 1);

int _sum(List<Map<String, Object?>> rows, String key) =>
    rows.fold<int>(0, (s, e) => s + (e[key]! as int));

/// `GET /v1/reports/operations-overview`: agrega Refeitório, Catracas, RH e
/// Secretaria, como o servidor faria. Cada secção só existe se o módulo estiver
/// licenciado. Valores determinísticos a partir do período e do campus.
class OperationsOverviewMockHandlers {
  const OperationsOverviewMockHandlers({this.enabledModules});

  /// Módulos licenciados; `null` = sem verificação.
  final Set<String> Function()? enabledModules;

  void register(MockApiRegistry r) =>
      r.get('/v1/reports/operations-overview', _overview);

  static const _meals = ['Pequeno-almoço', 'Almoço', 'Lanche'];
  static const _roles = [
    'Docentes',
    'Administrativos',
    'Auxiliares',
    'Direcção',
  ];
  static const _pending = [
    'Matrículas por validar',
    'Renovações pendentes',
    'Documentos pedidos',
    'Justificações de faltas',
    'Processos incompletos',
  ];

  Map<String, Object?> _cafeteria(String k) {
    final byMeal = [
      for (final m in _meals)
        {'label': m, 'count': _n('cm$m$k', m == 'Almoço' ? 900 : 200, 1500)},
    ];
    return {
      'meals': _sum(byMeal, 'count'),
      'revenue': _n('cr$k', 400000, 1200000),
      'prepaidBalance': _n('cb$k', 800000, 2400000),
      'lowBalanceCards': _n('cl$k', 8, 60),
      'byMeal': byMeal,
    };
  }

  Map<String, Object?> _access(String k) {
    final byHour = <Map<String, Object?>>[];
    for (var h = 6; h <= 19; h++) {
      final inFactor = h == 7 || h == 12 ? 4 : 1;
      final outFactor = h == 13 || h == 17 ? 4 : 1;
      byHour.add({
        'hour': h,
        'entries': inFactor * _n('ae$h$k', 20, 90),
        'exits': outFactor * _n('ax$h$k', 20, 90),
      });
    }
    return {
      'entries': _sum(byHour, 'entries'),
      'exits': _sum(byHour, 'exits'),
      'denied': _n('ad$k', 5, 40),
      'byHour': byHour,
    };
  }

  Map<String, Object?> _hr(String k) {
    final byRole = [
      for (final r in _roles) {'label': r, 'count': _n('hr$r$k', 4, 30)},
    ];
    return {
      'activeStaff': _sum(byRole, 'count'),
      'onLeave': _n('ho$k', 0, 6),
      'contractsExpiring': _n('hc$k', 0, 8),
      'teachersWithoutContract': _n('ht$k', 0, 3),
      'byRole': byRole,
    };
  }

  Map<String, Object?> _secretariat(String k) {
    final items = [
      for (final p in _pending) {'label': p, 'count': _n('s$p$k', 0, 25)},
    ];
    return {'totalPending': _sum(items, 'count'), 'items': items};
  }

  MockResponse _overview(MockRequest q) {
    final yearId = q.query['yearId'];
    if (yearId == null || yearId.isEmpty) {
      throw const MockApiException.validation({'yearId': 'Campo obrigatório'});
    }
    final licensed = enabledModules?.call();
    bool has(String m) => licensed?.contains(m) ?? true;
    const sections = ['cafeteria', 'access_control', 'hr', 'students'];
    if (!sections.any(has)) throw const MockApiException.moduleNotLicensed();
    final k = '$yearId|${q.query['termId'] ?? ''}|${q.query['campusId'] ?? ''}';
    return MockResponse.ok({
      if (has('cafeteria')) 'cafeteria': _cafeteria(k),
      if (has('access_control')) 'access': _access(k),
      if (has('hr')) 'hr': _hr(k),
      if (has('students')) 'secretariat': _secretariat(k),
    });
  }
}
