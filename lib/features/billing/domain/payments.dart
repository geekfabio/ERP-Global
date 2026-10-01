import '../data/models/billing_enums.dart';
import '../data/models/charge.dart';
import '../data/models/payment.dart';
import '../data/models/student_account.dart';

/// Rótulos (pt-AO) dos métodos de pagamento.
const paymentMethodLabelsPt = <PaymentMethod, String>{
  PaymentMethod.cash: 'Numerário',
  PaymentMethod.bankTransfer: 'Transferência',
  PaymentMethod.card: 'TPA / Multicaixa',
  PaymentMethod.paymentReference: 'Referência de pagamento',
  PaymentMethod.prepaidBalance: 'Saldo pré-pago',
};

/// Valor líquido (após desconto) de uma cobrança.
int chargeNetMinor(Charge c) => c.amountMinor - c.discountMinor;

/// Cobrança que ainda aceita pagamentos.
bool isChargeOpen(Charge c) =>
    c.deletedAt == null &&
    (c.status == ChargeStatus.pending ||
        c.status == ChargeStatus.partiallyPaid ||
        c.status == ChargeStatus.overdue);

/// Total alocado por cobrança (só pagamentos concluídos).
Map<String, int> allocatedByCharge(Iterable<Payment> payments) {
  final out = <String, int>{};
  for (final p in payments) {
    if (p.status != PaymentStatus.completed) continue;
    for (final a in p.allocations) {
      out[a.chargeId] = (out[a.chargeId] ?? 0) + a.amountMinor;
    }
  }
  return out;
}

/// Valor ainda em dívida de [c] dado o total já alocado.
int outstandingOf(Charge c, int allocatedMinor) =>
    c.status == ChargeStatus.cancelled
    ? 0
    : (chargeNetMinor(c) - allocatedMinor).clamp(0, chargeNetMinor(c));

/// Distribui [amountMinor] pelas cobranças abertas, das mais antigas para as
/// mais recentes (data de vencimento, depois id). O que sobra fica como
/// adiantamento (não é alocado).
({List<PaymentAllocation> allocations, int remainderMinor}) autoAllocate({
  required Iterable<Charge> charges,
  required Map<String, int> allocated,
  required int amountMinor,
}) {
  final open = charges.where(isChargeOpen).toList()
    ..sort((a, b) {
      final d = a.dueDate.compareTo(b.dueDate);
      return d != 0 ? d : a.id.compareTo(b.id);
    });
  var left = amountMinor;
  final out = <PaymentAllocation>[];
  for (final c in open) {
    if (left <= 0) break;
    final due = outstandingOf(c, allocated[c.id] ?? 0);
    if (due == 0) continue;
    final take = due < left ? due : left;
    out.add(PaymentAllocation(chargeId: c.id, amountMinor: take));
    left -= take;
  }
  return (allocations: out, remainderMinor: left);
}

/// Estado da cobrança depois de alocados [allocatedMinor]. Uma cobrança
/// vencida continua vencida enquanto não for totalmente paga.
ChargeStatus statusAfterAllocation(Charge c, int allocatedMinor) {
  if (c.status == ChargeStatus.cancelled) return c.status;
  if (allocatedMinor >= chargeNetMinor(c)) return ChargeStatus.paid;
  if (allocatedMinor <= 0) return c.status;
  return c.status == ChargeStatus.overdue
      ? ChargeStatus.overdue
      : ChargeStatus.partiallyPaid;
}

/// Crédito pré-pago disponível: dinheiro recebido e não alocado, menos o
/// saldo pré-pago já usado em pagamentos.
int prepaidAvailableMinor(Iterable<Payment> payments) {
  var total = 0;
  for (final p in payments) {
    if (p.status != PaymentStatus.completed) continue;
    final allocated = p.allocations.fold<int>(0, (a, x) => a + x.amountMinor);
    total += p.method == PaymentMethod.prepaidBalance
        ? -p.amountMinor
        : p.amountMinor - allocated;
  }
  return total;
}

/// Conta corrente do aluno. Débitos = cobranças (líquidas); créditos =
/// dinheiro recebido (o uso de saldo pré-pago só redistribui crédito e não
/// cria lançamento). Invariante: `balance = prepaid - outstanding`.
StudentAccount buildStudentAccount({
  required String studentId,
  required String institutionId,
  required Iterable<Charge> charges,
  required Iterable<Payment> payments,
  required DateTime now,
}) {
  final live = charges
      .where((c) => c.status != ChargeStatus.cancelled)
      .toList();
  final done = payments
      .where((p) => p.status == PaymentStatus.completed)
      .toList();
  final allocated = allocatedByCharge(done);
  final entries = <LedgerEntry>[
    for (final c in live)
      LedgerEntry(
        id: 'ch-${c.id}',
        referenceId: c.id,
        kind: 'charge',
        occurredAt: c.createdAt,
        debitMinor: chargeNetMinor(c),
        creditMinor: 0,
      ),
    for (final p in done)
      if (p.method != PaymentMethod.prepaidBalance)
        LedgerEntry(
          id: 'pay-${p.id}',
          referenceId: p.id,
          occurredAt: p.paidAt,
          debitMinor: 0,
          creditMinor: p.amountMinor,
        ),
  ]..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
  final outstanding = live.fold<int>(
    0,
    (a, c) => a + outstandingOf(c, allocated[c.id] ?? 0),
  );
  final prepaid = prepaidAvailableMinor(done);
  return StudentAccount(
    id: 'acc-$studentId',
    institutionId: institutionId,
    createdAt: now,
    updatedAt: now,
    studentId: studentId,
    balanceMinor: prepaid - outstanding,
    prepaidMinor: prepaid,
    outstandingMinor: outstanding,
    entries: entries,
  );
}
