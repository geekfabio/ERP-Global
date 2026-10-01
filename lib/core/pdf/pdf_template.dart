import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Cabeçalho/rodapé institucional partilhado por todos os documentos PDF
/// (docs/04-design-system.md · Documentos impressos).
class PdfLetterhead {
  const PdfLetterhead({
    required this.institutionName,
    this.nif,
    this.address,
    this.phone,
    this.email,
    this.brandColor = '#1B4DB1',
    this.logo,
  });

  final String institutionName;
  final String? nif;
  final String? address;
  final String? phone;
  final String? email;

  /// `#RRGGBB`; valores inválidos usam a cor por omissão.
  final String brandColor;

  /// Imagem do logótipo (PNG/JPG) já carregada; opcional.
  final Uint8List? logo;

  /// Linha de rodapé: NIF e contactos disponíveis.
  String get footerLine => [
    if (nif != null && nif!.isNotEmpty) 'NIF $nif',
    if (address != null && address!.isNotEmpty) address!,
    if (phone != null && phone!.isNotEmpty) phone!,
    if (email != null && email!.isNotEmpty) email!,
  ].join('  |  ');
}

/// Modelo de documento: só descreve o corpo; o `PdfTemplateEngine` trata do
/// cabeçalho, rodapé, paginação e QR de verificação.
abstract interface class PdfDocumentTemplate {
  /// Título do documento (cabeçalho e metadados).
  String get title;

  /// Nome de ficheiro sugerido, sem extensão.
  String get fileName;

  /// Texto codificado no QR de verificação.
  String get verificationCode;

  List<pw.Widget> buildBody(PdfTemplateStyle style);
}

/// Estilos e blocos reutilizáveis pelos modelos (cor da marca incluída).
class PdfTemplateStyle {
  PdfTemplateStyle(this.brand);

  final PdfColor brand;

  static const muted = PdfColors.grey700;
  static const line = PdfColors.grey400;

  /// As fontes base do PDF só cobrem Latin-1: troca travessões por '-'.
  static String plain(String t) => t.replaceAll(RegExp('[–—]'), '-');

  pw.TextStyle get body => const pw.TextStyle(fontSize: 10, lineSpacing: 2);
  pw.TextStyle get bold =>
      pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
  pw.TextStyle get label => const pw.TextStyle(fontSize: 8, color: muted);

  /// Título de secção com filete na cor da marca.
  pw.Widget section(String title) => pw.Container(
    width: double.infinity,
    margin: const pw.EdgeInsets.only(top: 14, bottom: 6),
    padding: const pw.EdgeInsets.only(bottom: 3),
    decoration: pw.BoxDecoration(
      border: pw.Border(bottom: pw.BorderSide(color: brand, width: 1)),
    ),
    child: pw.Text(
      title.toUpperCase(),
      style: pw.TextStyle(
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
        color: brand,
      ),
    ),
  );

  /// Grelha de pares rótulo/valor em duas colunas.
  pw.Widget fields(List<(String, String?)> items) {
    pw.Widget cell((String, String?) f) => pw.Expanded(
      child: pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6, right: 8),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(f.$1, style: label),
            pw.Text(
              (f.$2 == null || f.$2!.isEmpty) ? '-' : plain(f.$2!),
              style: bold,
            ),
          ],
        ),
      ),
    );
    final rows = <pw.Widget>[];
    for (var i = 0; i < items.length; i += 2) {
      rows.add(
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            cell(items[i]),
            if (i + 1 < items.length) cell(items[i + 1]) else pw.Spacer(),
          ],
        ),
      );
    }
    return pw.Column(children: rows);
  }

  /// Tabela simples com cabeçalho na cor da marca.
  pw.Widget table(List<String> headers, List<List<String>> rows) =>
      pw.TableHelper.fromTextArray(
        headers: headers,
        data: [
          for (final r in rows) [for (final c in r) plain(c)],
        ],
        headerStyle: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.white,
        ),
        headerDecoration: pw.BoxDecoration(color: brand),
        cellStyle: const pw.TextStyle(fontSize: 9),
        cellAlignment: pw.Alignment.centerLeft,
        border: pw.TableBorder.all(color: line, width: 0.4),
      );

  /// Linhas de assinatura lado a lado.
  pw.Widget signatures(List<String> names) => pw.Padding(
    padding: const pw.EdgeInsets.only(top: 40),
    child: pw.Row(
      children: [
        for (final n in names)
          pw.Expanded(
            child: pw.Padding(
              padding: const pw.EdgeInsets.symmetric(horizontal: 12),
              child: pw.Column(
                children: [
                  pw.Container(height: 0.6, color: PdfColors.black),
                  pw.SizedBox(height: 3),
                  pw.Text(n, style: label),
                ],
              ),
            ),
          ),
      ],
    ),
  );
}
