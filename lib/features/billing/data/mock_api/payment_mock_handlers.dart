import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/invoicing.dart';
import '../../domain/payments.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/payment.dart';
import '../models/receipt.dart';
import '../repositories/api_payment_repository.dart';

/// Handlers de `/v1/payments`, `/v1/receipts` e `/v1/student-accounts`
/// (docs/07-mock-api.md). A alocação actualiza o estado das cobranças e o
/// saldo reconcilia sempre: `saldo = pré-pago - em dívida`. Pagamentos
/// concluídos são imutáveis (sem edição nem remoção).
class PaymentMockHandlers implements MockApiModule {
  PaymentMockHandlers({
    required this._chargesOf,
    required this._setChargeStatus,
    this._onPayment,
    DateTime Function()? clock,
  }) : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  /// Notifica cada pagamento registado (ex.: o caixa regista o numerário).
  final void Function(Payment payment)? _onPayment;
  final List<Charge> Function(String studentId) _chargesOf;
  final void Function(String id, ChargeStatus status) _setChargeStatus;
  final DateTime Function() _clock;

  late Map<String, Payment> _payments;
  late Map<String, Receipt> _receipts;
  late Map<String, int> _sequences;
  late SeedGenerator _ids;

  void _reset() {
    _payments = {};
    _receipts = {};
    _sequences = {};
    _ids = SeedGenerator(560);
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/payments', _list)
      ..post('/v1/payments', _create)
      ..patch('/v1/payments/{id}', _immutable)
      ..put('/v1/payments/{id}', _immutable)
      ..delete('/v1/payments/{id}', _immutable)
      ..get('/v1/receipts', _listReceipts)
      ..get('/v1/student-accounts/{studentId}', _account);
  }

  late final _paymentSpec = MockListSpec<Payment>(
    sortable: {'paidAt': (p) => p.paidAt, 'amountMinor': (p) => p.amountMinor},
    filterable: {'studentId': (p) => p.studentId},
    defaultSort: const ['-paidAt'],
  );

  late final _receiptSpec = MockListSpec<Receipt>(
    sortable: {'issuedAt': (r) => r.issuedAt},
    filterable: {
      'studentId': (r) => r.studentId,
      'paymentId': (r) => r.paymentId,
    },
    defaultSort: const ['-issuedAt'],
  );

  MockResponse _list(MockRequest req) => mockPaginate(
    _payments.values,
    req,
    toJson: (p) => p.toJson(),
    spec: _paymentSpec,
  );

  MockResponse _listReceipts(MockRequest req) => mockPaginate(
    _receipts.values,
    req,
    toJson: (r) => r.toJson(),
    spec: _receiptSpec,
  );

  MockResponse _immutable(MockRequest req) =>
      throw const MockApiException.conflict('Pagamento registado é imutável');

  /// Todos os pagamentos (usado pela cobrança/devedores).
  List<Payment> allPayments() => _payments.values.toList();

  Iterable<Payment> _paymentsOf(String studentId) =>
      _payments.values.where((p) => p.studentId == studentId);

  MockResponse _account(MockRequest req) {
    final id = req.params['studentId']!;
    return MockResponse.ok(
      buildStudentAccount(
        studentId: id,
        institutionId: MockRef.institutionId,
        charges: _chargesOf(id),
        payments: _paymentsOf(id),
        now: _clock(),
      ).toJson(),
    );
  }

  MockResponse _create(MockRequest req) {
    final b = req.jsonBody;
    final methods = paymentMethodWire.entries.where(
      (e) => e.value == b['method'],
    );
    final amount = b['amountMinor'];
    MockValidator(b)
      ..required('studentId')
      ..check('method', methods.isNotEmpty, 'Método de pagamento inválido')
      ..check('amountMinor', amount is int && amount > 0, 'Valor inválido')
      ..throwIfInvalid();
    final studentId = '${b['studentId']}';
    final method = methods.first.key;
    final total = amount! as int;
    final charges = _chargesOf(studentId);
    final byId = {for (final c in charges) c.id: c};
    final allocated = allocatedByCharge(_paymentsOf(studentId));
    final prepaid = method == PaymentMethod.prepaidBalance;
    if (prepaid && total > prepaidAvailableMinor(_paymentsOf(studentId))) {
      throw const MockApiException.validation({
        'amountMinor': 'Saldo pré-pago insuficiente',
      });
    }

    final List<PaymentAllocation> allocations;
    final raw = b['allocations'];
    if (raw == null) {
      allocations = autoAllocate(
        charges: charges,
        allocated: allocated,
        amountMinor: total,
      ).allocations;
    } else {
      if (raw is! List) {
        throw const MockApiException.validation({
          'allocations': 'Alocações inválidas',
        });
      }
      allocations = [
        for (final a in raw)
          PaymentAllocation.fromJson(Map<String, dynamic>.from(a as Map)),
      ];
      final seen = <String>{};
      for (final a in allocations) {
        final c = byId[a.chargeId];
        if (c == null || !isChargeOpen(c)) {
          throw MockApiException.validation({
            'allocations': 'Cobrança ${a.chargeId} indisponível para pagamento',
          });
        }
        if (!seen.add(a.chargeId) || a.amountMinor <= 0) {
          throw const MockApiException.validation({
            'allocations': 'Alocação inválida',
          });
        }
        if (a.amountMinor > outstandingOf(c, allocated[c.id] ?? 0)) {
          throw const MockApiException.validation({
            'allocations': 'Valor alocado excede o em dívida da cobrança',
          });
        }
      }
    }
    final sum = allocations.fold<int>(0, (a, x) => a + x.amountMinor);
    if (sum > total) {
      throw const MockApiException.validation({
        'allocations': 'Alocado superior ao valor do pagamento',
      });
    }
    if (prepaid && sum != total) {
      throw const MockApiException.validation({
        'amountMinor': 'O saldo pré-pago só pode pagar cobranças em dívida',
      });
    }

    final now = _clock();
    final payment = Payment(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: charges.isEmpty ? null : charges.first.campusId,
      createdAt: now,
      updatedAt: now,
      studentId: studentId,
      method: method,
      amountMinor: total,
      paidAt: now,
      allocations: allocations,
    );
    _payments[payment.id] = payment;
    _onPayment?.call(payment);
    final after = allocatedByCharge(_paymentsOf(studentId));
    for (final a in allocations) {
      _setChargeStatus(
        a.chargeId,
        statusAfterAllocation(byId[a.chargeId]!, after[a.chargeId] ?? 0),
      );
    }

    Receipt? receipt;
    if (!prepaid) {
      final series = 'RC ${now.year}';
      final seq = (_sequences[series] ?? 0) + 1;
      _sequences[series] = seq;
      receipt = Receipt(
        id: _ids.ulid(now),
        institutionId: payment.institutionId,
        campusId: payment.campusId,
        createdAt: now,
        updatedAt: now,
        studentId: studentId,
        paymentId: payment.id,
        number: formatDocumentNumber(series, seq),
        issuedAt: now,
        amountMinor: total,
      );
      _receipts[receipt.id] = receipt;
    }
    return MockResponse.created({
      'payment': payment.toJson(),
      'receipt': receipt?.toJson(),
    });
  }
}
