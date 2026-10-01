import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';

/// Separador de listagem: botão de criação (com permissão), estados
/// carregamento/erro/vazio e tabela. Partilhado por zonas, regras e dispositivos.
class AccessListTab<T> extends ConsumerWidget {
  const AccessListTab({
    super.key,
    required this.value,
    required this.onRetry,
    required this.createLabel,
    required this.createPermission,
    required this.onCreate,
    required this.emptyIcon,
    required this.emptyTitle,
    required this.columns,
    required this.rowId,
    required this.rowActions,
  });

  final AsyncValue<List<T>> value;
  final VoidCallback onRetry;
  final String createLabel;
  final String createPermission;
  final VoidCallback onCreate;
  final IconData emptyIcon;
  final String emptyTitle;
  final List<AppColumn<T>> columns;
  final String Function(T) rowId;
  final List<RowAction<T>> rowActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Align(
          alignment: Alignment.centerRight,
          child: Can(
            permission: createPermission,
            child: AppButton(
              label: createLabel,
              icon: Icons.add,
              onPressed: onCreate,
            ),
          ),
        ),
      ),
      Expanded(
        child: AsyncValueView<List<T>>(
          value: value,
          onRetry: onRetry,
          isEmpty: (d) => d.isEmpty,
          empty: EmptyState(icon: emptyIcon, title: emptyTitle),
          data: (items) => _Table<T>(
            items: items,
            columns: columns,
            rowId: rowId,
            rowActions: rowActions,
          ),
        ),
      ),
    ],
  );
}

class _Table<T> extends StatefulWidget {
  const _Table({
    required this.items,
    required this.columns,
    required this.rowId,
    required this.rowActions,
  });

  final List<T> items;
  final List<AppColumn<T>> columns;
  final String Function(T) rowId;
  final List<RowAction<T>> rowActions;

  @override
  State<_Table<T>> createState() => _TableState<T>();
}

class _TableState<T> extends State<_Table<T>> {
  late final TableController<T> _table = TableController(
    rows: widget.items,
    rowId: widget.rowId,
    columns: widget.columns,
  );

  @override
  void didUpdateWidget(_Table<T> old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<T>(
    controller: _table,
    selectable: false,
    rowActions: widget.rowActions,
  );
}
