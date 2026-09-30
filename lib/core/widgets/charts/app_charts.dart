import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

List<FlSpot> _spots(List<double> values) => [
  for (final (i, v) in values.indexed) FlSpot(i.toDouble(), v),
];

/// Gráfico de linha. [labels] (opcional) rotula o eixo X; [semanticLabel] descreve-o.
class AppLineChart extends StatelessWidget {
  const AppLineChart({
    super.key,
    required this.values,
    required this.semanticLabel,
    this.labels,
    this.height = 200,
  });

  final List<double> values;
  final String semanticLabel;
  final List<String>? labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final animate = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        height: height,
        child: LineChart(
          duration: animate ? AppMotion.page : Duration.zero,
          curve: AppMotion.curve,
          LineChartData(
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: scheme.outlineVariant, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: _titles(context, labels),
            lineBarsData: [
              LineChartBarData(
                spots: _spots(values),
                isCurved: true,
                color: scheme.primary,
                barWidth: 3,
                dotData: const FlDotData(show: false),
                belowBarData: BarAreaData(
                  show: true,
                  color: scheme.primary.withValues(alpha: 0.12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

FlTitlesData _titles(BuildContext context, List<String>? labels) {
  final style = Theme.of(context).textTheme.labelSmall;
  return FlTitlesData(
    topTitles: const AxisTitles(),
    rightTitles: const AxisTitles(),
    bottomTitles: AxisTitles(
      sideTitles: SideTitles(
        showTitles: labels != null,
        interval: 1,
        getTitlesWidget: (v, meta) {
          final i = v.toInt();
          if (labels == null || i < 0 || i >= labels.length) {
            return const SizedBox.shrink();
          }
          return SideTitleWidget(
            meta: meta,
            child: Text(labels[i], style: style),
          );
        },
      ),
    ),
  );
}

/// Gráfico de barras.
class AppBarChart extends StatelessWidget {
  const AppBarChart({
    super.key,
    required this.values,
    required this.semanticLabel,
    this.labels,
    this.height = 200,
  });

  final List<double> values;
  final String semanticLabel;
  final List<String>? labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final animate = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return Semantics(
      label: semanticLabel,
      child: SizedBox(
        height: height,
        child: BarChart(
          duration: animate ? AppMotion.page : Duration.zero,
          curve: AppMotion.curve,
          BarChartData(
            gridData: FlGridData(
              drawVerticalLine: false,
              getDrawingHorizontalLine: (_) =>
                  FlLine(color: scheme.outlineVariant, strokeWidth: 1),
            ),
            borderData: FlBorderData(show: false),
            titlesData: _titles(context, labels),
            barGroups: [
              for (final (i, v) in values.indexed)
                BarChartGroupData(
                  x: i,
                  barRods: [
                    BarChartRodData(
                      toY: v,
                      color: scheme.primary,
                      width: 16,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(AppRadius.input),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fatia de um [AppDonutChart].
class DonutSlice {
  const DonutSlice({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final double value;
  final Color color;
}

/// Donut com legenda por baixo (a cor nunca é o único indicador).
class AppDonutChart extends StatelessWidget {
  const AppDonutChart({
    super.key,
    required this.slices,
    required this.semanticLabel,
    this.size = 160,
  });

  final List<DonutSlice> slices;
  final String semanticLabel;
  final double size;

  @override
  Widget build(BuildContext context) {
    final animate = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    return Semantics(
      label: semanticLabel,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox.square(
            dimension: size,
            child: PieChart(
              duration: animate ? AppMotion.page : Duration.zero,
              curve: AppMotion.curve,
              PieChartData(
                centerSpaceRadius: size / 4,
                sectionsSpace: 2,
                sections: [
                  for (final s in slices)
                    PieChartSectionData(
                      value: s.value,
                      color: s.color,
                      radius: size / 5,
                      showTitle: false,
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.xs,
            children: [
              for (final s in slices)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.circle, size: 10, color: s.color),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      s.label,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Mini-gráfico de tendência para KPIs e tabelas (sem eixos nem interacção).
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.width = 96,
    this.height = 32,
    this.color,
  });

  final List<double> values;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final line = color ?? Theme.of(context).colorScheme.primary;
    return ExcludeSemantics(
      child: SizedBox(
        width: width,
        height: height,
        child: LineChart(
          duration: Duration.zero,
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: const FlTitlesData(show: false),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: false),
            lineBarsData: [
              LineChartBarData(
                spots: _spots(values),
                isCurved: true,
                color: line,
                barWidth: 2,
                dotData: const FlDotData(show: false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
