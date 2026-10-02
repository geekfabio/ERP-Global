import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Páginas a mostrar no paginador (1-based); `null` = reticências. Mostra
/// sempre a primeira, a última e as vizinhas da actual, em até [slots] posições.
List<int?> pageWindow(int current, int totalPages, {int slots = 7}) {
  List<int> range(int from, int to) => [for (var p = from; p <= to; p++) p];
  if (totalPages <= slots) return range(1, totalPages);
  // Perto do início: 1 2 3 4 5 … 15
  if (current <= slots - 3) return [...range(1, slots - 2), null, totalPages];
  // Perto do fim: 1 … 11 12 13 14 15
  if (current >= totalPages - (slots - 4)) {
    return [1, null, ...range(totalPages - (slots - 3), totalPages)];
  }
  // No meio: 1 … 7 8 9 … 15
  final side = (slots - 5) ~/ 2;
  return [1, null, ...range(current - side, current + side), null, totalPages];
}

/// Paginação de listagens: "A mostrar 1–20 de 300 alunos", itens por página
/// e páginas numeradas. Em ecrã estreito fica só anterior/seguinte.
class AppPaginator extends StatelessWidget {
  const AppPaginator({
    super.key,
    required this.page,
    required this.pageSize,
    required this.total,
    required this.onPage,
    this.onPageSize,
    this.itemLabel = 'registos',
    this.pageSizes = const [10, 20, 50, 100],
  });

  /// Página actual (1-based).
  final int page;
  final int pageSize;
  final int total;
  final ValueChanged<int> onPage;
  final ValueChanged<int>? onPageSize;

  /// Nome dos itens no plural (ex.: "alunos").
  final String itemLabel;
  final List<int> pageSizes;

  int get totalPages => total == 0 ? 1 : (total + pageSize - 1) ~/ pageSize;

  /// Texto do resumo; público para testes e leitores de ecrã.
  String get summary {
    if (total == 0) return '0 $itemLabel';
    final first = (page - 1) * pageSize + 1;
    final last = (page * pageSize).clamp(0, total);
    return 'A mostrar $first–$last de $total $itemLabel';
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final pages = totalPages;
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= AppBreakpoints.medium;
        return Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.sm,
          children: [
            Text(summary, style: text.bodyMedium?.copyWith(color: muted)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onPageSize != null && wide) ...[
                  Text(
                    'Itens por página',
                    style: text.bodyMedium?.copyWith(color: muted),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  DropdownButton<int>(
                    value: pageSizes.contains(pageSize) ? pageSize : null,
                    underline: const SizedBox.shrink(),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                    items: [
                      for (final s in pageSizes)
                        DropdownMenuItem(value: s, child: Text('$s')),
                    ],
                    onChanged: (v) => v == null ? null : onPageSize!(v),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                ],
                IconButton.outlined(
                  tooltip: 'Página anterior',
                  icon: const Icon(Icons.chevron_left),
                  onPressed: page > 1 ? () => onPage(page - 1) : null,
                ),
                const SizedBox(width: AppSpacing.xs),
                if (wide)
                  for (final p in pageWindow(page, pages))
                    p == null
                        ? const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppSpacing.sm,
                            ),
                            child: ExcludeSemantics(child: Text('…')),
                          )
                        : _PageButton(
                            page: p,
                            current: p == page,
                            onTap: () => onPage(p),
                          )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                    ),
                    child: Text('$page / $pages'),
                  ),
                const SizedBox(width: AppSpacing.xs),
                IconButton.outlined(
                  tooltip: 'Página seguinte',
                  icon: const Icon(Icons.chevron_right),
                  onPressed: page < pages ? () => onPage(page + 1) : null,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({
    required this.page,
    required this.current,
    required this.onTap,
  });

  final int page;
  final bool current;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = Text('$page');
    const size = Size.square(AppSizes.minTouchTarget);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs / 2),
      child: Semantics(
        selected: current,
        label: 'Página $page',
        excludeSemantics: true,
        button: true,
        child: current
            ? FilledButton(
                style: FilledButton.styleFrom(
                  minimumSize: size,
                  padding: EdgeInsets.zero,
                ),
                onPressed: onTap,
                child: label,
              )
            : TextButton(
                style: TextButton.styleFrom(
                  minimumSize: size,
                  padding: EdgeInsets.zero,
                ),
                onPressed: onTap,
                child: label,
              ),
      ),
    );
  }
}
