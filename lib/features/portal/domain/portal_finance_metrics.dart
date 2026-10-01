import '../../students/data/models/student_summaries_model.dart';

/// Valor em dívida (menor unidade) de uma cobrança.
int chargeOutstandingMinor(StudentChargeLine c) =>
    c.status == StudentChargeStatus.paid ? 0 : c.amountMinor - c.paidMinor;

/// Cobranças por pagar (em aberto, parciais ou em atraso), por vencimento.
List<StudentChargeLine> payableCharges(List<StudentChargeLine> charges) =>
    charges.where((c) => chargeOutstandingMinor(c) > 0).toList()
      ..sort((a, b) => a.dueOn.compareTo(b.dueOn));

int totalOutstandingMinor(List<StudentChargeLine> charges) =>
    charges.fold(0, (sum, c) => sum + chargeOutstandingMinor(c));

/// Referência de 9 dígitos, determinística para o mesmo educando e valor.
String buildPaymentReference(String studentId, int amountMinor) {
  var h = 7;
  for (final c in '$studentId/$amountMinor'.codeUnits) {
    h = (h * 31 + c) & 0x7fffffff;
  }
  return (100000000 + h % 900000000).toString();
}
