import 'user_model.dart';

/// Sessão autenticada devolvida por `login` e `me`.
class AuthSession {
  const AuthSession({
    required this.user,
    required this.roles,
    required this.permissions,
    required this.license,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    roles: (json['roles'] as List).cast<String>(),
    permissions: (json['permissions'] as List).cast<String>(),
    license: (json['license'] as Map?)?.cast<String, dynamic>() ?? const {},
  );

  final UserModel user;

  /// Códigos de perfil (`super_admin`, `encarregado`, …).
  final List<String> roles;

  /// Permissões `modulo.recurso.acção`; `*` = total.
  final List<String> permissions;

  /// Licença crua; o modelo tipado chega com a issue #23.
  final Map<String, dynamic> license;

  bool get mustChangePassword => user.mustChangePassword;
}
