import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/security/permission_service.dart';
import '../../data/models/managed_user.dart';
import '../../data/repositories/api_users_repository.dart';
import '../../domain/users_repository.dart';

final usersRepositoryProvider = Provider<UsersRepository>(
  (ref) => ApiUsersRepository(ref.watch(apiClientProvider)),
);

/// Pode ver a gestão de contas (`super_admin` tem `*`). Com a licença em só
/// leitura continua a poder consultar; as acções é que ficam negadas.
final canViewUsersProvider = Provider<bool>((ref) {
  final codes = ref.watch(sessionPermissionsProvider);
  return codes != null &&
      PermissionService.fromCodes(codes).canAny('users.account.create');
});

/// Pode criar, editar, desactivar e repor passwords (nega em licença só leitura).
final canManageUsersProvider = Provider<bool>(
  (ref) => ref.watch(permissionServiceProvider).canAny('users.account.create'),
);

/// Conta a editar, lida pela API.
final managedUserProvider = FutureProvider.autoDispose
    .family<ManagedUser, String>((ref, id) async {
      final result = await ref.watch(usersRepositoryProvider).get(id);
      return result.getOrThrow();
    });

/// Opções de âmbito para atribuir a um perfil (valor → rótulo).
class ScopeOptions {
  const ScopeOptions({required this.campuses, required this.grades});

  final Map<String, String> campuses;
  final Map<String, String> grades;
}

/// Opções de âmbito. Até o módulo `academic` expor campus/classes por API,
/// usa os ids de referência partilhados pelas fixtures.
final scopeOptionsProvider = Provider<ScopeOptions>(
  (ref) => ScopeOptions(
    campuses: const {MockRef.campusId: 'Campus principal'},
    grades: {
      for (var i = 0; i < MockRef.gradeCount; i++)
        MockRef.gradeId(i): MockRef.gradeLabel(i),
    },
  ),
);

/// Incrementa quando uma conta é criada/alterada, para a lista recarregar.
class UsersRevision extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state++;
}

final usersRevisionProvider = NotifierProvider<UsersRevision, int>(
  UsersRevision.new,
);
