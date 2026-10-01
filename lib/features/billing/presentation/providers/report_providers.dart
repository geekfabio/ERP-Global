import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/report_mock_handlers.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/report_rows.dart';
import '../../data/repositories/api_report_repository.dart';
import '../../domain/report_repository.dart';
import 'billing_providers.dart';
import 'payment_providers.dart';

/// Permissões dos relatórios financeiros.
const reportReadPermission = 'billing.report.read';
const reportExportPermission = 'billing.report.export';

final reportRepositoryProvider = Provider<ReportRepository>(
  (ref) => ApiReportRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos relatórios; partilham cobranças e pagamentos do billing.
final reportMockHandlersProvider = Provider<ReportMockHandlers>((ref) {
  final billing = ref.watch(billingMockHandlersProvider);
  final payments = ref.watch(paymentMockHandlersProvider);
  return ReportMockHandlers(
    allCharges: billing.allCharges,
    allPayments: payments.allPayments,
    feeTypeOf: (c) => billing.feeItemById(c.feeItemId)?.type ?? FeeType.other,
  );
});

/// Filtros dos relatórios: agrupamento da receita e janela em meses (contados
/// a partir do início do mês corrente; `null` = sem limite).
class ReportFilter {
  const ReportFilter({this.group = RevenueGroup.period, this.months});

  final RevenueGroup group;
  final int? months;

  ReportFilter copyWith({RevenueGroup? group, int? Function()? months}) =>
      ReportFilter(
        group: group ?? this.group,
        months: months == null ? this.months : months(),
      );
}

class ReportFilterNotifier extends Notifier<ReportFilter> {
  @override
  ReportFilter build() => const ReportFilter();

  void setGroup(RevenueGroup group) => state = state.copyWith(group: group);

  void setMonths(int? months) => state = state.copyWith(months: () => months);
}

final reportFilterProvider =
    NotifierProvider<ReportFilterNotifier, ReportFilter>(
      ReportFilterNotifier.new,
    );

/// Início da janela de [months] meses (inclui o mês corrente) ou `null`.
DateTime? reportFrom(int? months, DateTime now) {
  if (months == null) return null;
  final total = now.year * 12 + (now.month - 1) - (months - 1);
  return DateTime.utc(total ~/ 12, total % 12 + 1);
}

final revenueReportProvider = FutureProvider.autoDispose<List<RevenueRow>>((
  ref,
) async {
  final filter = ref.watch(reportFilterProvider);
  return (await ref
          .watch(reportRepositoryProvider)
          .revenue(
            group: filter.group,
            from: reportFrom(filter.months, DateTime.now().toUtc()),
          ))
      .getOrThrow();
}, retry: (_, _) => null);

final forecastReportProvider = FutureProvider.autoDispose<List<ForecastRow>>((
  ref,
) async {
  final filter = ref.watch(reportFilterProvider);
  return (await ref
          .watch(reportRepositoryProvider)
          .forecast(from: reportFrom(filter.months, DateTime.now().toUtc())))
      .getOrThrow();
}, retry: (_, _) => null);
