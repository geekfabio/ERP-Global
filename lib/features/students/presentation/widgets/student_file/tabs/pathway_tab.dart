import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/enrollment_model.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';
import '../editable_section.dart';
import '../student_labels.dart';

/// Separador 4 — Percurso académico: escola de origem e histórico de matrículas
/// por ano lectivo, com transferências e repetências assinaladas.
class PathwayTab extends ConsumerWidget {
  const PathwayTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollments = ref.watch(studentEnrollmentsProvider(student.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: FieldRow(
              label: 'Escola de origem',
              value: student.originSchool,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AsyncValueView<List<EnrollmentModel>>(
          value: enrollments,
          onRetry: () => ref.invalidate(studentEnrollmentsProvider(student.id)),
          isEmpty: (d) => d.isEmpty,
          loading: const SkeletonCard(),
          empty: const EmptyState(
            icon: Icons.timeline_outlined,
            title: 'Sem percurso',
            message: 'Este aluno ainda não tem matrículas registadas.',
          ),
          data: (items) {
            final repeated = repeatedEnrollmentIds(items);
            return Column(
              children: [
                for (final e in items)
                  _EnrollmentRow(
                    enrollment: e,
                    repeated: repeated.contains(e.id),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _EnrollmentRow extends StatelessWidget {
  const _EnrollmentRow({required this.enrollment, required this.repeated});

  final EnrollmentModel enrollment;
  final bool repeated;

  @override
  Widget build(BuildContext context) {
    final e = enrollment;
    final text = Theme.of(context).textTheme;
    return Card(
      child: ListTile(
        key: Key('pathway_${e.id}'),
        leading: const Icon(Icons.school_outlined),
        title: Text(
          '${academicYearLabelFor(e.academicYearId)} · '
          '${gradeLabelFor(e.gradeId)}',
          style: text.titleMedium,
        ),
        subtitle: Text(
          '${enrollmentTypeLabel(e.type)} · '
          '${PtAoFormatters.date(e.enrolledOn)}',
        ),
        trailing: Wrap(
          spacing: AppSpacing.sm,
          children: [
            if (repeated)
              const StatusBadge(
                label: 'Repetência',
                status: BadgeStatus.warning,
              ),
            if (e.type == EnrollmentType.transfer)
              const StatusBadge(
                label: 'Transferência',
                status: BadgeStatus.info,
              ),
            StatusBadge(
              label: enrollmentStatusLabel(e.status),
              status: switch (e.status) {
                EnrollmentStatus.confirmed ||
                EnrollmentStatus.completed => BadgeStatus.success,
                EnrollmentStatus.application ||
                EnrollmentStatus.underReview ||
                EnrollmentStatus.approved => BadgeStatus.warning,
                EnrollmentStatus.rejected ||
                EnrollmentStatus.cancelled => BadgeStatus.danger,
              },
            ),
          ],
        ),
      ),
    );
  }
}
