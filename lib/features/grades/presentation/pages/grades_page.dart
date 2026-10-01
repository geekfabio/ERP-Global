import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../academic/data/models/classroom_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../settings/data/models/term_model.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../domain/grade_entry_repository.dart';
import '../widgets/grade_grid.dart';

/// Turma com as disciplinas em que o utilizador pode lançar notas.
typedef _Option = ({ClassroomModel classroom, Set<String> subjectIds});

/// Notas: lançamento por turma × disciplina × trimestre. A coordenação vê
/// todas as turmas (currículo); o professor só as suas atribuições.
class GradesPage extends ConsumerStatefulWidget {
  const GradesPage({super.key});

  @override
  ConsumerState<GradesPage> createState() => _GradesPageState();
}

class _GradesPageState extends ConsumerState<GradesPage> {
  String? _classroomId;
  String? _subjectId;
  String? _termId;

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionServiceProvider);
    final all = permissions.canAny(gradeEntryApprovePermission);
    final optionsAsync = ref.watch(_optionsProvider(all));
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final subjects = ref.watch(subjectListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};
    final subjectNames = {for (final s in subjects) s.id: s.name};

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Lançamento de notas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  TextButton.icon(
                    key: const Key('grades_report_cards'),
                    onPressed: () => context.go('/grades/report-cards'),
                    icon: const Icon(Icons.description_outlined),
                    label: const Text('Boletins'),
                  ),
                  TextButton.icon(
                    key: const Key('grades_pautas'),
                    onPressed: () => context.go('/grades/pautas'),
                    icon: const Icon(Icons.table_chart_outlined),
                    label: const Text('Pautas'),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: optionsAsync.when(
                  skipLoadingOnReload: true,
                  loading: () => const SkeletonList(),
                  error: (e, _) => ErrorState(
                    failure: optionsAsync.failure ?? UnknownFailure(cause: e),
                    onRetry: () => ref.invalidate(_optionsProvider(all)),
                  ),
                  data: (options) => options.isEmpty
                      ? const EmptyState(
                          title: 'Sem turmas para lançar notas',
                          message:
                              'As turmas aparecem quando existirem atribuições.',
                        )
                      : _body(options, gradeNames, subjectNames),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(
    List<_Option> options,
    Map<String, String> gradeNames,
    Map<String, String> subjectNames,
  ) {
    final current = options
        .where((o) => o.classroom.id == _classroomId)
        .firstOrNull;
    final terms = current == null
        ? const <TermModel>[]
        : ref.watch(termsProvider(current.classroom.academicYearId)).value ??
              const <TermModel>[];
    final subjectId = current?.subjectIds.contains(_subjectId) ?? false
        ? _subjectId
        : null;
    final termId = terms.any((t) => t.id == _termId) ? _termId : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                key: const Key('grades_classroom'),
                decoration: const InputDecoration(labelText: 'Turma'),
                initialValue: current?.classroom.id,
                items: [
                  for (final o in options)
                    DropdownMenuItem(
                      value: o.classroom.id,
                      child: Text(
                        '${gradeNames[o.classroom.gradeId] ?? ''} · ${o.classroom.name}',
                      ),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _classroomId = v;
                  _subjectId = null;
                  _termId = null;
                }),
              ),
            ),
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                key: const Key('grades_subject'),
                decoration: const InputDecoration(labelText: 'Disciplina'),
                initialValue: subjectId,
                items: [
                  for (final id in current?.subjectIds ?? const <String>{})
                    DropdownMenuItem(
                      value: id,
                      child: Text(subjectNames[id] ?? id),
                    ),
                ],
                onChanged: current == null
                    ? null
                    : (v) => setState(() => _subjectId = v),
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                key: const Key('grades_term'),
                decoration: const InputDecoration(labelText: 'Trimestre'),
                initialValue: termId,
                items: [
                  for (final t in terms)
                    DropdownMenuItem(value: t.id, child: Text(t.name)),
                ],
                onChanged: current == null
                    ? null
                    : (v) => setState(() => _termId = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: current == null || subjectId == null || termId == null
              ? const EmptyState(
                  title: 'Escolha a turma, a disciplina e o trimestre',
                )
              : GradeGrid(
                  key: ValueKey('$_classroomId/$subjectId/$termId'),
                  sheetKey: GradeSheetKey(
                    classroomId: current.classroom.id,
                    subjectId: subjectId,
                    termId: termId,
                    gradeId: current.classroom.gradeId,
                    courseId: current.classroom.courseId,
                  ),
                ),
        ),
      ],
    );
  }
}

/// Turmas/disciplinas onde o utilizador pode lançar notas (`all` = coordenação).
final _optionsProvider = FutureProvider.autoDispose.family<List<_Option>, bool>(
  (ref, all) async {
    if (all) {
      final classrooms = await ref.watch(classroomListProvider.future);
      final curriculum = await ref.watch(curriculumAllProvider.future);
      return [
        for (final c in classrooms)
          (
            classroom: c,
            subjectIds: {
              for (final i in curriculum)
                if (i.courseId == c.courseId && i.gradeId == c.gradeId)
                  i.subjectId,
            },
          ),
      ];
    }
    final mine = await ref.watch(myClassroomsProvider.future);
    return [
      for (final m in mine)
        if (m.assignments.isNotEmpty)
          (
            classroom: m.classroom,
            subjectIds: {for (final a in m.assignments) a.subjectId},
          ),
    ];
  },
  retry: (_, _) => null,
);
