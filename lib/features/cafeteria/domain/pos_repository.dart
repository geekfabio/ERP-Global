import '../../../core/errors/result.dart';
import 'pos_sale.dart';

/// Contrato do POS: identifica o cliente (cartão ou titular) e reúne o que a
/// validação local precisa. A UI só conhece esta interface.
abstract interface class PosRepository {
  /// Lê um cartão pelo UID. 404 se o cartão não existe ou o titular não tem
  /// carteira.
  Future<Result<PosCustomer>> identifyCard(String uid);

  /// Identifica pelo titular (leitura simulada a partir de uma carteira).
  Future<Result<PosCustomer>> identifyHolder(String holderId);
}
