import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Moldura de um gráfico: título (cabeçalho acessível), subtítulo com a
/// unidade/período, legenda opcional à direita e o gráfico por baixo.
class ChartCard extends StatelessWidget {
  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.subtitle,
    this.legend,
  });

  final String title;
  final String? subtitle;

  /// Normalmente uma `Wrap` de [ChartLegendKey] (≥ 2 séries).
  final Widget? legend;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.sm,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Semantics(
                      header: true,
                      child: Text(title, style: text.titleMedium),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        style: text.bodySmall?.copyWith(color: muted),
                      ),
                  ],
                ),
                ?legend,
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            child,
          ],
        ),
      ),
    );
  }
}

/// Entrada da legenda: amostra de linha (sólida ou tracejada) + texto. O
/// tracejado dá uma segunda pista além da cor; o texto usa a cor do tema.
class ChartLegendKey extends StatelessWidget {
  const ChartLegendKey({
    super.key,
    required this.label,
    required this.color,
    this.dashed = false,
  });

  final String label;
  final Color color;
  final bool dashed;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < (dashed ? 3 : 1); i++) ...[
              if (i > 0) const SizedBox(width: 2),
              SizedBox(
                width: dashed ? 6 : 22,
                height: 3,
                child: ColoredBox(color: color),
              ),
            ],
          ],
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Text(label, style: Theme.of(context).textTheme.labelMedium),
    ],
  );
}
