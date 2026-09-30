import 'dart:async';

import '../api_envelope.dart';

typedef MockHandler = FutureOr<MockResponse> Function(MockRequest request);

/// Pedido recebido por um handler mock.
class MockRequest {
  const MockRequest({
    required this.method,
    required this.path,
    this.query = const {},
    this.params = const {},
    this.body,
    this.headers = const {},
  });

  final String method;

  /// Path sem query, ex.: `/v1/students/01H...`.
  final String path;
  final Map<String, String> query;

  /// Parâmetros de rota (`/v1/users/{id}` → `{id: ...}`).
  final Map<String, String> params;
  final Object? body;
  final Map<String, dynamic> headers;

  Map<String, dynamic> get jsonBody =>
      body is Map<String, dynamic> ? body! as Map<String, dynamic> : const {};
}

/// Resposta produzida por um handler mock.
class MockResponse {
  const MockResponse(this.status, this.body);

  /// 200 com `{data}`.
  factory MockResponse.ok(Object? data) =>
      MockResponse(200, ApiEnvelope.success(data));

  /// 201 com `{data}`.
  factory MockResponse.created(Object? data) =>
      MockResponse(201, ApiEnvelope.success(data));

  /// 200 com `{data: [...], meta}`.
  factory MockResponse.page(List<Object?> items, PageMeta meta) =>
      MockResponse(200, ApiEnvelope.success(items, meta: meta));

  final int status;
  final Object? body;
}

/// Erro de API que o handler lança; o adaptador converte-o no envelope de erro.
class MockApiException implements Exception {
  const MockApiException(this.status, this.code, this.message, {this.fields});

  const MockApiException.badRequest([String message = 'Pedido inválido'])
    : this(400, 'BAD_REQUEST', message);
  const MockApiException.unauthenticated([String message = 'Sessão inválida'])
    : this(401, 'UNAUTHENTICATED', message);
  const MockApiException.tokenExpired()
    : this(401, 'TOKEN_EXPIRED', 'A sessão expirou');
  const MockApiException.forbidden([String message = 'Sem permissão'])
    : this(403, 'FORBIDDEN', message);
  const MockApiException.moduleNotLicensed([
    String message = 'Módulo não licenciado',
  ]) : this(403, 'MODULE_NOT_LICENSED', message);
  const MockApiException.notFound([String message = 'Registo não encontrado'])
    : this(404, 'NOT_FOUND', message);
  const MockApiException.conflict([String message = 'Registo duplicado'])
    : this(409, 'CONFLICT', message);
  const MockApiException.validation(
    Map<String, String> fields, [
    String message = 'Dados inválidos',
  ]) : this(422, 'VALIDATION_ERROR', message, fields: fields);

  final int status;
  final String code;
  final String message;
  final Map<String, String>? fields;

  @override
  String toString() => 'MockApiException($status $code: $message)';
}
