import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/invoicing.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/credit_note.dart';
import '../models/fee_item.dart';
import '../models/invoice.dart';

/// Handlers de `/v1/invoices` e `/v1/credit-notes` (docs/07-mock-api.md).
/// Séries e numeração locais simples (`FT 2026/000001`); a numeração fiscal
/// definitiva é do backend (#94). Documentos emitidos são imutáveis.
class InvoiceMockHandlers implements MockApiModule {
  InvoiceMockHandlers({
    required this._chargeById,
    required this._feeItemById,
    DateTime Function()? clock,
  }) : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final Charge? Function(String id) _chargeById;
  final FeeItem? Function(String id) _feeItemById;
  final DateTime Function() _clock;

  late Map<String, Invoice> _invoices;
  late Map<String, CreditNote> _creditNotes;
  late Map<String, int> _sequences;
  late SeedGenerator _ids;

  void _reset() {
    _invoices = {};
    _creditNotes = {};
    _sequences = {};
    _ids = SeedGenerator(550);
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/invoices', _list)
      ..post('/v1/invoices', _issue)
      ..post('/v1/invoices/{id}/cancel', _cancel)
      ..patch('/v1/invoices/{id}', _immutable)
      ..put('/v1/invoices/{id}', _immutable)
      ..delete('/v1/invoices/{id}', _immutable)
      ..get('/v1/credit-notes', _listCreditNotes);
  }

  late final _invoiceSpec = MockListSpec<Invoice>(
    sortable: {
      'issuedAt': (i) => i.issuedAt ?? i.createdAt,
      'number': (i) => i.number ?? '',
    },
    filterable: {
      'studentId': (i) => i.studentId,
      'status': (i) => i.status.name,
    },
    defaultSort: const ['-issuedAt'],
  );

  late final _noteSpec = MockListSpec<CreditNote>(
    sortable: {'issuedAt': (n) => n.issuedAt},
    filterable: {'invoiceId': (n) => n.invoiceId},
    defaultSort: const ['-issuedAt'],
  );

  MockResponse _list(MockRequest req) => mockPaginate(
    _invoices.values,
    req,
    toJson: (i) => i.toJson(),
    spec: _invoiceSpec,
  );

  MockResponse _listCreditNotes(MockRequest req) => mockPaginate(
    _creditNotes.values,
    req,
    toJson: (n) => n.toJson(),
    spec: _noteSpec,
  );

  MockResponse _immutable(MockRequest req) =>
      throw const MockApiException.conflict(
        'Documento emitido é imutável; anule-o com uma nota de crédito',
      );

  /// Série do ano e próximo número (sequência por série).
  (String, String) _nextNumber(String prefix, DateTime at) {
    final series = '$prefix ${at.year}';
    final seq = (_sequences[series] ?? 0) + 1;
    _sequences[series] = seq;
    return (series, formatDocumentNumber(series, seq));
  }

  bool _isInvoiced(String chargeId) => _invoices.values.any(
    (i) =>
        i.status == InvoiceStatus.issued &&
        i.lines.any((l) => l.chargeId == chargeId),
  );

  MockResponse _issue(MockRequest req) {
    final b = req.jsonBody;
    final ids = b['chargeIds'];
    final rate = b['taxRateBp'];
    MockValidator(b)
      ..required('studentId')
      ..check(
        'chargeIds',
        ids is List && ids.isNotEmpty && ids.every((e) => e is String),
        'Seleccione pelo menos uma cobrança',
      )
      ..check(
        'taxRateBp',
        rate is int && vatRatesBp.contains(rate),
        'Taxa de IVA inválida',
      )
      ..check(
        'exemptionReason',
        rate != 0 || '${b['exemptionReason'] ?? ''}'.trim().isNotEmpty,
        'Indique o motivo da isenção',
      )
      ..throwIfInvalid();
    final studentId = '${b['studentId']}';
    final lines = <InvoiceLine>[];
    Charge? first;
    for (final id in (ids as List).cast<String>().toSet()) {
      final charge =
          _chargeById(id) ??
          (throw MockApiException.validation({
            'chargeIds': 'Cobrança $id inexistente',
          }));
      if (charge.studentId != studentId) {
        throw const MockApiException.validation({
          'chargeIds': 'Cobranças de outro aluno',
        });
      }
      if (charge.status == ChargeStatus.cancelled) {
        throw const MockApiException.validation({
          'chargeIds': 'Cobrança anulada',
        });
      }
      if (_isInvoiced(id)) {
        throw const MockApiException.conflict('Cobrança já facturada');
      }
      first ??= charge;
      final fee = _feeItemById(charge.feeItemId);
      lines.add(
        buildInvoiceLine(
          chargeId: id,
          description: fee == null ? 'Cobrança' : feeTypeLabelsPt[fee.type]!,
          netMinor: charge.amountMinor - charge.discountMinor,
          rateBp: rate as int,
          exemptionReason: b['exemptionReason'] as String?,
        ),
      );
    }
    final now = _clock();
    final (series, number) = _nextNumber('FT', now);
    final totals = invoiceTotals(lines);
    final invoice = Invoice(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: first!.campusId,
      createdAt: now,
      updatedAt: now,
      studentId: studentId,
      number: number,
      series: series,
      issuedAt: now,
      status: InvoiceStatus.issued,
      lines: lines,
      taxMinor: totals.tax,
      totalMinor: totals.total,
    );
    _invoices[invoice.id] = invoice;
    return MockResponse.created(invoice.toJson());
  }

  MockResponse _cancel(MockRequest req) {
    final invoice =
        _invoices[req.params['id']] ??
        (throw const MockApiException.notFound());
    final b = req.jsonBody;
    MockValidator(b)
      ..required('reason', 'Indique o motivo da anulação')
      ..throwIfInvalid();
    if (invoice.status != InvoiceStatus.issued) {
      throw const MockApiException.conflict('Factura já anulada');
    }
    final now = _clock();
    final (series, number) = _nextNumber('NC', now);
    final note = CreditNote(
      id: _ids.ulid(now),
      institutionId: invoice.institutionId,
      campusId: invoice.campusId,
      createdAt: now,
      updatedAt: now,
      studentId: invoice.studentId,
      invoiceId: invoice.id,
      number: number,
      series: series,
      issuedAt: now,
      reason: '${b['reason']}'.trim(),
      totalMinor: invoice.totalMinor,
    );
    final cancelled = invoice.copyWith(
      status: InvoiceStatus.cancelled,
      cancelReason: note.reason,
      creditNoteId: note.id,
      updatedAt: now,
    );
    _creditNotes[note.id] = note;
    _invoices[invoice.id] = cancelled;
    return MockResponse.ok({
      'invoice': cancelled.toJson(),
      'creditNote': note.toJson(),
    });
  }
}
