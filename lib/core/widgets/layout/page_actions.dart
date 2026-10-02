import 'package:flutter/material.dart';

/// Acção de cabeçalho de página. Quem a cria decide se aparece (licença e
/// permissões); o componente só a apresenta.
class PageAction {
  const PageAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.primary = false,
    this.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  /// Acção principal da página (botão cheio); as restantes têm contorno.
  final bool primary;
  final Key? key;
}

/// Botão de uma [PageAction]: cheio se principal, com contorno caso contrário.
class PageActionButton extends StatelessWidget {
  const PageActionButton(this.action, {super.key});

  final PageAction action;

  @override
  Widget build(BuildContext context) => action.primary
      ? FilledButton.icon(
          key: action.key,
          onPressed: action.onPressed,
          icon: Icon(action.icon),
          label: Text(action.label),
        )
      : OutlinedButton.icon(
          key: action.key,
          onPressed: action.onPressed,
          icon: Icon(action.icon),
          label: Text(action.label),
        );
}

/// Menu "⋯" com acções secundárias da página.
class OverflowActionsMenu extends StatelessWidget {
  const OverflowActionsMenu({
    super.key,
    required this.actions,
    this.tooltip = 'Mais acções',
  });

  final List<PageAction> actions;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    if (actions.isEmpty) return const SizedBox.shrink();
    return PopupMenuButton<int>(
      tooltip: tooltip,
      icon: const Icon(Icons.more_horiz),
      style: IconButton.styleFrom(
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      onSelected: (i) => actions[i].onPressed(),
      itemBuilder: (_) => [
        for (final (i, a) in actions.indexed)
          PopupMenuItem(
            key: a.key,
            value: i,
            child: ListTile(leading: Icon(a.icon), title: Text(a.label)),
          ),
      ],
    );
  }
}
