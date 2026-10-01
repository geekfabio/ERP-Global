import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/charts/app_charts.dart';
import '../../domain/grade_statistics.dart';
import '../../domain/report_card.dart';

/// Painel de estatísticas: KPIs, distribuição, médias por disciplina e alunos
/// em risco.
class GradeStatisticsView extends StatelessWidget {
  const GradeStatisticsView({super.key, required this.stats});

  final GradeStatistics stats;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subjects = [
      for (final s in stats.subjects)
        if (s.average != null) s,
    ];
    final bands = [
      for (var i = 0; i < stats.distribution.length; i++)
        '${stats.bandLabels[i]}: ${stats.distribution[i]}',
    ].join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _Kpi(
              id: 'average',
              label: 'Média geral',
              value: formatReportGrade(stats.average),
            ),
            _Kpi(
              id: 'approval',
              label: 'Taxa de aprovação',
              value: formatPercent(stats.approvalRate),
            ),
            _Kpi(
              id: 'at_risk',
              label: 'Alunos em risco',
              value: '${stats.atRisk.length}',
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [
            _Panel(
              title: 'Distribuição das notas',
              child: AppBarChart(
                key: const Key('stats_distribution'),
                values: [for (final c in stats.distribution) c.toDouble()],
                labels: stats.bandLabels,
                semanticLabel: 'Distribuição das notas: $bands',
              ),
            ),
            _Panel(
              title: 'Média por disciplina',
              child: subjects.isEmpty
                  ? const Text('Sem notas lançadas.')
                  : AppBarChart(
                      key: const Key('stats_subject_average'),
                      values: [for (final s in subjects) s.average!],
                      labels: [for (final s in subjects) s.name],
                      semanticLabel: 'Média por disciplina',
                    ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Disciplinas', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              key: const Key('stats_subjects_table'),
              columns: const [
                DataColumn(label: Text('Disciplina')),
                DataColumn(label: Text('Média'), numeric: true),
                DataColumn(label: Text('Aprovados'), numeric: true),
                DataColumn(label: Text('Reprovados'), numeric: true),
                DataColumn(label: Text('Taxa'), numeric: true),
              ],
              rows: [
                for (final s in stats.subjects)
                  DataRow(
                    cells: [
                      DataCell(Text(s.name)),
                      DataCell(Text(formatReportGrade(s.average))),
                      DataCell(Text('${s.approved}')),
                      DataCell(Text('${s.failed}')),
                      DataCell(Text(formatPercent(s.approvalRate))),
                    ],
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text('Alunos em risco', style: theme.textTheme.titleMedium),
        const SizedBox(height: AppSpacing.sm),
        if (stats.atRisk.isEmpty)
          const Text(
            'Nenhum aluno com várias negativas.',
            key: Key('stats_no_risk'),
          )
        else
          Card(
            child: Column(
              key: const Key('stats_at_risk'),
              children: [
                for (final s in stats.atRisk)
                  ListTile(
                    key: Key('stats_risk_${s.studentId}'),
                    leading: Icon(
                      Icons.warning_amber_outlined,
                      color: theme.colorScheme.error,
                    ),
                    title: Text(s.name),
                    subtitle: Text('Média ${formatReportGrade(s.average)}'),
                    trailing: Text('${s.negatives} negativas'),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Kpi extends StatelessWidget {
  const _Kpi({required this.id, required this.label, required this.value});

  final String id;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 200,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.labelMedium),
              Text(
                value,
                key: Key('stats_kpi_$id'),
                style: theme.textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 440,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.md),
            child,
          ],
        ),
      ),
    ),
  );
}
