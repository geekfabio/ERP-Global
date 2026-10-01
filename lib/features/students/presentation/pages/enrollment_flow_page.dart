import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/enrollment_rules_model.dart';
import '../../data/models/student_enums.dart';
import '../../domain/enrollment_flow.dart';
import '../providers/enrollment_flow_providers.dart';
import '../providers/student_file_providers.dart';
import '../providers/student_providers.dart';
import '../widgets/student_file/student_labels.dart';

const enrollmentUpdatePermission = 'students.record.update';

BadgeStatus _badge(EnrollmentStatus s) => switch (s) {
  EnrollmentStatus.confirmed ||
  EnrollmentStatus.completed => BadgeStatus.success,
  EnrollmentStatus.application ||
  EnrollmentStatus.underReview ||
  EnrollmentStatus.approved => BadgeStatus.warning,
  EnrollmentStatus.rejected || EnrollmentStatus.cancelled => BadgeStatus.danger,
};

String _advanceLabel(EnrollmentStatus next) => switch (next) {
  EnrollmentStatus.underReview => 'Iniciar análise',
  EnrollmentStatus.approved => 'Aprovar',
  EnrollmentStatus.confirmed => 'Confirmar',
  _ => enrollmentStatusLabel(next),
};

/// Fila de matrículas: candidatura → em análise → aprovada → confirmada, com
/// regras (idade, documentos, vagas) validadas pelo servidor e atribuição de
/// turma.
class EnrollmentFlowPage extends ConsumerWidget {
  const EnrollmentFlowPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final queue = ref.watch(enrollmentQueueProvider);
    final filter = ref.watch(enrollmentStatusFilterProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Matrículas',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Can(
                  permission: enrollmentUpdatePermission,
                  child: AppButton(
                    label: 'Regras',
                    icon: Icons.rule,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => _editRules(context, ref),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              children: [
                ChoiceChip(
                  key: const Key('enrollment_filter_all'),
                  label: const Text('Todas'),
                  selected: filter == null,
                  onSelected: (_) => ref
                      .read(enrollmentStatusFilterProvider.notifier)
                      .set(null),
                ),
                for (final s in EnrollmentStatus.values)
                  ChoiceChip(
                    key: Key('enrollment_filter_${s.name}'),
                    label: Text(enrollmentStatusLabel(s)),
                    selected: filter == s,
                    onSelected: (_) => ref
                        .read(enrollmentStatusFilterProvider.notifier)
                        .set(s),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: AsyncValueView(
                value: queue,
                onRetry: () => ref.invalidate(enrollmentQueueProvider),
                isEmpty: (p) => p.items.isEmpty,
                empty: const EmptyState(
                  icon: Icons.assignment_outlined,
                  title: 'Sem matrículas',
                  message: 'Não há matrículas neste estado.',
                ),
                data: (page) => ListView.separated(
                  itemCount: page.items.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (_, i) => _EnrollmentRow(page.items[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _editRules(BuildContext context, WidgetRef ref) async {
  final current =
      (await ref.read(enrollmentRulesRepositoryProvider).get()).valueOrNull;
  if (current == null || !context.mounted) return;
  final age = TextEditingController(text: '${current.minAgeYears}');
  final capacity = TextEditingController(
    text: '${current.capacityPerClassroom}',
  );
  var verified = current.requireVerifiedDocuments;
  final toast = ref.read(toastProvider.notifier);
  final repo = ref.read(enrollmentRulesRepositoryProvider);
  final container = ref.container;
  await showAppDialog<void>(
    context: context,
    title: 'Regras de matrícula',
    content: StatefulBuilder(
      builder: (context, setState) => SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const Key('rule_min_age'),
              controller: age,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Idade mínima (anos)',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            TextField(
              key: const Key('rule_capacity'),
              controller: capacity,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Vagas por turma (0 = sem limite)',
              ),
            ),
            SwitchListTile(
              title: const Text('Exigir documentos verificados'),
              value: verified,
              onChanged: (v) => setState(() => verified = v),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('rule_save'),
        onPressed: () async {
          final result = await repo.save(
            current.copyWith(
              minAgeYears: int.tryParse(age.text) ?? current.minAgeYears,
              capacityPerClassroom:
                  int.tryParse(capacity.text) ?? current.capacityPerClassroom,
              requireVerifiedDocuments: verified,
            ),
          );
          result.when(
            ok: (_) {
              toast.success('Regras guardadas');
              container.invalidate(enrollmentRulesProvider);
              if (context.mounted) Navigator.of(context).pop();
            },
            err: (f) => toast.error(_message(f)),
          );
        },
        child: const Text('Guardar'),
      ),
    ],
  );
}

String _message(Failure f) => switch (f) {
  ValidationFailure(:final fields) when fields.isNotEmpty => fields.values.join(
    '\n',
  ),
  _ => f.message,
};

class _EnrollmentRow extends ConsumerWidget {
  const _EnrollmentRow(this.enrollment);

  final EnrollmentModel enrollment;

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    EnrollmentStatus to,
  ) async {
    var room = enrollment.classroomId;
    if (to == EnrollmentStatus.confirmed && room == null) {
      room = await _pickClassroom(context, ref, enrollment);
      if (room == null) return;
    }
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final result = await ref
        .read(enrollmentWorkflowProvider)
        .transition(enrollment.id, to, classroomId: room);
    result.when(
      ok: (e) {
        toast.success('Matrícula: ${enrollmentStatusLabel(e.status)}');
        container.invalidate(enrollmentQueueProvider);
        container.invalidate(studentEnrollmentsProvider(e.studentId));
      },
      err: (f) => toast.error(_message(f)),
    );
  }

  Future<void> _assign(BuildContext context, WidgetRef ref) async {
    final room = await _pickClassroom(context, ref, enrollment);
    if (room == null) return;
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final result = await ref
        .read(enrollmentRepositoryProvider)
        .assignClassroom(enrollment.id, room);
    result.when(
      ok: (_) {
        toast.success('Turma atribuída');
        container.invalidate(enrollmentQueueProvider);
      },
      err: (f) => toast.error(_message(f)),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final student = ref.watch(studentProvider(enrollment.studentId));
    final next = nextEnrollmentStatus(enrollment.status);
    final name = student.maybeWhen(
      data: (s) => s.fullName,
      orElse: () => enrollment.studentId,
    );
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: Theme.of(context).textTheme.titleSmall),
                  Text(
                    '${enrollmentTypeLabel(enrollment.type)} · '
                    '${gradeLabelFor(enrollment.gradeId)} · '
                    '${classroomLabelFor(enrollment.gradeId, enrollment.classroomId)}',
                  ),
                ],
              ),
            ),
            StatusBadge(
              label: enrollmentStatusLabel(enrollment.status),
              status: _badge(enrollment.status),
            ),
            Can(
              permission: enrollmentUpdatePermission,
              child: Wrap(
                spacing: AppSpacing.sm,
                children: [
                  if (next != null)
                    AppButton(
                      key: Key('advance_${enrollment.id}'),
                      label: _advanceLabel(next),
                      onPressed: () => _run(context, ref, next),
                    ),
                  if (occupiesSeat(enrollment.status))
                    AppButton(
                      key: Key('assign_${enrollment.id}'),
                      label: 'Turma',
                      icon: Icons.groups_outlined,
                      variant: AppButtonVariant.secondary,
                      onPressed: () => _assign(context, ref),
                    ),
                  if (canTransitionEnrollment(
                    enrollment.status,
                    EnrollmentStatus.rejected,
                  ))
                    AppButton(
                      key: Key('reject_${enrollment.id}'),
                      label: 'Rejeitar',
                      variant: AppButtonVariant.secondary,
                      onPressed: () =>
                          _run(context, ref, EnrollmentStatus.rejected),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<String?> _pickClassroom(
  BuildContext context,
  WidgetRef ref,
  EnrollmentModel e,
) async {
  final vacancies = await ref
      .read(enrollmentRepositoryProvider)
      .vacancies(gradeId: e.gradeId, academicYearId: e.academicYearId);
  if (!context.mounted) return null;
  final list = vacancies.valueOrNull ?? const <ClassroomVacancy>[];
  return showAppDialog<String>(
    context: context,
    title: 'Atribuir turma',
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final v in list)
          ListTile(
            key: Key('room_${v.classroomId}'),
            enabled: v.hasRoom,
            title: Text(classroomLabelFor(e.gradeId, v.classroomId)),
            subtitle: Text(
              v.capacity == 0
                  ? '${v.occupied} alunos'
                  : '${v.occupied}/${v.capacity} lugares',
            ),
            onTap: () => Navigator.of(context).pop(v.classroomId),
          ),
      ],
    ),
  );
}
