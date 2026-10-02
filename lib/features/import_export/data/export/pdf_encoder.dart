import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'export_file.dart';

/// PDF A4 em paisagem com título, data de geração e tabela paginada
/// (o cabeçalho repete-se em cada página).
Future<Uint8List> encodePdf(ExportTable table) async {
  final doc = pw.Document(title: table.title, creator: 'ERP-Global');
  final stamp = DateFormat('dd/MM/yyyy HH:mm').format(table.generatedAt);
  doc.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4.landscape,
      margin: const pw.EdgeInsets.all(28),
      header: (_) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              table.title,
              style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(stamp, style: const pw.TextStyle(fontSize: 9)),
          ],
        ),
      ),
      footer: (ctx) => pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          '${ctx.pageNumber} / ${ctx.pagesCount}',
          style: const pw.TextStyle(fontSize: 9),
        ),
      ),
      build: (_) => [
        pw.TableHelper.fromTextArray(
          headers: table.headers,
          data: table.rows,
          headerStyle: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
          ),
          cellStyle: const pw.TextStyle(fontSize: 8),
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          cellAlignment: pw.Alignment.centerLeft,
          headerAlignment: pw.Alignment.centerLeft,
          border: pw.TableBorder.all(color: PdfColors.grey500, width: 0.4),
        ),
      ],
    ),
  );
  return doc.save();
}
