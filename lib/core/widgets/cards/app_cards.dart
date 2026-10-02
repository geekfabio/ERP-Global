import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';

export 'kpi_card.dart';

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
