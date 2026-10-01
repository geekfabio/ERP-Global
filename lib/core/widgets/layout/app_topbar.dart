import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../academic/period_context.dart';
import '../../sync/sync_indicator.dart';

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
        SyncIndicator(compact: compact),
        IconButton(
          tooltip: 'Notificações',
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
        PopupMenuButton<String>(
          tooltip: 'Menu do utilizador',
          icon: const CircleAvatar(child: Icon(Icons.person_outline)),
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'profile', child: Text('O meu perfil')),
            PopupMenuItem(value: 'logout', child: Text('Terminar sessão')),
          ],
        ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Text(label), const Icon(Icons.arrow_drop_down)],
      ),
    ),
  );
}
