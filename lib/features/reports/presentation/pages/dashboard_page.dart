import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/layout/responsive_grid.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/dashboard_metric.dart';
import '../../domain/dashboard_widget.dart';
import '../providers/reports_providers.dart';
import '../widgets/dashboard/dashboard_charts.dart';
import '../widgets/dashboard/dashboard_header.dart';
import '../widgets/dashboard/dashboard_kpi_sections.dart';
import '../widgets/dashboard_filters_bar.dart';

/// Dashboard por perfil: os widgets dependem do perfil e dos módulos
/// licenciados; filtros de ano/trimestre/campus e comparação entre períodos.
/// Compõe os componentes de `widgets/dashboard/`.
class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(dashboardProfileProvider);
    final widgets = ref.watch(visibleWidgetsProvider);
    final query = ref.watch(dashboardQueryProvider);
    final compareMode = ref.watch(
      dashboardFiltersProvider.select((f) => f.compare),
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            DashboardHeader(profile: profile),
            const SizedBox(height: AppSpacing.lg),
            const DashboardFiltersBar(),
            const SizedBox(height: AppSpacing.xl),
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
            else ...[
              AsyncValueView<Map<String, DashboardMetric>>(
                value: ref.watch(dashboardMetricsProvider),
                loading: const ResponsiveGrid(
                  children: [
                    SkeletonCard(),
                    SkeletonCard(),
                    SkeletonCard(),
                    SkeletonCard(),
                  ],
                ),
                onRetry: () => ref.invalidate(dashboardMetricsProvider),
                data: (data) => DashboardKpiSections(
                  widgets: widgets,
                  metrics: data,
                  caption: compareMode == CompareMode.none
                      ? null
                      : 'vs. ${compareMode.label.toLowerCase()}',
                  noBaseline:
                      compareMode != CompareMode.none &&
                      query.compareYearId == null,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              DashboardCharts(widgetIds: {for (final w in widgets) w.id}),
            ],
          ],
        ),
      ),
    );
  }
}
