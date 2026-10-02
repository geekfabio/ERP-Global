import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/wallet.dart';

/// Contrato da carteira pré-paga; a UI só conhece esta interface.
abstract interface class WalletRepository {
  Future<Result<PagedList<Wallet>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    bool? blocked,
  });

  /// Abre a carteira de um titular; 409 se já existe.
  Future<Result<Wallet>> open({
    required String holderId,
    required String holderName,
    int dailyLimitMinor = 0,
  });

  /// Carrega saldo. [method] e [reference] ligam ao pagamento no billing.
  Future<Result<WalletTransaction>> topUp(
    String walletId, {
    required int amountMinor,
    required String method,
    String? reference,
  });

  /// Consumo; 422 sem saldo suficiente, 409 se bloqueada ou acima do limite.
  Future<Result<WalletTransaction>> purchase(
    String walletId, {
    required int amountMinor,
    String? description,
    String? mealTypeId,
    String? className,
  });

  /// Estorna um consumo (uma só vez).
  Future<Result<WalletTransaction>> refund(
    String walletId, {
    required String transactionId,
    String? reason,
  });

  /// Define o limite diário (`0` = sem limite).
  Future<Result<Wallet>> setDailyLimit(String walletId, int dailyLimitMinor);

  Future<Result<Wallet>> setBlocked(String walletId, {required bool blocked});

  /// Extracto: movimentos do mais recente para o mais antigo, por período.
  Future<Result<PagedList<WalletTransaction>>> statement(
    String walletId, {
    int page = 1,
    int pageSize = 20,
    DateTime? from,
    DateTime? to,
    WalletTransactionType? type,
  });
}
