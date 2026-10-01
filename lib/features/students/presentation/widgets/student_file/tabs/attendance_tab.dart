import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/cards/app_cards.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/student_model.dart';
import '../../../../data/models/student_summaries_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';

String attendanceLabel(AttendanceKind k) => switch (k) {
  AttendanceKind.present => 'Presente',
  AttendanceKind.justified => 'Falta justificada',
  AttendanceKind.unjustified => 'Falta injustificada',
  AttendanceKind.late => 'Atraso',
};

BadgeStatus attendanceBadge(AttendanceKind k) => switch (k) {
  AttendanceKind.present => BadgeStatus.success,
  AttendanceKind.justified => BadgeStatus.info,
  AttendanceKind.unjustified => BadgeStatus.danger,
  AttendanceKind.late => BadgeStatus.warning,
};

/// Separador 7 — Assiduidade (módulo `attendance`): totais e últimos registos.
class AttendanceTab extends ConsumerWidget {
  const AttendanceTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueView<StudentAttendanceSummary>(
        value: ref.watch(studentAttendanceProvider(student.id)),
        onRetry: () => ref.invalidate(studentAttendanceProvider(student.id)),
        isEmpty: (d) => d.records.isEmpty,
        loading: const SkeletonCard(),
        empty: const EmptyState(
          icon: Icons.fact_check_outlined,
          title: 'Sem registos',
          message: 'Ainda não há presenças lançadas para este aluno.',
        ),
        data: (a) {
          final counts = attendanceCounts(a.records);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final k in AttendanceKind.values)
                    SizedBox(
                      width: 200,
                      child: KpiCard(
                        label: attendanceLabel(k),
                        value: counts[k] ?? 0,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              for (final r in a.records.take(20))
                ListTile(
                  dense: true,
                  title: Text(PtAoFormatters.date(r.date)),
                  trailing: StatusBadge(
                    label: attendanceLabel(r.kind),
                    status: attendanceBadge(r.kind),
                  ),
                ),
            ],
          );
        },
      );
}
