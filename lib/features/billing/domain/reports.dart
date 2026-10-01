import '../data/models/billing_enums.dart';
import '../data/models/charge.dart';
import '../data/models/payment.dart';
import '../data/models/report_rows.dart';
import 'debt.dart';
import 'payments.dart';

/// Valor de query (snake_case) de cada agrupamento.
const revenueGroupWire = <RevenueGroup, String>{
  RevenueGroup.period: 'period',
  RevenueGroup.feeType: 'fee_type',
  RevenueGroup.campus: 'campus',
};

bool _inRange(DateTime d, DateTime? from, DateTime? to) {
  final day = dayOf(d);
  if (from != null && day.isBefore(dayOf(from))) return false;
  if (to != null && day.isAfter(dayOf(to))) return false;
  return true;
}

/// Receita: o que foi efectivamente recebido (alocações de pagamentos
/// concluídos) com `paidAt` em `[from, to]`, agrupado por mês de pagamento,
/// rubrica (tipo da cobrança) ou campus. Adiantamentos ainda por alocar não
/// contam. O período sai por ordem cronológica; os restantes agrupamentos do
/// maior para o menor valor.
List<RevenueRow> buildRevenue({
  required Iterable<Charge> charges,
  required Iterable<Payment> payments,
  required FeeType Function(Charge charge) feeTypeOf,
  required RevenueGroup group,
  DateTime? from,
  DateTime? to,
  String? campusId,
}) {
  final byId = {for (final c in charges) c.id: c};
  final totals = <String, int>{};
  final counts = <String, int>{};
  for (final p in payments) {
    if (p.status != PaymentStatus.completed) continue;
    if (!_inRange(p.paidAt, from, to)) continue;
    for (final a in p.allocations) {
      final c = byId[a.chargeId];
      if (c == null) continue;
      if (campusId != null && c.campusId != campusId) continue;
      final key = switch (group) {
        RevenueGroup.period => monthKey(p.paidAt.toUtc()),
        RevenueGroup.feeType => feeTypeOf(c).name,
        RevenueGroup.campus => c.campusId ?? '',
      };
      totals[key] = (totals[key] ?? 0) + a.amountMinor;
      counts[key] = (counts[key] ?? 0) + 1;
    }
  }
  final rows = [
    for (final e in totals.entries)
      RevenueRow(
        key: e.key,
        receivedMinor: e.value,
        allocationCount: counts[e.key]!,
      ),
  ];
  rows.sort(
    group == RevenueGroup.period
        ? (a, b) => a.key.compareTo(b.key)
        : (a, b) {
            final d = b.receivedMinor.compareTo(a.receivedMinor);
            return d != 0 ? d : a.key.compareTo(b.key);
          },
  );
  return rows;
}

/// Previsto vs. recebido por mês de vencimento: previsto = valor líquido das
/// cobranças não canceladas que vencem no mês; recebido = o já alocado a
/// essas cobranças (limitado ao valor líquido). Ordem cronológica.
List<ForecastRow> buildForecast({
  required Iterable<Charge> charges,
  required Map<String, int> allocated,
  DateTime? from,
  DateTime? to,
  String? campusId,
}) {
  final expected = <String, int>{};
  final received = <String, int>{};
  final counts = <String, int>{};
  for (final c in charges) {
    if (c.deletedAt != null || c.status == ChargeStatus.cancelled) continue;
    if (!_inRange(c.dueDate, from, to)) continue;
    if (campusId != null && c.campusId != campusId) continue;
    final key = monthKey(c.dueDate);
    final net = chargeNetMinor(c);
    final paid = (allocated[c.id] ?? 0).clamp(0, net);
    expected[key] = (expected[key] ?? 0) + net;
    received[key] = (received[key] ?? 0) + paid;
    counts[key] = (counts[key] ?? 0) + 1;
  }
  return [
    for (final k in expected.keys.toList()..sort())
      ForecastRow(
        period: k,
        expectedMinor: expected[k]!,
        receivedMinor: received[k]!,
        chargeCount: counts[k]!,
      ),
  ];
}

/// Taxa de cobrança em percentagem inteira (0 se nada previsto).
int collectionRatePercent(int expectedMinor, int receivedMinor) =>
    expectedMinor <= 0 ? 0 : (receivedMinor * 100 ~/ expectedMinor);
