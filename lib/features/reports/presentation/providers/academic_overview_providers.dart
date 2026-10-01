import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/academic/period_context.dart';
import '../../data/models/academic_overview.dart';
import 'reports_providers.dart';

/// Pedido em vigor (período global + campus + comparação); `null` sem ano.
final academicOverviewQueryProvider = Provider<AcademicOverviewQuery?>((ref) {
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

/// KPIs e desdobramento por classe. Falhas chegam à UI como `AsyncError`.
final academicOverviewProvider = FutureProvider.autoDispose<AcademicOverview?>((
  ref,
) async {
  final query = ref.watch(academicOverviewQueryProvider);
  if (query == null) return null;
  return (await ref.watch(reportsRepositoryProvider).academicOverview(query))
      .getOrThrow();
}, retry: (_, _) => null);
