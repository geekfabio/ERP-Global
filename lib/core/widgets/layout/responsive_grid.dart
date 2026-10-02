import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Grelha que ajusta o n.º de colunas ao espaço do pai (não ao dispositivo):
/// tantas colunas de pelo menos [minItemWidth] quantas couberem, até
/// [maxColumns], com as linhas equilibradas ([balancedColumns]). Os itens de
/// uma linha ficam com a mesma largura e altura.
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.children,
    this.minItemWidth = 240,
    this.maxColumns = 4,
    this.spacing = AppSpacing.lg,
  });

  final List<Widget> children;
  final double minItemWidth;
  final int maxColumns;
  final double spacing;

  /// Colunas para a largura [width] (pelo menos 1).
  static int columnsFor(
    double width, {
    double minItemWidth = 240,
    int maxColumns = 4,
    double spacing = AppSpacing.lg,
  }) => ((width + spacing) ~/ (minItemWidth + spacing)).clamp(1, maxColumns);

  /// Colunas a usar com [count] itens quando cabem [fit] por linha: se não
  /// cabem numa linha, reparte-os por igual (4 itens com 3 lugares → 2 + 2,
  /// não 3 + 1), para não deixar um cartão sozinho na última linha.
  static int balancedColumns(int fit, int count) {
    if (count <= fit) return fit;
    final rows = (count + fit - 1) ~/ fit;
    return (count + rows - 1) ~/ rows;
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final columns = balancedColumns(
        columnsFor(
          constraints.maxWidth,
          minItemWidth: minItemWidth,
          maxColumns: maxColumns,
          spacing: spacing,
        ),
        children.length,
      );
      // Linhas com a mesma altura: os cartões de uma linha alinham-se
      // mesmo quando uns têm barra de progresso e outros não.
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var start = 0; start < children.length; start += columns) ...[
            if (start > 0) SizedBox(height: spacing),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (var i = start; i < start + columns; i++) ...[
                    if (i > start) SizedBox(width: spacing),
                    Expanded(
                      child: i < children.length
                          ? children[i]
                          : const SizedBox.shrink(),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      );
    },
  );
}
