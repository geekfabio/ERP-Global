import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../data/models/student_model.dart';
import '../../../../data/models/student_summaries_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';

String formatGrade(double? v) =>
    v == null ? '—' : PtAoFormatters.number(v, decimalDigits: 1);

/// Separador 6 — Notas e boletins (módulo `grades`): notas por disciplina e
/// trimestre, médias e boletins emitidos.
class GradesTab extends ConsumerWidget {
  const GradesTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return AsyncValueView<StudentGradesSummary>(
      value: ref.watch(studentGradesProvider(student.id)),
      onRetry: () => ref.invalidate(studentGradesProvider(student.id)),
      isEmpty: (d) => d.subjects.isEmpty,
      loading: const SkeletonCard(),
      empty: const EmptyState(
        icon: Icons.grading_outlined,
        title: 'Sem notas',
        message: 'Ainda não há notas lançadas para este aluno.',
      ),
      data: (g) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Disciplina')),
                    DataColumn(label: Text('1.º trim.'), numeric: true),
                    DataColumn(label: Text('2.º trim.'), numeric: true),
                    DataColumn(label: Text('3.º trim.'), numeric: true),
                    DataColumn(label: Text('Média'), numeric: true),
                  ],
                  rows: [
                    for (final s in g.subjects)
                      DataRow(
                        cells: [
                          DataCell(Text(s.subject)),
                          DataCell(Text(formatGrade(s.term1))),
                          DataCell(Text(formatGrade(s.term2))),
                          DataCell(Text(formatGrade(s.term3))),
                          DataCell(Text(formatGrade(subjectAverage(s)))),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'Média geral: ${formatGrade(overallAverage(g.subjects))}',
            key: const Key('grades_overall'),
            style: text.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Boletins emitidos', style: text.titleMedium),
          if (g.bulletins.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Text('Nenhum boletim emitido.'),
            ),
          for (final b in g.bulletins)
            ListTile(
              leading: const Icon(Icons.description_outlined),
              title: Text(b.label),
              subtitle: Text('Emitido em ${PtAoFormatters.date(b.issuedOn)}'),
            ),
        ],
      ),
    );
  }
}
