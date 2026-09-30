import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'error_handler.dart';
import 'failure.dart';

/// Resultado de uma operação: [Ok] com valor ou [Err] com [Failure].
sealed class Result<T> {
  const Result();

  /// Executa [action] convertendo excepções em [Err] (via [ErrorHandler]).
  static Future<Result<T>> guard<T>(Future<T> Function() action) async {
    try {
      return Ok(await action());
    } catch (error, stack) {
      return Err(ErrorHandler.toFailure(error, stack));
    }
  }

  bool get isOk => this is Ok<T>;
  bool get isErr => this is Err<T>;

  T? get valueOrNull => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>() => null,
  };

  Failure? get failureOrNull => switch (this) {
    Ok<T>() => null,
    Err<T>(:final failure) => failure,
  };

  R when<R>({
    required R Function(T value) ok,
    required R Function(Failure failure) err,
  }) => switch (this) {
    Ok<T>(:final value) => ok(value),
    Err<T>(:final failure) => err(failure),
  };

  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Ok<T>(:final value) => Ok(transform(value)),
    Err<T>(:final failure) => Err(failure),
  };

  /// Devolve o valor ou lança o [Failure].
  T getOrThrow() => switch (this) {
    Ok<T>(:final value) => value,
    Err<T>(:final failure) => throw failure,
  };

  /// Integração Riverpod: [Err] passa a `AsyncError` com o [Failure].
  AsyncValue<T> toAsyncValue() => switch (this) {
    Ok<T>(:final value) => AsyncData(value),
    Err<T>(:final failure) => AsyncError(failure, StackTrace.current),
  };
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final Failure failure;
}

extension AsyncValueFailure<T> on AsyncValue<T> {
  /// [Failure] do erro actual, se existir (erros não tipados viram `UnknownFailure`).
  Failure? get failure {
    final err = error;
    if (err == null) return null;
    return ErrorHandler.toFailure(err, stackTrace, false);
  }
}
