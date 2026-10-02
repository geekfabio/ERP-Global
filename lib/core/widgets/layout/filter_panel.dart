import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Cartão de pesquisa + filtros de uma listagem. Em espaço largo fica numa
/// linha que quebra; em espaço estreito os filtros recolhem-se atrás de
/// "Filtros (n)" para a lista não ficar fora do ecrã.
class FilterPanel extends StatefulWidget {
  const FilterPanel({
    super.key,
    required this.search,
    required this.filters,
    this.activeCount = 0,
    this.onClear,
    this.searchWidth = 340,
    this.filterWidth = 200,
  });

  /// Campo de pesquisa (ocupa a largura toda em espaço estreito).
  final Widget search;

  /// Constrói os selectores com a largura a usar (`null` = largura toda).
  final List<Widget> Function(double? width) filters;

  /// Filtros activos (mostrado no botão quando recolhido).
  final int activeCount;

  /// "Limpar filtros"; `null` esconde o botão (nada para limpar).
  final VoidCallback? onClear;
  final double searchWidth;
  final double filterWidth;

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final clear = widget.onClear == null
        ? null
        : TextButton.icon(
            onPressed: widget.onClear,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Limpar filtros'),
          );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= AppBreakpoints.medium) {
              return Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(width: widget.searchWidth, child: widget.search),
                  ...widget.filters(widget.filterWidth),
                  ?clear,
                ],
              );
            }
            final n = widget.activeCount;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                widget.search,
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton.icon(
                      key: const Key('toggle_filters'),
                      onPressed: () => setState(() => _expanded = !_expanded),
                      icon: Icon(
                        _expanded ? Icons.expand_less : Icons.tune_outlined,
                      ),
                      label: Text(n == 0 ? 'Filtros' : 'Filtros ($n)'),
                    ),
                    ?clear,
                  ],
                ),
                if (_expanded)
                  for (final f in widget.filters(null)) ...[
                    const SizedBox(height: AppSpacing.md),
                    f,
                  ],
              ],
            );
          },
        ),
      ),
    );
  }
}
