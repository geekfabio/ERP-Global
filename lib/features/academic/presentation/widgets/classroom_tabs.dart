import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../data/models/classroom_models.dart';
import '../providers/academic_structure_providers.dart';
import 'academic_form_dialog.dart';
import 'crud_tab.dart';

AppColumn<T> _activeColumn<T>(
  bool Function(T) isActive,
  String yes,
  String no,
) => AppColumn<T>(
  label: 'Estado',
  text: (r) => isActive(r) ? yes : no,
  sortValue: (r) => isActive(r) ? 0 : 1,
  cell: (r) => StatusBadge(
    label: isActive(r) ? yes : no,
    status: isActive(r) ? BadgeStatus.success : BadgeStatus.neutral,
  ),
);

/// Salas físicas e respectiva capacidade.
class RoomsTab extends ConsumerWidget {
  const RoomsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CrudTab<RoomModel>(
    value: ref.watch(roomListProvider),
    onChanged: () => ref.invalidate(roomListProvider),
    repository: ref.watch(roomRepositoryProvider),
    permission: 'academic.room',
    noun: 'sala',
    feminine: true,
    icon: Icons.meeting_room_outlined,
    rowId: (r) => r.id,
    describe: (r) => r.name,
    columns: [
      AppColumn(label: 'Código', text: (r) => r.code, sortValue: (r) => r.code),
      AppColumn(label: 'Sala', text: (r) => r.name, sortValue: (r) => r.name),
      AppColumn(
        label: 'Capacidade',
        text: (r) => '${r.capacity}',
        sortValue: (r) => r.capacity,
        numeric: true,
      ),
      _activeColumn((r) => r.isActive, 'Activa', 'Inactiva'),
    ],
    fieldsFor: (r) => [
      AcademicField('code', 'Código', initial: r?.code),
      AcademicField('name', 'Designação', initial: r?.name),
      AcademicField(
        'capacity',
        'Capacidade (lugares)',
        kind: FieldKind.integer,
        initial: r?.capacity.toString(),
      ),
      AcademicField(
        'isActive',
        'Activa',
        kind: FieldKind.toggle,
        initial: r?.isActive ?? true,
      ),
    ],
    fromValues: (r, v) => RoomModel(
      id: r?.id ?? '',
      code: v['code']! as String,
      name: v['name']! as String,
      capacity: (v['capacity'] as int?) ?? 0,
      isActive: v['isActive']! as bool,
    ),
  );
}

/// Turnos (Manhã, Tarde, Noite) e respectivo horário.
class ShiftsTab extends ConsumerWidget {
  const ShiftsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CrudTab<ShiftModel>(
    value: ref.watch(shiftListProvider),
    onChanged: () => ref.invalidate(shiftListProvider),
    repository: ref.watch(shiftRepositoryProvider),
    permission: 'academic.shift',
    noun: 'turno',
    feminine: false,
    icon: Icons.schedule_outlined,
    rowId: (s) => s.id,
    describe: (s) => s.name,
    columns: [
      AppColumn(label: 'Turno', text: (s) => s.name, sortValue: (s) => s.name),
      AppColumn(
        label: 'Início',
        text: (s) => s.startTime,
        sortValue: (s) => s.startTime,
      ),
      AppColumn(
        label: 'Fim',
        text: (s) => s.endTime,
        sortValue: (s) => s.endTime,
      ),
      _activeColumn((s) => s.isActive, 'Activo', 'Inactivo'),
    ],
    fieldsFor: (s) => [
      AcademicField('name', 'Designação', initial: s?.name),
      AcademicField('startTime', 'Início (HH:mm)', initial: s?.startTime),
      AcademicField('endTime', 'Fim (HH:mm)', initial: s?.endTime),
      AcademicField(
        'isActive',
        'Activo',
        kind: FieldKind.toggle,
        initial: s?.isActive ?? true,
      ),
    ],
    fromValues: (s, v) => ShiftModel(
      id: s?.id ?? '',
      name: v['name']! as String,
      startTime: v['startTime']! as String,
      endTime: v['endTime']! as String,
      isActive: v['isActive']! as bool,
    ),
  );
}

/// Turmas: ano lectivo, classe, curso, turno, sala e vagas.
class ClassroomsTab extends ConsumerWidget {
  const ClassroomsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final years = <String, String>{
      for (final y in ref.watch(academicYearsProvider).value ?? const [])
        y.id: y.code,
    };
    final grades = <String, String>{
      for (final g in ref.watch(gradeListProvider).value ?? const [])
        g.id: g.name,
    };
    final gradeOrder = <String, int>{
      for (final g in ref.watch(gradeListProvider).value ?? const [])
        g.id: g.order,
    };
    final courses = <String, String>{
      for (final c in ref.watch(courseListProvider).value ?? const [])
        c.id: c.name,
    };
    final shifts = <String, String>{
      for (final s in ref.watch(shiftListProvider).value ?? const [])
        s.id: s.name,
    };
    final rooms = <String, String>{
      for (final r in ref.watch(roomListProvider).value ?? const [])
        r.id: r.name,
    };
    return CrudTab<ClassroomModel>(
      value: ref.watch(classroomListProvider),
      onChanged: () => ref.invalidate(classroomListProvider),
      repository: ref.watch(classroomRepositoryProvider),
      permission: 'academic.classroom',
      noun: 'turma',
      feminine: true,
      icon: Icons.groups_outlined,
      rowId: (c) => c.id,
      describe: (c) => '${grades[c.gradeId] ?? ''} ${c.name}'.trim(),
      columns: [
        AppColumn(
          label: 'Ano lectivo',
          text: (c) => years[c.academicYearId] ?? '—',
          sortValue: (c) => years[c.academicYearId] ?? '',
        ),
        AppColumn(
          label: 'Classe',
          text: (c) => grades[c.gradeId] ?? '—',
          sortValue: (c) => gradeOrder[c.gradeId] ?? 0,
        ),
        AppColumn(
          label: 'Turma',
          text: (c) => c.name,
          sortValue: (c) => c.name,
        ),
        AppColumn(
          label: 'Curso',
          text: (c) => courses[c.courseId] ?? '—',
          sortValue: (c) => courses[c.courseId] ?? '',
        ),
        AppColumn(
          label: 'Turno',
          text: (c) => shifts[c.shiftId] ?? '—',
          sortValue: (c) => shifts[c.shiftId] ?? '',
        ),
        AppColumn(
          label: 'Sala',
          text: (c) => rooms[c.roomId] ?? '—',
          sortValue: (c) => rooms[c.roomId] ?? '',
        ),
        AppColumn(
          label: 'Matriculados',
          text: (c) => '${c.enrolledCount}/${c.capacity}',
          sortValue: (c) => c.enrolledCount,
          numeric: true,
        ),
        AppColumn(
          label: 'Vagas livres',
          text: (c) => '${c.freeSeats}',
          sortValue: (c) => c.freeSeats,
          numeric: true,
          cell: (c) => StatusBadge(
            label: c.freeSeats <= 0 ? 'Lotada' : '${c.freeSeats}',
            status: c.freeSeats <= 0 ? BadgeStatus.danger : BadgeStatus.success,
          ),
        ),
      ],
      fieldsFor: (c) => [
        AcademicField(
          'academicYearId',
          'Ano lectivo',
          kind: FieldKind.choice,
          initial: c?.academicYearId,
          options: years,
        ),
        AcademicField(
          'gradeId',
          'Classe',
          kind: FieldKind.choice,
          initial: c?.gradeId,
          options: grades,
        ),
        AcademicField(
          'courseId',
          'Curso',
          kind: FieldKind.choice,
          initial: c?.courseId,
          options: courses,
        ),
        AcademicField(
          'shiftId',
          'Turno',
          kind: FieldKind.choice,
          initial: c?.shiftId,
          options: shifts,
        ),
        AcademicField(
          'roomId',
          'Sala',
          kind: FieldKind.choice,
          initial: c?.roomId,
          options: rooms,
        ),
        AcademicField('name', 'Designação da turma', initial: c?.name),
        AcademicField(
          'capacity',
          'Vagas',
          kind: FieldKind.integer,
          initial: c?.capacity.toString(),
        ),
      ],
      fromValues: (c, v) => ClassroomModel(
        id: c?.id ?? '',
        academicYearId: v['academicYearId']! as String,
        gradeId: v['gradeId']! as String,
        courseId: v['courseId']! as String,
        shiftId: v['shiftId']! as String,
        roomId: v['roomId']! as String,
        name: v['name']! as String,
        capacity: (v['capacity'] as int?) ?? 0,
        enrolledCount: c?.enrolledCount ?? 0,
      ),
    );
  }
}
