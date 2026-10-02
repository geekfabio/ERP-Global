import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import 'app_avatar.dart';

/// Avatar (foto ou iniciais) + nome, para células de tabela e listas de
/// pessoas (alunos, encarregados, funcionários).
class PersonLabel extends StatelessWidget {
  const PersonLabel({
    super.key,
    required this.name,
    this.photoUrl,
    this.avatarRadius = 18,
  });

  final String name;
  final String? photoUrl;
  final double avatarRadius;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      // O nome já é lido a seguir; o avatar não o repete.
      ExcludeSemantics(
        child: AppAvatar(name: name, imageUrl: photoUrl, radius: avatarRadius),
      ),
      const SizedBox(width: AppSpacing.md),
      Flexible(
        child: Text(
          name,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
    ],
  );
}
