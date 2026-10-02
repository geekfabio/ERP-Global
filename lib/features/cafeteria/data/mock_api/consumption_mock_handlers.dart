import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/consumption.dart';
import '../models/menu.dart';
import '../models/wallet.dart';

/// Handlers de `/v1/cafeteria/reports/*` (docs/07-mock-api.md). Relatórios
/// calculados a partir das carteiras e dos movimentos (nunca guardados), sem
/// estado próprio.
class ConsumptionMockHandlers implements MockApiModule {
  ConsumptionMockHandlers({
    required this._wallets,
    required this._transactions,
    required this._mealTypes,
  });

  final List<Wallet> Function() _wallets;
  final List<WalletTransaction> Function() _transactions;
  final List<MealType> Function() _mealTypes;

  static const _date = DateOnlyConverter();

  @override
  void register(MockApiRegistry r) {
    r
      ..get('/v1/cafeteria/reports/consumption', _consumption)
      ..get(
        '/v1/cafeteria/reports/prepaid-balance',
        (req) => MockResponse.ok(buildPrepaidBalance(_wallets()).toJson()),
      );
  }

  DateTime? _parse(MockRequest req, String field) {
    final raw = req.query[field];
    if (raw == null) return null;
    try {
      return _date.fromJson(raw);
    } on FormatException {
      throw MockApiException.validation({field: 'Data inválida'});
    }
  }

  MockResponse _consumption(MockRequest req) {
    final wire = req.query['groupBy'] ?? 'class';
    final group = consumptionGroupWire.entries
        .where((e) => e.value == wire)
        .map((e) => e.key)
        .firstOrNull;
    if (group == null) {
      throw const MockApiException.validation({
        'groupBy': 'Agrupamento inválido (class, day, meal)',
      });
    }
    final from = _parse(req, 'from'), to = _parse(req, 'to');
    if (from != null && to != null && from.isAfter(to)) {
      throw const MockApiException.validation({
        'from': 'A data inicial é posterior à final',
      });
    }
    final names = {for (final t in _mealTypes()) t.id: t.name};
    final rows = buildConsumption(
      transactions: _transactions(),
      group: group,
      mealName: (id) => names[id],
      from: from,
      to: to,
    );
    return MockResponse.ok([for (final r in rows) r.toJson()]);
  }
}
