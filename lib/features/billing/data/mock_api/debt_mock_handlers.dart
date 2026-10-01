import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/debt.dart';
import '../../domain/payments.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/debtor.dart';
import '../models/payment.dart';
import '../models/payment_agreement.dart';
import '../models/payment_notice.dart';
import '../repositories/api_debt_repository.dart';

/// Handlers de `/v1/billing/debtors`, `/v1/billing/notices` e
/// `/v1/payment-agreements` (docs/07-mock-api.md). Os devedores e o estado dos
/// acordos são calculados a partir das cobranças e pagamentos (nunca
/// guardados). Estado em memória; `POST /__mock/reset` repõe-no.
class DebtMockHandlers implements MockApiModule {
  DebtMockHandlers({
    required this._allCharges,
    required this._allPayments,
    required this._classroomOf,
    DateTime Function()? clock,
  }) : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final List<Charge> Function() _allCharges;
  final List<Payment> Function() _allPayments;
  final String? Function(String studentId) _classroomOf;
  final DateTime Function() _clock;

  late Map<String, PaymentNotice> _notices;
  late Map<String, PaymentAgreement> _agreements;
  late SeedGenerator _ids;

  void _reset() {
    _notices = {};
    _agreements = {};
    _ids = SeedGenerator(580);
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/billing/debtors', _debtors)
      ..get('/v1/billing/notices', _listNotices)
      ..post('/v1/billing/notices/run', _runNotices)
      ..get('/v1/payment-agreements', _listAgreements)
      ..post('/v1/payment-agreements', _createAgreement)
      ..get('/v1/payment-agreements/{id}', _getAgreement)
      ..post('/v1/payment-agreements/{id}/cancel', _cancelAgreement);
  }

  static const _date = DateOnlyConverter();

  Map<String, int> get _allocated => allocatedByCharge(_allPayments());

  DateTime _asOf(Object? raw) {
    if (raw == null) return _clock();
    try {
      return _date.fromJson('$raw');
    } on FormatException {
      throw const MockApiException.validation({'asOf': 'Data inválida'});
    }
  }

  /// Acordos com o estado calculado agora.
  List<PaymentAgreement> _evaluated(DateTime asOf) {
    final byId = {for (final c in _allCharges()) c.id: c};
    final allocated = _allocated;
    return [
      for (final a in _agreements.values)
        evaluateAgreement(
          a,
          asOf: asOf,
          outstandingMinor: a.chargeIds.fold<int>(0, (sum, id) {
            final c = byId[id];
            return c == null ? sum : sum + outstandingOf(c, allocated[id] ?? 0);
          }),
        ),
    ];
  }

  // ---- Devedores --------------------------------------------------------

  late final _debtorSpec = MockListSpec<Debtor>(
    sortable: {
      'overdueMinor': (d) => d.overdueMinor,
      'daysOverdue': (d) => d.daysOverdue,
      'oldestDueDate': (d) => d.oldestDueDate,
    },
    filterable: {'classroomId': (d) => d.classroomId},
  );

  MockResponse _debtors(MockRequest req) {
    final asOf = _asOf(req.query['asOf']);
    final month = req.query['filter[month]'];
    if (month != null && !RegExp(r'^\d{4}-(0[1-9]|1[0-2])$').hasMatch(month)) {
      throw const MockApiException.validation({
        'filter[month]': 'Mês inválido (yyyy-MM)',
      });
    }
    final withAgreement = {
      for (final a in _evaluated(asOf))
        if (a.status == AgreementStatus.active) a.studentId,
    };
    final debtors = buildDebtors(
      charges: _allCharges(),
      allocated: _allocated,
      asOf: asOf,
      classroomOf: _classroomOf,
      studentsWithAgreement: withAgreement,
      month: month,
    );
    return mockPaginate(
      debtors,
      // `month` e `asOf` já foram aplicados ao cálculo dos devedores.
      MockRequest(
        method: req.method,
        path: req.path,
        query: {
          for (final e in req.query.entries)
            if (e.key != 'filter[month]' && e.key != 'asOf') e.key: e.value,
        },
      ),
      toJson: (d) => d.toJson(),
      spec: _debtorSpec,
    );
  }

  // ---- Avisos -----------------------------------------------------------

  late final _noticeSpec = MockListSpec<PaymentNotice>(
    sortable: {'sentAt': (n) => n.sentAt},
    filterable: {
      'studentId': (n) => n.studentId,
      'kind': (n) => noticeKindWire[n.kind],
    },
    defaultSort: const ['-sentAt'],
  );

  MockResponse _listNotices(MockRequest req) => mockPaginate(
    _notices.values,
    req,
    toJson: (n) => n.toJson(),
    spec: _noticeSpec,
  );

  String _noticeMessage(PlannedNotice p) {
    final amount = PtAoFormatters.currency(p.amountMinor);
    final due = PtAoFormatters.date(p.charge.dueDate);
    return p.kind == NoticeKind.preDue
        ? 'Lembrete: tem $amount a vencer em $due.'
        : 'Aviso: tem $amount em atraso desde $due.';
  }

  MockResponse _runNotices(MockRequest req) {
    final b = req.jsonBody;
    final days = b['preDueDays'] ?? 3;
    MockValidator(b)
      ..check(
        'preDueDays',
        days is int && days >= 0 && days <= 30,
        'Dias de antecedência inválidos (0 a 30)',
      )
      ..throwIfInvalid();
    final asOf = _asOf(b['asOf']);
    final exempt = {
      for (final a in _evaluated(asOf))
        if (a.status == AgreementStatus.active) ...a.chargeIds,
    };
    final planned = planNotices(
      charges: _allCharges(),
      allocated: _allocated,
      asOf: asOf,
      preDueDays: days as int,
      sent: {for (final n in _notices.values) noticeKey(n.chargeId, n.kind)},
      exempt: exempt,
    );
    final now = _clock();
    final created = <PaymentNotice>[
      for (final p in planned)
        PaymentNotice(
          id: _ids.ulid(now),
          institutionId: MockRef.institutionId,
          campusId: p.charge.campusId,
          createdAt: now,
          updatedAt: now,
          studentId: p.charge.studentId,
          chargeId: p.charge.id,
          kind: p.kind,
          dueDate: p.charge.dueDate,
          amountMinor: p.amountMinor,
          message: _noticeMessage(p),
          sentAt: now,
        ),
    ];
    for (final n in created) {
      _notices[n.id] = n;
    }
    return MockResponse.ok([for (final n in created) n.toJson()]);
  }

  // ---- Acordos ----------------------------------------------------------

  late final _agreementSpec = MockListSpec<PaymentAgreement>(
    sortable: {
      'createdAt': (a) => a.createdAt,
      'totalMinor': (a) => a.totalMinor,
    },
    filterable: {
      'studentId': (a) => a.studentId,
      'status': (a) => a.status.name,
    },
    defaultSort: const ['-createdAt'],
  );

  MockResponse _listAgreements(MockRequest req) => mockPaginate(
    _evaluated(_clock()),
    req,
    toJson: (a) => a.toJson(),
    spec: _agreementSpec,
  );

  PaymentAgreement _find(MockRequest req) {
    final a = _evaluated(
      _clock(),
    ).where((a) => a.id == req.params['id']).firstOrNull;
    return a ?? (throw const MockApiException.notFound());
  }

  MockResponse _getAgreement(MockRequest req) =>
      MockResponse.ok(_find(req).toJson());

  MockResponse _cancelAgreement(MockRequest req) {
    final a = _find(req);
    if (a.status == AgreementStatus.completed) {
      throw const MockApiException.conflict('O acordo já foi cumprido');
    }
    final cancelled = _agreements[a.id]!.copyWith(
      status: AgreementStatus.cancelled,
      updatedAt: _clock(),
    );
    _agreements[a.id] = cancelled;
    return MockResponse.ok(cancelled.toJson());
  }

  MockResponse _createAgreement(MockRequest req) {
    final b = req.jsonBody;
    final count = b['installmentCount'];
    final rawIds = b['chargeIds'];
    DateTime? first;
    try {
      first = _date.fromJson('${b['firstDueDate']}');
    } on FormatException {
      first = null;
    }
    final now = _clock();
    MockValidator(b)
      ..required('studentId')
      ..check(
        'chargeIds',
        rawIds == null ||
            (rawIds is List &&
                rawIds.isNotEmpty &&
                rawIds.every((e) => e is String)),
        'Seleccione as cobranças do acordo',
      )
      ..check(
        'installmentCount',
        count is int && count >= 2 && count <= 12,
        'O acordo tem de ter entre 2 e 12 prestações',
      )
      ..check(
        'firstDueDate',
        first != null && !dayOf(first).isBefore(dayOf(now)),
        'A primeira prestação não pode estar no passado',
      )
      ..throwIfInvalid();
    final studentId = '${b['studentId']}';
    final byId = {for (final c in _allCharges()) c.id: c};
    final allocated = _allocated;
    // Sem cobranças indicadas, abrange tudo o que o aluno tem em atraso.
    final ids = rawIds == null
        ? [
            for (final c in byId.values)
              if (c.studentId == studentId &&
                  isChargeOverdue(c, allocated[c.id] ?? 0, now))
                c.id,
          ]
        : (rawIds as List).cast<String>().toSet().toList();
    if (ids.isEmpty) {
      throw const MockApiException.validation({
        'chargeIds': 'O aluno não tem cobranças em atraso',
      });
    }
    var total = 0;
    for (final id in ids) {
      final c = byId[id];
      if (c == null ||
          c.studentId != studentId ||
          !isChargeOverdue(c, allocated[id] ?? 0, now)) {
        throw MockApiException.validation({
          'chargeIds': 'Cobrança $id não está em atraso para este aluno',
        });
      }
      total += outstandingOf(c, allocated[id] ?? 0);
    }
    final taken = {
      for (final a in _evaluated(now))
        if (a.status == AgreementStatus.active) ...a.chargeIds,
    };
    if (ids.any(taken.contains)) {
      throw const MockApiException.conflict(
        'Há cobranças já incluídas num acordo em curso',
      );
    }
    final agreement = PaymentAgreement(
      id: _ids.ulid(now),
      institutionId: MockRef.institutionId,
      campusId: byId[ids.first]!.campusId,
      createdAt: now,
      updatedAt: now,
      studentId: studentId,
      chargeIds: ids,
      totalMinor: total,
      installments: splitInstallments(
        totalMinor: total,
        count: count! as int,
        firstDue: first!,
      ),
    );
    _agreements[agreement.id] = agreement;
    return MockResponse.created(agreement.toJson());
  }
}
