import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/credit_note.dart';
import '../data/models/invoice.dart';

/// Resultado da anulação: factura anulada + nota de crédito emitida.
class InvoiceCancellation {
  const InvoiceCancellation({required this.invoice, required this.creditNote});

  final Invoice invoice;
  final CreditNote creditNote;
}

/// Facturas e notas de crédito. Documentos emitidos são imutáveis: não há
/// edição nem remoção; a correcção faz-se anulando (nota de crédito).
abstract interface class InvoiceRepository {
  Future<Result<PagedList<Invoice>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    InvoiceStatus? status,
  });

  /// Emite uma factura (série e número atribuídos) a partir de cobranças do
  /// mesmo aluno. 422 sem cobranças/isenção sem motivo; 409 se alguma
  /// cobrança já está facturada.
  Future<Result<Invoice>> issue({
    required String studentId,
    required List<String> chargeIds,
    required int taxRateBp,
    String? exemptionReason,
  });

  /// Anula com motivo obrigatório e emite a nota de crédito (409 se já anulada).
  Future<Result<InvoiceCancellation>> cancel(
    String id, {
    required String reason,
  });

  Future<Result<PagedList<CreditNote>>> creditNotes({
    int page = 1,
    int pageSize = 20,
    String? invoiceId,
  });
}
