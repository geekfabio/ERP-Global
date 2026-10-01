import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/billing_enums.dart';
import '../data/models/cash_register.dart';
import '../data/models/cash_session.dart';

/// Caixas, sessões de caixa por operador, movimentos e fecho com conferência.
abstract interface class CashRepository {
  Future<Result<List<CashRegister>>> registers();

  Future<Result<PagedList<CashSession>>> sessions({
    int page = 1,
    int pageSize = 20,
    CashSessionStatus? status,
    String? operatorId,
  });

  /// Abre a sessão do [operatorId] no caixa. 409 se o caixa ou o operador já
  /// têm uma sessão aberta; 422 em valor de abertura inválido.
  Future<Result<CashSession>> open({
    required String cashRegisterId,
    required String operatorId,
    required int openingMinor,
  });

  Future<Result<List<CashMovement>>> movements(String sessionId);

  /// Regista sangria ou reforço. 409 se a sessão está fechada; 422 se a
  /// sangria excede o numerário em caixa.
  Future<Result<CashMovement>> addMovement({
    required String sessionId,
    required CashMovementType type,
    required int amountMinor,
    String? description,
  });

  /// Fecha a sessão com o valor contado. 422 se há diferença sem justificação.
  Future<Result<CashSession>> close({
    required String sessionId,
    required int countedMinor,
    String? notes,
  });
}
