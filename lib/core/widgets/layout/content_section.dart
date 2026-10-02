import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

/// Bloco de conteúdo com título opcional (cabeçalho para leitores de ecrã).
class ContentSection extends StatelessWidget {
  const ContentSection({super.key, required this.child, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      if (title != null)
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Semantics(
            header: true,
            child: Text(title!, style: Theme.of(context).textTheme.titleMedium),
          ),
        ),
      child,
    ],
  );
}
