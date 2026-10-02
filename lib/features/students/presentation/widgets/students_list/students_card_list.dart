import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/app_avatar.dart';
import '../../../data/models/student_model.dart';
import '../student_display.dart';
import 'student_row_menu.dart';

/// Lista de alunos para espaço estreito: avatar, nome, processo · data de
/// nascimento e estado, separados por divisórias.
class StudentsCardList extends StatelessWidget {
  const StudentsCardList({
    super.key,
    required this.students,
    required this.onDelete,
  });

  final List<StudentModel> students;
  final ValueChanged<StudentModel> onDelete;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Column(
      children: [
        for (final (i, s) in students.indexed) ...[
          if (i > 0) const Divider(height: 1),
          ListTile(
            onTap: () => context.go('/students/${s.id}'),
            minTileHeight: 72,
            leading: AppAvatar(name: s.fullName, imageUrl: s.photoUrl),
            title: Text(s.fullName),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    '${s.processNumber} · ${PtAoFormatters.date(s.birthDate)}',
                    style: TextStyle(color: muted),
                  ),
                  StudentStatusBadge(s.status),
                ],
              ),
            ),
            trailing: StudentRowMenu(student: s, onDelete: onDelete),
          ),
        ],
      ],
    );
  }
}
