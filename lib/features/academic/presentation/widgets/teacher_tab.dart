import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/teacher_models.dart';
import '../providers/academic_structure_providers.dart';
import 'academic_form_dialog.dart';
import 'crud_tab.dart';

/// Professores: lista, ficha simples (disciplinas e turmas) e CRUD.
class TeachersTab extends ConsumerWidget {
  const TeachersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjects = <String, String>{
      for (final s in ref.watch(subjectListProvider).value ?? const [])
        s.id: s.name,
    };
    final grades = <String, String>{
      for (final g in ref.watch(gradeListProvider).value ?? const [])
        g.id: g.name,
    };
    final classrooms = <String, String>{
      for (final c in ref.watch(classroomListProvider).value ?? const [])
        c.id: '${grades[c.gradeId] ?? ''} ${c.name}'.trim(),
    };
    String subjectNames(TeacherModel t) =>
        t.subjectIds.map((id) => subjects[id] ?? '—').join(', ');
    return CrudTab<TeacherModel>(
      value: ref.watch(teacherListProvider),
      onChanged: () => ref.invalidate(teacherListProvider),
      repository: ref.watch(teacherRepositoryProvider),
      permission: 'academic.teacher',
      noun: 'professor',
      feminine: false,
      icon: Icons.school_outlined,
      rowId: (t) => t.id,
      describe: (t) => t.fullName,
      extraActions: [
        RowAction(
          label: 'Ficha',
          icon: Icons.badge_outlined,
          onTap: (t) => showDialog<void>(
            context: context,
            builder: (_) => _TeacherSheet(
              teacher: t,
              subjects: t.subjectIds.map((id) => subjects[id] ?? '—').toList(),
              classrooms: t.classroomIds
                  .map((id) => classrooms[id] ?? '—')
                  .toList(),
            ),
          ),
        ),
      ],
      columns: [
        AppColumn(
          label: 'N.º',
          text: (t) => t.employeeNumber,
          sortValue: (t) => t.employeeNumber,
        ),
        AppColumn(
          label: 'Nome',
          text: (t) => t.fullName,
          sortValue: (t) => t.fullName,
        ),
        AppColumn(
          label: 'Disciplinas',
          text: subjectNames,
          sortValue: subjectNames,
        ),
        AppColumn(
          label: 'Turmas',
          text: (t) => '${t.classroomIds.length}',
          sortValue: (t) => t.classroomIds.length,
          numeric: true,
        ),
        AppColumn(
          label: 'Estado',
          text: (t) => t.isActive ? 'Activo' : 'Inactivo',
          sortValue: (t) => t.isActive ? 0 : 1,
          cell: (t) => StatusBadge(
            label: t.isActive ? 'Activo' : 'Inactivo',
            status: t.isActive ? BadgeStatus.success : BadgeStatus.neutral,
          ),
        ),
      ],
      fieldsFor: (t) => [
        AcademicField('fullName', 'Nome completo', initial: t?.fullName),
        AcademicField('email', 'Email', initial: t?.email),
        AcademicField('phone', 'Telemóvel', initial: t?.phone),
        AcademicField('specialty', 'Formação', initial: t?.specialty),
        AcademicField(
          'subjectIds',
          'Disciplinas',
          kind: FieldKind.multi,
          initial: t?.subjectIds,
          options: subjects,
        ),
        AcademicField(
          'isActive',
          'Activo',
          kind: FieldKind.toggle,
          initial: t?.isActive ?? true,
        ),
      ],
      fromValues: (t, v) => TeacherModel(
        id: t?.id ?? '',
        employeeNumber: t?.employeeNumber ?? '',
        fullName: v['fullName']! as String,
        email: v['email']! as String,
        phone: v['phone']! as String,
        specialty: v['specialty']! as String,
        subjectIds: (v['subjectIds']! as List).cast<String>(),
        classroomIds: t?.classroomIds ?? const [],
        isActive: v['isActive']! as bool,
      ),
    );
  }
}

class _TeacherSheet extends StatelessWidget {
  const _TeacherSheet({
    required this.teacher,
    required this.subjects,
    required this.classrooms,
  });

  final TeacherModel teacher;
  final List<String> subjects;
  final List<String> classrooms;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: theme.textTheme.labelLarge),
          ),
          Expanded(child: Text(value.isEmpty ? '—' : value)),
        ],
      ),
    );
    return AlertDialog(
      key: const Key('teacher_sheet'),
      title: Text(teacher.fullName),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row('N.º funcionário', teacher.employeeNumber),
              row('Email', teacher.email),
              row('Telemóvel', teacher.phone),
              row('Formação', teacher.specialty),
              row('Estado', teacher.isActive ? 'Activo' : 'Inactivo'),
              row('Disciplinas', subjects.join(', ')),
              row(
                'Turmas',
                classrooms.isEmpty
                    ? 'Sem turmas atribuídas'
                    : classrooms.join(', '),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
