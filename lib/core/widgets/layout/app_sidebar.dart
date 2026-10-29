import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';
import 'nav_item.dart';

/// Largura da sidebar em ecrãs `expanded`.
const double appSidebarWidth = 248;

/// Largura da sidebar em ecrãs `medium` (tablet): mais estreita para deixar
/// espaço ao conteúdo.
const double appSidebarWidthMedium = 216;

/// Sidebar "acordeão" de desktop/tablet: marca no topo, itens soltos (Painel,
/// Definições) e módulos agrupados por área em secções colapsáveis — só uma
/// aberta de cada vez. O grupo da rota actual abre-se automaticamente.
class AppSidebar extends StatefulWidget {
  const AppSidebar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
    this.width = appSidebarWidth,
  });

  final List<NavItem> items;

  /// Índice activo; `-1` quando a rota não pertence a nenhum item.
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Largura da coluna: [appSidebarWidth] ou [appSidebarWidthMedium].
  final double width;

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  late List<NavSection> _sections = buildNavSections(widget.items);

  /// Rótulo do grupo aberto; `null` com todos fechados.
  String? _open;

  @override
  void initState() {
    super.initState();
    _open = navGroupLabelFor(_sections, widget.selectedIndex);
  }

  @override
  void didUpdateWidget(AppSidebar old) {
    super.didUpdateWidget(old);
    final itemsChanged = !identical(old.items, widget.items);
    if (itemsChanged) _sections = buildNavSections(widget.items);
    if (itemsChanged || old.selectedIndex != widget.selectedIndex) {
      // Navegar para fora do grupo aberto (breadcrumb, pesquisa global, deep
      // link) revela o grupo da nova rota.
      final group = navGroupLabelFor(_sections, widget.selectedIndex);
      if (group != null && group != _open) _open = group;
    }
  }

  void _toggle(String label) =>
      setState(() => _open = _open == label ? null : label);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: ColoredBox(
        color: Theme.of(context).extension<AppColors>()!.sidebarBackground,
        child: Semantics(
          container: true,
          label: 'Menu principal',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _Brand(),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm,
                  ),
                  itemCount: _sections.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.xs),
                  itemBuilder: (context, i) => switch (_sections[i]) {
                    final NavLink l => _SidebarTile(
                      item: l.item,
                      selected: l.index == widget.selectedIndex,
                      onTap: () => widget.onSelected(l.index),
                    ),
                    final NavGroup g => _SidebarGroup(
                      group: g,
                      expanded: _open == g.label,
                      selectedIndex: widget.selectedIndex,
                      onToggle: () => _toggle(g.label),
                      onSelected: widget.onSelected,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Brand extends StatelessWidget {
  const _Brand();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          // Marca com tokens (claro/escuro). TODO(#200): trocar pelo
          // `symbol.svg` quando o `flutter_svg` entrar; o `symbol.png` actual
          // está mal recortado (desenho num canto de 512²).
          ExcludeSemantics(
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(AppRadius.card),
              ),
              child: SizedBox.square(
                dimension: 36,
                child: Icon(Icons.school, color: scheme.onPrimary, size: 22),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Flexible(
            child: Text(
              'ERP-Global',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cabeçalho de grupo (ícone, rótulo, chevron) com os filhos revelados por
/// animação ao expandir.
class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({
    required this.group,
    required this.expanded,
    required this.selectedIndex,
    required this.onToggle,
    required this.onSelected,
  });

  final NavGroup group;
  final bool expanded;
  final int selectedIndex;
  final VoidCallback onToggle;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final hasSelected = group.links.any((l) => l.index == selectedIndex);
    // Fechado com a rota actual lá dentro: o cabeçalho herda o destaque.
    final highlight = hasSelected && !expanded;
    final fg = highlight ? scheme.primary : scheme.onSurface;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          button: true,
          expanded: expanded,
          child: Material(
            color: highlight
                ? scheme.primary.withValues(alpha: 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppRadius.card),
            child: InkWell(
              onTap: onToggle,
              borderRadius: BorderRadius.circular(AppRadius.card),
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTouchTarget,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Row(
                    children: [
                      Icon(group.icon, size: 22, color: fg),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          group.label,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                color: fg,
                                fontWeight: highlight || expanded
                                    ? FontWeight.w600
                                    : null,
                              ),
                        ),
                      ),
                      ExcludeSemantics(
                        child: AnimatedRotation(
                          turns: expanded ? 0.5 : 0,
                          duration: AppMotion.micro,
                          curve: AppMotion.curve,
                          child: Icon(
                            Icons.expand_more,
                            size: 20,
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedSize(
          duration: AppMotion.standard,
          curve: AppMotion.curve,
          alignment: Alignment.topCenter,
          child: expanded
              ? Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final l in group.links)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: AppSpacing.md,
                            bottom: AppSpacing.xs,
                          ),
                          child: _SidebarTile(
                            item: l.item,
                            selected: l.index == selectedIndex,
                            onTap: () => onSelected(l.index),
                            dense: true,
                          ),
                        ),
                    ],
                  ),
                )
              : const SizedBox(width: double.infinity),
        ),
      ],
    );
  }
}

class _SidebarTile extends StatelessWidget {
  const _SidebarTile({
    required this.item,
    required this.selected,
    required this.onTap,
    this.dense = false,
  });

  final NavItem item;
  final bool selected;
  final VoidCallback onTap;

  /// Filho de grupo: ícone e altura ligeiramente menores.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final fg = selected ? scheme.onPrimary : scheme.onSurfaceVariant;
    return Semantics(
      selected: selected,
      button: true,
      child: Material(
        color: selected ? scheme.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.card),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: dense ? 40 : AppSizes.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Row(
                children: [
                  Icon(item.icon, size: dense ? 20 : 22, color: fg),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Text(
                      item.label,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: selected ? fg : scheme.onSurface,
                        fontWeight: selected ? FontWeight.w600 : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
