import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_template.dart';

/// Motor de modelos PDF: A4 com cabeçalho institucional (logo, nome, título),
/// rodapé (NIF/contactos, página) e QR de verificação. Reutilizável por
/// matrícula, boletim, recibo e demais documentos impressos.
class PdfTemplateEngine {
  const PdfTemplateEngine();

  static final _hex = RegExp(r'^#[0-9A-Fa-f]{6}$');

  /// Cor `#RRGGBB` → [PdfColor]; azul por omissão se inválida.
  static PdfColor parseColor(String? hex) {
    if (hex == null || !_hex.hasMatch(hex)) {
      return const PdfColor.fromInt(0xFF1B4DB1);
    }
    return PdfColor.fromInt(
      0xFF000000 | int.parse(hex.substring(1), radix: 16),
    );
  }

  Future<Uint8List> render({
    required PdfLetterhead letterhead,
    required PdfDocumentTemplate template,
    required DateTime generatedAt,
  }) async {
    final brand = parseColor(letterhead.brandColor);
    final style = PdfTemplateStyle(brand);
    final doc = pw.Document(
      title: template.title,
      author: letterhead.institutionName,
      creator: 'ERP-Global',
    );
    pw.MemoryImage? logo;
    if (letterhead.logo != null) {
      try {
        logo = pw.MemoryImage(letterhead.logo!);
      } on Object {
        logo = null; // logótipo inválido não deve impedir o documento
      }
    }
    final stamp = DateFormat('dd/MM/yyyy HH:mm').format(generatedAt);
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.fromLTRB(40, 36, 40, 36),
        header: (_) => _header(letterhead, template, brand, logo),
        footer: (ctx) => _footer(letterhead, template, stamp, ctx),
        build: (_) => template.buildBody(style),
      ),
    );
    return doc.save();
  }

  pw.Widget _header(
    PdfLetterhead lh,
    PdfDocumentTemplate t,
    PdfColor brand,
    pw.MemoryImage? logo,
  ) => pw.Container(
    margin: const pw.EdgeInsets.only(bottom: 12),
    padding: const pw.EdgeInsets.only(bottom: 8),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: brand, width: 2)),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        if (logo != null)
          pw.Container(
            width: 48,
            height: 48,
            margin: const pw.EdgeInsets.only(right: 12),
            child: pw.Image(logo, fit: pw.BoxFit.contain),
          ),
        pw.Expanded(
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                lh.institutionName,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: brand,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                t.title,
                style: pw.TextStyle(
                  fontSize: 11,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );

  pw.Widget _footer(
    PdfLetterhead lh,
    PdfDocumentTemplate t,
    String stamp,
    pw.Context ctx,
  ) {
    const small = pw.TextStyle(fontSize: 7, color: PdfTemplateStyle.muted);
    return pw.Container(
      padding: const pw.EdgeInsets.only(top: 6),
      decoration: const pw.BoxDecoration(
        border: pw.Border(top: pw.BorderSide(color: PdfColors.grey400)),
      ),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Expanded(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                if (lh.footerLine.isNotEmpty)
                  pw.Text(lh.footerLine, style: small),
                pw.Text(
                  'Emitido em $stamp  |  Página ${ctx.pageNumber} de '
                  '${ctx.pagesCount}',
                  style: small,
                ),
                pw.Text('Verificação: ${t.verificationCode}', style: small),
              ],
            ),
          ),
          pw.BarcodeWidget(
            barcode: pw.Barcode.qrCode(),
            data: t.verificationCode,
            width: 40,
            height: 40,
          ),
        ],
      ),
    );
  }
}
