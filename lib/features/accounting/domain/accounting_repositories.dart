import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/accounting_models.dart';

/// Contrato do plano de contas; a UI só conhece esta interface.
abstract interface class AccountRepository {
  Future<Result<PagedList<AccountModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
  });

  /// Cria a conta; 409 se o código existe ou não começa pelo da conta-mãe;
  /// 422 sem código/designação.
  Future<Result<AccountModel>> create(AccountModel account);

  /// Altera designação, estado e/ou se é movimentável (o código é imutável).
  Future<Result<AccountModel>> update(
    String id, {
    String? name,
    bool? isActive,
    bool? postable,
  });

  /// Elimina; 409 se tiver subcontas.
  Future<Result<void>> delete(String id);
}

/// Contrato dos exercícios contabilísticos.
abstract interface class FiscalYearRepository {
  Future<Result<PagedList<FiscalYearModel>>> list({
    int page = 1,
    int pageSize = 50,
  });

  /// Cria o exercício; 422 se fim ≤ início, 409 se sobrepõe outro.
  Future<Result<FiscalYearModel>> create(FiscalYearModel year);

  /// Fecha o exercício (terminal); 409 se já fechado.
  Future<Result<FiscalYearModel>> close(String id);
}

/// Contrato dos centros de custo.
abstract interface class CostCenterRepository {
  Future<Result<PagedList<CostCenterModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
  });

  /// 409 se o código já existe.
  Future<Result<CostCenterModel>> create(CostCenterModel center);

  Future<Result<CostCenterModel>> update(
    String id, {
    String? name,
    bool? isActive,
  });

  Future<Result<void>> delete(String id);
}
