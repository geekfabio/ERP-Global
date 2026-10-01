import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/classroom_models.dart';
import '../../data/models/schedule_models.dart';
import '../../domain/schedule_rules.dart';
import '../providers/academic_structure_providers.dart';
import '../providers/assignment_providers.dart';
import '../providers/schedule_providers.dart';
import 'academic_form_dialog.dart';

enum _View { classroom, teacher, room }

/// Horários: grelha semanal por turma, professor ou sala; o professor vê
/// apenas o seu horário. Conflitos de professor, sala e turma bloqueiam a
/// gravação (409 do servidor, mostrado como aviso).
class ScheduleTab extends ConsumerStatefulWidget {
  const ScheduleTab({super.key});

  @override
  ConsumerState<ScheduleTab> createState() => _ScheduleTabState();
}

class _ScheduleTabState extends ConsumerState<ScheduleTab> {
  _View _view = _View.classroom;
  String _id = '';

  String _shortName(String fullName) {
    final parts = fullName.split(' ').where((p) => p.isNotEmpty).toList();
    return parts.length < 2 ? fullName : '${parts.first} ${parts.last}';
  }

  void _refresh() => ref.invalidate(scheduleListProvider);

  @override
  Widget build(BuildContext context) {
    final manage = ref
        .watch(permissionServiceProvider)
        .canAny('academic.schedule.create');
    final watched = [
      ref.watch(scheduleListProvider),
      ref.watch(classroomListProvider),
      ref.watch(subjectListProvider),
      ref.watch(gradeListProvider),
      ref.watch(teacherListProvider),
      ref.watch(roomListProvider),
      ref.watch(shiftListProvider),
      if (!manage) ref.watch(myTeacherProvider),
    ];
    final failed = watched.where((w) => w.hasError).firstOrNull;
    if (failed != null) {
      return ErrorState(
        failure: failed.failure ?? UnknownFailure(cause: failed.error),
        onRetry: _refresh,
      );
    }
    if (watched.any((w) => !w.hasValue)) return const SkeletonList();

    final slots = ref.watch(scheduleListProvider).requireValue;
    final classrooms = ref.watch(classroomListProvider).requireValue;
    final subjects = {
      for (final s in ref.watch(subjectListProvider).requireValue) s.id: s,
    };
    final grades = {
      for (final g in ref.watch(gradeListProvider).requireValue) g.id: g.name,
    };
    final teachers = {
      for (final t in ref.watch(teacherListProvider).requireValue) t.id: t,
    };
    final rooms = {
      for (final r in ref.watch(roomListProvider).requireValue) r.id: r,
    };
    final shifts = {
      for (final s in ref.watch(shiftListProvider).requireValue) s.id: s,
    };
    final me = manage ? null : ref.watch(myTeacherProvider).requireValue;

    String classroomName(ClassroomModel c) =>
        '${grades[c.gradeId] ?? ''} ${c.name}'.trim();
    final classroomNames = {for (final c in classrooms) c.id: classroomName(c)};

    final view = manage ? _view : _View.teacher;
    final options = switch (view) {
      _View.classroom => classroomNames,
      _View.teacher => {
        for (final t in teachers.values.where((t) => t.isActive))
          t.id: t.fullName,
      },
      _View.room => {for (final r in rooms.values) r.id: r.name},
    };
    final selected = manage
        ? (options.containsKey(_id) ? _id : options.keys.firstOrNull)
        : me?.id;

    if (!manage && me == null) {
      return const EmptyState(
        icon: Icons.schedule_outlined,
        title: 'Sem horário disponível',
      );
    }

    final shown = [
      for (final s in slots)
        if (selected != null &&
            switch (view) {
              _View.classroom => s.classroomId == selected,
              _View.teacher => s.teacherId == selected,
              _View.room => s.roomId == selected,
            })
          s,
    ];
    final classroom = view == _View.classroom
        ? classrooms.where((c) => c.id == selected).firstOrNull
        : null;
    final shift = classroom == null ? null : shifts[classroom.shiftId];
    final rows = scheduleRows(
      shown,
      shiftStart: shift?.startTime,
      shiftEnd: shift?.endTime,
    );
    final canAdd =
        manage &&
        classroom != null &&
        ref.watch(permissionServiceProvider).canAny('academic.schedule.create');
    final theme = Theme.of(context);

    Widget cell(Widget child, {VoidCallback? onTap, Key? key}) => InkWell(
      key: key,
      onTap: onTap,
      child: Container(
        width: 128,
        height: 56,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
        child: child,
      ),
    );

    Widget slotCell(ScheduleSlotModel s) {
      final subject = subjects[s.subjectId];
      final second = switch (view) {
        _View.classroom => _shortName(teachers[s.teacherId]?.fullName ?? '—'),
        _View.teacher => classroomNames[s.classroomId] ?? '—',
        _View.room => classroomNames[s.classroomId] ?? '—',
      };
      return cell(
        key: Key('slot_${s.id}'),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              subject?.code ?? '—',
              style: theme.textTheme.labelLarge,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              second,
              style: theme.textTheme.bodySmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        onTap: () => _showSlot(
          s,
          subject: subject?.name ?? '—',
          teacher: teachers[s.teacherId]?.fullName ?? '—',
          room: rooms[s.roomId]?.name ?? '—',
          classroomName: classroomNames[s.classroomId] ?? '—',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (manage) ...[
                SegmentedButton<_View>(
                  key: const Key('schedule_view'),
                  showSelectedIcon: false,
                  segments: const [
                    ButtonSegment(value: _View.classroom, label: Text('Turma')),
                    ButtonSegment(
                      value: _View.teacher,
                      label: Text('Professor'),
                    ),
                    ButtonSegment(value: _View.room, label: Text('Sala')),
                  ],
                  selected: {_view},
                  onSelectionChanged: (v) => setState(() {
                    _view = v.first;
                    _id = '';
                  }),
                ),
                SizedBox(
                  width: 280,
                  child: DropdownButtonFormField<String>(
                    key: ValueKey('schedule_target_${_view.name}'),
                    initialValue: selected,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: switch (_view) {
                        _View.classroom => 'Turma',
                        _View.teacher => 'Professor',
                        _View.room => 'Sala',
                      },
                    ),
                    items: [
                      for (final e in options.entries)
                        DropdownMenuItem(value: e.key, child: Text(e.value)),
                    ],
                    onChanged: (v) => setState(() => _id = v ?? ''),
                  ),
                ),
              ] else
                Text('O meu horário', style: theme.textTheme.titleMedium),
            ],
          ),
        ),
        Expanded(
          child: rows.isEmpty
              ? const EmptyState(
                  icon: Icons.schedule_outlined,
                  title: 'Sem aulas no horário',
                )
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
                            cell(const Text('Hora')),
                            for (final d in kScheduleWeekdays)
                              cell(Text(kWeekdayNames[d]!)),
                          ],
                        ),
                        for (final (start, end) in rows)
                          TableRow(
                            children: [
                              cell(Text('$start–$end')),
                              for (final d in kScheduleWeekdays)
                                _dayCell(
                                  cell,
                                  slotCell,
                                  shown
                                      .where(
                                        (s) =>
                                            s.weekday == d &&
                                            s.startTime == start,
                                      )
                                      .toList(),
                                  canAdd: canAdd,
                                  onAdd: () => _add(
                                    classroom!,
                                    d,
                                    start,
                                    end,
                                    subjects.map((k, v) => MapEntry(k, v.name)),
                                    teachers.map(
                                      (k, v) => MapEntry(k, v.fullName),
                                    ),
                                    rooms.map((k, v) => MapEntry(k, v.name)),
                                  ),
                                  day: d,
                                  start: start,
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

  Widget _dayCell(
    Widget Function(Widget, {VoidCallback? onTap, Key? key}) cell,
    Widget Function(ScheduleSlotModel) slotCell,
    List<ScheduleSlotModel> inCell, {
    required bool canAdd,
    required VoidCallback onAdd,
    required int day,
    required String start,
  }) {
    if (inCell.isNotEmpty) return slotCell(inCell.first);
    if (!canAdd) return cell(const SizedBox.shrink());
    return cell(
      key: Key('add_${day}_$start'),
      const Icon(Icons.add, size: 16),
      onTap: onAdd,
    );
  }

  Future<void> _add(
    ClassroomModel classroom,
    int weekday,
    String start,
    String end,
    Map<String, String> subjectNames,
    Map<String, String> teacherNames,
    Map<String, String> roomNames,
  ) async {
    final assignments = [
      for (final a in await ref.read(assignmentListProvider.future))
        if (a.classroomId == classroom.id) a,
    ];
    if (!mounted) return;
    if (assignments.isEmpty) {
      ref
          .read(toastProvider.notifier)
          .error('Atribua primeiro professores às disciplinas da turma');
      return;
    }
    final subjectOptions = {
      for (final a in assignments)
        a.subjectId: subjectNames[a.subjectId] ?? a.subjectId,
    };
    final teacherOptions = {
      for (final a in assignments)
        a.teacherId: teacherNames[a.teacherId] ?? a.teacherId,
    };
    final values = await showAcademicForm(
      context,
      title: 'Nova aula · ${kWeekdayNames[weekday]}',
      fields: [
        AcademicField(
          'subjectId',
          'Disciplina',
          kind: FieldKind.choice,
          options: subjectOptions,
        ),
        AcademicField(
          'teacherId',
          'Professor',
          kind: FieldKind.choice,
          options: teacherOptions,
        ),
        AcademicField(
          'roomId',
          'Sala',
          kind: FieldKind.choice,
          initial: classroom.roomId,
          options: roomNames,
        ),
        AcademicField('startTime', 'Início (HH:mm)', initial: start),
        AcademicField('endTime', 'Fim (HH:mm)', initial: end),
      ],
    );
    if (values == null) return;
    final result = await ref
        .read(scheduleRepositoryProvider)
        .create(
          ScheduleSlotModel(
            id: '',
            classroomId: classroom.id,
            subjectId: values['subjectId']! as String,
            teacherId: values['teacherId']! as String,
            roomId: values['roomId']! as String,
            weekday: weekday,
            startTime: (values['startTime']! as String).trim(),
            endTime: (values['endTime']! as String).trim(),
          ),
        );
    if (reportResult(ref, result, done: 'Aula registada')) _refresh();
  }

  Future<void> _showSlot(
    ScheduleSlotModel s, {
    required String subject,
    required String teacher,
    required String room,
    required String classroomName,
  }) async {
    final canDelete = ref
        .read(permissionServiceProvider)
        .canAny('academic.schedule.delete');
    final remove = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        key: const Key('schedule_slot_dialog'),
        title: Text(subject),
        content: Text(
          '${kWeekdayNames[s.weekday]}, ${s.startTime}–${s.endTime}\n'
          'Turma: $classroomName\nProfessor: $teacher\nSala: $room',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Fechar'),
          ),
          if (canDelete)
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Retirar'),
            ),
        ],
      ),
    );
    if (remove != true) return;
    final result = await ref.read(scheduleRepositoryProvider).delete(s.id);
    if (reportResult(ref, result, done: 'Aula retirada')) _refresh();
  }
}
