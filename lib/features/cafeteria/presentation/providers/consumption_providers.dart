import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/consumption_mock_handlers.dart';
import '../../data/models/consumption_rows.dart';
import '../../data/repositories/api_consumption_repository.dart';
import '../../domain/consumption_repository.dart';
import 'menu_providers.dart';
import 'wallet_providers.dart';

/// Permissões dos relatórios de consumo.
const consumptionReadPermission = 'cafeteria.report.read';
const consumptionExportPermission = 'cafeteria.report.export';

final consumptionRepositoryProvider = Provider<ConsumptionRepository>(
  (ref) => ApiConsumptionRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos relatórios; partilham carteiras, movimentos e tipos de
/// refeição do módulo.
final consumptionMockHandlersProvider = Provider<ConsumptionMockHandlers>((
  ref,
) {
  final wallets = ref.watch(walletMockHandlersProvider);
  final menus = ref.watch(menuMockHandlersProvider);
  return ConsumptionMockHandlers(
    wallets: () => wallets.allWallets,
    transactions: () => wallets.allTransactions,
    mealTypes: () => menus.allMealTypes,
  );
});

/// Filtros: agrupamento e janela em meses (contados a partir do início do mês
/// corrente; `null` = sem limite).
class ConsumptionFilter {
  const ConsumptionFilter({
    this.group = ConsumptionGroup.classroom,
    this.months,
  });

  final ConsumptionGroup group;
  final int? months;

  ConsumptionFilter copyWith({
    ConsumptionGroup? group,
    int? Function()? months,
  }) => ConsumptionFilter(
    group: group ?? this.group,
    months: months == null ? this.months : months(),
  );
}

class ConsumptionFilterNotifier extends Notifier<ConsumptionFilter> {
  @override
  ConsumptionFilter build() => const ConsumptionFilter();

  void setGroup(ConsumptionGroup group) => state = state.copyWith(group: group);

  void setMonths(int? months) => state = state.copyWith(months: () => months);
}

final consumptionFilterProvider =
    NotifierProvider<ConsumptionFilterNotifier, ConsumptionFilter>(
      ConsumptionFilterNotifier.new,
    );

/// Início da janela de [months] meses (inclui o mês corrente) ou `null`.
DateTime? consumptionFrom(int? months, DateTime now) {
  if (months == null) return null;
  final total = now.year * 12 + (now.month - 1) - (months - 1);
  return DateTime.utc(total ~/ 12, total % 12 + 1);
}

final consumptionReportProvider =
    FutureProvider.autoDispose<List<ConsumptionRow>>((ref) async {
      final filter = ref.watch(consumptionFilterProvider);
      return (await ref
              .watch(consumptionRepositoryProvider)
              .consumption(
                group: filter.group,
                from: consumptionFrom(filter.months, DateTime.now().toUtc()),
              ))
          .getOrThrow();
    }, retry: (_, _) => null);

final prepaidBalanceProvider = FutureProvider.autoDispose<PrepaidBalance>(
  (ref) async =>
      (await ref.watch(consumptionRepositoryProvider).prepaidBalance())
          .getOrThrow(),
  retry: (_, _) => null,
);
