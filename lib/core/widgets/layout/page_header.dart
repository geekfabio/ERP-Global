import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Cabeçalho de página: título, subtítulo opcional e acções. Em espaço
/// estreito as acções passam para baixo do título (sem overflow).
class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.overline,
    this.actions = const [],
  });

  final String title;
  final String? subtitle;

  /// Linha pequena acima do título (ex.: a data de hoje).
  final String? overline;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (overline != null)
          Text(overline!, style: text.bodyMedium?.copyWith(color: muted)),
        Semantics(
          header: true,
          child: Text(
            title,
            style: text.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(
              subtitle!,
              style: text.bodyLarge?.copyWith(color: muted),
            ),
          ),
      ],
    );
    final buttons = Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: actions,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        if (actions.isEmpty) return heading;
        if (constraints.maxWidth < AppBreakpoints.expanded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              heading,
              const SizedBox(height: AppSpacing.md),
              buttons,
            ],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(child: heading),
            const SizedBox(width: AppSpacing.lg),
            buttons,
          ],
        );
      },
    );
  }
}
