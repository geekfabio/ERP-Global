import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/academic_models.dart';
import '../providers/academic_structure_providers.dart';
import 'academic_form_dialog.dart';
import 'academic_table.dart';

/// Currículo por curso × classe: disciplinas e carga horária semanal.
class CurriculumTab extends ConsumerStatefulWidget {
  const CurriculumTab({super.key});

  @override
  ConsumerState<CurriculumTab> createState() => _CurriculumTabState();
}

class _CurriculumTabState extends ConsumerState<CurriculumTab> {
  String? _courseId;
  String? _gradeId;

  ({String courseId, String gradeId})? get _key =>
      _courseId == null || _gradeId == null
      ? null
      : (courseId: _courseId!, gradeId: _gradeId!);

  void _refresh() {
    final key = _key;
    if (key != null) ref.invalidate(curriculumProvider(key));
  }

  Future<void> _add(List<SubjectModel> subjects, Set<String> used) async {
    final available = {
      for (final s in subjects)
        if (s.isActive && !used.contains(s.id)) s.id: s.name,
    };
    final v = await showAcademicForm(
      context,
      title: 'Adicionar disciplina',
      fields: [
        AcademicField(
          'subjectId',
          'Disciplina',
          kind: FieldKind.choice,
          options: available,
        ),
        const AcademicField(
          'weeklyHours',
          'Carga semanal (tempos)',
          kind: FieldKind.integer,
        ),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(curriculumRepositoryProvider)
        .create(
          CurriculumItemModel(
            id: '',
            courseId: _courseId!,
            gradeId: _gradeId!,
            subjectId: v['subjectId']! as String,
            weeklyHours: (v['weeklyHours'] as int?) ?? 0,
          ),
        );
    if (reportResult(ref, result, done: 'Disciplina adicionada')) _refresh();
  }

  Future<void> _edit(CurriculumItemModel item, String subject) async {
    final v = await showAcademicForm(
      context,
      title: 'Editar carga horária',
      subtitle: subject,
      fields: [
        AcademicField(
          'weeklyHours',
          'Carga semanal (tempos)',
          kind: FieldKind.integer,
          initial: item.weeklyHours.toString(),
        ),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(curriculumRepositoryProvider)
        .update(
          item.id,
          item.copyWith(weeklyHours: (v['weeklyHours'] as int?) ?? 0),
        );
    if (reportResult(ref, result, done: 'Carga horária actualizada')) {
      _refresh();
    }
  }

  Future<void> _remove(CurriculumItemModel item, String subject) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Retirar disciplina',
      message: 'Retirar $subject deste currículo?',
      confirmLabel: 'Retirar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref.read(curriculumRepositoryProvider).delete(item.id);
    if (reportResult(ref, result, done: 'Disciplina retirada')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(courseListProvider).value ?? const [];
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final subjects = ref.watch(subjectListProvider).value ?? const [];
    final subjectName = {for (final s in subjects) s.id: s.name};
    final course = courses.where((c) => c.id == _courseId).firstOrNull;
    final courseGrades = course == null
        ? const <GradeModel>[]
        : [
            for (final g in grades)
              if (course.levelIds.contains(g.levelId)) g,
          ];
    final key = _key;
    final can = ref.watch(permissionServiceProvider).canAny;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 320,
                child: DropdownButtonFormField<String>(
                  key: const Key('curriculum_course'),
                  decoration: const InputDecoration(labelText: 'Curso'),
                  isExpanded: true,
                  initialValue: _courseId,
                  items: [
                    for (final c in courses)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: (v) => setState(() {
                    _courseId = v;
                    _gradeId = null;
                  }),
                ),
              ),
              SizedBox(
                width: 220,
                child: DropdownButtonFormField<String>(
                  key: ValueKey('curriculum_grade_$_courseId'),
                  decoration: const InputDecoration(labelText: 'Classe'),
                  isExpanded: true,
                  initialValue: _gradeId,
                  items: [
                    for (final g in courseGrades)
                      DropdownMenuItem(value: g.id, child: Text(g.name)),
                  ],
                  onChanged: (v) => setState(() => _gradeId = v),
                ),
              ),
              if (key != null)
                Can(
                  permission: 'academic.curriculum.create',
                  child: AppButton(
                    label: 'Adicionar disciplina',
                    icon: Icons.add,
                    onPressed: () => _add(subjects, {
                      for (final i
                          in ref.read(curriculumProvider(key)).value ??
                              const <CurriculumItemModel>[])
                        i.subjectId,
                    }),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: key == null
              ? const EmptyState(
                  icon: Icons.account_tree_outlined,
                  title: 'Escolha um curso e uma classe',
                )
              : AsyncValueView<List<CurriculumItemModel>>(
                  value: ref.watch(curriculumProvider(key)),
                  onRetry: _refresh,
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.account_tree_outlined,
                    title: 'Sem disciplinas neste currículo',
                  ),
                  data: (items) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          'Carga semanal total: '
                          '${items.fold<int>(0, (a, i) => a + i.weeklyHours)} tempos',
                          key: const Key('curriculum_total'),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      Expanded(
                        child: AcademicTable<CurriculumItemModel>(
                          items: items,
                          rowId: (i) => i.id,
                          emptyText: 'Sem resultados',
                          columns: [
                            AppColumn(
                              label: 'Disciplina',
                              text: (i) => subjectName[i.subjectId] ?? '—',
                              sortValue: (i) => subjectName[i.subjectId] ?? '',
                            ),
                            AppColumn(
                              label: 'Tempos/semana',
                              text: (i) => '${i.weeklyHours}',
                              sortValue: (i) => i.weeklyHours,
                              numeric: true,
                            ),
                          ],
                          rowActions: [
                            if (can('academic.curriculum.update'))
                              RowAction(
                                label: 'Editar',
                                icon: Icons.edit_outlined,
                                onTap: (i) =>
                                    _edit(i, subjectName[i.subjectId] ?? ''),
                              ),
                            if (can('academic.curriculum.delete'))
                              RowAction(
                                label: 'Retirar',
                                icon: Icons.delete_outline,
                                onTap: (i) =>
                                    _remove(i, subjectName[i.subjectId] ?? ''),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
