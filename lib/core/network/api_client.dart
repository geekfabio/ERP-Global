import 'dart:async';
import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/config/app_config.dart';
import '../errors/error_handler.dart';
import 'api_envelope.dart';
import 'mock/mock_api_adapter.dart';
import 'mock/mock_api_config.dart';
import 'mock/mock_api_registry.dart';

/// Tokens da sessão. A persistência segura fica a cargo do módulo `auth`.
abstract class TokenStore {
  String? get accessToken;
  String? get refreshToken;
  void save({required String accessToken, required String refreshToken});
  void clear();
}

class InMemoryTokenStore implements TokenStore {
  @override
  String? accessToken;
  @override
  String? refreshToken;

  @override
  void save({required String accessToken, required String refreshToken}) {
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  @override
  void clear() {
    accessToken = null;
    refreshToken = null;
  }
}

/// Cliente HTTP único da app (Dio). `useMockApi` só troca o adaptador de rede.
class ApiClient {
  ApiClient._(this.dio, this.tokens);

  factory ApiClient.create({
    required String baseUrl,
    required bool useMockApi,
    MockApiRegistry? registry,
    MockApiConfig mockConfig = const MockApiConfig(),
    TokenStore? tokens,
    bool logging = kDebugMode,
  }) {
    final store = tokens ?? InMemoryTokenStore();
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );
    // `kReleaseMode` é constante: em release o adaptador mock é removido (tree-shaking).
    if (useMockApi && !kReleaseMode) {
      dio.httpClientAdapter = MockApiAdapter(
        registry: registry ?? MockApiRegistry(),
        config: mockConfig,
      );
    }
    dio.interceptors.addAll([
      if (logging) _LogInterceptor(),
      _AuthInterceptor(dio, store),
      _ErrorInterceptor(),
    ]);
    return ApiClient._(dio, store);
  }

  final Dio dio;
  final TokenStore tokens;

  bool get isMock => dio.httpClientAdapter is MockApiAdapter;
}

const _publicPaths = ['/v1/auth/login', '/v1/auth/refresh'];
const _retriedKey = 'auth_retried';

/// Junta o Bearer token e, em `401 TOKEN_EXPIRED`, faz `POST /v1/auth/refresh` e repete o pedido.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._dio, this._tokens);

  final Dio _dio;
  final TokenStore _tokens;
  Future<bool>? _refreshing;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokens.accessToken;
    if (token != null && !_publicPaths.contains(options.path)) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final failure = ApiEnvelope.failureFrom(err.response);
    final expired =
        err.response?.statusCode == 401 &&
        failure?.code == 'TOKEN_EXPIRED' &&
        err.requestOptions.extra[_retriedKey] != true &&
        _tokens.refreshToken != null;
    if (!expired) return handler.next(err);

    final refreshed = await (_refreshing ??= _refresh().whenComplete(
      () => _refreshing = null,
    ));
    if (!refreshed) return handler.next(err);

    final options = err.requestOptions
      ..extra[_retriedKey] = true
      ..headers['Authorization'] = 'Bearer ${_tokens.accessToken}';
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  Future<bool> _refresh() async {
    try {
      // Dio sem interceptors (evita recursão), mesmo adaptador de rede.
      final plain = Dio(BaseOptions(baseUrl: _dio.options.baseUrl))
        ..httpClientAdapter = _dio.httpClientAdapter;
      final response = await plain.post<dynamic>(
        '/v1/auth/refresh',
        data: {'refreshToken': _tokens.refreshToken},
      );
      final data = ApiEnvelope.data(response)! as Map<String, dynamic>;
      _tokens.save(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
      return true;
    } catch (_) {
      _tokens.clear();
      return false;
    }
  }
}

/// Converte respostas de erro (envelope) e falhas de rede em `Failure` (`DioException.error`).
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final failure =
        ApiEnvelope.failureFrom(err.response) ??
        ErrorHandler.toFailure(err, err.stackTrace);
    handler.next(err.copyWith(error: failure));
  }
}

class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log('→ ${options.method} ${options.uri}', name: 'erp.http');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler h) {
    developer.log(
      '← ${response.statusCode} ${response.requestOptions.uri}',
      name: 'erp.http',
    );
    h.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '✗ ${err.response?.statusCode ?? err.type.name} ${err.requestOptions.uri}',
      name: 'erp.http',
    );
    handler.next(err);
  }
}

/// Registo partilhado de handlers mock; os módulos adicionam-se aqui.
final mockApiRegistryProvider = Provider<MockApiRegistry>(
  (ref) => MockApiRegistry(),
);

final tokenStoreProvider = Provider<TokenStore>((ref) => InMemoryTokenStore());

final apiClientProvider = Provider<ApiClient>(
  (ref) => ApiClient.create(
    baseUrl: AppConfig.apiBaseUrl,
    useMockApi: AppConfig.useMockApi,
    registry: ref.watch(mockApiRegistryProvider),
    tokens: ref.watch(tokenStoreProvider),
  ),
);
