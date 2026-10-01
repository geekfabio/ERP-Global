import 'package:flutter/material.dart';

import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';

/// Tabela do módulo: recria as linhas do controller quando a lista muda.
class AcademicTable<T> extends StatefulWidget {
  const AcademicTable({
    super.key,
    required this.items,
    required this.rowId,
    required this.columns,
    required this.emptyText,
    this.rowActions = const [],
  });

  final List<T> items;
  final String Function(T) rowId;
  final List<AppColumn<T>> columns;
  final String emptyText;
  final List<RowAction<T>> rowActions;

  @override
  State<AcademicTable<T>> createState() => _AcademicTableState<T>();
}

class _AcademicTableState<T> extends State<AcademicTable<T>> {
  late final TableController<T> _table = TableController(
    rows: widget.items,
    rowId: widget.rowId,
    columns: widget.columns,
  );

  @override
  void didUpdateWidget(AcademicTable<T> old) {
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
    emptyText: widget.emptyText,
    rowActions: widget.rowActions,
  );
}
