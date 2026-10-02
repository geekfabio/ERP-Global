import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/student_enums.dart';

/// Nome apresentado de cada estado do aluno.
String studentStatusLabel(StudentStatus s) => switch (s) {
  StudentStatus.active => 'Activo',
  StudentStatus.inactive => 'Inactivo',
  StudentStatus.suspended => 'Suspenso',
  StudentStatus.transferred => 'Transferido',
  StudentStatus.graduated => 'Concluído',
  StudentStatus.dropout => 'Desistente',
};

BadgeStatus studentStatusBadge(StudentStatus s) => switch (s) {
  StudentStatus.active => BadgeStatus.success,
  StudentStatus.inactive => BadgeStatus.neutral,
  StudentStatus.suspended => BadgeStatus.warning,
  StudentStatus.transferred || StudentStatus.graduated => BadgeStatus.info,
  StudentStatus.dropout => BadgeStatus.danger,
};

String genderLabel(Gender g) => g == Gender.male ? 'Masculino' : 'Feminino';

/// Selo do estado do aluno (cor e texto).
class StudentStatusBadge extends StatelessWidget {
  const StudentStatusBadge(this.status, {super.key});

  final StudentStatus status;

  @override
  Widget build(BuildContext context) => StatusBadge(
    label: studentStatusLabel(status),
    status: studentStatusBadge(status),
  );
}

/// Género com ícone (o ícone é decorativo; o texto é o que se lê).
class StudentGenderLabel extends StatelessWidget {
  const StudentGenderLabel(this.gender, {super.key});

  final Gender gender;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      ExcludeSemantics(
        child: Icon(
          gender == Gender.male ? Icons.male : Icons.female,
          size: 18,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      const SizedBox(width: AppSpacing.xs),
      Text(genderLabel(gender)),
    ],
  );
}
