import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';

int _hash(String text) {
  var h = 0x811c9dc5;
  for (final unit in text.codeUnits) {
    h = ((h ^ unit) * 0x01000193) & 0x7fffffff;
  }
  return h;
}

int _pct(int part, int whole) => whole == 0 ? 0 : (part * 100 / whole).round();

const _months = [
  ('09', 'Set'),
  ('10', 'Out'),
  ('11', 'Nov'),
  ('12', 'Dez'),
  ('01', 'Jan'),
  ('02', 'Fev'),
  ('03', 'Mar'),
  ('04', 'Abr'),
  ('05', 'Mai'),
  ('06', 'Jun'),
  ('07', 'Jul'),
];

/// Meses (índices em [_months]) de cada trimestre; sem trimestre, o ano todo.
const _termMonths = <String, List<int>>{
  't1': [0, 1, 2, 3],
  't2': [4, 5, 6],
  't3': [7, 8, 9, 10],
};

/// `GET /v1/reports/finance-overview`: agrega por mês (previsto, recebido e
/// dívida) e, com contabilidade licenciada, contas a receber/pagar e
/// resultado, como o servidor faria. Os valores derivam do período e do campus
/// (sem estado mutável). Dinheiro em cêntimos.
class FinanceOverviewMockHandlers {
  const FinanceOverviewMockHandlers({this.enabledModules});

  /// Módulos licenciados; `null` = sem verificação.
  final Set<String> Function()? enabledModules;

  void register(MockApiRegistry r) =>
      r.get('/v1/reports/finance-overview', _overview);

  /// Meses do trimestre; ids desconhecidos (ULID) mapeiam-se de forma estável
  /// a um dos três trimestres; sem trimestre, o ano todo.
  List<int> _selected(String term) {
    if (term.isEmpty) return [for (var i = 0; i < _months.length; i++) i];
    return _termMonths[term] ??
        _termMonths.values.elementAt(_hash(term) % _termMonths.length);
  }

  Map<String, Object?> _period(
    String year,
    String term,
    String campus,
    bool accounting,
  ) {
    final rows = <Map<String, Object?>>[];
    var expected = 0, collected = 0, debt = 0;
    for (final i in _selected(term)) {
      final key = '$year|$campus|$i';
      final exp = 3000000 + _hash('e$key') % 600000;
      final col = (exp * (70 + _hash('c$key') % 28) / 100).round();
      final owed = exp - col;
      expected += exp;
      collected += col;
      debt += owed;
      rows.add({
        'month': _months[i].$1,
        'label': _months[i].$2,
        'expected': exp,
        'collected': col,
        'debt': owed,
      });
    }
    final payables = 1500000 + _hash('p$year|$term|$campus') % 1500000;
    return {
      'rows': rows,
      'totals': {
        'collected': collected,
        'expected': expected,
        'debt': debt,
        'defaultRate': _pct(debt, expected),
        if (accounting) ...{
          'receivables': debt,
          'payables': payables,
          'result': collected - payables,
        },
      },
    };
  }

  MockResponse _overview(MockRequest q) {
    final yearId = q.query['yearId'];
    if (yearId == null || yearId.isEmpty) {
      throw const MockApiException.validation({'yearId': 'Campo obrigatório'});
    }
    final licensed = enabledModules?.call();
    if (licensed != null && !licensed.contains('billing')) {
      throw const MockApiException.moduleNotLicensed();
    }
    final accounting = licensed?.contains('accounting') ?? true;
    final campus = q.query['campusId'] ?? '';
    final current = _period(
      yearId,
      q.query['termId'] ?? '',
      campus,
      accounting,
    );
    final compareYear = q.query['compareYearId'];
    final previous = compareYear == null
        ? null
        : _period(
            compareYear,
            q.query['compareTermId'] ?? '',
            campus,
            accounting,
          )['totals'];
    return MockResponse.ok({...current, 'previous': ?previous});
  }
}
