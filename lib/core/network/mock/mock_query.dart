import '../api_envelope.dart';
import 'mock_types.dart';

/// Como paginar/ordenar/filtrar/pesquisar uma colecção de [T] (feito no handler, como o servidor).
class MockListSpec<T> {
  const MockListSpec({
    this.sortable = const {},
    this.filterable = const {},
    this.searchText,
    this.defaultSort = const [],
  });

  /// Campos ordenáveis (`sort=campo,-outro`).
  final Map<String, Comparable<Object?> Function(T)> sortable;

  /// Campos filtráveis (`filter[campo]=valor`), comparados como texto.
  final Map<String, Object? Function(T)> filterable;

  /// Texto pesquisável para `q` (sem acentos e sem distinguir maiúsculas).
  final String Function(T)? searchText;
  final List<String> defaultSort;
}

const maxPageSize = 100;
const defaultPageSize = 20;

/// Aplica filtros, pesquisa, ordenação e paginação; lança 422 para parâmetros inválidos.
MockResponse mockPaginate<T>(
  Iterable<T> source,
  MockRequest request, {
  required Object? Function(T) toJson,
  MockListSpec<T> spec = const MockListSpec(),
}) {
  final errors = <String, String>{};
  final page = _positiveInt(request.query['page'], 1, 'page', errors);
  final pageSize = _positiveInt(
    request.query['pageSize'],
    defaultPageSize,
    'pageSize',
    errors,
    max: maxPageSize,
  );

  var items = source.toList();

  final filters = <String, String>{};
  for (final entry in request.query.entries) {
    final match = RegExp(r'^filter\[(\w+)\]$').firstMatch(entry.key);
    if (match == null) continue;
    final field = match.group(1)!;
    if (!spec.filterable.containsKey(field)) {
      errors['filter[$field]'] = 'Filtro não suportado';
    } else {
      filters[field] = entry.value;
    }
  }

  final sort = <String>[
    ...?request.query['sort']?.split(',').where((s) => s.isNotEmpty),
    ...request.query.containsKey('sort') ? const [] : spec.defaultSort,
  ];
  for (final key in sort) {
    final field = key.startsWith('-') ? key.substring(1) : key;
    if (!spec.sortable.containsKey(field)) {
      errors['sort'] = 'Campo de ordenação inválido: $field';
    }
  }

  if (errors.isNotEmpty) throw MockApiException.validation(errors);

  filters.forEach((field, value) {
    final read = spec.filterable[field]!;
    items = items.where((i) => '${read(i)}' == value).toList();
  });

  final q = request.query['q']?.trim() ?? '';
  final searchText = spec.searchText;
  if (q.isNotEmpty && searchText != null) {
    final needle = foldText(q);
    items = items
        .where((i) => foldText(searchText(i)).contains(needle))
        .toList();
  }

  if (sort.isNotEmpty) {
    items.sort((a, b) {
      for (final key in sort) {
        final desc = key.startsWith('-');
        final read = spec.sortable[desc ? key.substring(1) : key]!;
        final c = Comparable.compare(read(a), read(b));
        if (c != 0) return desc ? -c : c;
      }
      return 0;
    });
  }

  final start = (page - 1) * pageSize;
  final slice = items.skip(start).take(pageSize).map(toJson).toList();
  return MockResponse.page(
    slice,
    PageMeta(page: page, pageSize: pageSize, total: items.length),
  );
}

int _positiveInt(
  String? raw,
  int fallback,
  String name,
  Map<String, String> errors, {
  int? max,
}) {
  if (raw == null) return fallback;
  final value = int.tryParse(raw);
  if (value == null || value < 1 || (max != null && value > max)) {
    errors[name] = max == null
        ? 'Deve ser um inteiro ≥ 1'
        : 'Deve ser um inteiro entre 1 e $max';
    return fallback;
  }
  return value;
}

/// Minúsculas e sem diacríticos (pesquisa "joao" encontra "João").
String foldText(String input) {
  const from = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
  const to = 'aaaaaeeeeiiiiooooouuuucn';
  final buffer = StringBuffer();
  for (final rune in input.toLowerCase().runes) {
    final ch = String.fromCharCode(rune);
    final i = from.indexOf(ch);
    buffer.write(i >= 0 ? to[i] : ch);
  }
  return buffer.toString();
}
