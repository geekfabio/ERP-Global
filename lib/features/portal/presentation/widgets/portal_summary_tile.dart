import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';

/// Cartão de resumo da Home do portal (um por módulo licenciado).
class PortalSummaryTile extends StatelessWidget {
  const PortalSummaryTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.caption,
  });

  final IconData icon;
  final String label;
  final String value;
  final String? caption;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Semantics(
          label: '$label: $value${caption == null ? '' : ', $caption'}',
          child: ExcludeSemantics(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(child: Text(label, style: text.labelLarge)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(value, style: text.headlineMedium),
                if (caption != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(caption!, style: text.bodySmall),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
