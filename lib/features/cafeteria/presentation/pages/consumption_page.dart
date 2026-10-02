import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/consumption_rows.dart';
import '../providers/consumption_providers.dart';

const _groupLabels = {
  ConsumptionGroup.classroom: 'Por turma',
  ConsumptionGroup.day: 'Por dia',
  ConsumptionGroup.meal: 'Por refeição',
};

const _windows = <int?, String>{
  null: 'Todo o período',
  1: 'Mês corrente',
  3: 'Últimos 3 meses',
  12: 'Últimos 12 meses',
};

/// Rótulo da linha conforme o agrupamento (`yyyy-MM-dd` → `dd/MM/yyyy`).
String consumptionKeyLabel(ConsumptionGroup group, ConsumptionRow row) =>
    switch (group) {
      ConsumptionGroup.classroom => row.key.isEmpty ? 'Sem turma' : row.key,
      ConsumptionGroup.day => _dayLabel(row.key),
      ConsumptionGroup.meal =>
        row.label ?? (row.key.isEmpty ? 'Sem tipo' : row.key),
    };

String _dayLabel(String key) {
  final p = key.split('-');
  return p.length == 3 ? '${p[2]}/${p[1]}/${p[0]}' : key;
}

/// Relatórios de consumo do refeitório: consumo por turma/dia/refeição e
/// saldo total pré-pago, com exportação (CSV/Excel/PDF).
class ConsumptionPage extends ConsumerWidget {
  const ConsumptionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Can(
    permission: consumptionReadPermission,
    fallback: const EmptyState(
      icon: Icons.lock_outline,
      title: 'Sem permissão para os relatórios',
    ),
    child: const _ConsumptionBody(),
  );
}

class _ConsumptionBody extends ConsumerWidget {
  const _ConsumptionBody();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(consumptionFilterProvider);
    final notifier = ref.read(consumptionFilterProvider.notifier);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _BalanceCard(),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<ConsumptionGroup>(
                  key: const Key('consumption_group'),
                  initialValue: filter.group,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Agrupar',
                    isDense: true,
                  ),
                  items: [
                    for (final g in ConsumptionGroup.values)
                      DropdownMenuItem(value: g, child: Text(_groupLabels[g]!)),
                  ],
                  onChanged: (g) {
                    if (g != null) notifier.setGroup(g);
                  },
                ),
              ),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<int?>(
                  key: const Key('consumption_window'),
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
            child: AsyncValueView<List<ConsumptionRow>>(
              value: ref.watch(consumptionReportProvider),
              onRetry: () => ref.invalidate(consumptionReportProvider),
              isEmpty: (d) => d.isEmpty,
              empty: const EmptyState(
                icon: Icons.bar_chart_outlined,
                title: 'Sem consumo no período',
              ),
              data: (rows) => _ConsumptionTable(
                key: ValueKey(filter.group),
                rows: rows,
                group: filter.group,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BalanceCard extends ConsumerWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balance = ref.watch(prepaidBalanceProvider);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: balance.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Row(
            children: [
              const Expanded(child: Text('Não foi possível obter o saldo')),
              IconButton(
                tooltip: 'Repetir',
                icon: const Icon(Icons.refresh),
                onPressed: () => ref.invalidate(prepaidBalanceProvider),
              ),
            ],
          ),
          data: (b) => Wrap(
            spacing: AppSpacing.lg,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('Saldo total pré-pago', style: theme.textTheme.labelLarge),
              Text(
                PtAoFormatters.currency(b.totalBalanceMinor),
                key: const Key('prepaid_total'),
                style: theme.textTheme.titleLarge,
              ),
              Text(
                '${b.walletCount} carteiras · ${b.blockedCount} bloqueadas',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ConsumptionTable extends ConsumerStatefulWidget {
  const _ConsumptionTable({super.key, required this.rows, required this.group});

  final List<ConsumptionRow> rows;
  final ConsumptionGroup group;

  @override
  ConsumerState<_ConsumptionTable> createState() => _ConsumptionTableState();
}

class _ConsumptionTableState extends ConsumerState<_ConsumptionTable> {
  late final List<AppColumn<ConsumptionRow>> _columns = [
    AppColumn(
      label: switch (widget.group) {
        ConsumptionGroup.classroom => 'Turma',
        ConsumptionGroup.day => 'Dia',
        ConsumptionGroup.meal => 'Refeição',
      },
      text: (r) => consumptionKeyLabel(widget.group, r),
      sortValue: (r) => r.key,
    ),
    AppColumn(
      label: 'Consumos',
      text: (r) => '${r.purchaseCount}',
      sortValue: (r) => r.purchaseCount,
      numeric: true,
    ),
    AppColumn(
      label: 'Total',
      text: (r) => PtAoFormatters.currency(r.totalMinor),
      sortValue: (r) => r.totalMinor,
      numeric: true,
    ),
  ];

  late final TableController<ConsumptionRow> _table = TableController(
    rows: widget.rows,
    rowId: (r) => r.key,
    columns: _columns,
  );

  @override
  void didUpdateWidget(_ConsumptionTable old) {
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
    final total = widget.rows.fold<int>(0, (s, r) => s + r.totalMinor);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: AppDataTable<ConsumptionRow>(
            controller: _table,
            selectable: false,
            emptyText: 'Sem consumo no período',
            onExport: exportHookFor<ConsumptionRow>(
              context,
              ref,
              permission: consumptionExportPermission,
              title: 'Consumo ${_groupLabels[widget.group]!.toLowerCase()}',
              entity: 'cafeteria-consumption-${widget.group.name}',
              columns: [
                for (final c in _columns)
                  ExportColumn<ConsumptionRow>(
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
            'Total consumido: ${PtAoFormatters.currency(total)}',
            key: const Key('consumption_total'),
            textAlign: TextAlign.end,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ],
    );
  }
}
