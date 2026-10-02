import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state.dart';

/// Nome apresentado de cada perfil (códigos em docs/01-perfis-e-permissoes.md).
const roleLabels = <String, String>{
  'super_admin': 'Super Administrador',
  'direcao': 'Direcção',
  'coordenacao': 'Coordenação',
  'secretaria': 'Secretaria',
  'professor': 'Professor',
  'diretor_turma': 'Director de turma',
  'financeiro': 'Financeiro',
  'contabilista': 'Contabilista',
  'rh': 'Recursos Humanos',
  'refeitorio': 'Refeitório',
  'seguranca': 'Segurança',
  'bibliotecario': 'Bibliotecário',
  'encarregado': 'Encarregado',
  'aluno': 'Aluno',
};

/// Perfil activo da sessão. Com um só perfil é automático; com vários, o
/// utilizador escolhe no login (`null` = ainda por escolher).
class ActiveRoleNotifier extends Notifier<String?> {
  @override
  String? build() {
    final roles = ref.watch(currentSessionProvider)?.roles ?? const [];
    return roles.length == 1 ? roles.single : null;
  }

  void select(String role) {
    final roles = ref.read(currentSessionProvider)?.roles ?? const [];
    if (roles.contains(role)) state = role;
  }
}

final activeRoleProvider = NotifierProvider<ActiveRoleNotifier, String?>(
  ActiveRoleNotifier.new,
);
