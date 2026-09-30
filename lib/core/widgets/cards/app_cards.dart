import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';

/// Indicador com contagem animada e variação face ao período anterior.
/// A animação é omitida quando `MediaQuery.disableAnimations` está activo.
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.format,
    this.deltaPercent,
    this.icon,
  });

  final String label;

  /// Valor inteiro (ex.: cêntimos ou contagem); [format] apresenta-o.
  final int value;
  final String Function(int value)? format;

  /// Variação em %; positiva = verde, negativa = vermelha.
  final double? deltaPercent;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final animate = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    final show = format ?? (v) => '$v';
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                ],
                Expanded(child: Text(label, style: text.labelLarge)),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: animate ? 0 : value, end: value),
              duration: animate ? AppMotion.page : Duration.zero,
              curve: AppMotion.curve,
              builder: (_, v, _) => Semantics(
                label: '$label: ${show(value)}',
                child: ExcludeSemantics(
                  child: Text(show(v), style: text.headlineMedium),
                ),
              ),
            ),
            if (deltaPercent != null) ...[
              const SizedBox(height: AppSpacing.xs),
              _Delta(deltaPercent!),
            ],
          ],
        ),
      ),
    );
  }
}

class _Delta extends StatelessWidget {
  const _Delta(this.percent);

  final double percent;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final up = percent >= 0;
    final color = up ? colors.success : colors.danger;
    final sign = up ? '+' : '';
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          up ? Icons.arrow_upward : Icons.arrow_downward,
          size: 14,
          color: color,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '$sign${percent.toStringAsFixed(1).replaceAll('.', ',')}%',
          style: Theme.of(
            context,
          ).textTheme.labelMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}

/// Cartão de entidade (aluno, turma, funcionário…): avatar/ícone, título, subtítulo, acção.
class EntityCard extends StatelessWidget {
  const EntityCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: ListTile(
      leading: leading,
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      trailing: trailing,
      onTap: onTap,
      minTileHeight: AppSizes.minTouchTarget,
    ),
  );
}

/// Cartão com título e uma lista de linhas (ex.: últimos pagamentos).
class ListCard extends StatelessWidget {
  const ListCard({
    super.key,
    required this.title,
    required this.children,
    this.emptyText = 'Sem registos',
  });

  final String title;
  final List<Widget> children;
  final String emptyText;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            if (children.isEmpty) Text(emptyText, style: text.bodyMedium),
            ...children,
          ],
        ),
      ),
    );
  }
}
