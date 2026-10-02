import '../data/models/billing_enums.dart';
import '../data/models/invoice.dart';

/// Rótulos (pt-AO) dos tipos de preço.
const feeTypeLabelsPt = <FeeType, String>{
  FeeType.enrollment: 'Matrícula',
  FeeType.tuition: 'Propina',
  FeeType.uniform: 'Uniforme',
  FeeType.material: 'Material',
  FeeType.exam: 'Exame',
  FeeType.transport: 'Transporte',
  FeeType.cafeteria: 'Cantina',
  FeeType.other: 'Outro',
};

/// Taxas de IVA oferecidas na emissão (pontos-base); 0 = isento.
const vatRatesBp = <int>[1400, 700, 500, 0];

/// Imposto de [netMinor] à taxa [rateBp] (pontos-base), arredondado ao cêntimo
/// (meio para cima), só com inteiros.
int computeTax(int netMinor, int rateBp) => (netMinor * rateBp + 5000) ~/ 10000;

/// Linha de factura com imposto calculado.
InvoiceLine buildInvoiceLine({
  required String chargeId,
  required String description,
  required int netMinor,
  required int rateBp,
  String? exemptionReason,
}) => InvoiceLine(
  chargeId: chargeId,
  description: description,
  amountMinor: netMinor,
  taxRateBp: rateBp,
  taxMinor: computeTax(netMinor, rateBp),
  exemptionReason: rateBp == 0 ? exemptionReason : null,
);

/// Totais de uma factura a partir das suas linhas.
({int net, int tax, int total}) invoiceTotals(List<InvoiceLine> lines) {
  final net = lines.fold<int>(0, (a, l) => a + l.amountMinor);
  final tax = lines.fold<int>(0, (a, l) => a + l.taxMinor);
  return (net: net, tax: tax, total: net + tax);
}

/// Número local `<série>/<sequência com 6 dígitos>`, ex.: `FT 2026/000012`.
String formatDocumentNumber(String series, int sequence) =>
    '$series/${sequence.toString().padLeft(6, '0')}';

/// Texto da taxa: `14 %` ou `Isento`.
String vatRateLabel(int rateBp) {
  if (rateBp == 0) return 'Isento';
  final pct = rateBp / 100;
  return '${pct == pct.roundToDouble() ? pct.round() : pct} %';
}
