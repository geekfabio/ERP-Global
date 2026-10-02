import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../domain/pauta.dart';

/// Pauta da turma (trimestral ou final). Desenha-se a partir dos mesmos
/// cabeçalhos e linhas de [PautaData] que o ecrã e a exportação Excel.
class PautaTemplate implements PdfDocumentTemplate {
  PautaTemplate(this.data, {this.termIndex, required this.verificationCode});

  final PautaData data;

  /// `null` = pauta final.
  final int? termIndex;

  @override
  final String verificationCode;

  @override
  String get title =>
      PdfTemplateStyle.plain('Pauta ${data.scopeName(termIndex)}');

  @override
  String get fileName {
    String slug(String s) => s
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return 'pauta-${slug(data.classroomLabel)}-${slug(data.scopeName(termIndex))}';
  }

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle style) => [
    style.section('Turma'),
    style.fields([
      ('Turma', data.classroomLabel),
      ('Ano lectivo', data.yearName),
      ('Pauta', data.scopeName(termIndex)),
      (
        'Estado',
        data.approved ? 'Aprovada pelo conselho de turma' : 'Provisória',
      ),
    ]),
    style.section('Resultados'),
    style.table(data.tableHeaders(termIndex), data.tableRows(termIndex)),
    style.signatures(['O Director de Turma', 'A Direcção Pedagógica']),
  ];
}
