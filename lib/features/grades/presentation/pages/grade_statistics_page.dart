import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../academic/data/models/classroom_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../settings/data/models/academic_year_model.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../domain/grade_statistics.dart';
import '../providers/pauta_providers.dart';
import '../widgets/grade_statistics_view.dart';

/// Estatísticas de desempenho por turma, filtráveis por ano e trimestre.
class GradeStatisticsPage extends ConsumerStatefulWidget {
  const GradeStatisticsPage({super.key});

  @override
  ConsumerState<GradeStatisticsPage> createState() =>
      _GradeStatisticsPageState();
}

class _GradeStatisticsPageState extends ConsumerState<GradeStatisticsPage> {
  String? _yearId;
  String? _classroomId;

  /// `null` = ano completo (médias finais).
  int? _termIndex;

  @override
  Widget build(BuildContext context) {
    final classrooms = ref.watch(classroomListProvider);
    final years = ref.watch(academicYearsProvider).value ?? const [];
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            children: [
              Text(
                'Estatísticas de desempenho',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              classrooms.when(
                skipLoadingOnReload: true,
                loading: () => const SkeletonList(),
                error: (e, _) => ErrorState(
                  failure: classrooms.failure ?? UnknownFailure(cause: e),
                  onRetry: () => ref.invalidate(classroomListProvider),
                ),
                data: (list) => list.isEmpty
                    ? const EmptyState(title: 'Sem turmas')
                    : _body(list, years, gradeNames),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(
    List<ClassroomModel> all,
    List<AcademicYearModel> years,
    Map<String, String> names,
  ) {
    final yearIds = {for (final c in all) c.academicYearId}.toList();
    final yearLabels = {for (final y in years) y.id: y.code};
    final yearId = yearIds.contains(_yearId) ? _yearId : null;
    final list = [
      for (final c in all)
        if (yearId == null || c.academicYearId == yearId) c,
    ];
    final current = list.where((c) => c.id == _classroomId).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SizedBox(
              width: 200,
              child: DropdownButtonFormField<String?>(
                key: const Key('stats_year'),
                decoration: const InputDecoration(labelText: 'Ano lectivo'),
                initialValue: yearId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('Todos')),
                  for (final id in yearIds)
                    DropdownMenuItem(
                      value: id,
                      child: Text(yearLabels[id] ?? id),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _yearId = v;
                  _classroomId = null;
                  _termIndex = null;
                }),
              ),
            ),
            SizedBox(
              width: 300,
              child: DropdownButtonFormField<String>(
                key: const Key('stats_classroom'),
                decoration: const InputDecoration(labelText: 'Turma'),
                initialValue: current?.id,
                items: [
                  for (final c in list)
                    DropdownMenuItem(
                      value: c.id,
                      child: Text('${names[c.gradeId] ?? ''} · ${c.name}'),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _classroomId = v;
                  _termIndex = null;
                }),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (current == null)
          const EmptyState(title: 'Escolha a turma')
        else
          _StatsBody(
            key: ValueKey(current.id),
            classroomId: current.id,
            termIndex: _termIndex,
            onScope: (i) => setState(() => _termIndex = i),
          ),
      ],
    );
  }
}

class _StatsBody extends ConsumerWidget {
  const _StatsBody({
    super.key,
    required this.classroomId,
    required this.termIndex,
    required this.onScope,
  });

  final String classroomId;
  final int? termIndex;
  final ValueChanged<int?> onScope;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(pautaDataProvider(classroomId));
    return data.when(
      skipLoadingOnReload: true,
      loading: () => const SkeletonCard(),
      error: (e, _) => ErrorState(
        failure: data.failure ?? UnknownFailure(cause: e),
        onRetry: () => ref.invalidate(pautaDataProvider(classroomId)),
      ),
      data: (pauta) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: SegmentedButton<int?>(
              key: const Key('stats_scope'),
              showSelectedIcon: false,
              segments: [
                for (var i = 0; i < pauta.termNames.length; i++)
                  ButtonSegment(value: i, label: Text(pauta.termNames[i])),
                const ButtonSegment(value: null, label: Text('Ano')),
              ],
              selected: {termIndex},
              onSelectionChanged: (s) => onScope(s.first),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (pauta.rows.isEmpty)
            const EmptyState(title: 'A turma não tem alunos')
          else
            GradeStatisticsView(
              stats: GradeStatistics.fromPauta(pauta, termIndex: termIndex),
            ),
        ],
      ),
    );
  }
}
