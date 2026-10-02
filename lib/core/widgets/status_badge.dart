import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_tokens.dart';

enum BadgeStatus { success, warning, danger, info, neutral }

/// Selo de estado (ex.: Pago, Pendente). Estilo tonal: fundo suave, ponto e
/// texto na cor semântica (contraste AA) — cor e texto, nunca só cor.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.status});

  final String label;
  final BadgeStatus status;

  /// Cor semântica (texto e ponto) do [status] no tema actual.
  static Color colorOf(BuildContext context, BadgeStatus status) {
    final colors = context.appColors;
    return switch (status) {
      BadgeStatus.success => colors.success,
      BadgeStatus.warning => colors.warning,
      BadgeStatus.danger => colors.danger,
      BadgeStatus.info => colors.info,
      BadgeStatus.neutral => Theme.of(context).colorScheme.onSurfaceVariant,
    };
  }

  @override
  Widget build(BuildContext context) {
    final fg = colorOf(context, status);
    return DecoratedBox(
      key: const Key('status_badge_box'),
      decoration: BoxDecoration(
        color: fg.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.modal),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(child: Icon(Icons.circle, size: 8, color: fg)),
            const SizedBox(width: AppSpacing.sm),
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: fg,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
