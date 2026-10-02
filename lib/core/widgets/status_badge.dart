import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_tokens.dart';

enum BadgeStatus { success, warning, danger, info, neutral }

/// Selo de estado (ex.: Pago, Pendente). Cor e texto — nunca só cor.
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.label, required this.status});

  final String label;
  final BadgeStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      BadgeStatus.success => (colors.success, colors.onSuccess),
      BadgeStatus.warning => (colors.warning, colors.onWarning),
      BadgeStatus.danger => (colors.danger, colors.onDanger),
      BadgeStatus.info => (colors.info, colors.onInfo),
      BadgeStatus.neutral => (
        scheme.surfaceContainerHighest,
        scheme.onSurfaceVariant,
      ),
    };
    return DecoratedBox(
      key: const Key('status_badge_box'),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppRadius.modal),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
        ),
      ),
    );
  }
}
