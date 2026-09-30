import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../data/models/auth_session.dart';
import 'auth_providers.dart';

/// Sessão actual: `null` = sem sessão (mostra `/login`).
///
/// `build()` tenta reabrir a sessão guardada (refresh token); qualquer falha
/// resulta em "sem sessão" — nunca bloqueia o arranque.
class AuthNotifier extends AsyncNotifier<AuthSession?> {
  @override
  Future<AuthSession?> build() async {
    final result = await ref.read(authRepositoryProvider).restoreSession();
    return result.valueOrNull;
  }

  /// Autentica; em sucesso actualiza o estado. O erro (`Failure`) é devolvido
  /// ao chamador para mostrar na UI, sem estragar a sessão actual.
  Future<Result<AuthSession>> login({
    required String identifier,
    required String password,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .login(identifier: identifier, password: password);
    if (result case Ok(:final value)) state = AsyncData(value);
    return result;
  }

  Future<Result<AuthSession>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await ref
        .read(authRepositoryProvider)
        .changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
    if (result case Ok(:final value)) state = AsyncData(value);
    return result;
  }

  /// Termina a sessão. A sessão local é sempre limpa, mesmo se o servidor falhar.
  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AsyncData(null);
  }
}

final authStateProvider = AsyncNotifierProvider<AuthNotifier, AuthSession?>(
  AuthNotifier.new,
);

/// `true` com sessão iniciada.
final isAuthenticatedProvider = Provider<bool>(
  (ref) => ref.watch(authStateProvider).value != null,
);

/// Pessoa autenticada, se existir.
final currentSessionProvider = Provider<AuthSession?>(
  (ref) => ref.watch(authStateProvider).value,
);
