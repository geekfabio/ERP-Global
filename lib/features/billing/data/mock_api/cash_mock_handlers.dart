import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/cash.dart';
import '../models/billing_enums.dart';
import '../models/cash_register.dart';
import '../models/cash_session.dart';
import '../models/payment.dart';
import '../repositories/api_cash_repository.dart';

/// Handlers de `/v1/cash-registers` e `/v1/cash-sessions` (docs/07-mock-api.md).
/// Um caixa e um operador só têm uma sessão aberta de cada vez; sessões
/// fechadas são imutáveis. Os pagamentos em numerário entram na sessão aberta
/// via [recordCashPayment].
class CashMockHandlers implements MockApiModule {
  CashMockHandlers({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final DateTime Function() _clock;

  late Map<String, CashRegister> _registers;
  late Map<String, CashSession> _sessions;
  late Map<String, List<CashMovement>> _movements;
  late SeedGenerator _ids;

  void _reset() {
    _ids = SeedGenerator(570);
    final at = DateTime.utc(2025, 9);
    _registers = {};
    var i = 0;
    for (final name in ['Caixa principal', 'Caixa da secretaria']) {
      final r = CashRegister(
        id: _ids.ulid(at.add(Duration(minutes: i++))),
        institutionId: MockRef.institutionId,
        createdAt: at,
        updatedAt: at,
        name: name,
      );
      _registers[r.id] = r;
    }
    _sessions = {};
    _movements = {};
  }

  Iterable<CashSession> get _openSessions =>
      _sessions.values.where((s) => s.status == CashSessionStatus.open);

  /// Regista um pagamento em numerário na sessão aberta mais recente (se
  /// existir). Pagamentos por outros métodos não passam pelo caixa.
  void recordCashPayment(Payment payment) {
    if (payment.method != PaymentMethod.cash) return;
    final open = _openSessions.toList()
      ..sort((a, b) => b.openedAt.compareTo(a.openedAt));
    if (open.isEmpty) return;
    final now = _clock();
    final session = open.first;
    _movements[session.id]!.add(
      CashMovement(
        id: _ids.ulid(now),
        institutionId: payment.institutionId,
        campusId: payment.campusId,
        createdAt: now,
        updatedAt: now,
        sessionId: session.id,
        type: CashMovementType.cashPayment,
        amountMinor: payment.amountMinor,
        occurredAt: now,
        description: 'Pagamento em numerário',
        paymentId: payment.id,
      ),
    );
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/cash-registers', _listRegisters)
      ..get('/v1/cash-sessions', _listSessions)
      ..post('/v1/cash-sessions', _openSession)
      ..get('/v1/cash-sessions/{id}', _get)
      ..patch('/v1/cash-sessions/{id}', _immutable)
      ..put('/v1/cash-sessions/{id}', _immutable)
      ..delete('/v1/cash-sessions/{id}', _immutable)
      ..get('/v1/cash-sessions/{id}/movements', _listMovements)
      ..post('/v1/cash-sessions/{id}/movements', _addMovement)
      ..post('/v1/cash-sessions/{id}/close', _close);
  }

  late final _sessionSpec = MockListSpec<CashSession>(
    sortable: {'openedAt': (s) => s.openedAt},
    filterable: {
      'status': (s) => s.status.name,
      'operatorId': (s) => s.operatorId,
      'cashRegisterId': (s) => s.cashRegisterId,
    },
    defaultSort: const ['-openedAt'],
  );

  late final _movementSpec = MockListSpec<CashMovement>(
    sortable: {'occurredAt': (m) => m.occurredAt},
    defaultSort: const ['occurredAt'],
  );

  CashSession _session(MockRequest req) =>
      _sessions[req.params['id']] ??
      (throw const MockApiException.notFound('Sessão de caixa não encontrada'));

  MockResponse _immutable(MockRequest req) =>
      throw const MockApiException.conflict(
        'Sessão de caixa é imutável; use o fecho',
      );

  MockResponse _listRegisters(MockRequest req) =>
      mockPaginate(_registers.values, req, toJson: (r) => r.toJson());

  MockResponse _listSessions(MockRequest req) => mockPaginate(
    _sessions.values,
    req,
    toJson: (s) => s.toJson(),
    spec: _sessionSpec,
  );

  MockResponse _get(MockRequest req) => MockResponse.ok(_session(req).toJson());

  MockResponse _listMovements(MockRequest req) => mockPaginate(
    _movements[_session(req).id]!,
    req,
    toJson: (m) => m.toJson(),
    spec: _movementSpec,
  );

  MockResponse _openSession(MockRequest req) {
    final b = req.jsonBody;
    final opening = b['openingMinor'];
    MockValidator(b)
      ..required('cashRegisterId')
      ..required('operatorId')
      ..check(
        'openingMinor',
        opening is int && opening >= 0,
        'Valor de abertura inválido',
      )
      ..throwIfInvalid();
    final register = _registers['${b['cashRegisterId']}'];
    if (register == null || register.status != CashRegisterStatus.active) {
      throw const MockApiException.validation({
        'cashRegisterId': 'Caixa inexistente ou inactivo',
      });
    }
    final operatorId = '${b['operatorId']}';
    if (_openSessions.any((s) => s.cashRegisterId == register.id)) {
      throw const MockApiException.conflict('O caixa já tem uma sessão aberta');
    }
    if (_openSessions.any((s) => s.operatorId == operatorId)) {
      throw const MockApiException.conflict(
        'O operador já tem uma sessão aberta',
      );
    }
    final now = _clock();
    final session = CashSession(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: register.campusId,
      createdAt: now,
      updatedAt: now,
      cashRegisterId: register.id,
      operatorId: operatorId,
      openedAt: now,
      openingMinor: opening! as int,
    );
    _sessions[session.id] = session;
    _movements[session.id] = [];
    return MockResponse.created(session.toJson());
  }

  MockResponse _addMovement(MockRequest req) {
    final session = _session(req);
    if (session.status != CashSessionStatus.open) {
      throw const MockApiException.conflict('A sessão de caixa está fechada');
    }
    final b = req.jsonBody;
    final types = cashMovementTypeWire.entries.where(
      (e) => e.value == b['type'] && e.key != CashMovementType.cashPayment,
    );
    final amount = b['amountMinor'];
    MockValidator(b)
      ..check('type', types.isNotEmpty, 'Tipo de movimento inválido')
      ..check('amountMinor', amount is int && amount > 0, 'Valor inválido')
      ..throwIfInvalid();
    final type = types.first.key;
    final list = _movements[session.id]!;
    if (type == CashMovementType.withdrawal &&
        (amount! as int) > expectedCashMinor(session.openingMinor, list)) {
      throw const MockApiException.validation({
        'amountMinor': 'A sangria excede o numerário em caixa',
      });
    }
    final now = _clock();
    final movement = CashMovement(
      id: _ids.ulid(now),
      institutionId: session.institutionId,
      campusId: session.campusId,
      createdAt: now,
      updatedAt: now,
      sessionId: session.id,
      type: type,
      amountMinor: amount! as int,
      occurredAt: now,
      description: (b['description'] as String?)?.trim(),
    );
    list.add(movement);
    return MockResponse.created(movement.toJson());
  }

  MockResponse _close(MockRequest req) {
    final session = _session(req);
    if (session.status != CashSessionStatus.open) {
      throw const MockApiException.conflict(
        'A sessão de caixa já está fechada',
      );
    }
    final b = req.jsonBody;
    final counted = b['countedMinor'];
    MockValidator(b)
      ..check(
        'countedMinor',
        counted is int && counted >= 0,
        'Valor contado inválido',
      )
      ..throwIfInvalid();
    final expected = expectedCashMinor(
      session.openingMinor,
      _movements[session.id]!,
    );
    final difference = cashDifferenceMinor(
      countedMinor: counted! as int,
      expectedMinor: expected,
    );
    final notes = (b['notes'] as String?)?.trim();
    if (difference != 0 && (notes == null || notes.isEmpty)) {
      throw const MockApiException.validation({
        'notes': 'Justifique a diferença de conferência',
      });
    }
    final now = _clock();
    final closed = session.copyWith(
      status: CashSessionStatus.closed,
      closedAt: now,
      updatedAt: now,
      expectedMinor: expected,
      countedMinor: counted,
      differenceMinor: difference,
      closingNotes: notes == null || notes.isEmpty ? null : notes,
    );
    _sessions[session.id] = closed;
    return MockResponse.ok(closed.toJson());
  }
}
