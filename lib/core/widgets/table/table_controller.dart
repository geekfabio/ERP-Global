import 'package:flutter/widgets.dart';

/// Coluna tipada de [AppDataTable]. [sortValue] activa a ordenação da coluna.
class AppColumn<T> {
  const AppColumn({
    required this.label,
    required this.text,
    this.sortValue,
    this.numeric = false,
    this.cell,
  });

  final String label;

  /// Texto da célula (também usado na pesquisa e na vista em cartões).
  final String Function(T row) text;

  /// Valor comparável para ordenar; `null` = coluna não ordenável.
  final Comparable<Object?> Function(T row)? sortValue;
  final bool numeric;

  /// Célula personalizada (ex.: `StatusBadge`); por omissão `Text(text(row))`.
  final Widget Function(T row)? cell;
}

/// Estado e lógica da tabela (pesquisa, ordenação, paginação, selecção).
/// Independente de widgets: testável e reutilizável com 10k+ linhas.
class TableController<T> extends ChangeNotifier {
  TableController({
    required List<T> rows,
    required this.columns,
    required this.rowId,
    this.pageSize = 20,
  }) {
    _rows = rows;
    _recompute();
  }

  final List<AppColumn<T>> columns;
  final Object Function(T row) rowId;

  late List<T> _rows;
  List<T> _view = const [];
  String _query = '';
  int? _sortColumn;
  bool _ascending = true;
  int _page = 0;
  int pageSize;
  final Set<Object> _selected = {};
  final Set<int> _hidden = {};

  String get query => _query;
  int? get sortColumn => _sortColumn;
  bool get ascending => _ascending;
  int get page => _page;

  /// Linhas após pesquisa e ordenação.
  List<T> get view => _view;
  int get total => _view.length;
  int get pageCount => total == 0 ? 1 : (total + pageSize - 1) ~/ pageSize;

  List<T> get pageRows {
    final start = _page * pageSize;
    final end = (start + pageSize).clamp(0, total);
    return start >= total ? const [] : _view.sublist(start, end);
  }

  Set<Object> get selectedIds => Set.unmodifiable(_selected);
  List<T> get selectedRows =>
      _rows.where((r) => _selected.contains(rowId(r))).toList();
  bool isSelected(T row) => _selected.contains(rowId(row));

  /// Índices de colunas visíveis.
  List<int> get visibleColumns => [
    for (var i = 0; i < columns.length; i++)
      if (!_hidden.contains(i)) i,
  ];
  bool isVisible(int column) => !_hidden.contains(column);

  void setRows(List<T> rows) {
    _rows = rows;
    _selected.removeWhere((id) => !rows.any((r) => rowId(r) == id));
    _recompute();
    notifyListeners();
  }

  void setQuery(String value) {
    _query = value;
    _page = 0;
    _recompute();
    notifyListeners();
  }

  void sortBy(int column, {bool? ascending}) {
    if (columns[column].sortValue == null) return;
    _ascending = ascending ?? (_sortColumn == column ? !_ascending : true);
    _sortColumn = column;
    _recompute();
    notifyListeners();
  }

  void setPage(int page) {
    _page = page.clamp(0, pageCount - 1);
    notifyListeners();
  }

  void setPageSize(int size) {
    pageSize = size;
    _page = 0;
    notifyListeners();
  }

  void toggleSelected(T row, {bool? selected}) {
    final id = rowId(row);
    final on = selected ?? !_selected.contains(id);
    on ? _selected.add(id) : _selected.remove(id);
    notifyListeners();
  }

  /// Selecciona/deselecciona todas as linhas da página actual.
  void setPageSelected(bool selected) {
    for (final row in pageRows) {
      final id = rowId(row);
      selected ? _selected.add(id) : _selected.remove(id);
    }
    notifyListeners();
  }

  void clearSelection() {
    _selected.clear();
    notifyListeners();
  }

  void setColumnVisible(int column, bool visible) {
    // Mantém sempre pelo menos uma coluna visível.
    if (!visible && visibleColumns.length <= 1) return;
    visible ? _hidden.remove(column) : _hidden.add(column);
    notifyListeners();
  }

  void _recompute() {
    final q = _query.trim().toLowerCase();
    var result = q.isEmpty
        ? List<T>.of(_rows)
        : _rows
              .where(
                (r) => columns.any((c) => c.text(r).toLowerCase().contains(q)),
              )
              .toList();
    final sort = _sortColumn;
    if (sort != null) {
      final value = columns[sort].sortValue!;
      result.sort((a, b) {
        final c = Comparable.compare(value(a), value(b));
        return _ascending ? c : -c;
      });
    }
    _view = result;
    _page = _page.clamp(0, pageCount - 1);
  }
}
