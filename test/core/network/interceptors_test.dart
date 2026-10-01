import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:flutter_test/flutter_test.dart';

/// Adaptador que regista os pedidos e responde com [reply].
class _Recorder implements HttpClientAdapter {
  _Recorder(this.reply);

  final ResponseBody Function(RequestOptions) reply;
  final seen = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    seen.add(options);
    return reply(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

ApiClient _client(_Recorder adapter, {TokenStore? tokens}) {
  final c = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: false,
    tokens: tokens,
    logging: false,
  );
  c.dio.httpClientAdapter = adapter;
  return c;
}

void main() {
  test('junta Bearer às rotas privadas e não às públicas', () async {
    final tokens = InMemoryTokenStore()
      ..save(accessToken: 'AT', refreshToken: 'RT');
    final rec = _Recorder((_) => _json(200, {'data': <String, dynamic>{}}));
    final client = _client(rec, tokens: tokens);

    await client.dio.get<dynamic>('/v1/students');
    await client.dio.post<dynamic>('/v1/auth/login', data: {});

    expect(rec.seen[0].headers['Authorization'], 'Bearer AT');
    expect(rec.seen[1].headers.containsKey('Authorization'), isFalse);
  });

  test('envelope de erro vira Failure tipada', () async {
    final rec = _Recorder(
      (_) => _json(422, {
        'error': {
          'code': 'VALIDATION_ERROR',
          'message': 'Dados inválidos',
          'fields': {'fullName': 'Obrigatório'},
        },
      }),
    );
    final client = _client(rec);
    try {
      await client.dio.get<dynamic>('/v1/students');
      fail('devia falhar');
    } on DioException catch (e) {
      final f = e.error! as ValidationFailure;
      expect(f.fields['fullName'], 'Obrigatório');
    }
  });

  test('falha de ligação vira NetworkFailure', () async {
    final rec = _Recorder(
      (o) => throw DioException.connectionError(
        requestOptions: o,
        reason: 'offline',
      ),
    );
    final client = _client(rec);
    try {
      await client.dio.get<dynamic>('/v1/students');
      fail('devia falhar');
    } on DioException catch (e) {
      expect(e.error, isA<NetworkFailure>());
    }
  });
}
