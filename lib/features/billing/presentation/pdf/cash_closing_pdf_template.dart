import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/cash_session.dart';
import '../../domain/cash.dart';
import 'package:pdf/widgets.dart' as pw;

String _short(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

/// Relatório de fecho de caixa: totais, conferência e movimentos da sessão.
class CashClosingPdfTemplate implements PdfDocumentTemplate {
  const CashClosingPdfTemplate({
    required this.session,
    required this.movements,
    required this.registerName,
  });

  final CashSession session;
  final List<CashMovement> movements;
  final String registerName;

  @override
  String get title => 'Fecho de caixa - $registerName';

  @override
  String get fileName => 'fecho-caixa-${_short(session.id)}';

  @override
  String get verificationCode => 'ERP-CX-${_short(session.id)}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    final expected =
        session.expectedMinor ??
        expectedCashMinor(session.openingMinor, movements);
    final diff = session.differenceMinor;
    return [
      s.section('Sessão'),
      s.fields([
        ('Caixa', registerName),
        ('Operador (ref.)', _short(session.operatorId)),
        ('Abertura', PtAoFormatters.dateTime(session.openedAt)),
        (
          'Fecho',
          session.closedAt == null
              ? 'Em aberto'
              : PtAoFormatters.dateTime(session.closedAt!),
        ),
      ]),
      s.section('Conferência'),
      s.fields([
        ('Fundo de abertura', PtAoFormatters.currency(session.openingMinor)),
        (
          'Recebimentos',
          PtAoFormatters.currency(
            totalOfType(movements, CashMovementType.cashPayment),
          ),
        ),
        (
          'Reforços',
          PtAoFormatters.currency(
            totalOfType(movements, CashMovementType.supply),
          ),
        ),
        (
          'Sangrias',
          PtAoFormatters.currency(
            totalOfType(movements, CashMovementType.withdrawal),
          ),
        ),
        ('Esperado', PtAoFormatters.currency(expected)),
        (
          'Contado',
          session.countedMinor == null
              ? null
              : PtAoFormatters.currency(session.countedMinor!),
        ),
        ('Diferença', diff == null ? null : PtAoFormatters.currency(diff)),
        ('Justificação', session.closingNotes),
      ]),
      s.section('Movimentos'),
      if (movements.isEmpty)
        pw.Text('Sem movimentos.', style: s.body)
      else
        s.table(
          const ['Hora', 'Tipo', 'Descrição', 'Valor'],
          [
            for (final m in movements)
              [
                PtAoFormatters.dateTime(m.occurredAt),
                cashMovementLabelsPt[m.type]!,
                m.description ?? '',
                PtAoFormatters.currency(signedMovementMinor(m)),
              ],
          ],
        ),
    ];
  }
}
