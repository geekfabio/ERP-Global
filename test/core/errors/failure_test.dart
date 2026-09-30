import 'dart:async';

import 'package:dio/dio.dart';
import 'package:erp_global/core/errors/error_handler.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure.fromApiError', () {
    test('mapeia códigos do contrato para o tipo certo', () {
      Failure f(String code) => Failure.fromApiError(statusCode: 0, code: code);
      expect(f('UNAUTHENTICATED'), isA<AuthFailure>());
      expect(f('TOKEN_EXPIRED'), isA<AuthFailure>());
      expect((f('TOKEN_EXPIRED') as AuthFailure).isTokenExpired, isTrue);
      expect(f('INVALID_CREDENTIALS'), isA<AuthFailure>());
      expect(f('FORBIDDEN'), isA<PermissionFailure>());
      expect(f('MODULE_NOT_LICENSED'), isA<LicenseFailure>());
      expect((f('LICENSE_READ_ONLY') as LicenseFailure).isReadOnly, isTrue);
      expect(f('VALIDATION_ERROR'), isA<ValidationFailure>());
      expect(f('NOT_FOUND'), isA<UnknownFailure>());
      expect(f('CONFLICT').code, 'CONFLICT');
    });

    test('usa o estado HTTP quando não há code', () {
      expect(Failure.fromApiError(statusCode: 403), isA<PermissionFailure>());
      expect(Failure.fromApiError(statusCode: 422), isA<ValidationFailure>());
      expect(Failure.fromApiError(statusCode: 500).code, 'INTERNAL_ERROR');
    });

    test('preserva campos e mensagem do servidor; senão usa pt-AO', () {
      final v =
          Failure.fromApiError(
                statusCode: 422,
                code: 'VALIDATION_ERROR',
                message: 'Dados inválidos',
                fields: {'email': 'Formato inválido'},
              )
              as ValidationFailure;
      expect(v.fields['email'], 'Formato inválido');
      expect(v.message, 'Dados inválidos');
      expect(NetworkFailure().message, contains('ligação'));
      expect(NetworkFailure.timeout().code, 'TIMEOUT');
      expect(UnknownFailure().message, 'Ocorreu um erro inesperado.');
    });
  });

  group('ErrorHandler', () {
    late List<Failure> logged;
    setUp(() {
      logged = [];
      ErrorHandler.logger = (_, _, failure) => logged.add(failure);
    });

    test('converte excepções e regista', () {
      expect(
        ErrorHandler.toFailure(TimeoutException('x')),
        isA<NetworkFailure>(),
      );
      expect(ErrorHandler.toFailure(StateError('x')), isA<UnknownFailure>());
      expect(logged, hasLength(2));
    });

    test('Failure passa inalterado e sem log', () {
      final f = AuthFailure();
      expect(identical(ErrorHandler.toFailure(f), f), isTrue);
      expect(logged, isEmpty);
    });

    test('DioException: timeout, ligação e Failure embrulhado', () {
      final req = RequestOptions(path: '/x');
      expect(
        ErrorHandler.toFailure(
          DioException(
            requestOptions: req,
            type: DioExceptionType.receiveTimeout,
          ),
        ).code,
        'TIMEOUT',
      );
      expect(
        ErrorHandler.toFailure(
          DioException(
            requestOptions: req,
            type: DioExceptionType.connectionError,
          ),
        ),
        isA<NetworkFailure>(),
      );
      final wrapped = PermissionFailure();
      expect(
        ErrorHandler.toFailure(
          DioException(requestOptions: req, error: wrapped),
        ),
        same(wrapped),
      );
    });
  });

  group('Result', () {
    test('Ok / Err', () {
      const Result<int> ok = Ok(2);
      final Result<int> err = Err(AuthFailure());
      expect(ok.map((v) => v * 2).valueOrNull, 4);
      expect(err.valueOrNull, isNull);
      expect(err.failureOrNull, isA<AuthFailure>());
      expect(ok.when(ok: (v) => 'ok$v', err: (f) => 'err'), 'ok2');
      expect(err.when(ok: (v) => 'ok', err: (f) => f.code), 'UNAUTHENTICATED');
      expect(ok.getOrThrow(), 2);
      expect(err.getOrThrow, throwsA(isA<AuthFailure>()));
    });

    test('guard captura excepções como Err', () async {
      ErrorHandler.logger = (_, _, _) {};
      expect((await Result.guard(() async => 1)).valueOrNull, 1);
      final r = await Result.guard<int>(() async => throw StateError('x'));
      expect(r.failureOrNull, isA<UnknownFailure>());
    });

    test('toAsyncValue e AsyncValue.failure', () {
      expect(const Ok(1).toAsyncValue(), const AsyncData(1));
      final av = Err<int>(PermissionFailure()).toAsyncValue();
      expect(av.hasError, isTrue);
      expect(av.failure, isA<PermissionFailure>());
      expect(const AsyncData(1).failure, isNull);
    });
  });
}
