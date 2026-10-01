import 'dart:async';

import '../../../../core/errors/failure.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/managed_user.dart';
import '../../domain/users_repository.dart';

/// Adapta a tabela partilhada à paginação, pesquisa e ordenação feitas pela API.
/// Colunas ordenáveis no servidor: `name` (coluna 0) e `email` (coluna 1).
class UsersTableController extends TableController<ManagedUser> {
  UsersTableController(this.repository, {required super.columns})
    : super(rows: const [], rowId: (a) => a.user.id);

  static const _sortFields = ['name', 'email'];

  final UsersRepository repository;
  List<ManagedUser> _items = const [];
  int _total = 0;
  int _page = 0;
  int _revision = 0;
  String _query = '';
  int _sortIndex = 0;
  bool _ascending = true;
  bool _disposed = false;
  Timer? _debounce;

  bool loading = false;
  Failure? failure;

  @override
  List<ManagedUser> get pageRows => _items;
  @override
  List<ManagedUser> get view => _items;
  @override
  int get total => _total;
  @override
  int get page => _page;
  @override
  String get query => _query;
  @override
  int? get sortColumn => _sortIndex;
  @override
  bool get ascending => _ascending;

  @override
  void setQuery(String value) {
    _query = value;
    _page = 0;
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 250), load);
  }

  @override
  void setPage(int page) {
    _page = page.clamp(0, pageCount - 1);
    unawaited(load());
  }

  @override
  void setPageSize(int size) {
    pageSize = size;
    _page = 0;
    unawaited(load());
  }

  @override
  void sortBy(int column, {bool? ascending}) {
    if (column >= _sortFields.length) return;
    _ascending = ascending ?? (_sortIndex == column ? !_ascending : true);
    _sortIndex = column;
    unawaited(load());
  }

  Future<void> load() async {
    final revision = ++_revision;
    loading = true;
    failure = null;
    notifyListeners();
    final result = await repository.list(
      page: _page + 1,
      pageSize: pageSize,
      query: _query,
      sort: '${_ascending ? '' : '-'}${_sortFields[_sortIndex]}',
    );
    // Resposta de um pedido já ultrapassado: ignora.
    if (_disposed || revision != _revision) return;
    result.when(
      ok: (p) {
        _items = p.items;
        _total = p.meta.total;
      },
      err: (f) => failure = f,
    );
    loading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _debounce?.cancel();
    super.dispose();
  }
}
