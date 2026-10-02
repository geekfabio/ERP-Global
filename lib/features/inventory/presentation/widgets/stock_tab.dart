import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/inventory_models.dart';
import '../providers/inventory_providers.dart';
import 'inventory_form_dialog.dart';
import 'result_feedback.dart';

/// Consumíveis: quantidades, movimentos e alerta de stock mínimo.
class StockTab extends ConsumerStatefulWidget {
  const StockTab({super.key});

  @override
  ConsumerState<StockTab> createState() => _StockTabState();
}

class _StockTabState extends ConsumerState<StockTab> {
  void _refresh() => ref.invalidate(stockListProvider);

  Future<void> _create() async {
    final v = await showInventoryForm(
      context,
      title: 'Novo consumível',
      fields: const [
        FormFieldSpec('sku', 'Código'),
        FormFieldSpec('name', 'Designação'),
        FormFieldSpec('unit', 'Unidade (un, cx, resma…)'),
        FormFieldSpec('location', 'Localização'),
        FormFieldSpec(
          'quantity',
          'Quantidade inicial',
          kind: FieldKind.integer,
        ),
        FormFieldSpec('minQuantity', 'Stock mínimo', kind: FieldKind.integer),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(stockRepositoryProvider)
        .create(
          StockItemModel(
            id: '',
            sku: v['sku']! as String,
            name: v['name']! as String,
            unit: v['unit']! as String,
            location: v['location']! as String,
            quantity: v['quantity']! as int,
            minQuantity: v['minQuantity']! as int,
          ),
        );
    if (reportResult(ref, result, done: 'Consumível registado')) _refresh();
  }

  Future<void> _move(StockItemModel item) async {
    final v = await showInventoryForm(
      context,
      title: 'Movimento de stock',
      subtitle:
          '${item.name} · ${item.quantity} ${item.unit} em stock. '
          'Use valor negativo para saídas.',
      fields: const [
        FormFieldSpec(
          'delta',
          'Quantidade (+entrada / −saída)',
          kind: FieldKind.integer,
        ),
        FormFieldSpec('reason', 'Motivo'),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(stockRepositoryProvider)
        .move(
          item.id,
          delta: v['delta']! as int,
          reason: v['reason']! as String,
        );
    if (reportResult(ref, result, done: 'Movimento registado')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final stock = ref.watch(stockListProvider);
    final low = stock.value?.where((i) => i.lowStock).toList() ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: low.isEmpty
                    ? const SizedBox.shrink()
                    : _LowStockBanner(items: low),
              ),
              const SizedBox(width: AppSpacing.md),
              Can(
                permission: 'inventory.stock.create',
                child: AppButton(
                  label: 'Novo consumível',
                  icon: Icons.add,
                  onPressed: _create,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AsyncValueView<List<StockItemModel>>(
            value: stock,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.inventory_outlined,
              title: 'Sem consumíveis',
            ),
            data: (items) => _StockTable(items: items, onMove: _move),
          ),
        ),
      ],
    );
  }
}

class _LowStockBanner extends StatelessWidget {
  const _LowStockBanner({required this.items});

  final List<StockItemModel> items;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return DecoratedBox(
      key: const Key('low_stock_banner'),
      decoration: BoxDecoration(
        color: colors.warning,
        borderRadius: BorderRadius.circular(AppRadius.input),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: colors.onWarning),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                items.length == 1
                    ? '1 item abaixo do stock mínimo: ${items.first.name}'
                    : '${items.length} itens abaixo do stock mínimo',
                style: TextStyle(color: colors.onWarning),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StockTable extends ConsumerStatefulWidget {
  const _StockTable({required this.items, required this.onMove});

  final List<StockItemModel> items;
  final void Function(StockItemModel) onMove;

  @override
  ConsumerState<_StockTable> createState() => _StockTableState();
}

class _StockTableState extends ConsumerState<_StockTable> {
  late final TableController<StockItemModel> _table = TableController(
    rows: widget.items,
    rowId: (i) => i.id,
    columns: [
      AppColumn(label: 'Código', text: (i) => i.sku, sortValue: (i) => i.sku),
      AppColumn(
        label: 'Designação',
        text: (i) => i.name,
        sortValue: (i) => i.name,
      ),
      AppColumn(
        label: 'Quantidade',
        text: (i) => '${i.quantity} ${i.unit}',
        sortValue: (i) => i.quantity,
        numeric: true,
      ),
      AppColumn(
        label: 'Mínimo',
        text: (i) => '${i.minQuantity} ${i.unit}',
        sortValue: (i) => i.minQuantity,
        numeric: true,
      ),
      AppColumn(label: 'Localização', text: (i) => i.location),
      AppColumn(
        label: 'Estado',
        text: (i) => i.lowStock ? 'Stock baixo' : 'Normal',
        sortValue: (i) => i.lowStock ? 0 : 1,
        cell: (i) => StatusBadge(
          label: i.lowStock ? 'Stock baixo' : 'Normal',
          status: i.lowStock ? BadgeStatus.warning : BadgeStatus.success,
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(_StockTable old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<StockItemModel>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem consumíveis',
      rowActions: [
        if (can('inventory.stock.move'))
          RowAction(
            label: 'Entrada / saída',
            icon: Icons.sync_alt,
            onTap: widget.onMove,
          ),
      ],
    );
  }
}
