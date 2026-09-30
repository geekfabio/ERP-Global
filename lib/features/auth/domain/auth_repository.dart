import '../../../core/errors/result.dart';
import '../data/models/auth_session.dart';

/// Contrato de autenticação. Só existe login: sem registo nem recuperação
/// auto-serviço (docs/07-mock-api.md).
abstract interface class AuthRepository {
  Future<Result<AuthSession>> login({
    required String identifier,
    required String password,
  });

  /// Reabre a sessão guardada (refresh token). `Ok(null)` se não houver sessão válida.
  Future<Result<AuthSession?>> restoreSession();

  Future<Result<AuthSession>> me();

  Future<Result<AuthSession>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  Future<Result<void>> logout();
}
