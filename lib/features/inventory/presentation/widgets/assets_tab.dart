import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/inventory_models.dart';
import '../providers/inventory_providers.dart';
import 'inventory_form_dialog.dart';
import 'maintenance_dialog.dart';
import 'result_feedback.dart';

String assetStatusLabel(AssetStatus s) => switch (s) {
  AssetStatus.active => 'Activo',
  AssetStatus.inMaintenance => 'Em manutenção',
  AssetStatus.writtenOff => 'Abatido',
};

BadgeStatus assetStatusBadge(AssetStatus s) => switch (s) {
  AssetStatus.active => BadgeStatus.success,
  AssetStatus.inMaintenance => BadgeStatus.warning,
  AssetStatus.writtenOff => BadgeStatus.neutral,
};

/// Bens patrimoniais: registo, responsável/localização, manutenção e abate.
class AssetsTab extends ConsumerStatefulWidget {
  const AssetsTab({super.key});

  @override
  ConsumerState<AssetsTab> createState() => _AssetsTabState();
}

class _AssetsTabState extends ConsumerState<AssetsTab> {
  void _refresh() => ref.invalidate(assetListProvider);

  Future<void> _create() async {
    final v = await showInventoryForm(
      context,
      title: 'Novo bem',
      fields: const [
        FormFieldSpec('tag', 'N.º de património'),
        FormFieldSpec('name', 'Designação'),
        FormFieldSpec('category', 'Categoria'),
        FormFieldSpec('location', 'Localização'),
        FormFieldSpec('custodian', 'Responsável'),
        FormFieldSpec('acquiredOn', 'Data de aquisição', kind: FieldKind.date),
        FormFieldSpec(
          'valueCents',
          'Valor de aquisição',
          kind: FieldKind.money,
          required: false,
        ),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(assetRepositoryProvider)
        .create(
          AssetModel(
            id: '',
            tag: v['tag']! as String,
            name: v['name']! as String,
            category: v['category']! as String,
            location: v['location']! as String,
            custodian: v['custodian']! as String,
            acquiredOn: v['acquiredOn']! as DateTime,
            valueCents: v['valueCents']! as int,
          ),
        );
    if (reportResult(ref, result, done: 'Bem registado')) _refresh();
  }

  Future<void> _reassign(AssetModel a) async {
    final v = await showInventoryForm(
      context,
      title: 'Responsável e localização',
      subtitle: '${a.tag} · ${a.name}',
      fields: [
        FormFieldSpec('custodian', 'Responsável', initial: a.custodian),
        FormFieldSpec('location', 'Localização', initial: a.location),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(assetRepositoryProvider)
        .reassign(
          a.id,
          custodian: v['custodian']! as String,
          location: v['location']! as String,
        );
    if (reportResult(ref, result, done: 'Bem actualizado')) _refresh();
  }

  Future<void> _writeOff(AssetModel a) async {
    final v = await showInventoryForm(
      context,
      title: 'Abater bem',
      subtitle: 'O abate de ${a.tag} · ${a.name} não pode ser revertido.',
      submitLabel: 'Abater',
      fields: const [FormFieldSpec('reason', 'Motivo', maxLines: 2)],
    );
    if (v == null || !mounted) return;
    final ok = await showConfirmDialog(
      context: context,
      title: 'Confirmar abate',
      message: 'Abater "${a.name}" (${a.tag})?',
      confirmLabel: 'Abater',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref
        .read(assetRepositoryProvider)
        .writeOff(a.id, reason: v['reason']! as String);
    if (reportResult(ref, result, done: 'Bem abatido')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final assets = ref.watch(assetListProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'inventory.asset.create',
              child: AppButton(
                label: 'Novo bem',
                icon: Icons.add,
                onPressed: _create,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<AssetModel>>(
            value: assets,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.inventory_2_outlined,
              title: 'Sem bens registados',
            ),
            data: (items) => _AssetsTable(
              items: items,
              onReassign: _reassign,
              onWriteOff: _writeOff,
              onMaintenance: (a) => showMaintenanceDialog(context, a),
            ),
          ),
        ),
      ],
    );
  }
}

class _AssetsTable extends ConsumerStatefulWidget {
  const _AssetsTable({
    required this.items,
    required this.onReassign,
    required this.onWriteOff,
    required this.onMaintenance,
  });

  final List<AssetModel> items;
  final void Function(AssetModel) onReassign;
  final void Function(AssetModel) onWriteOff;
  final void Function(AssetModel) onMaintenance;

  @override
  ConsumerState<_AssetsTable> createState() => _AssetsTableState();
}

class _AssetsTableState extends ConsumerState<_AssetsTable> {
  late final TableController<AssetModel> _table = TableController(
    rows: widget.items,
    rowId: (a) => a.id,
    columns: [
      AppColumn(label: 'N.º', text: (a) => a.tag, sortValue: (a) => a.tag),
      AppColumn(
        label: 'Designação',
        text: (a) => a.name,
        sortValue: (a) => a.name,
      ),
      AppColumn(label: 'Categoria', text: (a) => a.category),
      AppColumn(label: 'Localização', text: (a) => a.location),
      AppColumn(label: 'Responsável', text: (a) => a.custodian),
      AppColumn(
        label: 'Valor',
        text: (a) => PtAoFormatters.currency(a.valueCents),
        sortValue: (a) => a.valueCents,
        numeric: true,
      ),
      AppColumn(
        label: 'Estado',
        text: (a) => assetStatusLabel(a.status),
        sortValue: (a) => a.status.index,
        cell: (a) => StatusBadge(
          label: assetStatusLabel(a.status),
          status: assetStatusBadge(a.status),
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(_AssetsTable old) {
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
    return AppDataTable<AssetModel>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem bens',
      rowActions: [
        if (can('inventory.asset.update'))
          RowAction(
            label: 'Responsável / localização',
            icon: Icons.swap_horiz,
            onTap: (a) {
              if (a.status != AssetStatus.writtenOff) widget.onReassign(a);
            },
          ),
        RowAction(
          label: 'Manutenção',
          icon: Icons.build_outlined,
          onTap: widget.onMaintenance,
        ),
        if (can('inventory.asset.writeoff'))
          RowAction(
            label: 'Abater',
            icon: Icons.delete_outline,
            onTap: (a) {
              if (a.status != AssetStatus.writtenOff) widget.onWriteOff(a);
            },
          ),
      ],
    );
  }
}
