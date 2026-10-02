import '../data/data_mocks/menu_seed.dart';
import '../data/models/consumption_rows.dart';
import '../data/models/wallet.dart';

/// Valor de query de cada agrupamento.
const consumptionGroupWire = <ConsumptionGroup, String>{
  ConsumptionGroup.classroom: 'class',
  ConsumptionGroup.day: 'day',
  ConsumptionGroup.meal: 'meal',
};

DateTime _day(DateTime d) {
  final u = d.toUtc();
  return DateTime.utc(u.year, u.month, u.day);
}

/// Consumo líquido por turma, dia ou tipo de refeição: conta os consumos de
/// `[from, to]` (dias UTC, inclusive) que não foram estornados. A turma e o
/// dia saem por ordem; a refeição do maior para o menor valor. [mealName]
/// resolve o rótulo do tipo de refeição.
List<ConsumptionRow> buildConsumption({
  required Iterable<WalletTransaction> transactions,
  required ConsumptionGroup group,
  String? Function(String mealTypeId)? mealName,
  DateTime? from,
  DateTime? to,
}) {
  final txs = transactions.toList();
  final refunded = {
    for (final t in txs)
      if (t.type == WalletTransactionType.refund && t.refundOfId != null)
        t.refundOfId!,
  };
  final totals = <String, int>{};
  final counts = <String, int>{};
  for (final t in txs) {
    if (t.type != WalletTransactionType.purchase) continue;
    if (refunded.contains(t.id)) continue;
    final day = _day(t.occurredAt);
    if (from != null && day.isBefore(_day(from))) continue;
    if (to != null && day.isAfter(_day(to))) continue;
    final key = switch (group) {
      ConsumptionGroup.classroom => t.className ?? '',
      ConsumptionGroup.day => menuDateKey(day),
      ConsumptionGroup.meal => t.mealTypeId ?? '',
    };
    totals[key] = (totals[key] ?? 0) + t.amountMinor;
    counts[key] = (counts[key] ?? 0) + 1;
  }
  final rows = [
    for (final e in totals.entries)
      ConsumptionRow(
        key: e.key,
        label: group == ConsumptionGroup.meal && e.key.isNotEmpty
            ? mealName?.call(e.key)
            : null,
        purchaseCount: counts[e.key]!,
        totalMinor: e.value,
      ),
  ];
  rows.sort(
    group == ConsumptionGroup.meal
        ? (a, b) {
            final d = b.totalMinor.compareTo(a.totalMinor);
            return d != 0 ? d : a.key.compareTo(b.key);
          }
        : (a, b) => a.key.compareTo(b.key),
  );
  return rows;
}

/// Saldo pré-pago total: soma dos saldos de todas as carteiras.
PrepaidBalance buildPrepaidBalance(Iterable<Wallet> wallets) {
  final list = wallets.toList();
  return PrepaidBalance(
    totalBalanceMinor: list.fold(0, (s, w) => s + w.balanceMinor),
    walletCount: list.length,
    blockedCount: list.where((w) => w.blocked).length,
  );
}
