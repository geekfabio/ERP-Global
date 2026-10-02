import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/payment.dart';
import '../../data/models/receipt.dart';
import '../../domain/payments.dart';

String _short(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

/// Recibo de um pagamento, com o método e as cobranças liquidadas.
class ReceiptPdfTemplate implements PdfDocumentTemplate {
  const ReceiptPdfTemplate(this.receipt, this.payment);

  final Receipt receipt;
  final Payment payment;

  @override
  String get title => 'Recibo ${receipt.number}';

  @override
  String get fileName =>
      'recibo-${receipt.number.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-')}';

  @override
  String get verificationCode =>
      'ERP-RC-${_short(receipt.id)}-${receipt.number}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final allocated = payment.allocations.fold<int>(
      0,
      (a, x) => a + x.amountMinor,
    );
    final advance = payment.method == PaymentMethod.prepaidBalance
        ? 0
        : payment.amountMinor - allocated;
    return [
      s.section('Documento'),
      s.fields([
        ('Número', receipt.number),
        ('Data de emissão', PtAoFormatters.date(receipt.issuedAt)),
        ('Aluno (ref.)', _short(receipt.studentId)),
        ('Método', paymentMethodLabelsPt[payment.method]),
        ('Valor recebido', PtAoFormatters.currency(receipt.amountMinor)),
      ]),
      if (payment.allocations.isNotEmpty) ...[
        s.section('Cobranças liquidadas'),
        s.table(
          const ['Cobrança (ref.)', 'Valor'],
          [
            for (final a in payment.allocations)
              [_short(a.chargeId), PtAoFormatters.currency(a.amountMinor)],
          ],
        ),
      ],
      if (advance > 0) ...[
        pw.SizedBox(height: 6),
        pw.Text(
          'Adiantamento (saldo pré-pago): '
          '${PtAoFormatters.currency(advance)}',
          style: s.label,
        ),
      ],
    ];
  }
}
