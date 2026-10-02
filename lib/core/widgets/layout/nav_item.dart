import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../modules/license_gate.dart';
import '../../modules/module_catalog.dart';
import '../../security/permission_providers.dart';

/// Entrada de menu do shell.
class NavItem {
  const NavItem({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;
}

/// Menu = módulos registados ∩ licença ∩ permissões do utilizador.
/// "Painel" abre sempre; os módulos obrigatórios
/// (Definições) ficam no fim.
final navItemsProvider = Provider<List<NavItem>>((ref) {
  final permissions = ref.watch(permissionServiceProvider);
  final enabled = ref.watch(enabledModulesProvider);
  final modules = ref
      .watch(moduleRegistryProvider)
      .all
      .where(
        (m) =>
            m.showInMenu &&
            enabled.contains(m.code) &&
            permissions.canAccessNamespace(m.namespace),
      );
  NavItem toItem(m) => NavItem(label: m.name, icon: m.icon, path: m.path);
  return [
    const NavItem(
      label: 'Painel',
      icon: Icons.dashboard_outlined,
      path: '/dashboard',
    ),
    ...modules.where((m) => !m.required).map(toItem),
    ...modules.where((m) => m.required).map(toItem),
  ];
});

/// Índice do item cujo caminho é prefixo de [location]; -1 se nenhum.
int navIndexFor(List<NavItem> items, String location) => items.indexWhere(
  (i) => location == i.path || location.startsWith('${i.path}/'),
);
