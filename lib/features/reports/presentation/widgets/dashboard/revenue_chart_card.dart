import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/widgets/charts/app_charts.dart';
import '../../../../../core/widgets/charts/chart_card.dart';
import '../../../../../core/widgets/states/app_states.dart';
import '../../../data/models/finance_overview.dart';
import '../../providers/finance_overview_providers.dart';

/// Altura comum dos gráficos do painel.
const double dashboardChartHeight = 240;

/// Receita cobrada (linha sólida) vs. prevista (tracejada) por mês, em
/// milhares de Kz. Dados de `GET /v1/reports/finance-overview`.
class RevenueChartCard extends ConsumerWidget {
  const RevenueChartCard({super.key});

  /// Cêntimos → milhares de Kz (eixo legível).
  static double thousands(int cents) => cents / 100 / 1000;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheme = Theme.of(context).colorScheme;
    return ChartCard(
      title: 'Receita por mês',
      subtitle: 'Cobrada vs. prevista, em milhares de Kz',
      legend: Wrap(
        spacing: AppSpacing.lg,
        children: [
          ChartLegendKey(label: 'Cobrada', color: scheme.primary),
          ChartLegendKey(
            label: 'Prevista',
            color: scheme.onSurfaceVariant,
            dashed: true,
          ),
        ],
      ),
      child: AsyncValueView<FinanceOverview?>(
        value: ref.watch(financeOverviewProvider),
        loading: const SkeletonCard(height: dashboardChartHeight),
        onRetry: () => ref.invalidate(financeOverviewProvider),
        isEmpty: (o) => o == null || o.rows.isEmpty,
        empty: const EmptyState(
          icon: Icons.show_chart,
          title: 'Sem movimentos no período',
        ),
        data: (o) => AppLineChart(
          height: dashboardChartHeight,
          semanticLabel:
              'Receita cobrada e prevista por mês: '
              '${o!.rows.map((r) => r.label).join(', ')}',
          labels: [for (final r in o.rows) r.label],
          values: [for (final r in o.rows) thousands(r.collected)],
          referenceValues: [for (final r in o.rows) thousands(r.expected)],
        ),
      ),
    );
  }
}
