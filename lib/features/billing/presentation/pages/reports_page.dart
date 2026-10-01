import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/report_rows.dart';
import '../../domain/debt.dart';
import '../../domain/invoicing.dart';
import '../../domain/reports.dart';
import '../providers/report_providers.dart';

/// Rótulo de um mês `yyyy-MM` (ex.: `Setembro 2024`).
String periodLabel(String key) {
  final parts = key.split('-');
  final month = int.tryParse(parts.length == 2 ? parts[1] : '');
  if (month == null || month < 1 || month > 12) return key;
  return '${monthNamesPt[month - 1]} ${parts[0]}';
}

/// Rótulo da linha de receita conforme o agrupamento.
String revenueKeyLabel(RevenueGroup group, String key) => switch (group) {
  RevenueGroup.period => periodLabel(key),
  RevenueGroup.feeType =>
    feeTypeLabelsPt[FeeType.values.asNameMap()[key]] ?? key,
  RevenueGroup.campus =>
    key.isEmpty
        ? 'Sem campus'
        : key == MockRef.campusId
        ? 'Campus principal'
        : key,
};

const _groupLabels = {
  RevenueGroup.period: 'Por período',
  RevenueGroup.feeType: 'Por rubrica',
  RevenueGroup.campus: 'Por campus',
};

const _windows = <int?, String>{
  null: 'Todo o período',
  3: 'Últimos 3 meses',
  6: 'Últimos 6 meses',
  12: 'Últimos 12 meses',
};

enum _View { revenue, forecast }

/// Relatórios financeiros base: receita por período/rubrica/campus e previsto
/// vs. recebido, com exportação (CSV/Excel/PDF).
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage> {
  _View _view = _View.revenue;

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(reportFilterProvider);
    final notifier = ref.read(reportFilterProvider.notifier);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Relatórios financeiros',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SegmentedButton<_View>(
                    key: const Key('report_view'),
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: _View.revenue,
                        label: Text('Receita'),
                      ),
                      ButtonSegment(
                        value: _View.forecast,
                        label: Text('Previsto vs. recebido'),
                      ),
                    ],
                    selected: {_view},
                    onSelectionChanged: (s) => setState(() => _view = s.first),
                  ),
                  if (_view == _View.revenue)
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<RevenueGroup>(
                        key: const Key('report_group'),
                        initialValue: filter.group,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Agrupar',
                          isDense: true,
                        ),
                        items: [
                          for (final g in RevenueGroup.values)
                            DropdownMenuItem(
                              value: g,
                              child: Text(_groupLabels[g]!),
                            ),
                        ],
                        onChanged: (g) {
                          if (g != null) notifier.setGroup(g);
                        },
                      ),
                    ),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<int?>(
                      key: const Key('report_window'),
                      initialValue: filter.months,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Período',
                        isDense: true,
                      ),
                      items: [
                        for (final e in _windows.entries)
                          DropdownMenuItem<int?>(
                            value: e.key,
                            child: Text(e.value),
                          ),
                      ],
                      onChanged: notifier.setMonths,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: _view == _View.revenue
                    ? const _RevenueView()
                    : const _ForecastView(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RevenueView extends ConsumerWidget {
  const _RevenueView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final group = ref.watch(reportFilterProvider.select((f) => f.group));
    return AsyncValueView<List<RevenueRow>>(
      value: ref.watch(revenueReportProvider),
      onRetry: () => ref.invalidate(revenueReportProvider),
      isEmpty: (d) => d.isEmpty,
      empty: const EmptyState(
        icon: Icons.bar_chart_outlined,
        title: 'Sem receita no período',
      ),
      data: (rows) =>
          _RevenueTable(key: ValueKey(group), rows: rows, group: group),
    );
  }
}

class _RevenueTable extends ConsumerStatefulWidget {
  const _RevenueTable({super.key, required this.rows, required this.group});

  final List<RevenueRow> rows;
  final RevenueGroup group;

  @override
  ConsumerState<_RevenueTable> createState() => _RevenueTableState();
}

class _RevenueTableState extends ConsumerState<_RevenueTable> {
  late final List<AppColumn<RevenueRow>> _columns = [
    AppColumn(
      label: switch (widget.group) {
        RevenueGroup.period => 'Período',
        RevenueGroup.feeType => 'Rubrica',
        RevenueGroup.campus => 'Campus',
      },
      text: (r) => revenueKeyLabel(widget.group, r.key),
      sortValue: (r) => r.key,
    ),
    AppColumn(
      label: 'Recebido',
      text: (r) => PtAoFormatters.currency(r.receivedMinor),
      sortValue: (r) => r.receivedMinor,
      numeric: true,
    ),
    AppColumn(
      label: 'Alocações',
      text: (r) => '${r.allocationCount}',
      sortValue: (r) => r.allocationCount,
      numeric: true,
    ),
  ];

  late final TableController<RevenueRow> _table = TableController(
    rows: widget.rows,
    rowId: (r) => r.key,
    columns: _columns,
  );

  @override
  void didUpdateWidget(_RevenueTable old) {
    super.didUpdateWidget(old);
    if (old.rows != widget.rows) _table.setRows(widget.rows);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.rows.fold<int>(0, (s, r) => s + r.receivedMinor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppDataTable<RevenueRow>(
            controller: _table,
            selectable: false,
            emptyText: 'Sem receita no período',
            onExport: exportHookFor<RevenueRow>(
              context,
              ref,
              permission: reportExportPermission,
              title: 'Receita ${_groupLabels[widget.group]!.toLowerCase()}',
              entity: 'billing-revenue-${widget.group.name}',
              columns: [
                for (final c in _columns)
                  ExportColumn<RevenueRow>(
                    key: c.label,
                    label: c.label,
                    text: c.text,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            'Total recebido: ${PtAoFormatters.currency(total)}',
            key: const Key('revenue_total'),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}

class _ForecastView extends ConsumerWidget {
  const _ForecastView();

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueView<List<ForecastRow>>(
        value: ref.watch(forecastReportProvider),
        onRetry: () => ref.invalidate(forecastReportProvider),
        isEmpty: (d) => d.isEmpty,
        empty: const EmptyState(
          icon: Icons.bar_chart_outlined,
          title: 'Sem cobranças no período',
        ),
        data: (rows) => _ForecastTable(rows: rows),
      );
}

class _ForecastTable extends ConsumerStatefulWidget {
  const _ForecastTable({required this.rows});

  final List<ForecastRow> rows;

  @override
  ConsumerState<_ForecastTable> createState() => _ForecastTableState();
}

class _ForecastTableState extends ConsumerState<_ForecastTable> {
  late final List<AppColumn<ForecastRow>> _columns = [
    AppColumn(
      label: 'Mês de vencimento',
      text: (r) => periodLabel(r.period),
      sortValue: (r) => r.period,
    ),
    AppColumn(
      label: 'Previsto',
      text: (r) => PtAoFormatters.currency(r.expectedMinor),
      sortValue: (r) => r.expectedMinor,
      numeric: true,
    ),
    AppColumn(
      label: 'Recebido',
      text: (r) => PtAoFormatters.currency(r.receivedMinor),
      sortValue: (r) => r.receivedMinor,
      numeric: true,
    ),
    AppColumn(
      label: 'Em falta',
      text: (r) => PtAoFormatters.currency(r.expectedMinor - r.receivedMinor),
      sortValue: (r) => r.expectedMinor - r.receivedMinor,
      numeric: true,
    ),
    AppColumn(
      label: 'Cobrança',
      text: (r) =>
          '${collectionRatePercent(r.expectedMinor, r.receivedMinor)}%',
      sortValue: (r) => collectionRatePercent(r.expectedMinor, r.receivedMinor),
      numeric: true,
    ),
  ];

  late final TableController<ForecastRow> _table = TableController(
    rows: widget.rows,
    rowId: (r) => r.period,
    columns: _columns,
  );

  @override
  void didUpdateWidget(_ForecastTable old) {
    super.didUpdateWidget(old);
    if (old.rows != widget.rows) _table.setRows(widget.rows);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final expected = widget.rows.fold<int>(0, (s, r) => s + r.expectedMinor);
    final received = widget.rows.fold<int>(0, (s, r) => s + r.receivedMinor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppDataTable<ForecastRow>(
            controller: _table,
            selectable: false,
            emptyText: 'Sem cobranças no período',
            onExport: exportHookFor<ForecastRow>(
              context,
              ref,
              permission: reportExportPermission,
              title: 'Previsto vs. recebido',
              entity: 'billing-forecast',
              columns: [
                for (final c in _columns)
                  ExportColumn<ForecastRow>(
                    key: c.label,
                    label: c.label,
                    text: c.text,
                  ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Text(
            'Previsto ${PtAoFormatters.currency(expected)} · '
            'Recebido ${PtAoFormatters.currency(received)} '
            '(${collectionRatePercent(expected, received)}%)',
            key: const Key('forecast_total'),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
