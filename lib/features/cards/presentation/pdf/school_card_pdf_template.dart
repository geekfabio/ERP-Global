import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../data/models/card_model.dart';

/// Cartão escolar imprimível. A identificação QR do cartão é distinta do QR
/// de verificação que o motor acrescenta no rodapé.
class SchoolCardPdfTemplate implements PdfDocumentTemplate {
  const SchoolCardPdfTemplate(this.card);

  final CardModel card;

  @override
  String get title => 'Cartão escolar';

  @override
  String get fileName =>
      'cartao-${card.uid.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-')}';

  @override
  String get verificationCode => 'ERP-GLOBAL/CARTAO/${card.id}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle style) => [
    pw.Center(
      child: pw.Container(
        width: 310,
        padding: const pw.EdgeInsets.all(18),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(color: style.brand, width: 1.5),
          borderRadius: pw.BorderRadius.circular(10),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'CARTÃO ESCOLAR',
              style: pw.TextStyle(
                color: style.brand,
                fontSize: 13,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              PdfTemplateStyle.plain(card.holderName),
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              card.holderType == CardHolderType.student
                  ? 'Aluno'
                  : 'Funcionário',
              style: style.body,
            ),
            pw.SizedBox(height: 18),
            pw.Row(
              children: [
                pw.Expanded(
                  child: style.fields([('UID', card.uid), ('Estado', _status)]),
                ),
                pw.BarcodeWidget(
                  barcode: pw.Barcode.qrCode(),
                  data: card.uid,
                  width: 74,
                  height: 74,
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ];

  String get _status => switch (card.status) {
    CardStatus.active => 'Activo',
    CardStatus.blocked => 'Bloqueado',
    CardStatus.replaced => 'Substituído',
  };
}
