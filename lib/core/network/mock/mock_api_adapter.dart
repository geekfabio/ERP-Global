import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import '../../utils/seeded_random.dart';
import '../api_envelope.dart';
import 'mock_api_config.dart';
import 'mock_api_registry.dart';
import 'mock_types.dart';

/// `HttpClientAdapter` que simula o backend: resolve `method + path` no [MockApiRegistry],
/// aplica latência/chaos e responde sempre com o envelope de docs/07-mock-api.md.
class MockApiAdapter implements HttpClientAdapter {
  MockApiAdapter({required this.registry, this.config = const MockApiConfig()})
    : _random = SeededRandom(config.seed);

  final MockApiRegistry registry;
  final MockApiConfig config;
  final SeededRandom _random;
  Duration _lastLatency = Duration.zero;

  /// Rotas do próprio adaptador (não passam pelo registry nem sofrem chaos).
  MockResponse? _builtIn(String method, String path) {
    if (method == 'GET' && path == '/v1/health') {
      return MockResponse.ok({
        'status': 'ok',
        'mock': true,
        'latencyMs': _lastLatency.inMilliseconds,
      });
    }
    if (method == 'POST' && path == '/__mock/reset') {
      registry.reset();
      return MockResponse.ok({'reset': true});
    }
    return null;
  }

  static bool _isInternal(String path) =>
      path == '/v1/health' || path.startsWith('/__mock/');

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = _relativePath(options);
    final internal = _isInternal(path);

    final minMs = config.minLatency.inMilliseconds;
    final maxMs = config.maxLatency.inMilliseconds;
    _lastLatency = Duration(
      milliseconds: maxMs <= minMs ? minMs : _random.range(minMs, maxMs),
    );
    await config.sleep(_lastLatency);

    if (config.chaos && !internal && _random.chance(config.chaosRate)) {
      switch (_random.nextInt(3)) {
        case 0:
          throw DioException.connectionTimeout(
            timeout: const Duration(seconds: 30),
            requestOptions: options,
          );
        case 1:
          return _json(503, _error('INTERNAL_ERROR', 'Serviço indisponível'));
        default:
          return _json(500, _error('INTERNAL_ERROR', 'Erro interno simulado'));
      }
    }

    final builtIn = _builtIn(options.method.toUpperCase(), path);
    if (builtIn != null) return _json(builtIn.status, builtIn.body);

    final match = registry.resolve(options.method, path);
    if (match == null) {
      return _json(404, _error('NOT_FOUND', 'Rota não encontrada: $path'));
    }

    try {
      final response = await match.handler(
        MockRequest(
          method: options.method.toUpperCase(),
          path: path,
          query: {
            for (final e in options.uri.queryParameters.entries) e.key: e.value,
          },
          params: match.params,
          body: _decodeBody(options.data),
          headers: options.headers,
        ),
      );
      return _json(response.status, response.body);
    } on MockApiException catch (e) {
      return _json(e.status, _error(e.code, e.message, e.fields));
    } catch (_) {
      return _json(500, _error('INTERNAL_ERROR', 'Erro interno do servidor'));
    }
  }

  static String _relativePath(RequestOptions options) {
    final path = options.uri.path;
    final base = Uri.tryParse(options.baseUrl)?.path ?? '';
    final prefix = base.endsWith('/')
        ? base.substring(0, base.length - 1)
        : base;
    return prefix.isNotEmpty && path.startsWith(prefix)
        ? path.substring(prefix.length)
        : path;
  }

  static Object? _decodeBody(Object? data) {
    if (data is String && data.isNotEmpty) {
      try {
        return jsonDecode(data);
      } on FormatException {
        return data;
      }
    }
    return data;
  }

  static Map<String, dynamic> _error(
    String code,
    String message, [
    Map<String, String>? fields,
  ]) => ApiEnvelope.error(code: code, message: message, fields: fields);

  static ResponseBody _json(int status, Object? body) =>
      ResponseBody.fromString(
        jsonEncode(body),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {}
}
