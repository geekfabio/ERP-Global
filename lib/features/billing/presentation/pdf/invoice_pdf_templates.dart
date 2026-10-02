import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/credit_note.dart';
import '../../data/models/invoice.dart';
import '../../domain/invoicing.dart';

String _short(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

String _fileSafe(String s) => s.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-');

/// Factura emitida: linhas, IVA e total. Anulada leva a indicação no corpo.
class InvoicePdfTemplate implements PdfDocumentTemplate {
  const InvoicePdfTemplate(this.invoice, {this.creditNoteNumber});

  final Invoice invoice;

  /// Número da nota de crédito, quando a factura foi anulada.
  final String? creditNoteNumber;

  @override
  String get title => 'Factura ${invoice.number ?? ''}'.trim();

  @override
  String get fileName => 'factura-${_fileSafe(invoice.number ?? invoice.id)}';

  @override
  String get verificationCode =>
      'ERP-FT-${_short(invoice.id)}-${invoice.number ?? ''}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final totals = invoiceTotals(invoice.lines);
    final cancelled = invoice.cancelReason != null;
    return [
      s.section('Documento'),
      s.fields([
        ('Número', invoice.number),
        ('Série', invoice.series),
        (
          'Data de emissão',
          invoice.issuedAt == null
              ? null
              : PtAoFormatters.date(invoice.issuedAt!),
        ),
        ('Aluno (ref.)', _short(invoice.studentId)),
      ]),
      if (cancelled) ...[
        s.section('Anulada'),
        s.fields([
          ('Motivo', invoice.cancelReason),
          ('Nota de crédito', creditNoteNumber),
        ]),
      ],
      s.section('Linhas'),
      s.table(
        const ['Descrição', 'Valor líquido', 'IVA', 'Imposto'],
        [
          for (final l in invoice.lines)
            [
              l.description,
              PtAoFormatters.currency(l.amountMinor),
              vatRateLabel(l.taxRateBp),
              PtAoFormatters.currency(l.taxMinor),
            ],
        ],
      ),
      ..._exemptions(s),
      s.section('Totais'),
      s.fields([
        ('Total líquido', PtAoFormatters.currency(totals.net)),
        ('Total de IVA', PtAoFormatters.currency(totals.tax)),
        ('Total a pagar', PtAoFormatters.currency(totals.total)),
      ]),
    ];
  }

  List<pw.Widget> _exemptions(PdfTemplateStyle s) {
    final reasons = {
      for (final l in invoice.lines)
        if (l.exemptionReason != null && l.exemptionReason!.isNotEmpty)
          l.exemptionReason!,
    };
    if (reasons.isEmpty) return const [];
    return [
      pw.SizedBox(height: 6),
      pw.Text('Isenção: ${reasons.join('; ')}', style: s.label),
    ];
  }
}

/// Nota de crédito que anula integralmente uma factura.
class CreditNotePdfTemplate implements PdfDocumentTemplate {
  const CreditNotePdfTemplate(this.note, {this.invoiceNumber});

  final CreditNote note;
  final String? invoiceNumber;

  @override
  String get title => 'Nota de crédito ${note.number}';

  @override
  String get fileName => 'nota-credito-${_fileSafe(note.number)}';

  @override
  String get verificationCode => 'ERP-NC-${_short(note.id)}-${note.number}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) => [
    s.section('Documento'),
    s.fields([
      ('Número', note.number),
      ('Série', note.series),
      ('Data de emissão', PtAoFormatters.date(note.issuedAt)),
      ('Factura anulada', invoiceNumber ?? _short(note.invoiceId)),
      ('Aluno (ref.)', _short(note.studentId)),
      ('Valor creditado', PtAoFormatters.currency(note.totalMinor)),
    ]),
    s.section('Motivo'),
    pw.Text(PdfTemplateStyle.plain(note.reason), style: s.body),
  ];
}
