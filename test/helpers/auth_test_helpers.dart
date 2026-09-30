import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/misc.dart' show Override;

AuthSession fakeSession({
  List<String> roles = const ['super_admin'],
  List<String> permissions = const ['*'],
}) => AuthSession.fromJson({
  'user': {
    'id': '01JTESTUSER00000000000001',
    'institutionId': '01JINSTITUTION000000000001',
    'createdAt': '2026-01-01T00:00:00Z',
    'updatedAt': '2026-01-01T00:00:00Z',
    'name': 'Teste',
  },
  'roles': roles,
  'permissions': permissions,
  'license': <String, dynamic>{},
});

/// Estado de auth fixo (sem chamar repository nem armazenamento seguro).
class FixedAuthNotifier extends AuthNotifier {
  FixedAuthNotifier(this._session);

  final AuthSession? _session;

  @override
  Future<AuthSession?> build() async => _session;
}

/// Sessão iniciada com [roles]/[permissions] (por omissão super_admin, tudo).
List<Override> signedInOverrides({
  List<String> roles = const ['super_admin'],
  List<String> permissions = const ['*'],
}) => [
  authStateProvider.overrideWith(
    () =>
        FixedAuthNotifier(fakeSession(roles: roles, permissions: permissions)),
  ),
  sessionPermissionsProvider.overrideWith(
    (ref) => ref.watch(currentSessionProvider)?.permissions,
  ),
];

/// Sem sessão (mostra `/login`).
List<Override> signedOutOverrides() => [
  authStateProvider.overrideWith(() => FixedAuthNotifier(null)),
  sessionPermissionsProvider.overrideWith(
    (ref) => ref.watch(currentSessionProvider)?.permissions,
  ),
];

/// Só as permissões (sem router/auth), para testar menu e widgets.
List<Override> permissionsOnly(List<String> codes) => [
  sessionPermissionsProvider.overrideWithValue(codes),
];
