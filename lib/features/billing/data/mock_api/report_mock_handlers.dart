import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/payments.dart';
import '../../domain/reports.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/payment.dart';

/// Handlers de `/v1/billing/reports/*` (docs/07-mock-api.md). Relatórios
/// calculados a partir das cobranças e pagamentos (nunca guardados), sem
/// estado próprio.
class ReportMockHandlers implements MockApiModule {
  ReportMockHandlers({
    required this._allCharges,
    required this._allPayments,
    required this._feeTypeOf,
  });

  final List<Charge> Function() _allCharges;
  final List<Payment> Function() _allPayments;
  final FeeType Function(Charge charge) _feeTypeOf;

  static const _date = DateOnlyConverter();

  @override
  void register(MockApiRegistry r) {
    r
      ..get('/v1/billing/reports/revenue', _revenue)
      ..get('/v1/billing/reports/forecast', _forecast);
  }

  ({DateTime? from, DateTime? to}) _range(MockRequest req) {
    DateTime? parse(String field) {
      final raw = req.query[field];
      if (raw == null) return null;
      try {
        return _date.fromJson(raw);
      } on FormatException {
        throw MockApiException.validation({field: 'Data inválida'});
      }
    }

    final from = parse('from'), to = parse('to');
    if (from != null && to != null && from.isAfter(to)) {
      throw const MockApiException.validation({
        'from': 'A data inicial é posterior à final',
      });
    }
    return (from: from, to: to);
  }

  MockResponse _revenue(MockRequest req) {
    final wire = req.query['groupBy'] ?? 'period';
    final group = revenueGroupWire.entries
        .where((e) => e.value == wire)
        .map((e) => e.key)
        .firstOrNull;
    if (group == null) {
      throw const MockApiException.validation({
        'groupBy': 'Agrupamento inválido (period, fee_type, campus)',
      });
    }
    final range = _range(req);
    final rows = buildRevenue(
      charges: _allCharges(),
      payments: _allPayments(),
      feeTypeOf: _feeTypeOf,
      group: group,
      from: range.from,
      to: range.to,
      campusId: req.query['filter[campusId]'],
    );
    return MockResponse.ok([for (final r in rows) r.toJson()]);
  }

  MockResponse _forecast(MockRequest req) {
    final range = _range(req);
    final rows = buildForecast(
      charges: _allCharges(),
      allocated: allocatedByCharge(_allPayments()),
      from: range.from,
      to: range.to,
      campusId: req.query['filter[campusId]'],
    );
    return MockResponse.ok([for (final r in rows) r.toJson()]);
  }
}
