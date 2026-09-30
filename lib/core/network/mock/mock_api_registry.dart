import 'mock_types.dart';

/// Módulo que contribui com handlers para o adaptador mock
/// (ex.: `features/students/data/mock_api/students_mock_handlers.dart`).
abstract interface class MockApiModule {
  /// Regista rotas em [registry] e, se tiver estado em memória, um hook de reset
  /// via [MockApiRegistry.onReset] que o repõe ao seed.
  void register(MockApiRegistry registry);
}

class _Route {
  _Route(this.method, this.pattern, this.handler) : segments = _split(pattern);

  final String method;
  final String pattern;
  final MockHandler handler;
  final List<String> segments;

  Map<String, String>? match(String method, List<String> path) {
    if (method != this.method || path.length != segments.length) return null;
    final params = <String, String>{};
    for (var i = 0; i < segments.length; i++) {
      final s = segments[i];
      if (s.startsWith('{') && s.endsWith('}')) {
        params[s.substring(1, s.length - 1)] = Uri.decodeComponent(path[i]);
      } else if (s != path[i]) {
        return null;
      }
    }
    return params;
  }
}

List<String> _split(String path) =>
    path.split('/').where((s) => s.isNotEmpty).toList();

/// Tabela de rotas `method + path` → handler (`/v1/users/{id}` suporta parâmetros).
class MockApiRegistry {
  final List<_Route> _routes = [];
  final List<void Function()> _resetHooks = [];

  void register(String method, String pattern, MockHandler handler) {
    _routes.add(_Route(method.toUpperCase(), pattern, handler));
  }

  void get(String pattern, MockHandler h) => register('GET', pattern, h);
  void post(String pattern, MockHandler h) => register('POST', pattern, h);
  void put(String pattern, MockHandler h) => register('PUT', pattern, h);
  void patch(String pattern, MockHandler h) => register('PATCH', pattern, h);
  void delete(String pattern, MockHandler h) => register('DELETE', pattern, h);

  void addModule(MockApiModule module) => module.register(this);

  /// Regista um hook chamado por `POST /__mock/reset` (repõe o estado do módulo).
  void onReset(void Function() hook) => _resetHooks.add(hook);

  void reset() {
    for (final hook in _resetHooks) {
      hook();
    }
  }

  /// Resolve o handler e os parâmetros de rota; `null` se não houver rota.
  ({MockHandler handler, Map<String, String> params})? resolve(
    String method,
    String path,
  ) {
    final segments = _split(path);
    for (final route in _routes) {
      final params = route.match(method.toUpperCase(), segments);
      if (params != null) return (handler: route.handler, params: params);
    }
    return null;
  }
}
