import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/cards/app_cards.dart';
import '../../../../core/widgets/charts/app_charts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../data/models/academic_overview.dart';
import '../providers/academic_overview_providers.dart';
import '../widgets/dashboard_filters_bar.dart';

const academicDashboardExportPermission = 'reports.dashboard.export';

/// Indicador do gráfico por classe.
enum AcademicChartMetric {
  occupancy('Ocupação'),
  approval('Aprovação'),
  attendance('Assiduidade');

  const AcademicChartMetric(this.label);
  final String label;

  int? of(AcademicGradeRow r) => switch (this) {
    occupancy => r.occupancy,
    approval => r.approvalRate,
    attendance => r.attendanceRate,
  };
}

/// Pontos percentuais de variação face ao período de comparação.
double? _delta(int? value, int? previous) =>
    value == null || previous == null ? null : (value - previous).toDouble();

String _pct(int? value) => value == null ? '—' : '$value%';

/// Dashboard da Direcção e Académico: matriculados/activos, aprovação,
/// assiduidade e ocupação, com desdobramento por classe.
class AcademicDashboardPage extends ConsumerStatefulWidget {
  const AcademicDashboardPage({super.key});

  @override
  ConsumerState<AcademicDashboardPage> createState() =>
      _AcademicDashboardPageState();
}

class _AcademicDashboardPageState extends ConsumerState<AcademicDashboardPage> {
  AcademicChartMetric _metric = AcademicChartMetric.occupancy;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(academicOverviewProvider);
    final comparing = ref.watch(
      academicOverviewQueryProvider.select((q) => q?.compareYearId != null),
    );
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Dashboard · Direcção e Académico',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const DashboardFiltersBar(),
            const SizedBox(height: AppSpacing.lg),
            AsyncValueView<AcademicOverview?>(
              value: overview,
              loading: const SkeletonCard(),
              onRetry: () => ref.invalidate(academicOverviewProvider),
              data: (data) => data == null
                  ? const EmptyState(
                      icon: Icons.event_outlined,
                      title: 'Sem ano lectivo',
                      message: 'Crie um ano lectivo nas definições.',
                    )
                  : _Content(
                      data: data,
                      comparing: comparing,
                      metric: _metric,
                      onMetric: (m) => setState(() => _metric = m),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.data,
    required this.comparing,
    required this.metric,
    required this.onMetric,
  });

  final AcademicOverview data;
  final bool comparing;
  final AcademicChartMetric metric;
  final ValueChanged<AcademicChartMetric> onMetric;

  @override
  Widget build(BuildContext context) {
    final t = data.totals;
    final p = comparing ? data.previous : null;
    double? count(int v, int? prev) =>
        prev == null || prev == 0 ? null : (v - prev) * 100 / prev;
    final kpis = <Widget>[
      KpiCard(
        key: const ValueKey('kpi_enrolled'),
        label: 'Alunos matriculados',
        icon: Icons.school_outlined,
        value: t.enrolled,
        format: (v) => PtAoFormatters.number(v),
        deltaPercent: count(t.enrolled, p?.enrolled),
      ),
      KpiCard(
        key: const ValueKey('kpi_active'),
        label: 'Alunos activos',
        icon: Icons.how_to_reg_outlined,
        value: t.active,
        format: (v) => PtAoFormatters.number(v),
        deltaPercent: count(t.active, p?.active),
      ),
      if (t.approvalRate case final v?)
        KpiCard(
          key: const ValueKey('kpi_approval'),
          label: 'Taxa de aprovação',
          icon: Icons.task_alt_outlined,
          value: v,
          format: (v) => '$v%',
          deltaPercent: _delta(v, p?.approvalRate),
        ),
      if (t.attendanceRate case final v?)
        KpiCard(
          key: const ValueKey('kpi_attendance'),
          label: 'Assiduidade',
          icon: Icons.fact_check_outlined,
          value: v,
          format: (v) => '$v%',
          deltaPercent: _delta(v, p?.attendanceRate),
        ),
      KpiCard(
        key: const ValueKey('kpi_occupancy'),
        label: 'Ocupação das turmas',
        icon: Icons.groups_outlined,
        value: t.occupancy,
        format: (v) => '$v%',
        deltaPercent: _delta(t.occupancy, p?.occupancy),
      ),
    ];
    final metrics = [
      AcademicChartMetric.occupancy,
      if (t.approvalRate != null) AcademicChartMetric.approval,
      if (t.attendanceRate != null) AcademicChartMetric.attendance,
    ];
    final current = metrics.contains(metric) ? metric : metrics.first;
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [for (final k in kpis) SizedBox(width: 260, child: k)],
        ),
        const SizedBox(height: AppSpacing.xl),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            Text('Por classe', style: text.titleMedium),
            SegmentedButton<AcademicChartMetric>(
              key: const ValueKey('chart_metric'),
              showSelectedIcon: false,
              segments: [
                for (final m in metrics)
                  ButtonSegment(value: m, label: Text(m.label)),
              ],
              selected: {current},
              onSelectionChanged: (s) => onMetric(s.first),
            ),
            ExportButton(
              key: const ValueKey('academic_export'),
              permission: academicDashboardExportPermission,
              dataset: () => _dataset(data),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppBarChart(
          key: ValueKey('chart_${current.name}'),
          values: [for (final r in data.rows) (current.of(r) ?? 0).toDouble()],
          labels: [for (final r in data.rows) r.label],
          semanticLabel: '${current.label} por classe',
        ),
        const SizedBox(height: AppSpacing.lg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            key: const ValueKey('academic_table'),
            columns: [for (final h in _headers) DataColumn(label: Text(h))],
            rows: [
              for (final r in data.rows)
                DataRow(cells: [for (final c in _cells(r)) DataCell(Text(c))]),
            ],
          ),
        ),
      ],
    );
  }
}

const _headers = [
  'Classe',
  'Matriculados',
  'Activos',
  'Lotação',
  'Ocupação',
  'Aprovação',
  'Assiduidade',
];

List<String> _cells(AcademicGradeRow r) => [
  r.label,
  '${r.enrolled}',
  '${r.active}',
  '${r.capacity}',
  _pct(r.occupancy),
  _pct(r.approvalRate),
  _pct(r.attendanceRate),
];

ExportDataset _dataset(AcademicOverview data) => ExportDataset(
  title: 'Dashboard Direcção e Académico',
  entity: 'academic_dashboard',
  permission: academicDashboardExportPermission,
  columns: [
    for (final (i, h) in _headers.indexed)
      ExportDatasetColumn(key: 'c$i', label: h),
  ],
  rows: [for (final r in data.rows) _cells(r)],
);
