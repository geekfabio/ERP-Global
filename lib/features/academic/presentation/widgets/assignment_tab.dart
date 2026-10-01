import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/assignment_models.dart';
import '../../data/models/teacher_models.dart';
import '../../domain/assignment_rules.dart';
import '../providers/academic_structure_providers.dart';
import '../providers/assignment_providers.dart';
import 'academic_form_dialog.dart';

/// Atribuições: a secretaria/coordenação vê a matriz turma × disciplina; o
/// professor vê apenas "As minhas turmas".
class AssignmentsTab extends ConsumerWidget {
  const AssignmentsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manage = ref
        .watch(permissionServiceProvider)
        .canAny('academic.assignment.create');
    return manage ? const _AssignmentMatrix() : const _MyClassrooms();
  }
}

String _shortName(String fullName) {
  final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
  return parts.length < 2 ? fullName : '${parts.first} ${parts.last}';
}

void _refresh(WidgetRef ref) {
  ref
    ..invalidate(assignmentListProvider)
    ..invalidate(homeroomListProvider)
    ..invalidate(myClassroomsProvider);
}

class _AssignmentMatrix extends ConsumerStatefulWidget {
  const _AssignmentMatrix();

  @override
  ConsumerState<_AssignmentMatrix> createState() => _AssignmentMatrixState();
}

class _AssignmentMatrixState extends ConsumerState<_AssignmentMatrix> {
  String _gradeId = '';

  @override
  Widget build(BuildContext context) {
    final watched = [
      ref.watch(classroomListProvider),
      ref.watch(subjectListProvider),
      ref.watch(gradeListProvider),
      ref.watch(teacherListProvider),
      ref.watch(curriculumAllProvider),
      ref.watch(assignmentListProvider),
      ref.watch(homeroomListProvider),
    ];
    final failed = watched.where((w) => w.hasError).firstOrNull;
    if (failed != null) {
      return ErrorState(
        failure: failed.failure ?? UnknownFailure(cause: failed.error),
        onRetry: () => _refresh(ref),
      );
    }
    if (watched.any((w) => !w.hasValue)) return const SkeletonList();

    final classrooms = ref.watch(classroomListProvider).requireValue;
    final subjects = ref.watch(subjectListProvider).requireValue;
    final grades = ref.watch(gradeListProvider).requireValue;
    final teachers = {
      for (final t in ref.watch(teacherListProvider).requireValue) t.id: t,
    };
    final curriculum = ref.watch(curriculumAllProvider).requireValue;
    final assignments = ref.watch(assignmentListProvider).requireValue;
    final homerooms = {
      for (final h in ref.watch(homeroomListProvider).requireValue)
        h.classroomId: h,
    };
    final gradeNames = {for (final g in grades) g.id: g.name};
    final shown = [
      for (final c in classrooms)
        if (_gradeId.isEmpty || c.gradeId == _gradeId) c,
    ];
    final inCurriculum = {
      for (final i in curriculum)
        '${i.courseId}/${i.gradeId}/${i.subjectId}': i.weeklyHours,
    };
    final theme = Theme.of(context);

    Widget cell(Widget child, {VoidCallback? onTap, Key? key}) => InkWell(
      key: key,
      onTap: onTap,
      child: Container(
        width: 112,
        height: 48,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: child,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              SizedBox(
                width: 240,
                child: DropdownButtonFormField<String>(
                  key: const Key('assignment_grade_filter'),
                  decoration: const InputDecoration(labelText: 'Classe'),
                  initialValue: _gradeId,
                  items: [
                    const DropdownMenuItem(value: '', child: Text('Todas')),
                    for (final g in grades)
                      DropdownMenuItem(value: g.id, child: Text(g.name)),
                  ],
                  onChanged: (v) => setState(() => _gradeId = v ?? ''),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(
                'Carga máxima: $kMaxTeacherWeeklyHours h semanais por professor',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: shown.isEmpty
              ? const EmptyState(title: 'Sem turmas')
              : SingleChildScrollView(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Table(
                      defaultColumnWidth: const IntrinsicColumnWidth(),
                      border: TableBorder.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
                      children: [
                        TableRow(
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest,
                          ),
                          children: [
                            cell(const Text('Turma')),
                            cell(const Text('Director')),
                            for (final s in subjects)
                              cell(
                                Tooltip(message: s.name, child: Text(s.code)),
                              ),
                          ],
                        ),
                        for (final c in shown)
                          TableRow(
                            children: [
                              cell(
                                Text(
                                  '${gradeNames[c.gradeId] ?? ''} ${c.name}'
                                      .trim(),
                                ),
                              ),
                              cell(
                                key: Key('homeroom_${c.id}'),
                                Text(
                                  homerooms[c.id] == null
                                      ? '+'
                                      : _shortName(
                                          teachers[homerooms[c.id]!.teacherId]
                                                  ?.fullName ??
                                              '—',
                                        ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                onTap: () => _editHomeroom(
                                  context,
                                  c.id,
                                  homerooms[c.id],
                                  teachers.values.where((t) => t.isActive),
                                ),
                              ),
                              for (final s in subjects)
                                _subjectCell(
                                  context,
                                  cell,
                                  classroomId: c.id,
                                  subjectId: s.id,
                                  hours:
                                      inCurriculum['${c.courseId}/${c.gradeId}/${s.id}'],
                                  cellAssignments: assignments
                                      .where(
                                        (a) =>
                                            a.classroomId == c.id &&
                                            a.subjectId == s.id,
                                      )
                                      .toList(),
                                  teachers: teachers,
                                  all: assignments,
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _subjectCell(
    BuildContext context,
    Widget Function(Widget, {VoidCallback? onTap, Key? key}) cell, {
    required String classroomId,
    required String subjectId,
    required int? hours,
    required List<TeachingAssignmentModel> cellAssignments,
    required Map<String, TeacherModel> teachers,
    required List<TeachingAssignmentModel> all,
  }) {
    if (hours == null) {
      return cell(
        Text('·', style: TextStyle(color: Theme.of(context).disabledColor)),
      );
    }
    final titular = cellAssignments
        .where((a) => a.role == AssignmentRole.titular)
        .firstOrNull;
    final substitutes = cellAssignments.length - (titular == null ? 0 : 1);
    return cell(
      key: Key('cell_${classroomId}_$subjectId'),
      titular == null
          ? const Icon(Icons.add, size: 16)
          : Text(
              '${_shortName(teachers[titular.teacherId]?.fullName ?? '—')}'
              '${substitutes > 0 ? ' +$substitutes' : ''}',
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: Theme.of(context).textTheme.bodySmall,
            ),
      onTap: () => showDialog<void>(
        context: context,
        builder: (_) => _CellDialog(
          classroomId: classroomId,
          subjectId: subjectId,
          defaultHours: hours,
        ),
      ),
    );
  }

  Future<void> _editHomeroom(
    BuildContext context,
    String classroomId,
    HomeroomModel? current,
    Iterable<TeacherModel> teachers,
  ) async {
    final repo = ref.read(homeroomRepositoryProvider);
    final values = await showAcademicForm(
      context,
      title: 'Director de turma',
      fields: [
        AcademicField(
          'teacherId',
          'Professor',
          kind: FieldKind.choice,
          initial: current?.teacherId,
          options: {for (final t in teachers) t.id: t.fullName},
        ),
      ],
    );
    if (values == null) return;
    final next = HomeroomModel(
      id: current?.id ?? '',
      classroomId: classroomId,
      teacherId: values['teacherId']! as String,
    );
    final result = current == null
        ? await repo.create(next)
        : await repo.update(current.id, next);
    if (reportResult(ref, result, done: 'Director de turma guardado')) {
      _refresh(ref);
    }
  }
}

/// Atribuições de uma turma × disciplina: titular e substitutos.
class _CellDialog extends ConsumerWidget {
  const _CellDialog({
    required this.classroomId,
    required this.subjectId,
    required this.defaultHours,
  });

  final String classroomId;
  final String subjectId;
  final int defaultHours;

  Future<void> _add(
    BuildContext context,
    WidgetRef ref,
    AssignmentRole role,
    List<TeacherModel> teachers,
    List<TeachingAssignmentModel> all,
  ) async {
    final eligible = teachers.where(
      (t) => t.isActive && t.subjectIds.contains(subjectId),
    );
    final substitute = role == AssignmentRole.substitute;
    final values = await showAcademicForm(
      context,
      title: substitute ? 'Adicionar substituto' : 'Atribuir titular',
      subtitle: 'Carga máxima: $kMaxTeacherWeeklyHours h semanais',
      fields: [
        AcademicField(
          'teacherId',
          'Professor',
          kind: FieldKind.choice,
          options: {
            for (final t in eligible)
              t.id:
                  '${t.fullName} (${teacherLoad(all, t.id)}/'
                  '$kMaxTeacherWeeklyHours h)',
          },
        ),
        AcademicField(
          'weeklyHours',
          'Carga horária semanal (h)',
          kind: FieldKind.integer,
          initial: '$defaultHours',
        ),
        if (substitute) ...[
          const AcademicField('validFrom', 'Válido desde (AAAA-MM-DD)'),
          const AcademicField('validUntil', 'Válido até (AAAA-MM-DD)'),
        ],
      ],
    );
    if (values == null) return;
    final result = await ref
        .read(teachingAssignmentRepositoryProvider)
        .create(
          TeachingAssignmentModel(
            id: '',
            teacherId: values['teacherId']! as String,
            classroomId: classroomId,
            subjectId: subjectId,
            weeklyHours: (values['weeklyHours'] as int?) ?? 0,
            role: role,
            validFrom: values['validFrom'] as String?,
            validUntil: values['validUntil'] as String?,
          ),
        );
    if (reportResult(ref, result, done: 'Atribuição registada')) _refresh(ref);
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    TeachingAssignmentModel a,
    String name,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Retirar atribuição',
      message: 'Retirar $name desta disciplina?',
      confirmLabel: 'Retirar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref
        .read(teachingAssignmentRepositoryProvider)
        .delete(a.id);
    if (reportResult(ref, result, done: 'Atribuição retirada')) _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final can = ref.watch(permissionServiceProvider).canAny;
    final teachers = ref.watch(teacherListProvider).value ?? const [];
    final all = ref.watch(assignmentListProvider).value ?? const [];
    final subject = (ref.watch(subjectListProvider).value ?? const [])
        .where((s) => s.id == subjectId)
        .firstOrNull;
    final mine = all
        .where((a) => a.classroomId == classroomId && a.subjectId == subjectId)
        .toList();
    final hasTitular = mine.any((a) => a.role == AssignmentRole.titular);
    String name(String id) =>
        teachers.where((t) => t.id == id).firstOrNull?.fullName ?? '—';
    return AlertDialog(
      key: const Key('assignment_cell_dialog'),
      title: Text(subject?.name ?? 'Disciplina'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (mine.isEmpty) const Text('Sem professor atribuído'),
            for (final a in mine)
              ListTile(
                key: Key('assignment_${a.id}'),
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(name(a.teacherId)),
                subtitle: Text(
                  '${a.weeklyHours} h/semana'
                  '${a.role == AssignmentRole.substitute ? ' · ${a.validFrom} a ${a.validUntil}' : ''}',
                ),
                leading: StatusBadge(
                  label: a.role == AssignmentRole.titular
                      ? 'Titular'
                      : 'Substituto',
                  status: a.role == AssignmentRole.titular
                      ? BadgeStatus.success
                      : BadgeStatus.warning,
                ),
                trailing: can('academic.assignment.delete')
                    ? IconButton(
                        tooltip: 'Retirar',
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _remove(context, ref, a, name(a.teacherId)),
                      )
                    : null,
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        if (hasTitular)
          OutlinedButton(
            onPressed: () =>
                _add(context, ref, AssignmentRole.substitute, teachers, all),
            child: const Text('Adicionar substituto'),
          )
        else
          FilledButton(
            onPressed: () =>
                _add(context, ref, AssignmentRole.titular, teachers, all),
            child: const Text('Atribuir titular'),
          ),
      ],
    );
  }
}

/// "As minhas turmas": só as turmas do professor autenticado.
class _MyClassrooms extends ConsumerWidget {
  const _MyClassrooms();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final grades = {
      for (final g in ref.watch(gradeListProvider).value ?? const [])
        g.id: g.name,
    };
    final subjects = {
      for (final s in ref.watch(subjectListProvider).value ?? const [])
        s.id: s.name,
    };
    return AsyncValueView<List<MyClassroom>>(
      value: ref.watch(myClassroomsProvider),
      onRetry: () => ref.invalidate(myClassroomsProvider),
      isEmpty: (d) => d.isEmpty,
      empty: const EmptyState(
        icon: Icons.class_outlined,
        title: 'Sem turmas atribuídas',
      ),
      data: (items) => ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        children: [
          for (final m in items)
            Card(
              key: Key('my_classroom_${m.classroom.id}'),
              child: ListTile(
                title: Text(
                  '${grades[m.classroom.gradeId] ?? ''} ${m.classroom.name}'
                      .trim(),
                ),
                subtitle: Text(
                  m.assignments.isEmpty
                      ? 'Director de turma'
                      : m.assignments
                            .map((a) => subjects[a.subjectId] ?? '—')
                            .join(', '),
                ),
                trailing: m.isHomeroom
                    ? const StatusBadge(
                        label: 'Director de turma',
                        status: BadgeStatus.info,
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}
