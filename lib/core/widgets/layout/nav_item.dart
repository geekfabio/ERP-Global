import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Entrada de menu do shell. Será alimentada pelo `ModuleRegistry` (#22).
@immutable
class NavItem {
  const NavItem({required this.label, required this.icon, required this.path});

  final String label;
  final IconData icon;
  final String path;
}

/// Itens de menu disponíveis. Por agora estático; o `ModuleRegistry` e os
/// guards de licença/permissão passam a filtrá-lo (#22, #24).
final navItemsProvider = Provider<List<NavItem>>(
  (ref) => const [
    NavItem(
      label: 'Painel',
      icon: Icons.dashboard_outlined,
      path: '/dashboard',
    ),
    NavItem(label: 'Alunos', icon: Icons.school_outlined, path: '/students'),
    NavItem(
      label: 'Académico',
      icon: Icons.menu_book_outlined,
      path: '/academic',
    ),
    NavItem(
      label: 'Financeiro',
      icon: Icons.payments_outlined,
      path: '/billing',
    ),
    NavItem(
      label: 'Definições',
      icon: Icons.settings_outlined,
      path: '/settings',
    ),
  ],
);

/// Índice do item cujo caminho é prefixo de [location]; -1 se nenhum.
int navIndexFor(List<NavItem> items, String location) => items.indexWhere(
  (i) => location == i.path || location.startsWith('${i.path}/'),
);
