import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/accounting_mock_handlers.dart';
import '../../data/mock_api/journal_mock_handlers.dart';
import '../../data/models/accounting_models.dart';
import '../../data/models/journal_models.dart';
import '../../data/repositories/api_accounting_repositories.dart';
import '../../data/repositories/api_journal_repositories.dart';
import '../../domain/accounting_repositories.dart';
import '../../domain/journal_repositories.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => ApiAccountRepository(ref.watch(apiClientProvider)),
);

final fiscalYearRepositoryProvider = Provider<FiscalYearRepository>(
  (ref) => ApiFiscalYearRepository(ref.watch(apiClientProvider)),
);

final costCenterRepositoryProvider = Provider<CostCenterRepository>(
  (ref) => ApiCostCenterRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final accountingMockHandlersProvider = Provider<AccountingMockHandlers>(
  (ref) => AccountingMockHandlers(),
);

final journalRepositoryProvider = Provider<JournalRepository>(
  (ref) => ApiJournalRepository(ref.watch(apiClientProvider)),
);

final openItemRepositoryProvider = Provider<OpenItemRepository>(
  (ref) => ApiOpenItemRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos lançamentos (leem contas/exercícios do módulo).
final journalMockHandlersProvider = Provider<JournalMockHandlers>(
  (ref) => JournalMockHandlers(ref.watch(accountingMockHandlersProvider)),
);

/// Percorre as páginas do servidor (a árvore e as tabelas são locais).
Future<List<T>> _fetchAll<T>(
  Future<PagedList<T>> Function(int page) fetch,
) async {
  final items = <T>[];
  var page = 1;
  while (true) {
    final result = await fetch(page);
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}

/// Todas as contas (lista plana ordenada por código; a UI monta a árvore).
final accountListProvider = FutureProvider.autoDispose<List<AccountModel>>((
  ref,
) {
  final repo = ref.watch(accountRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

final fiscalYearListProvider =
    FutureProvider.autoDispose<List<FiscalYearModel>>((ref) {
      final repo = ref.watch(fiscalYearRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.list(page: page, pageSize: 50)).getOrThrow(),
      );
    }, retry: (_, _) => null);

final costCenterListProvider =
    FutureProvider.autoDispose<List<CostCenterModel>>((ref) {
      final repo = ref.watch(costCenterRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.list(page: page, pageSize: 100)).getOrThrow(),
      );
    }, retry: (_, _) => null);

/// Período opcional (datas de calendário UTC) dos relatórios.
typedef ReportPeriod = ({DateTime? from, DateTime? to});

final journalEntriesProvider =
    FutureProvider.autoDispose<List<JournalEntryModel>>((ref) {
      final repo = ref.watch(journalRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.list(page: page, pageSize: 100)).getOrThrow(),
      );
    }, retry: (_, _) => null);

final ledgerProvider = FutureProvider.autoDispose
    .family<LedgerModel, ({String accountId, ReportPeriod period})>((
      ref,
      query,
    ) async {
      final repo = ref.watch(journalRepositoryProvider);
      return (await repo.ledger(
        query.accountId,
        from: query.period.from,
        to: query.period.to,
      )).getOrThrow();
    }, retry: (_, _) => null);

final trialBalanceProvider = FutureProvider.autoDispose
    .family<TrialBalanceModel, ReportPeriod>((ref, period) async {
      final repo = ref.watch(journalRepositoryProvider);
      return (await repo.trialBalance(
        from: period.from,
        to: period.to,
      )).getOrThrow();
    }, retry: (_, _) => null);

final openItemListProvider = FutureProvider.autoDispose<List<OpenItemModel>>((
  ref,
) {
  final repo = ref.watch(openItemRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);
