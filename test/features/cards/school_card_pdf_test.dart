import 'dart:convert';

import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/features/cards/data/models/card_model.dart';
import 'package:erp_global/features/cards/presentation/pdf/school_card_pdf_template.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('cartão usa o motor PDF institucional e tem QR verificável', () async {
    final card = CardModel(
      id: '01JCARDEXAMPLE000000000000',
      uid: 'RFID-1001',
      holderId: '01JSTUDENT000000000000000',
      holderName: 'Ana Silva',
      holderType: CardHolderType.student,
      issuedAt: DateTime.utc(2026, 1, 1),
    );
    final template = SchoolCardPdfTemplate(card);
    final bytes = await const PdfTemplateEngine().render(
      letterhead: const PdfLetterhead(
        institutionName: 'Colégio Teste',
        nif: '5000000000',
        phone: '+244 900 000 000',
      ),
      template: template,
      generatedAt: DateTime.utc(2026, 1, 2),
    );

    expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(template.fileName, 'cartao-rfid-1001');
    expect(template.verificationCode, 'ERP-GLOBAL/CARTAO/${card.id}');
  });
}
