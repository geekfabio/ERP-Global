import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/journal_models.dart';

/// Contrato do diário, razão e balancete; a UI só conhece esta interface.
abstract interface class JournalRepository {
  /// Diário (ordenado por data e número); filtros por período e conta.
  Future<Result<PagedList<JournalEntryModel>>> list({
    int page = 1,
    int pageSize = 50,
    DateTime? from,
    DateTime? to,
    String? accountId,
  });

  /// Lança; 422 se não balanceado/linhas inválidas, 409 se a data não cai
  /// num exercício aberto ou a conta não é movimentável/activa.
  Future<Result<JournalEntryModel>> create(JournalEntryModel entry);

  /// Estorna (cria o lançamento inverso); 409 se já estornado ou é um estorno.
  Future<Result<JournalEntryModel>> reverse(String id);

  /// Razão de uma conta (e subcontas) no período.
  Future<Result<LedgerModel>> ledger(
    String accountId, {
    DateTime? from,
    DateTime? to,
  });

  Future<Result<TrialBalanceModel>> trialBalance({
    DateTime? from,
    DateTime? to,
  });

  /// Contabiliza um evento de billing; idempotente por evento + referência.
  Future<Result<JournalEntryModel>> postBillingEvent(BillingEventModel event);
}

/// Contrato das contas a pagar e a receber.
abstract interface class OpenItemRepository {
  Future<Result<PagedList<OpenItemModel>>> list({
    int page = 1,
    int pageSize = 50,
    OpenItemKind? kind,
    OpenItemStatus? status,
  });

  /// Regista o título e o lançamento correspondente.
  Future<Result<OpenItemModel>> create(OpenItemModel item);

  /// Liquida (total ou parcial) contra a conta de caixa/banco [cashAccountId];
  /// 422 se exceder o em dívida, 409 se já liquidado.
  Future<Result<OpenItemModel>> settle(
    String id, {
    required int amountMinor,
    required DateTime date,
    required String cashAccountId,
  });
}
