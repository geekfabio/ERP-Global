import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/security/permission_providers.dart';
import '../../../data/models/student_model.dart';

/// Menu "⋮" de um aluno: ver ficha e, com permissão, remover.
class StudentRowMenu extends ConsumerWidget {
  const StudentRowMenu({
    super.key,
    required this.student,
    required this.onDelete,
  });

  final StudentModel student;
  final ValueChanged<StudentModel> onDelete;

  @override
  Widget build(BuildContext context, WidgetRef ref) => PopupMenuButton<String>(
    tooltip: 'Acções',
    itemBuilder: (_) {
      // Chamado fora do `build`: lê, não observa.
      final can = ref.read(permissionServiceProvider);
      return [
        const PopupMenuItem(
          value: 'view',
          child: ListTile(
            leading: Icon(Icons.badge_outlined),
            title: Text('Ver ficha'),
          ),
        ),
        if (can.canAny('students.record.delete'))
          const PopupMenuItem(
            value: 'delete',
            child: ListTile(
              leading: Icon(Icons.delete_outline),
              title: Text('Remover'),
            ),
          ),
      ];
    },
    onSelected: (v) {
      if (v == 'view') context.go('/students/${student.id}');
      if (v == 'delete') onDelete(student);
    },
  );
}
