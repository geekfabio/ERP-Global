import '../../../core/errors/result.dart';
import '../data/models/portal_finance_models.dart';

/// Leitura financeira do portal. O âmbito é decidido pela API: educando não
/// vinculado → `403 FORBIDDEN`.
abstract interface class PortalFinanceRepository {
  /// Cobranças (conta corrente) e recibos do educando. Módulo `billing`.
  Future<Result<PortalFinance>> finance(String studentId);

  /// Gera uma referência de pagamento (mock) para as cobranças em aberto,
  /// ou só para [chargeIds] quando indicados.
  Future<Result<PortalPaymentReference>> paymentReference(
    String studentId, {
    List<String> chargeIds = const [],
  });

  /// Saldo, extracto e entradas/saídas do cartão. Módulo `cards`.
  Future<Result<PortalCard>> card(String studentId);
}
