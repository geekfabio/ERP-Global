import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/academic/period_context.dart';
import '../../data/models/finance_overview.dart';
import 'reports_providers.dart';

/// Pedido em vigor (período global + campus + comparação); `null` sem ano.
final financeOverviewQueryProvider = Provider<FinanceOverviewQuery?>((ref) {
  final period = ref.watch(effectivePeriodProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  final choices =
      ref.watch(periodChoicesProvider).value ?? const PeriodChoices.empty();
  final year = period.year;
  if (year == null) return null;
  final compare = comparePeriod(choices, period, filters.compare);
  return (
    yearId: year.id,
    termId: period.term?.id,
    campusId: filters.campusId,
    compareYearId: compare?.yearId,
    compareTermId: compare?.termId,
  );
});

/// KPIs e desdobramento mensal. Falhas chegam à UI como `AsyncError`.
final financeOverviewProvider = FutureProvider.autoDispose<FinanceOverview?>((
  ref,
) async {
  final query = ref.watch(financeOverviewQueryProvider);
  if (query == null) return null;
  return (await ref.watch(reportsRepositoryProvider).financeOverview(query))
      .getOrThrow();
}, retry: (_, _) => null);
