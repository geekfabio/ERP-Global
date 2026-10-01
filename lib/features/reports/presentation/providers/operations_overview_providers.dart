import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/academic/period_context.dart';
import '../../data/models/operations_overview.dart';
import 'reports_providers.dart';

/// Pedido em vigor (período global + campus); `null` sem ano lectivo.
final operationsOverviewQueryProvider = Provider<OperationsOverviewQuery?>((
  ref,
) {
  final period = ref.watch(effectivePeriodProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  final year = period.year;
  if (year == null) return null;
  return (yearId: year.id, termId: period.term?.id, campusId: filters.campusId);
});

/// Dashboards operacionais. Falhas chegam à UI como `AsyncError`.
final operationsOverviewProvider =
    FutureProvider.autoDispose<OperationsOverview?>((ref) async {
      final query = ref.watch(operationsOverviewQueryProvider);
      if (query == null) return null;
      return (await ref
              .watch(reportsRepositoryProvider)
              .operationsOverview(query))
          .getOrThrow();
    }, retry: (_, _) => null);
