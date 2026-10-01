import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/billing_plan.dart';
import '../data_mocks/billing_seed.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/fee_item.dart';

/// Handlers de `/v1/fee-items`, `/v1/charges` e `/v1/billing/*`
/// (docs/07-mock-api.md). Estado em memória; `POST /__mock/reset` repõe o seed.
class BillingMockHandlers implements MockApiModule {
  BillingMockHandlers({LateFeeRules Function()? rules})
    : _rules = rules ?? (() => const LateFeeRules()) {
    _reset();
  }

  final LateFeeRules Function() _rules;

  late Map<String, FeeItem> _items;
  late Map<String, Charge> _charges;

  /// Matrícula → cobranças geradas (idempotência).
  late Map<String, List<String>> _byEnrollment;

  /// Cobrança vencida → cobrança da sua multa.
  late Map<String, String> _penalties;
  late SeedGenerator _ids;

  /// Aluno → turma (recebida ao gerar as cobranças da matrícula).
  late Map<String, String> _classrooms;

  void _reset() {
    _classrooms = {};
    _items = {for (final i in buildFeeItemSeed()) i.id: i};
    _charges = {};
    _byEnrollment = {};
    _penalties = {};
    _ids = SeedGenerator(530);
  }

  /// Consulta usada pelo módulo de facturação (mesmo estado em memória).
  Charge? chargeById(String id) => _charges[id];

  FeeItem? feeItemById(String id) => _items[id];

  /// Cobranças de um aluno (usado pelos pagamentos e conta corrente).
  List<Charge> chargesOf(String studentId) => [
    for (final c in _charges.values)
      if (c.studentId == studentId && c.deletedAt == null) c,
  ];

  /// Todas as cobranças activas (usado pela cobrança/devedores).
  List<Charge> allCharges() => [
    for (final c in _charges.values)
      if (c.deletedAt == null) c,
  ];

  /// Turma do aluno, se conhecida (filtro de devedores por turma).
  String? classroomOf(String studentId) => _classrooms[studentId];

  /// Actualiza o estado de uma cobrança após alocação de pagamentos.
  void setChargeStatus(String id, ChargeStatus status) {
    final c = _charges[id];
    if (c == null || c.status == status) return;
    _charges[id] = c.copyWith(
      status: status,
      updatedAt: DateTime.now().toUtc(),
    );
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/fee-items', _listItems)
      ..post('/v1/fee-items', _createItem)
      ..patch('/v1/fee-items/{id}', _updateItem)
      ..get('/v1/charges', _listCharges)
      ..post('/v1/billing/enrollment-charges', _generate)
      ..post('/v1/billing/late-fees', _applyLateFees);
  }

  // ---- Preços -----------------------------------------------------------

  late final _itemSpec = MockListSpec<FeeItem>(
    sortable: {
      'gradeId': (i) => i.gradeId,
      'amountMinor': (i) => i.amountMinor,
    },
    filterable: {
      'academicYearId': (i) => i.academicYearId,
      'gradeId': (i) => i.gradeId,
      'campusId': (i) => i.campusId,
      'type': (i) => _typeWire(i.type),
      'status': (i) => i.status.name,
    },
    defaultSort: const ['gradeId'],
  );

  /// Valor JSON do tipo (snake_case, como o `@JsonEnum` do modelo).
  String _typeWire(FeeType t) => const {
    FeeType.enrollment: 'enrollment',
    FeeType.tuition: 'tuition',
    FeeType.uniform: 'uniform',
    FeeType.material: 'material',
    FeeType.exam: 'exam',
    FeeType.transport: 'transport',
    FeeType.cafeteria: 'cafeteria',
    FeeType.other: 'other',
  }[t]!;

  MockResponse _listItems(MockRequest req) => mockPaginate(
    _items.values.where((i) => i.deletedAt == null),
    req,
    toJson: (i) => i.toJson(),
    spec: _itemSpec,
  );

  bool _validAmount(Object? v) => v is int && v > 0;

  MockResponse _createItem(MockRequest req) {
    final body = req.jsonBody;
    final types = FeeType.values.where((t) => _typeWire(t) == body['type']);
    MockValidator(body)
      ..required('academicYearId')
      ..required('gradeId')
      ..required('type')
      ..check(
        'amountMinor',
        _validAmount(body['amountMinor']),
        'Valor inválido',
      )
      ..check('type', types.isNotEmpty, 'Tipo inválido')
      ..throwIfInvalid();
    final type = types.first;
    final campusId = body['campusId'] as String?;
    final exists = _items.values.any(
      (i) =>
          i.status == FeeItemStatus.active &&
          i.academicYearId == body['academicYearId'] &&
          i.gradeId == body['gradeId'] &&
          i.campusId == campusId &&
          i.type == type,
    );
    if (exists) {
      throw const MockApiException.conflict(
        'Já existe um preço activo para esta classe, campus e tipo',
      );
    }
    final now = DateTime.now().toUtc();
    final item = FeeItem(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: campusId,
      createdAt: now,
      updatedAt: now,
      academicYearId: '${body['academicYearId']}',
      gradeId: '${body['gradeId']}',
      type: type,
      amountMinor: body['amountMinor'] as int,
    );
    _items[item.id] = item;
    return MockResponse.created(item.toJson());
  }

  MockResponse _updateItem(MockRequest req) {
    final item =
        _items[req.params['id']] ?? (throw const MockApiException.notFound());
    final body = req.jsonBody;
    MockValidator(body)
      ..check(
        'amountMinor',
        !body.containsKey('amountMinor') || _validAmount(body['amountMinor']),
        'Valor inválido',
      )
      ..check(
        'status',
        !body.containsKey('status') ||
            FeeItemStatus.values.any((s) => s.name == body['status']),
        'Estado inválido',
      )
      ..throwIfInvalid();
    final status = body['status'] == null
        ? item.status
        : FeeItemStatus.values.firstWhere((s) => s.name == body['status']);
    final updated = item.copyWith(
      amountMinor: (body['amountMinor'] as int?) ?? item.amountMinor,
      status: status,
      updatedAt: DateTime.now().toUtc(),
    );
    _items[item.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  // ---- Cobranças --------------------------------------------------------

  late final _chargeSpec = MockListSpec<Charge>(
    sortable: {'dueDate': (c) => c.dueDate, 'createdAt': (c) => c.createdAt},
    filterable: {'studentId': (c) => c.studentId},
    defaultSort: const ['dueDate'],
  );

  MockResponse _listCharges(MockRequest req) => mockPaginate(
    _charges.values,
    req,
    toJson: (c) => c.toJson(),
    spec: _chargeSpec,
  );

  /// Preço activo: o do campus pedido, senão o geral, senão qualquer campus.
  FeeItem? _price(Map<String, dynamic> b, FeeType type) {
    final candidates = _items.values.where(
      (i) =>
          i.status == FeeItemStatus.active &&
          i.deletedAt == null &&
          i.type == type &&
          i.academicYearId == b['academicYearId'] &&
          i.gradeId == b['gradeId'],
    );
    final campus = b['campusId'];
    for (final pick in <bool Function(FeeItem)>[
      (i) => campus != null && i.campusId == campus,
      (i) => i.campusId == null,
      (i) => campus == null,
    ]) {
      for (final i in candidates) {
        if (pick(i)) return i;
      }
    }
    return null;
  }

  Charge _newCharge(
    Map<String, dynamic> b,
    FeeItem item,
    DateTime due,
    int amount,
    DateTime now,
  ) {
    final c = Charge(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: item.campusId,
      createdAt: now,
      updatedAt: now,
      studentId: '${b['studentId']}',
      feeItemId: item.id,
      dueDate: due,
      amountMinor: amount,
    );
    _charges[c.id] = c;
    return c;
  }

  MockResponse _generate(MockRequest req) {
    final b = req.jsonBody;
    MockValidator(b)
      ..required('enrollmentId')
      ..required('studentId')
      ..required('academicYearId')
      ..required('gradeId')
      ..throwIfInvalid();
    final classroomId = b['classroomId'];
    if (classroomId is String) _classrooms['${b['studentId']}'] = classroomId;
    final existing = _byEnrollment['${b['enrollmentId']}'];
    if (existing != null) {
      return MockResponse.ok([
        for (final id in existing) _charges[id]!.toJson(),
      ]);
    }
    final tuition = _price(b, FeeType.tuition);
    final enrollment = _price(b, FeeType.enrollment);
    if (tuition == null) {
      throw const MockApiException.validation({
        'gradeId': 'Sem preço de propina para esta classe',
      });
    }
    final now = DateTime.now().toUtc();
    final start = (b['startYear'] as int?) ?? schoolYearStart(now);
    final created = <Charge>[
      if (enrollment != null)
        _newCharge(
          b,
          enrollment,
          DateTime.utc(now.year, now.month, now.day),
          (b['enrollmentFeeMinor'] as int?) ?? enrollment.amountMinor,
          now,
        ),
      for (final due in tuitionDueDates(start))
        _newCharge(b, tuition, due, tuition.amountMinor, now),
    ];
    _byEnrollment['${b['enrollmentId']}'] = [for (final c in created) c.id];
    return MockResponse.created([for (final c in created) c.toJson()]);
  }

  MockResponse _applyLateFees(MockRequest req) {
    final raw = req.jsonBody['asOf'];
    final asOf = raw == null
        ? DateTime.now().toUtc()
        : const DateOnlyConverter().fromJson('$raw');
    final rules = _rules();
    final penaltyIds = _penalties.values.toSet();
    final applied = <Map<String, Object?>>[];
    for (final c in List.of(_charges.values)) {
      final open =
          c.status == ChargeStatus.pending ||
          c.status == ChargeStatus.partiallyPaid ||
          c.status == ChargeStatus.overdue;
      if (!open || penaltyIds.contains(c.id) || _penalties.containsKey(c.id)) {
        continue;
      }
      final fee = computeLateFee(
        amountMinor: c.amountMinor - c.discountMinor,
        dueDate: c.dueDate,
        asOf: asOf,
        rules: rules,
      );
      if (fee == 0) continue;
      final now = DateTime.now().toUtc();
      _charges[c.id] = c.copyWith(status: ChargeStatus.overdue, updatedAt: now);
      final penalty = Charge(
        id: _ids.ulid(now),
        institutionId: c.institutionId,
        campusId: c.campusId,
        createdAt: now,
        updatedAt: now,
        studentId: c.studentId,
        feeItemId: c.feeItemId,
        dueDate: DateTime.utc(asOf.year, asOf.month, asOf.day),
        amountMinor: fee,
      );
      _charges[penalty.id] = penalty;
      _penalties[c.id] = penalty.id;
      applied.add({
        'chargeId': c.id,
        'penaltyChargeId': penalty.id,
        'penaltyMinor': fee,
      });
    }
    return MockResponse.ok(applied);
  }
}
