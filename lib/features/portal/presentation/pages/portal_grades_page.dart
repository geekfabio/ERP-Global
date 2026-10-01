import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../domain/portal_academic_logic.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_pupil_page.dart';

/// Notas por trimestre e boletins emitidos (só leitura).
class PortalGradesPage extends StatelessWidget {
  const PortalGradesPage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilPage(
    title: 'Notas e boletins',
    moduleCode: 'grades',
    builder: (context, pupil) => _Grades(studentId: pupil.student.id),
  );
}

class _Grades extends ConsumerStatefulWidget {
  const _Grades({required this.studentId});

  final String studentId;

  @override
  ConsumerState<_Grades> createState() => _GradesState();
}

class _GradesState extends ConsumerState<_Grades> {
  int _term = 1;

  @override
  Widget build(BuildContext context) {
    final grades = ref.watch(portalGradesProvider(widget.studentId));
    return AsyncValueView<StudentGradesSummary>(
      value: grades,
      onRetry: () => ref.invalidate(portalGradesProvider(widget.studentId)),
      loading: const SkeletonCard(),
      isEmpty: (g) => g.subjects.isEmpty && g.bulletins.isEmpty,
      empty: const EmptyState(
        icon: Icons.grading_outlined,
        title: 'Sem notas lançadas',
      ),
      data: (g) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SegmentedButton<int>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: 1, label: Text('1.º trim.')),
              ButtonSegment(value: 2, label: Text('2.º trim.')),
              ButtonSegment(value: 3, label: Text('3.º trim.')),
            ],
            selected: {_term},
            onSelectionChanged: (s) => setState(() => _term = s.single),
          ),
          const SizedBox(height: AppSpacing.md),
          Card(
            child: Column(
              children: [
                for (final s in g.subjects)
                  ListTile(
                    title: Text(s.subject),
                    trailing: Text(
                      _format(termGrade(s, _term)),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                if (g.subjects.isEmpty)
                  const ListTile(title: Text('Sem disciplinas')),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text('Boletins', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          Card(
            child: Column(
              children: [
                for (final b in g.bulletins)
                  ListTile(
                    leading: const Icon(Icons.description_outlined),
                    title: Text(b.label),
                    subtitle: Text(
                      'Emitido em ${PtAoFormatters.date(b.issuedOn)}',
                    ),
                  ),
                if (g.bulletins.isEmpty)
                  const ListTile(title: Text('Ainda sem boletins emitidos')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _format(double? v) =>
      v == null ? '—' : PtAoFormatters.number(v, decimalDigits: 1);
}
