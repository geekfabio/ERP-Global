import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../app/theme/theme_providers.dart';
import '../../academic/period_context.dart';
import '../../security/session_actions.dart';
import '../../sync/sync_indicator.dart';
import '../app_avatar.dart';

/// Barra superior: pesquisa global, período, notificações e menu do utilizador.
class AppTopbar extends ConsumerWidget implements PreferredSizeWidget {
  const AppTopbar({super.key, this.leading, this.compact = false});

  final Widget? leading;
  final bool compact;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(effectivePeriodProvider);
    final years = ref.watch(periodChoicesProvider).value?.years ?? const [];
    return AppBar(
      leading: leading,
      automaticallyImplyLeading: false,
      titleSpacing: AppSpacing.lg,
      title: compact
          ? const Text('ERP-Global')
          : ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: const SearchBar(
                hintText: 'Pesquisar alunos, turmas, facturas…',
                leading: Icon(Icons.search),
                elevation: WidgetStatePropertyAll(AppElevation.none),
                constraints: BoxConstraints(
                  minHeight: AppSizes.minTouchTarget,
                  maxHeight: AppSizes.minTouchTarget,
                ),
              ),
            ),
      actions: [
        if (compact)
          IconButton(
            tooltip: 'Pesquisar',
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        // Em ecrã compacto o espaço vai para o indicador de sync (o trimestre
        // já estava escondido).
        if (!compact && period.year != null)
          _PeriodMenu(
            tooltip: 'Ano lectivo',
            label: period.year!.label,
            options: {for (final y in years) y.id: y.label},
            onSelected: ref.read(periodProvider.notifier).setYear,
          ),
        if (!compact && period.term != null)
          _PeriodMenu(
            tooltip: 'Período',
            label: period.term!.label,
            options: {for (final t in period.year!.terms) t.id: t.label},
            onSelected: ref.read(periodProvider.notifier).setTerm,
          ),
        const SizedBox(width: AppSpacing.xs),
        SyncIndicator(compact: compact),
        // Em ecrã compacto o tema passa para o menu do utilizador.
        if (!compact) const _ThemeToggle(),
        IconButton(
          tooltip: 'Notificações',
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        _UserMenu(
          user: ref.watch(sessionUserProvider),
          showName: !compact,
          onToggleTheme: compact ? () => _toggleTheme(context, ref) : null,
          onLogout: ref.watch(sessionLogoutProvider),
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}

/// Menu do utilizador. "Terminar sessão" só existe com a sessão ligada ao
/// `core` (`sessionLogoutProvider`) e pede confirmação antes de sair.
class _UserMenu extends StatelessWidget {
  const _UserMenu({
    required this.user,
    required this.showName,
    required this.onLogout,
    this.onToggleTheme,
  });

  final SessionUser? user;
  final bool showName;
  final Future<void> Function()? onLogout;

  /// Alternar tema a partir do menu (ecrã compacto, sem botão na barra).
  final VoidCallback? onToggleTheme;

  Future<void> _confirmAndLogout(BuildContext context) async {
    final logout = onLogout;
    if (logout == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Terminar sessão'),
        content: const Text('Quer mesmo sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Terminar sessão'),
          ),
        ],
      ),
    );
    if (ok == true) await logout();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final u = user;
    return PopupMenuButton<String>(
      tooltip: 'Menu do utilizador',
      onSelected: (value) {
        if (value == 'logout') _confirmAndLogout(context);
        if (value == 'theme') onToggleTheme?.call();
      },
      itemBuilder: (_) => [
        if (onToggleTheme != null)
          PopupMenuItem(
            value: 'theme',
            child: ListTile(
              leading: Icon(
                dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
              ),
              title: Text(dark ? 'Usar tema claro' : 'Usar tema escuro'),
            ),
          ),
        if (onLogout != null)
          const PopupMenuItem(
            value: 'logout',
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('Terminar sessão'),
            ),
          ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            u == null
                ? const CircleAvatar(child: Icon(Icons.person_outline))
                : AppAvatar(name: u.name, radius: 18),
            if (showName && u != null) ...[
              const SizedBox(width: AppSpacing.sm),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 180),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      u.name,
                      style: text.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (u.roleLabel != null)
                      Text(
                        u.roleLabel!,
                        style: text.labelSmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const Icon(Icons.expand_more),
            ],
          ],
        ),
      ),
    );
  }
}

/// Alterna entre tema claro e escuro (a partir do tema em uso, mesmo que
/// venha do sistema).
class _ThemeToggle extends ConsumerWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return IconButton(
      tooltip: dark ? 'Usar tema claro' : 'Usar tema escuro',
      icon: Icon(dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined),
      onPressed: () => _toggleTheme(context, ref),
    );
  }
}

/// Passa para o tema oposto ao que está em uso (mesmo vindo do sistema).
void _toggleTheme(BuildContext context, WidgetRef ref) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  ref
      .read(themeModeProvider.notifier)
      .set(dark ? ThemeMode.light : ThemeMode.dark);
}

class _PeriodMenu extends StatelessWidget {
  const _PeriodMenu({
    required this.tooltip,
    required this.label,
    required this.options,
    required this.onSelected,
  });

  final String tooltip;
  final String label;
  final Map<String, String> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
    tooltip: tooltip,
    onSelected: onSelected,
    itemBuilder: (_) => [
      for (final o in options.entries)
        PopupMenuItem(value: o.key, child: Text(o.value)),
    ],
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: Theme.of(context).textTheme.labelLarge),
              const SizedBox(width: AppSpacing.xs),
              const Icon(Icons.expand_more, size: 18),
            ],
          ),
        ),
      ),
    ),
  );
}
