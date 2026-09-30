import 'dart:async';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'failure.dart';

typedef ErrorLogger =
    void Function(Object error, StackTrace? stack, Failure failure);

/// Converte excepções em [Failure] e regista-as; instala os handlers globais.
class ErrorHandler {
  const ErrorHandler._();

  /// Destino do logging (substituível, ex.: em testes ou para crash reporting).
  static ErrorLogger logger = _defaultLogger;

  static void _defaultLogger(Object error, StackTrace? stack, Failure failure) {
    developer.log(
      failure.toString(),
      name: 'erp.error',
      error: failure.cause ?? error,
      stackTrace: stack,
    );
  }

  /// Mapeia qualquer erro para [Failure]. Um [Failure] passa inalterado e não é registado.
  static Failure toFailure(Object error, [StackTrace? stack, bool log = true]) {
    if (error is Failure) return error;
    final failure = switch (error) {
      DioException e => _fromDio(e),
      TimeoutException e => NetworkFailure.timeout(cause: e),
      SocketException e => NetworkFailure(cause: e),
      _ => UnknownFailure(cause: error),
    };
    if (log) logger(error, stack, failure);
    return failure;
  }

  static Failure _fromDio(DioException e) {
    // O interceptor da API converte respostas de erro em Failure (ver #95).
    if (e.error case final Failure f) return f;
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => NetworkFailure.timeout(cause: e),
      DioExceptionType.connectionError => NetworkFailure(cause: e),
      _ => Failure.fromApiError(statusCode: e.response?.statusCode),
    };
  }

  /// Regista os handlers globais (Flutter e plataforma).
  static void install() {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      toFailure(details.exception, details.stack);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      toFailure(error, stack);
      return true;
    };
  }
}
