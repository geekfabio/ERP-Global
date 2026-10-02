import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../domain/report_card.dart';

/// Boletim no ecrã: mesmas secções, cabeçalhos e linhas do PDF.
class ReportCardView extends StatelessWidget {
  const ReportCardView({super.key, required this.data});

  final ReportCardData data;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    Widget section(String title) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.lg, bottom: AppSpacing.sm),
      child: Text(
        title.toUpperCase(),
        style: text.labelLarge?.copyWith(color: scheme.primary),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Boletim de notas - ${data.termName}',
              key: const Key('report_card_title'),
              style: text.titleLarge,
            ),
            section('Aluno'),
            Wrap(
              spacing: AppSpacing.xl,
              runSpacing: AppSpacing.sm,
              children: [
                _Field('Nome completo', data.studentName),
                _Field('N.º de processo', data.processNumber),
                _Field('Turma', data.classroomLabel),
                _Field('Período', data.termName),
              ],
            ),
            section('Aproveitamento'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                key: const Key('report_card_table'),
                columns: [
                  for (var i = 0; i < data.tableHeaders.length; i++)
                    DataColumn(
                      label: Text(data.tableHeaders[i]),
                      numeric: i > 0 && i < data.tableHeaders.length - 1,
                    ),
                ],
                rows: [
                  for (final row in data.tableRows)
                    DataRow(cells: [for (final c in row) DataCell(Text(c))]),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Média do período: ${formatReportGrade(data.overallAverage)}',
              key: const Key('report_card_average'),
              style: text.titleMedium,
            ),
            section('Faltas'),
            Text(data.absencesLine, key: const Key('report_card_absences')),
            section('Observações do director de turma'),
            Text(
              data.remarks.isEmpty ? '-' : data.remarks,
              key: const Key('report_card_remarks'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: text.labelSmall),
        Text(value, style: text.bodyLarge),
      ],
    );
  }
}
