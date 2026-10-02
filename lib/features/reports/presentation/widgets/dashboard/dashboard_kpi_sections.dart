import 'package:flutter/material.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/cards/kpi_card.dart';
import '../../../../../core/widgets/layout/content_section.dart';
import '../../../../../core/widgets/layout/responsive_grid.dart';
import '../../../data/models/dashboard_metric.dart';
import '../../../domain/dashboard_widget.dart';

String formatMetric(MetricKind kind, int value) => switch (kind) {
  MetricKind.count => PtAoFormatters.number(value),
  MetricKind.money => PtAoFormatters.currency(value),
  MetricKind.percent => '$value%',
};

/// Indicadores em que uma subida é má notícia (variação a vermelho).
const lowerIsBetterMetrics = {'billing.debt', 'billing.default_rate'};

/// Áreas do painel, pela ordem em que as secções aparecem.
const dashboardAreas = ['Académico', 'Financeiro', 'Operações'];

String dashboardAreaOf(String moduleCode) => switch (moduleCode) {
  'students' || 'academic' || 'attendance' => dashboardAreas[0],
  'billing' => dashboardAreas[1],
  _ => dashboardAreas[2],
};

/// Cor de destaque do módulo (tokens do tema, claro e escuro).
Color moduleAccentOf(BuildContext context, String moduleCode) {
  final colors = context.appColors;
  final scheme = Theme.of(context).colorScheme;
  return switch (moduleCode) {
    'students' || 'academic' || 'attendance' => colors.academic,
    'billing' => colors.finance,
    'cafeteria' => colors.canteen,
    'access_control' => colors.access,
    'hr' => scheme.secondary,
    _ => scheme.tertiary,
  };
}

/// KPI de um widget do dashboard: cor do módulo, tendência, progresso
/// (percentagens; receita face à prevista) e comparação.
class DashboardKpi extends StatelessWidget {
  const DashboardKpi({
    super.key,
    required this.spec,
    required this.metric,
    this.expected,
    this.caption,
  });

  final DashboardWidgetSpec spec;
  final DashboardMetric metric;

  /// Receita prevista (para a barra da receita cobrada), se visível.
  final int? expected;

  /// Texto da comparação ("vs. trimestre anterior"); `null` sem comparação.
  final String? caption;

  double? get _progress {
    if (spec.kind == MetricKind.percent) return metric.value / 100;
    final goal = expected;
    if (spec.id == 'billing.revenue' && goal != null && goal > 0) {
      return metric.value / goal;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final previous = metric.previous;
    return KpiCard(
      label: spec.title,
      icon: spec.icon,
      accent: moduleAccentOf(context, spec.moduleCode),
      value: metric.value,
      format: (v) => formatMetric(spec.kind, v),
      deltaPercent: deltaOf(spec.kind, metric.value, previous),
      higherIsBetter: !lowerIsBetterMetrics.contains(spec.id),
      trend: [for (final v in metric.trend) v.toDouble()],
      progress: _progress,
      caption: caption == null || previous == null
          ? null
          : '$caption: ${formatMetric(spec.kind, previous)}',
    );
  }
}

/// KPIs agrupados por área. O título da área só aparece com mais de uma.
class DashboardKpiSections extends StatelessWidget {
  const DashboardKpiSections({
    super.key,
    required this.widgets,
    required this.metrics,
    this.caption,
    this.noBaseline = false,
  });

  final List<DashboardWidgetSpec> widgets;
  final Map<String, DashboardMetric> metrics;
  final String? caption;

  /// Comparação pedida mas sem período anterior.
  final bool noBaseline;

  @override
  Widget build(BuildContext context) {
    final byArea = <String, List<DashboardWidgetSpec>>{
      for (final area in dashboardAreas)
        area: [
          for (final w in widgets)
            if (dashboardAreaOf(w.moduleCode) == area &&
                metrics.containsKey(w.id))
              w,
        ],
    }..removeWhere((_, list) => list.isEmpty);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (noBaseline)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text(
              'Não existe período anterior para comparar.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        for (final MapEntry(key: area, value: specs) in byArea.entries) ...[
          ContentSection(
            title: byArea.length > 1 ? area : null,
            child: ResponsiveGrid(
              children: [
                for (final w in specs)
                  DashboardKpi(
                    key: ValueKey(w.id),
                    spec: w,
                    metric: metrics[w.id]!,
                    expected: metrics['billing.expected']?.value,
                    caption: caption,
                  ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ],
    );
  }
}
