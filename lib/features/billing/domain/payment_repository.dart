import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/payment.dart';
import '../data/models/receipt.dart';
import '../data/models/student_account.dart';

/// Resultado de um pagamento: o pagamento e o recibo (ausente quando se usa
/// saldo pré-pago, pois o dinheiro já foi recibado antes).
class PaymentResult {
  const PaymentResult({required this.payment, this.receipt});

  final Payment payment;
  final Receipt? receipt;
}

/// Pagamentos (parciais e adiantados), recibos e conta corrente do aluno.
abstract interface class PaymentRepository {
  Future<Result<PagedList<Payment>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
  });

  /// Regista um pagamento. Sem [allocations], distribui pelas cobranças mais
  /// antigas; o excedente fica como saldo pré-pago (adiantamento). Com
  /// [PaymentMethod.prepaidBalance] o valor sai do saldo e tem de ficar
  /// totalmente alocado. 422 em valores/alocações inválidos.
  Future<Result<PaymentResult>> create({
    required String studentId,
    required PaymentMethod method,
    required int amountMinor,
    List<PaymentAllocation>? allocations,
  });

  Future<Result<PagedList<Receipt>>> receipts({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    String? paymentId,
  });

  /// Conta corrente (débitos, créditos, saldo e crédito pré-pago).
  Future<Result<StudentAccount>> account(String studentId);
}
