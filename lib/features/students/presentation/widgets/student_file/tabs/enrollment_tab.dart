import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/feedback/toasts.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../data/models/enrollment_model.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';
import '../../../providers/student_providers.dart';
import '../editable_section.dart';
import '../student_labels.dart';

/// Separador 5 — Matrícula actual: classe, turma, turno, estado e n.º de chamada.
/// A classe e o ano só mudam por nova matrícula (fluxo do módulo de matrículas).
class EnrollmentTab extends ConsumerWidget {
  const EnrollmentTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enrollments = ref.watch(studentEnrollmentsProvider(student.id));
    return AsyncValueView<List<EnrollmentModel>>(
      value: enrollments,
      onRetry: () => ref.invalidate(studentEnrollmentsProvider(student.id)),
      loading: const SkeletonCard(),
      data: (items) {
        final current = currentEnrollment(items);
        if (current == null) {
          return const EmptyState(
            icon: Icons.assignment_outlined,
            title: 'Sem matrícula',
            message: 'Este aluno não tem matrícula activa.',
          );
        }
        return _CurrentEnrollment(
          key: ValueKey(current),
          studentId: student.id,
          enrollment: current,
        );
      },
    );
  }
}

class _CurrentEnrollment extends ConsumerStatefulWidget {
  const _CurrentEnrollment({
    super.key,
    required this.studentId,
    required this.enrollment,
  });

  final String studentId;
  final EnrollmentModel enrollment;

  @override
  ConsumerState<_CurrentEnrollment> createState() => _CurrentEnrollmentState();
}

class _CurrentEnrollmentState extends ConsumerState<_CurrentEnrollment> {
  late EnrollmentModel _draft = widget.enrollment;

  Future<bool> _save() async {
    final repo = ref.read(enrollmentRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final result = await repo.update(_draft);
    return result.when(
      ok: (_) {
        toast.success('Matrícula actualizada');
        container.invalidate(studentEnrollmentsProvider(widget.studentId));
        return true;
      },
      err: (f) {
        toast.error(f.message);
        return false;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.enrollment;
    final rooms = classroomsOf(e.gradeId);
    return EditableSection(
      title: 'Matrícula actual',
      editPermission: 'students.record.update',
      onCancel: () => _draft = e,
      onSave: _save,
      view: (_) => Column(
        children: [
          FieldRow(
            label: 'Ano lectivo',
            value: academicYearLabelFor(e.academicYearId),
          ),
          FieldRow(label: 'Classe', value: gradeLabelFor(e.gradeId)),
          FieldRow(
            label: 'Turma',
            value: classroomLabelFor(e.gradeId, e.classroomId),
          ),
          FieldRow(label: 'Turno', value: shiftLabels[e.shiftId]),
          FieldRow(label: 'N.º de chamada', value: e.rollNumber?.toString()),
          FieldRow(label: 'Estado', value: enrollmentStatusLabel(e.status)),
          FieldRow(label: 'Tipo', value: enrollmentTypeLabel(e.type)),
          FieldRow(
            label: 'Data da matrícula',
            value: PtAoFormatters.date(e.enrolledOn),
          ),
          FieldRow(
            label: 'Taxa de matrícula',
            value:
                '${PtAoFormatters.currency(e.feeMinor)} · '
                '${e.feePaid ? 'paga' : 'por pagar'}',
          ),
        ],
      ),
      form: (_) => FormGrid(
        children: [
          DropdownButtonFormField<String>(
            key: const Key('enrollment_classroom'),
            initialValue: rooms.containsKey(_draft.classroomId)
                ? _draft.classroomId
                : null,
            decoration: const InputDecoration(labelText: 'Turma'),
            items: [
              for (final r in rooms.entries)
                DropdownMenuItem(value: r.key, child: Text(r.value)),
            ],
            onChanged: (v) => _draft = _draft.copyWith(classroomId: v),
          ),
          DropdownButtonFormField<String>(
            key: const Key('enrollment_shift'),
            initialValue: shiftLabels.containsKey(_draft.shiftId)
                ? _draft.shiftId
                : null,
            decoration: const InputDecoration(labelText: 'Turno'),
            items: [
              for (final s in shiftLabels.entries)
                DropdownMenuItem(value: s.key, child: Text(s.value)),
            ],
            onChanged: (v) => _draft = _draft.copyWith(shiftId: v),
          ),
          TextFormField(
            initialValue: _draft.rollNumber?.toString(),
            decoration: const InputDecoration(labelText: 'N.º de chamada'),
            keyboardType: TextInputType.number,
            validator: (v) {
              final t = v?.trim() ?? '';
              if (t.isEmpty) return null;
              final n = int.tryParse(t);
              return n == null || n < 1 ? 'Número inválido' : null;
            },
            onSaved: (v) => _draft = _draft.copyWith(
              rollNumber: int.tryParse(v?.trim() ?? ''),
            ),
          ),
          DropdownButtonFormField<EnrollmentStatus>(
            initialValue: _draft.status,
            decoration: const InputDecoration(labelText: 'Estado'),
            items: [
              for (final s in EnrollmentStatus.values)
                DropdownMenuItem(
                  value: s,
                  child: Text(enrollmentStatusLabel(s)),
                ),
            ],
            onChanged: (v) =>
                _draft = _draft.copyWith(status: v ?? _draft.status),
          ),
        ],
      ),
    );
  }
}
