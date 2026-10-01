import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../data/models/academic_document_models.dart';
import '../../domain/academic_document.dart';

/// Certificado ou declaração emitido. O texto vem já substituído do servidor
/// (`content`); o número sequencial e o QR de verificação ficam no
/// cabeçalho e rodapé do motor PDF.
class AcademicDocumentTemplate implements PdfDocumentTemplate {
  AcademicDocumentTemplate(this.document)
    : assert(
        document.number != null && document.content != null,
        'Só documentos emitidos têm PDF',
      );

  final AcademicDocumentModel document;

  String get _number => document.number!;

  @override
  String get title => PdfTemplateStyle.plain(document.kind.label);

  @override
  String get verificationCode => documentVerificationCode(_number);

  @override
  String get fileName {
    String slug(String s) => s
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return slug(_number);
  }

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle style) => [
    pw.SizedBox(height: 16),
    pw.Center(
      child: pw.Text(
        PdfTemplateStyle.plain('${document.kind.label} n.º $_number'),
        style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
      ),
    ),
    pw.SizedBox(height: 24),
    for (final paragraph in document.content!.split(RegExp(r'\n\s*\n')))
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 12),
        child: pw.Text(
          PdfTemplateStyle.plain(paragraph.trim()),
          style: const pw.TextStyle(fontSize: 11, lineSpacing: 4),
          textAlign: pw.TextAlign.justify,
        ),
      ),
    style.signatures(['A Secretaria', 'A Direcção']),
  ];
}
