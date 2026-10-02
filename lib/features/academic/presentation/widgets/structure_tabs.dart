import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/academic_models.dart';
import '../providers/academic_structure_providers.dart';
import 'academic_form_dialog.dart';
import 'crud_tab.dart';

AppColumn<T> _activeColumn<T>(bool Function(T) isActive) => AppColumn<T>(
  label: 'Estado',
  text: (r) => isActive(r) ? 'Activo' : 'Inactivo',
  sortValue: (r) => isActive(r) ? 0 : 1,
  cell: (r) => StatusBadge(
    label: isActive(r) ? 'Activo' : 'Inactivo',
    status: isActive(r) ? BadgeStatus.success : BadgeStatus.neutral,
  ),
);

/// Ciclos de ensino.
class LevelsTab extends ConsumerWidget {
  const LevelsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CrudTab<LevelModel>(
    value: ref.watch(levelListProvider),
    onChanged: () => ref.invalidate(levelListProvider),
    repository: ref.watch(levelRepositoryProvider),
    permission: 'academic.level',
    noun: 'ciclo',
    feminine: false,
    icon: Icons.layers_outlined,
    rowId: (l) => l.id,
    describe: (l) => l.name,
    columns: [
      AppColumn(
        label: 'Ordem',
        text: (l) => '${l.order}',
        sortValue: (l) => l.order,
        numeric: true,
      ),
      AppColumn(label: 'Código', text: (l) => l.code, sortValue: (l) => l.code),
      AppColumn(label: 'Ciclo', text: (l) => l.name, sortValue: (l) => l.name),
    ],
    fieldsFor: (l) => [
      AcademicField('code', 'Código', initial: l?.code),
      AcademicField('name', 'Designação', initial: l?.name),
      AcademicField(
        'order',
        'Ordem',
        kind: FieldKind.integer,
        initial: l?.order.toString(),
      ),
    ],
    fromValues: (l, v) => LevelModel(
      id: l?.id ?? '',
      code: v['code']! as String,
      name: v['name']! as String,
      order: (v['order'] as int?) ?? 0,
    ),
  );
}

/// Classes (Iniciação → 12.ª).
class GradesTab extends ConsumerWidget {
  const GradesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelListProvider).value ?? const [];
    final levelName = {for (final l in levels) l.id: l.name};
    return CrudTab<GradeModel>(
      value: ref.watch(gradeListProvider),
      onChanged: () => ref.invalidate(gradeListProvider),
      repository: ref.watch(gradeRepositoryProvider),
      permission: 'academic.grade',
      noun: 'classe',
      feminine: true,
      icon: Icons.stairs_outlined,
      rowId: (g) => g.id,
      describe: (g) => g.name,
      columns: [
        AppColumn(
          label: 'N.º',
          text: (g) => '${g.order}',
          sortValue: (g) => g.order,
          numeric: true,
        ),
        AppColumn(
          label: 'Classe',
          text: (g) => g.name,
          sortValue: (g) => g.name,
        ),
        AppColumn(
          label: 'Ciclo',
          text: (g) => levelName[g.levelId] ?? '—',
          sortValue: (g) => levelName[g.levelId] ?? '',
        ),
      ],
      fieldsFor: (g) => [
        AcademicField('name', 'Designação', initial: g?.name),
        AcademicField(
          'order',
          'N.º da classe (0 = Iniciação)',
          kind: FieldKind.integer,
          initial: g?.order.toString(),
        ),
        AcademicField(
          'levelId',
          'Ciclo',
          kind: FieldKind.choice,
          initial: g?.levelId,
          options: levelName,
        ),
      ],
      fromValues: (g, v) => GradeModel(
        id: g?.id ?? '',
        name: v['name']! as String,
        order: (v['order'] as int?) ?? 0,
        levelId: v['levelId']! as String,
      ),
    );
  }
}

/// Cursos.
class CoursesTab extends ConsumerWidget {
  const CoursesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levels = ref.watch(levelListProvider).value ?? const [];
    final levelName = {for (final l in levels) l.id: l.name};
    return CrudTab<CourseModel>(
      value: ref.watch(courseListProvider),
      onChanged: () => ref.invalidate(courseListProvider),
      repository: ref.watch(courseRepositoryProvider),
      permission: 'academic.course',
      noun: 'curso',
      feminine: false,
      icon: Icons.school_outlined,
      rowId: (c) => c.id,
      describe: (c) => c.name,
      columns: [
        AppColumn(
          label: 'Código',
          text: (c) => c.code,
          sortValue: (c) => c.code,
        ),
        AppColumn(
          label: 'Curso',
          text: (c) => c.name,
          sortValue: (c) => c.name,
        ),
        AppColumn(
          label: 'Ciclos',
          text: (c) =>
              [for (final id in c.levelIds) levelName[id] ?? '—'].join(', '),
        ),
        _activeColumn((c) => c.isActive),
      ],
      fieldsFor: (c) => [
        AcademicField('code', 'Código', initial: c?.code),
        AcademicField('name', 'Designação', initial: c?.name),
        AcademicField(
          'levelIds',
          'Ciclos em que é leccionado',
          kind: FieldKind.multi,
          initial: c?.levelIds,
          options: levelName,
        ),
        AcademicField(
          'isActive',
          'Activo',
          kind: FieldKind.toggle,
          initial: c?.isActive ?? true,
        ),
      ],
      fromValues: (c, v) => CourseModel(
        id: c?.id ?? '',
        code: v['code']! as String,
        name: v['name']! as String,
        levelIds: (v['levelIds']! as List).cast<String>(),
        isActive: v['isActive']! as bool,
      ),
    );
  }
}

/// Disciplinas.
class SubjectsTab extends ConsumerWidget {
  const SubjectsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CrudTab<SubjectModel>(
    value: ref.watch(subjectListProvider),
    onChanged: () => ref.invalidate(subjectListProvider),
    repository: ref.watch(subjectRepositoryProvider),
    permission: 'academic.subject',
    noun: 'disciplina',
    feminine: true,
    icon: Icons.menu_book_outlined,
    rowId: (s) => s.id,
    describe: (s) => s.name,
    columns: [
      AppColumn(label: 'Código', text: (s) => s.code, sortValue: (s) => s.code),
      AppColumn(
        label: 'Disciplina',
        text: (s) => s.name,
        sortValue: (s) => s.name,
      ),
      _activeColumn((s) => s.isActive),
    ],
    fieldsFor: (s) => [
      AcademicField('code', 'Código', initial: s?.code),
      AcademicField('name', 'Designação', initial: s?.name),
      AcademicField(
        'isActive',
        'Activa',
        kind: FieldKind.toggle,
        initial: s?.isActive ?? true,
      ),
    ],
    fromValues: (s, v) => SubjectModel(
      id: s?.id ?? '',
      code: v['code']! as String,
      name: v['name']! as String,
      isActive: v['isActive']! as bool,
    ),
  );
}
