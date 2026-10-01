import '../data/models/billing_enums.dart';
import '../data/models/discount.dart';

/// Rótulos (pt-AO) dos motivos de desconto.
const discountReasonLabels = <DiscountReason, String>{
  DiscountReason.sibling: 'Irmãos',
  DiscountReason.merit: 'Mérito',
  DiscountReason.scholarship: 'Bolsa',
  DiscountReason.other: 'Outro',
};

/// Rótulos (pt-AO) dos estados de desconto.
const discountStatusLabels = <DiscountStatus, String>{
  DiscountStatus.pending: 'Pendente',
  DiscountStatus.approved: 'Aprovado',
  DiscountStatus.rejected: 'Rejeitado',
  DiscountStatus.revoked: 'Revogado',
};

/// O desconto [d] aplica-se a uma cobrança de [type] com vencimento [due]?
/// Só descontos aprovados, do tipo certo e dentro da validade.
bool discountApplies(Discount d, FeeType type, DateTime due) {
  if (d.status != DiscountStatus.approved || d.deletedAt != null) return false;
  if (d.feeType != null && d.feeType != type) return false;
  final day = DateTime.utc(due.year, due.month, due.day);
  if (day.isBefore(d.validFrom)) return false;
  final until = d.validUntil;
  return until == null || !day.isAfter(until);
}

/// Desconto total (menor unidade) sobre uma cobrança de [amountMinor]: soma os
/// descontos aplicáveis (percentagem sobre o valor original, ou valor fixo) e
/// nunca ultrapassa o valor da cobrança. Aritmética inteira.
int totalDiscountMinor(
  Iterable<Discount> discounts, {
  required FeeType type,
  required DateTime due,
  required int amountMinor,
}) {
  var total = 0;
  for (final d in discounts) {
    if (!discountApplies(d, type, due)) continue;
    total += d.kind == DiscountKind.percentage
        ? amountMinor * d.value ~/ 10000
        : d.value;
  }
  return total.clamp(0, amountMinor);
}
