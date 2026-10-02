import 'package:flutter/material.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../data/models/student_model.dart';
import 'students_card_list.dart';
import 'students_table.dart';

/// Resultados da página: tabela em espaço largo, lista em espaço estreito.
/// Decide pelo espaço disponível (não pelo dispositivo).
class StudentsResults extends StatelessWidget {
  const StudentsResults({
    super.key,
    required this.students,
    required this.onDelete,
  });

  final List<StudentModel> students;
  final ValueChanged<StudentModel> onDelete;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) =>
        constraints.maxWidth >= AppBreakpoints.medium
        ? StudentsTable(students: students, onDelete: onDelete)
        : StudentsCardList(students: students, onDelete: onDelete),
  );
}
