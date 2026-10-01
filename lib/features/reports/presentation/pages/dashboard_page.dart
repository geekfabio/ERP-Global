import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/academic/period_context.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/cards/app_cards.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/dashboard_metric.dart';
import '../../domain/dashboard_widget.dart';
import '../providers/reports_providers.dart';
import '../widgets/dashboard_filters_bar.dart';

String formatMetric(MetricKind kind, int value) => switch (kind) {
  MetricKind.count => PtAoFormatters.number(value),
  MetricKind.money => PtAoFormatters.currency(value),
  MetricKind.percent => '$value%',
};

/// Dashboard por perfil: os widgets dependem do perfil e dos módulos
/// licenciados; filtros de ano/trimestre/campus e comparação entre períodos.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(dashboardProfileProvider);
    final widgets = ref.watch(visibleWidgetsProvider);
    final query = ref.watch(dashboardQueryProvider);
    final metrics = ref.watch(dashboardMetricsProvider);
    final compareMode = ref.watch(
      dashboardFiltersProvider.select((f) => f.compare),
    );
    final period = ref.watch(effectivePeriodProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              profile == null
                  ? 'Relatórios'
                  : 'Dashboard · ${dashboardProfiles[profile]}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const DashboardFiltersBar(),
            const SizedBox(height: AppSpacing.lg),
            if (profile == null || widgets.isEmpty)
              const EmptyState(
                icon: Icons.insights_outlined,
                title: 'Sem indicadores para o seu perfil',
                message:
                    'Os indicadores dependem do perfil e dos módulos '
                    'licenciados.',
              )
            else if (query == null)
              const EmptyState(
                icon: Icons.event_outlined,
                title: 'Sem ano lectivo',
                message: 'Crie um ano lectivo nas definições.',
              )
            else
              AsyncValueView<Map<String, DashboardMetric>>(
                value: metrics,
                loading: const SkeletonCard(),
                onRetry: () => ref.invalidate(dashboardMetricsProvider),
                data: (data) => _Grid(
                  widgets: widgets,
                  metrics: data,
                  comparing: query.compareYearId != null,
                  caption: compareMode == CompareMode.none
                      ? null
                      : 'vs. ${compareMode.label.toLowerCase()}',
                  noBaseline:
                      compareMode != CompareMode.none &&
                      query.compareYearId == null,
                  periodLabel: [
                    period.year?.label,
                    period.term?.label,
                  ].whereType<String>().join(' · '),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.widgets,
    required this.metrics,
    required this.comparing,
    required this.caption,
    required this.noBaseline,
    required this.periodLabel,
  });

  final List<DashboardWidgetSpec> widgets;
  final Map<String, DashboardMetric> metrics;
  final bool comparing;
  final String? caption;
  final bool noBaseline;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(periodLabel, style: text.titleMedium),
        if (noBaseline)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              'Não existe período anterior para comparar.',
              style: text.bodySmall,
            ),
          ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            for (final w in widgets)
              if (metrics[w.id] case final m?)
                SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      KpiCard(
                        key: ValueKey(w.id),
                        label: w.title,
                        icon: w.icon,
                        value: m.value,
                        format: (v) => formatMetric(w.kind, v),
                        deltaPercent: deltaOf(w.kind, m.value, m.previous),
                      ),
                      if (comparing && m.previous != null)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.sm,
                            top: AppSpacing.xs,
                          ),
                          child: Text(
                            '$caption: ${formatMetric(w.kind, m.previous!)}',
                            style: text.bodySmall,
                          ),
                        ),
                    ],
                  ),
                ),
          ],
        ),
      ],
    );
  }
}
