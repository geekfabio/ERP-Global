import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../data/models/portal_models.dart';

/// Selector de educando (multi-educando). Com um só educando não aparece.
class PupilSelector extends StatelessWidget {
  const PupilSelector({
    super.key,
    required this.pupils,
    required this.selectedId,
    required this.onSelected,
  });

  final List<PortalPupil> pupils;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    if (pupils.length < 2) return const SizedBox.shrink();
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: [
        for (final p in pupils)
          ChoiceChip(
            avatar: AppAvatar(name: p.student.fullName, radius: 12),
            label: Text(p.student.fullName),
            selected: p.student.id == selectedId,
            onSelected: (_) => onSelected(p.student.id),
          ),
      ],
    );
  }
}
