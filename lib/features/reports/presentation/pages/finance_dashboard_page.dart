import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/cards/app_cards.dart';
import '../../../../core/widgets/charts/app_charts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../data/models/finance_overview.dart';
import '../providers/finance_overview_providers.dart';
import '../widgets/dashboard_filters_bar.dart';

const financeDashboardExportPermission = 'reports.dashboard.export';

/// Série do gráfico mensal.
enum FinanceChartMetric {
  expected('Previsto'),
  collected('Recebido'),
  debt('Dívida');

  const FinanceChartMetric(this.label);
  final String label;

  int of(FinanceMonthRow r) => switch (this) {
    expected => r.expected,
    collected => r.collected,
    debt => r.debt,
  };
}

/// Variação em % face ao período de comparação (`null` sem base).
double? _pctDelta(int value, int? previous) => previous == null || previous == 0
    ? null
    : (value - previous) * 100 / previous;

/// Variação em pontos percentuais.
double? _ppDelta(int value, int? previous) =>
    previous == null ? null : (value - previous).toDouble();

String _money(int v) => PtAoFormatters.currency(v);

/// Dashboard Financeiro e Contabilidade: receita, dívida, inadimplência e
/// previsto vs. recebido por mês; contas a receber/pagar e resultado quando o
/// módulo de contabilidade está licenciado.
class FinanceDashboardPage extends ConsumerStatefulWidget {
  const FinanceDashboardPage({super.key});

  @override
  ConsumerState<FinanceDashboardPage> createState() =>
      _FinanceDashboardPageState();
}

class _FinanceDashboardPageState extends ConsumerState<FinanceDashboardPage> {
  FinanceChartMetric _metric = FinanceChartMetric.expected;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(financeOverviewProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Dashboard · Financeiro e Contabilidade',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const DashboardFiltersBar(),
            const SizedBox(height: AppSpacing.lg),
            AsyncValueView<FinanceOverview?>(
              value: overview,
              loading: const SkeletonCard(),
              onRetry: () => ref.invalidate(financeOverviewProvider),
              data: (data) => data == null
                  ? const EmptyState(
                      icon: Icons.event_outlined,
                      title: 'Sem ano lectivo',
                      message: 'Crie um ano lectivo nas definições.',
                    )
                  : _Content(
                      data: data,
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
    required this.metric,
    required this.onMetric,
  });

  final FinanceOverview data;
  final FinanceChartMetric metric;
  final ValueChanged<FinanceChartMetric> onMetric;

  @override
  Widget build(BuildContext context) {
    final t = data.totals;
    final p = data.previous;
    final kpis = <Widget>[
      KpiCard(
        key: const ValueKey('kpi_collected'),
        label: 'Receita cobrada',
        icon: Icons.payments_outlined,
        value: t.collected,
        format: _money,
        deltaPercent: _pctDelta(t.collected, p?.collected),
      ),
      KpiCard(
        key: const ValueKey('kpi_expected'),
        label: 'Receita prevista',
        icon: Icons.request_quote_outlined,
        value: t.expected,
        format: _money,
        deltaPercent: _pctDelta(t.expected, p?.expected),
      ),
      KpiCard(
        key: const ValueKey('kpi_debt'),
        label: 'Dívida em aberto',
        icon: Icons.money_off_outlined,
        value: t.debt,
        format: _money,
        deltaPercent: _pctDelta(t.debt, p?.debt),
      ),
      KpiCard(
        key: const ValueKey('kpi_default_rate'),
        label: 'Inadimplência',
        icon: Icons.trending_down_outlined,
        value: t.defaultRate,
        format: (v) => '$v%',
        deltaPercent: _ppDelta(t.defaultRate, p?.defaultRate),
      ),
      if (t.receivables case final v?)
        KpiCard(
          key: const ValueKey('kpi_receivables'),
          label: 'Contas a receber',
          icon: Icons.south_west_outlined,
          value: v,
          format: _money,
          deltaPercent: _pctDelta(v, p?.receivables),
        ),
      if (t.payables case final v?)
        KpiCard(
          key: const ValueKey('kpi_payables'),
          label: 'Contas a pagar',
          icon: Icons.north_east_outlined,
          value: v,
          format: _money,
          deltaPercent: _pctDelta(v, p?.payables),
        ),
      if (t.result case final v?)
        KpiCard(
          key: const ValueKey('kpi_result'),
          label: 'Resultado do período',
          icon: Icons.account_balance_outlined,
          value: v,
          format: _money,
          deltaPercent: _pctDelta(v, p?.result),
        ),
    ];
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
            Text('Por mês', style: text.titleMedium),
            SegmentedButton<FinanceChartMetric>(
              key: const ValueKey('chart_metric'),
              showSelectedIcon: false,
              segments: [
                for (final m in FinanceChartMetric.values)
                  ButtonSegment(value: m, label: Text(m.label)),
              ],
              selected: {metric},
              onSelectionChanged: (s) => onMetric(s.first),
            ),
            ExportButton(
              key: const ValueKey('finance_export'),
              permission: financeDashboardExportPermission,
              dataset: () => _dataset(data),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppBarChart(
          key: ValueKey('chart_${metric.name}'),
          values: [for (final r in data.rows) metric.of(r) / 100],
          labels: [for (final r in data.rows) r.label],
          semanticLabel: '${metric.label} por mês (Kz)',
        ),
        const SizedBox(height: AppSpacing.lg),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            key: const ValueKey('finance_table'),
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

const _headers = ['Mês', 'Previsto', 'Recebido', 'Dívida', 'Inadimplência'];

List<String> _cells(FinanceMonthRow r) => [
  r.label,
  _money(r.expected),
  _money(r.collected),
  _money(r.debt),
  '${r.expected == 0 ? 0 : (r.debt * 100 / r.expected).round()}%',
];

ExportDataset _dataset(FinanceOverview data) => ExportDataset(
  title: 'Dashboard Financeiro e Contabilidade',
  entity: 'finance_dashboard',
  permission: financeDashboardExportPermission,
  columns: [
    for (final (i, h) in _headers.indexed)
      ExportDatasetColumn(key: 'c$i', label: h),
  ],
  rows: [for (final r in data.rows) _cells(r)],
);
