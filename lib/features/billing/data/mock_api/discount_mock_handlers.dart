import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/discounts.dart';
import '../models/billing_enums.dart';
import '../models/discount.dart';

/// Handlers de `/v1/discounts` (docs/07-mock-api.md): pedido, aprovação,
/// rejeição e revogação de descontos e bolsas. Só os aprovados contam para a
/// cobrança ([discountFor]); cada decisão recalcula as cobranças em aberto do
/// aluno através de [onChanged]. Estado em memória; `POST /__mock/reset`
/// repõe-no.
class DiscountMockHandlers implements MockApiModule {
  DiscountMockHandlers({this.onChanged, DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  /// Chamado com o aluno cujos descontos aprovados mudaram.
  final void Function(String studentId)? onChanged;
  final DateTime Function() _clock;

  late Map<String, Discount> _discounts;
  late SeedGenerator _ids;

  void _reset() {
    _discounts = {};
    _ids = SeedGenerator(540);
  }

  static const _date = DateOnlyConverter();

  /// Desconto aprovado e válido sobre uma cobrança (menor unidade).
  int discountFor(
    String studentId,
    FeeType type,
    DateTime due,
    int amountMinor,
  ) => totalDiscountMinor(
    _discounts.values.where((d) => d.studentId == studentId),
    type: type,
    due: due,
    amountMinor: amountMinor,
  );

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/discounts', _list)
      ..post('/v1/discounts', _create)
      ..get('/v1/discounts/{id}', _get)
      ..post(
        '/v1/discounts/{id}/approve',
        (req) => _decide(req, _Action.approve),
      )
      ..post('/v1/discounts/{id}/reject', (req) => _decide(req, _Action.reject))
      ..post(
        '/v1/discounts/{id}/revoke',
        (req) => _decide(req, _Action.revoke),
      );
  }

  late final _spec = MockListSpec<Discount>(
    sortable: {
      'createdAt': (d) => d.createdAt,
      'validFrom': (d) => d.validFrom,
    },
    filterable: {
      'studentId': (d) => d.studentId,
      'status': (d) => d.status.name,
    },
    defaultSort: const ['-createdAt'],
  );

  MockResponse _list(MockRequest req) => mockPaginate(
    _discounts.values.where((d) => d.deletedAt == null),
    req,
    toJson: (d) => d.toJson(),
    spec: _spec,
  );

  Discount _find(MockRequest req) =>
      _discounts[req.params['id']] ?? (throw const MockApiException.notFound());

  MockResponse _get(MockRequest req) => MockResponse.ok(_find(req).toJson());

  DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    try {
      return _date.fromJson('$raw');
    } on FormatException {
      return null;
    }
  }

  MockResponse _create(MockRequest req) {
    final b = req.jsonBody;
    final kinds = DiscountKind.values.where((k) => k.name == b['kind']);
    final reasons = DiscountReason.values.where((k) => k.name == b['reason']);
    final types = FeeType.values.where((t) => t.name == b['feeType']);
    final value = b['value'];
    final from = _parseDate(b['validFrom']);
    final until = _parseDate(b['validUntil']);
    final kind = kinds.isEmpty ? null : kinds.first;
    MockValidator(b)
      ..required('studentId')
      ..check('kind', kind != null, 'Tipo inválido')
      ..check('reason', reasons.isNotEmpty, 'Motivo inválido')
      ..check(
        'feeType',
        b['feeType'] == null || types.isNotEmpty,
        'Tipo de cobrança inválido',
      )
      ..check(
        'value',
        value is int &&
            value > 0 &&
            (kind != DiscountKind.percentage || value <= 10000),
        kind == DiscountKind.percentage
            ? 'Percentagem inválida (0,01 a 100)'
            : 'Valor inválido',
      )
      ..check('validFrom', from != null, 'Data inválida')
      ..check(
        'validUntil',
        (b['validUntil'] == null || until != null) &&
            (until == null || from == null || !until.isBefore(from)),
        'A validade termina antes de começar',
      )
      ..throwIfInvalid();
    final now = _clock();
    final d = Discount(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      createdAt: now,
      updatedAt: now,
      studentId: '${b['studentId']}',
      kind: kind!,
      reason: reasons.first,
      value: value as int,
      feeType: types.isEmpty ? null : types.first,
      validFrom: from!,
      validUntil: until,
      note: (b['note'] as String?)?.trim().isEmpty ?? true
          ? null
          : (b['note'] as String).trim(),
    );
    _discounts[d.id] = d;
    return MockResponse.created(d.toJson());
  }

  MockResponse _decide(MockRequest req, _Action action) {
    final d = _find(req);
    final from = action == _Action.revoke
        ? DiscountStatus.approved
        : DiscountStatus.pending;
    if (d.status != from) {
      throw MockApiException.conflict(
        action == _Action.revoke
            ? 'Só um desconto aprovado pode ser revogado'
            : 'Este desconto já foi decidido',
      );
    }
    final note = (req.jsonBody['note'] as String?)?.trim();
    final now = _clock();
    final updated = d.copyWith(
      status: switch (action) {
        _Action.approve => DiscountStatus.approved,
        _Action.reject => DiscountStatus.rejected,
        _Action.revoke => DiscountStatus.revoked,
      },
      decisionNote: note == null || note.isEmpty ? null : note,
      decidedAt: now,
      updatedAt: now,
    );
    _discounts[d.id] = updated;
    if (action != _Action.reject) onChanged?.call(d.studentId);
    return MockResponse.ok(updated.toJson());
  }
}

enum _Action { approve, reject, revoke }
