import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import 'table_controller.dart';

/// Acção por linha (menu "⋮" na tabela e nos cartões).
class RowAction<T> {
  const RowAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final void Function(T row) onTap;
}

/// Tabela de dados genérica: pesquisa, ordenação, paginação, selecção múltipla,
/// colunas configuráveis, acções por linha, vista em cartões em ecrãs compact e
/// hook de exportação. A lógica vive em [TableController].
class AppDataTable<T> extends StatefulWidget {
  const AppDataTable({
    super.key,
    required this.controller,
    this.rowActions = const [],
    this.onExport,
    this.selectable = true,
    this.pageSizes = const [10, 20, 50, 100],
    this.emptyText = 'Sem resultados',
  });

  final TableController<T> controller;
  final List<RowAction<T>> rowActions;

  /// Recebe a selecção, ou todas as linhas filtradas se nada estiver seleccionado.
  final void Function(List<T> rows)? onExport;
  final bool selectable;
  final List<int> pageSizes;
  final String emptyText;

  @override
  State<AppDataTable<T>> createState() => _AppDataTableState<T>();
}

class _AppDataTableState<T> extends State<AppDataTable<T>> {
  TableController<T> get c => widget.controller;

  @override
  void initState() {
    super.initState();
    c.addListener(_rebuild);
  }

  @override
  void didUpdateWidget(AppDataTable<T> old) {
    super.didUpdateWidget(old);
    if (old.controller != c) {
      old.controller.removeListener(_rebuild);
      c.addListener(_rebuild);
    }
  }

  @override
  void dispose() {
    c.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < AppBreakpoints.medium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Toolbar<T>(
          controller: c,
          onExport: widget.onExport == null
              ? null
              : () => widget.onExport!(
                  c.selectedIds.isEmpty ? c.view : c.selectedRows,
                ),
        ),
        Expanded(
          child: c.pageRows.isEmpty
              ? Center(child: Text(widget.emptyText))
              : compact
              ? _CardList<T>(controller: c, actions: widget.rowActions)
              : _Table<T>(
                  controller: c,
                  actions: widget.rowActions,
                  selectable: widget.selectable,
                ),
        ),
        _Footer<T>(controller: c, pageSizes: widget.pageSizes),
      ],
    );
  }
}

class _Toolbar<T> extends StatelessWidget {
  const _Toolbar({required this.controller, this.onExport});

  final TableController<T> controller;
  final VoidCallback? onExport;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Pesquisar',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: c.setQuery,
            ),
          ),
          if (c.selectedIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: AppSpacing.sm),
              child: Chip(
                label: Text('${c.selectedIds.length} seleccionadas'),
                onDeleted: c.clearSelection,
              ),
            ),
          PopupMenuButton<int>(
            tooltip: 'Colunas',
            icon: const Icon(Icons.view_column_outlined),
            itemBuilder: (_) => [
              for (final (i, col) in c.columns.indexed)
                CheckedPopupMenuItem(
                  value: i,
                  checked: c.isVisible(i),
                  child: Text(col.label),
                ),
            ],
            onSelected: (i) => c.setColumnVisible(i, !c.isVisible(i)),
          ),
          if (onExport != null)
            IconButton(
              tooltip: 'Exportar',
              icon: const Icon(Icons.download_outlined),
              onPressed: onExport,
            ),
        ],
      ),
    );
  }
}

class _Table<T> extends StatelessWidget {
  const _Table({
    required this.controller,
    required this.actions,
    required this.selectable,
  });

  final TableController<T> controller;
  final List<RowAction<T>> actions;
  final bool selectable;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final visible = c.visibleColumns;
    final sortIndex = c.sortColumn == null
        ? null
        : visible.indexOf(c.sortColumn!);
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: selectable,
          sortColumnIndex: sortIndex == -1 ? null : sortIndex,
          sortAscending: c.ascending,
          onSelectAll: selectable ? (v) => c.setPageSelected(v ?? false) : null,
          columns: [
            for (final i in visible)
              DataColumn(
                label: Text(c.columns[i].label),
                numeric: c.columns[i].numeric,
                onSort: c.columns[i].sortValue == null
                    ? null
                    : (_, asc) => c.sortBy(i, ascending: asc),
              ),
            if (actions.isNotEmpty) const DataColumn(label: Text('')),
          ],
          rows: [
            for (final row in c.pageRows)
              DataRow(
                selected: c.isSelected(row),
                onSelectChanged: selectable
                    ? (v) => c.toggleSelected(row, selected: v)
                    : null,
                cells: [
                  for (final i in visible)
                    DataCell(
                      c.columns[i].cell?.call(row) ??
                          Text(c.columns[i].text(row)),
                    ),
                  if (actions.isNotEmpty)
                    DataCell(_ActionsMenu<T>(row: row, actions: actions)),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _CardList<T> extends StatelessWidget {
  const _CardList({required this.controller, required this.actions});

  final TableController<T> controller;
  final List<RowAction<T>> actions;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    final visible = c.visibleColumns;
    final text = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: c.pageRows.length,
      itemBuilder: (context, index) {
        final row = c.pageRows[index];
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.columns[visible.first].text(row),
                        style: text.titleMedium,
                      ),
                      for (final i in visible.skip(1))
                        Text(
                          '${c.columns[i].label}: ${c.columns[i].text(row)}',
                        ),
                    ],
                  ),
                ),
                if (actions.isNotEmpty)
                  _ActionsMenu<T>(row: row, actions: actions),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ActionsMenu<T> extends StatelessWidget {
  const _ActionsMenu({required this.row, required this.actions});

  final T row;
  final List<RowAction<T>> actions;

  @override
  Widget build(BuildContext context) => PopupMenuButton<int>(
    tooltip: 'Acções',
    onSelected: (i) => actions[i].onTap(row),
    itemBuilder: (_) => [
      for (final (i, a) in actions.indexed)
        PopupMenuItem(
          value: i,
          child: Row(
            children: [
              Icon(a.icon, size: 18),
              const SizedBox(width: AppSpacing.sm),
              Text(a.label),
            ],
          ),
        ),
    ],
  );
}

class _Footer<T> extends StatelessWidget {
  const _Footer({required this.controller, required this.pageSizes});

  final TableController<T> controller;
  final List<int> pageSizes;

  @override
  Widget build(BuildContext context) {
    final c = controller;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: AppSpacing.md,
        children: [
          Text('${c.total} registos'),
          DropdownButton<int>(
            value: pageSizes.contains(c.pageSize) ? c.pageSize : null,
            items: [
              for (final s in pageSizes)
                DropdownMenuItem(value: s, child: Text('$s / página')),
            ],
            onChanged: (v) => v == null ? null : c.setPageSize(v),
          ),
          IconButton(
            tooltip: 'Página anterior',
            icon: const Icon(Icons.chevron_left),
            onPressed: c.page > 0 ? () => c.setPage(c.page - 1) : null,
          ),
          Text('${c.page + 1} / ${c.pageCount}'),
          IconButton(
            tooltip: 'Página seguinte',
            icon: const Icon(Icons.chevron_right),
            onPressed: c.page < c.pageCount - 1
                ? () => c.setPage(c.page + 1)
                : null,
          ),
        ],
      ),
    );
  }
}
