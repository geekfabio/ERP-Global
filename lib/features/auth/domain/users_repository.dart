import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/managed_user.dart';

/// Gestão de contas (só `super_admin` ou `users.account.create`).
abstract interface class UsersRepository {
  /// Página de contas; [sort] no formato `campo,-outro` (`name`, `email`).
  Future<Result<PagedList<ManagedUser>>> list({
    int page = 1,
    int pageSize = 20,
    String query = '',
    String sort = 'name',
  });

  Future<Result<ManagedUser>> get(String id);

  /// Cria a conta com password temporária (`mustChangePassword`).
  Future<Result<ManagedUser>> create(UserInput input);

  Future<Result<ManagedUser>> update(String id, UserInput input);

  Future<Result<ManagedUser>> setActive(String id, {required bool active});

  /// Gera nova password temporária e obriga à mudança no próximo login.
  Future<Result<ManagedUser>> resetPassword(String id);
}
