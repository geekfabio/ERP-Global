import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../domain/report_card.dart';

/// Boletim de notas por aluno e trimestre. Desenha-se a partir dos mesmos
/// [ReportCardData] (cabeçalhos, linhas e faltas) que o ecrã.
class ReportCardTemplate implements PdfDocumentTemplate {
  ReportCardTemplate(this.data, {required this.verificationCode});

  final ReportCardData data;

  @override
  final String verificationCode;

  @override
  String get title =>
      PdfTemplateStyle.plain('Boletim de notas - ${data.termName}');

  @override
  String get fileName {
    String slug(String s) => s
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return 'boletim-${slug(data.processNumber)}-${slug(data.termName)}';
  }

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle style) {
    final average = data.overallAverage;
    return [
      style.section('Aluno'),
      style.fields([
        ('Nome completo', data.studentName),
        ('N.º de processo', data.processNumber),
        ('Turma', data.classroomLabel),
        ('Período', data.termName),
      ]),
      style.section('Aproveitamento'),
      style.table(data.tableHeaders, data.tableRows),
      pw.SizedBox(height: 6),
      pw.Text(
        'Média do período: ${formatReportGrade(average)}',
        style: style.bold,
      ),
      style.section('Faltas'),
      pw.Text(PdfTemplateStyle.plain(data.absencesLine), style: style.body),
      style.section('Observações do director de turma'),
      pw.Text(
        data.remarks.isEmpty ? '-' : PdfTemplateStyle.plain(data.remarks),
        style: style.body,
      ),
      style.signatures(['O Director de Turma', 'A Direcção Pedagógica']),
    ];
  }
}
