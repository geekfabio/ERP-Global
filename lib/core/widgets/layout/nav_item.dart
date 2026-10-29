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

/// Secção do menu "acordeão": ou um item solto, ou um grupo colapsável.
sealed class NavSection {
  const NavSection();
}

/// Item sem grupo (Painel, Definições): tile normal no topo/fim do menu.
class NavLink extends NavSection {
  const NavLink({required this.item, required this.index});

  final NavItem item;

  /// Índice em `navItemsProvider` (o que `onSelected` espera).
  final int index;
}

/// Grupo colapsável com os módulos de uma mesma área.
class NavGroup extends NavSection {
  const NavGroup({
    required this.label,
    required this.icon,
    required this.links,
  });

  final String label;
  final IconData icon;
  final List<NavLink> links;
}

/// Áreas do menu: rótulo, ícone e caminhos dos módulos que agrupa. A ordem das
/// secções segue a primeira ocorrência de cada grupo em `navItemsProvider`;
/// caminhos não listados (Painel, Comunicação, Portal, Definições) ficam como
/// itens soltos. Nenhum rótulo de grupo repete o nome de um módulo: o menu
/// nunca mostra o mesmo texto duas vezes.
const navGroupSpec = <({String label, IconData icon, List<String> paths})>[
  (
    label: 'Pessoas',
    icon: Icons.people_outline,
    paths: ['/students', '/guardians', '/hr'],
  ),
  (
    label: 'Pedagógico',
    icon: Icons.menu_book_outlined,
    paths: ['/academic', '/grades', '/attendance'],
  ),
  (
    label: 'Finanças',
    icon: Icons.payments_outlined,
    paths: ['/billing', '/accounting'],
  ),
  (
    label: 'Campus',
    icon: Icons.apartment_outlined,
    paths: [
      '/cards',
      '/access',
      '/cafeteria',
      '/library',
      '/inventory',
      '/transport',
    ],
  ),
  (
    label: 'Dados',
    icon: Icons.insights_outlined,
    paths: ['/reports', '/import-export', '/sync'],
  ),
];

/// Converte [items] nas secções do acordeão, preservando a ordem do menu.
List<NavSection> buildNavSections(List<NavItem> items) {
  final specByPath = {
    for (final g in navGroupSpec)
      for (final p in g.paths) p: g,
  };
  final sections = <NavSection>[];
  final groups = <String, NavGroup>{};
  for (var i = 0; i < items.length; i++) {
    final link = NavLink(item: items[i], index: i);
    final spec = specByPath[items[i].path];
    if (spec == null) {
      sections.add(link);
      continue;
    }
    final group = groups.putIfAbsent(spec.label, () {
      final created = NavGroup(
        label: spec.label,
        icon: spec.icon,
        links: <NavLink>[],
      );
      sections.add(created);
      return created;
    });
    group.links.add(link);
  }
  return sections;
}

/// Rótulo do grupo que contém [index]; `null` se for um item solto.
String? navGroupLabelFor(List<NavSection> sections, int index) {
  for (final s in sections) {
    if (s is NavGroup && s.links.any((l) => l.index == index)) return s.label;
  }
  return null;
}
