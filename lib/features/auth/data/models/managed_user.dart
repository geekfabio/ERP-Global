import 'scope_model.dart';
import 'user_model.dart';

/// Conta gerida pela administração: utilizador + perfis + âmbito.
/// [temporaryPassword] só vem nas respostas de criação e de reset.
class ManagedUser {
  const ManagedUser({
    required this.user,
    required this.roles,
    this.scope = const ScopeModel(),
    this.temporaryPassword,
  });

  factory ManagedUser.fromJson(Map<String, dynamic> json) => ManagedUser(
    user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    roles: (json['roles'] as List).cast<String>(),
    scope: json['scope'] == null
        ? const ScopeModel()
        : ScopeModel.fromJson(json['scope'] as Map<String, dynamic>),
    temporaryPassword: json['temporaryPassword'] as String?,
  );

  final UserModel user;
  final List<String> roles;
  final ScopeModel scope;
  final String? temporaryPassword;
}

/// Dados editáveis de uma conta (corpo de `POST`/`PATCH /v1/users`).
class UserInput {
  const UserInput({
    required this.name,
    required this.email,
    required this.roles,
    this.phone,
    this.scope = const ScopeModel(),
  });

  final String name;
  final String email;
  final String? phone;
  final List<String> roles;
  final ScopeModel scope;

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'phone': phone,
    'roles': roles,
    'scope': scope.toJson(),
  };
}
