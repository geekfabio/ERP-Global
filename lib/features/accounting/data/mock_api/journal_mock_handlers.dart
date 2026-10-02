import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../domain/journal_rules.dart';
import '../data_mocks/journal_seed.dart';
import '../models/accounting_models.dart';
import '../models/journal_models.dart';
import 'accounting_mock_handlers.dart';

const _dates = DateOnlyConverter();

/// Handlers de `/v1/journal-entries`, `/v1/ledger`, `/v1/trial-balance` e
/// `/v1/open-items` (docs/07-mock-api.md). Lê contas e exercícios do
/// [AccountingMockHandlers]; estado mutável em memória.
class JournalMockHandlers implements MockApiModule {
  JournalMockHandlers(this._accounting) {
    _reset();
  }

  final AccountingMockHandlers _accounting;
  late Map<String, JournalEntryModel> _entries;
  late Map<String, OpenItemModel> _items;
  late SeedGenerator _ids;
  late int _lastNumber;

  void _reset() {
    final s = buildJournalSeed();
    _ids = SeedGenerator(611);
    _entries = {for (final e in s.entries) e.id: e};
    _items = {for (final i in s.openItems) i.id: i};
    _lastNumber = s.entries.length;
  }

  String _newId() => _ids.ulid(DateTime.now().toUtc());

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/journal-entries', _listEntries)
      ..post('/v1/journal-entries', _createEntry)
      ..post('/v1/journal-entries/billing-events', _billingEvent)
      ..post('/v1/journal-entries/{id}/reverse', _reverse)
      ..get('/v1/ledger', _ledger)
      ..get('/v1/trial-balance', _trialBalance)
      ..get('/v1/open-items', _listItems)
      ..post('/v1/open-items', _createItem)
      ..post('/v1/open-items/{id}/settle', _settle);
  }

  // ---- Contas e exercícios ----------------------------------------------

  Map<String, AccountModel> get _accountsById => {
    for (final a in _accounting.accounts) a.id: a,
  };

  String _idOfCode(String code) =>
      _accounting.accounts.firstWhere((a) => a.code == code).id;

  void _assertOpenYear(DateTime date) {
    final year = _accounting.fiscalYears
        .where((y) => !date.isBefore(y.startDate) && !date.isAfter(y.endDate))
        .firstOrNull;
    if (year == null) {
      throw const MockApiException.conflict('Não existe exercício para a data');
    }
    if (year.status == FiscalYearStatus.closed) {
      throw MockApiException.conflict('O ${year.name} está fechado');
    }
  }

  DateTime _date(Object? raw, String field) {
    try {
      return _dates.fromJson('$raw');
    } on FormatException {
      throw MockApiException.validation({field: 'Data inválida'});
    }
  }

  DateTime? _optionalDate(MockRequest req, String key) =>
      req.query[key] == null ? null : _date(req.query[key], key);

  // ---- Lançamentos -------------------------------------------------------

  /// Valida e grava; a única porta de entrada de lançamentos (manuais,
  /// automáticos e de títulos), por isso débito = crédito é sempre garantido.
  JournalEntryModel _post({
    required DateTime date,
    required String description,
    required List<JournalLineModel> lines,
    JournalSource source = JournalSource.manual,
    String? sourceRef,
    String? reversalOfId,
  }) {
    final errors = JournalRules.validate(lines);
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    final accounts = _accountsById;
    for (final l in lines) {
      final account = accounts[l.accountId];
      if (account == null) {
        throw const MockApiException.validation({'lines': 'Conta inexistente'});
      }
      if (!account.postable || !account.isActive) {
        throw MockApiException.conflict(
          'A conta ${account.code} não aceita lançamentos',
        );
      }
    }
    _assertOpenYear(date);
    final entry = JournalEntryModel(
      id: _newId(),
      number: ++_lastNumber,
      date: date,
      description: description,
      lines: lines,
      source: source,
      sourceRef: sourceRef,
      reversalOfId: reversalOfId,
    );
    _entries[entry.id] = entry;
    return entry;
  }

  late final _entrySpec = MockListSpec<JournalEntryModel>(
    searchText: (e) => '${e.number} ${e.description}',
    sortable: {'date': (e) => e.date, 'number': (e) => e.number},
    filterable: {
      'status': (e) => e.status.name,
      'source': (e) => e.source.name,
    },
    defaultSort: const ['date', 'number'],
  );

  bool _inPeriod(DateTime d, DateTime? from, DateTime? to) =>
      (from == null || !d.isBefore(from)) && (to == null || !d.isAfter(to));

  MockResponse _listEntries(MockRequest req) {
    final from = _optionalDate(req, 'from');
    final to = _optionalDate(req, 'to');
    final accountId = req.query['accountId'];
    final scope = accountId == null ? null : _subtree(accountId);
    return mockPaginate(
      _entries.values.where(
        (e) =>
            _inPeriod(e.date, from, to) &&
            (scope == null || e.lines.any((l) => scope.contains(l.accountId))),
      ),
      req,
      toJson: (e) => e.toJson(),
      spec: _entrySpec,
    );
  }

  MockResponse _createEntry(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('date')
      ..required('description')
      ..check('lines', body['lines'] is List, 'Campo obrigatório')
      ..throwIfInvalid();
    final date = _date(body['date'], 'date');
    final List<JournalLineModel> lines;
    try {
      lines = [
        for (final l in body['lines'] as List)
          JournalLineModel.fromJson(l as Map<String, dynamic>),
      ];
    } on Object {
      throw const MockApiException.validation({'lines': 'Linhas inválidas'});
    }
    return MockResponse.created(
      _post(
        date: date,
        description: '${body['description']}'.trim(),
        lines: lines,
      ).toJson(),
    );
  }

  JournalEntryModel _reverseEntry(JournalEntryModel entry) {
    if (entry.status == JournalEntryStatus.reversed ||
        entry.reversalOfId != null) {
      throw const MockApiException.conflict(
        'O lançamento já foi estornado ou é um estorno',
      );
    }
    final reversal = _post(
      date: entry.date,
      description: 'Estorno do lançamento n.º ${entry.number}',
      lines: [
        for (final l in entry.lines)
          l.copyWith(debitMinor: l.creditMinor, creditMinor: l.debitMinor),
      ],
      source: entry.source,
      reversalOfId: entry.id,
    );
    _entries[entry.id] = entry.copyWith(status: JournalEntryStatus.reversed);
    return reversal;
  }

  MockResponse _reverse(MockRequest req) {
    final entry =
        _entries[req.params['id']] ?? (throw const MockApiException.notFound());
    return MockResponse.created(_reverseEntry(entry).toJson());
  }

  // ---- Eventos de billing ------------------------------------------------

  MockResponse _billingEvent(MockRequest req) {
    final BillingEventModel event;
    try {
      event = BillingEventModel.fromJson(req.jsonBody);
    } on Object {
      throw const MockApiException.validation({'event': 'Evento inválido'});
    }
    if (event.amountMinor <= 0 || event.referenceId.trim().isEmpty) {
      throw const MockApiException.validation({
        'amountMinor': 'Valor e referência são obrigatórios',
      });
    }
    final type = _eventName(event.event);
    final ref = '$type:${event.referenceId}';
    final existing = _entries.values.where((e) => e.sourceRef == ref);
    // Idempotente: o mesmo evento não gera um segundo lançamento.
    if (existing.isNotEmpty) return MockResponse.ok(existing.first.toJson());

    final amount = event.amountMinor;
    final text = event.description ?? event.referenceId;
    JournalEntryModel entry;
    switch (event.event) {
      case BillingEventType.chargeIssued:
        entry = _post(
          date: event.occurredOn,
          description: 'Cobrança emitida — $text',
          lines: [
            JournalLineModel(accountId: _idOfCode('311'), debitMinor: amount),
            JournalLineModel(accountId: _idOfCode('721'), creditMinor: amount),
          ],
          source: JournalSource.billing,
          sourceRef: ref,
        );
      case BillingEventType.paymentReceived:
        entry = _post(
          date: event.occurredOn,
          description: 'Pagamento recebido — $text',
          lines: [
            JournalLineModel(
              accountId: _idOfCode(event.method == 'cash' ? '45' : '43'),
              debitMinor: amount,
            ),
            JournalLineModel(accountId: _idOfCode('311'), creditMinor: amount),
          ],
          source: JournalSource.billing,
          sourceRef: ref,
        );
      case BillingEventType.paymentReversed:
        final original = _entries.values
            .where(
              (e) => e.sourceRef == 'payment.received:${event.referenceId}',
            )
            .firstOrNull;
        if (original == null) throw const MockApiException.notFound();
        entry = _reverseEntry(original).copyWith(sourceRef: ref);
        _entries[entry.id] = entry;
    }
    return MockResponse.created(entry.toJson());
  }

  String _eventName(BillingEventType t) => switch (t) {
    BillingEventType.chargeIssued => 'charge.issued',
    BillingEventType.paymentReceived => 'payment.received',
    BillingEventType.paymentReversed => 'payment.reversed',
  };

  // ---- Razão e balancete -------------------------------------------------

  /// Conta e descendentes.
  Set<String> _subtree(String id) {
    final all = _accounting.accounts.toList();
    final ids = {id};
    var grew = true;
    while (grew) {
      grew = false;
      for (final a in all) {
        if (a.parentId != null && ids.contains(a.parentId) && ids.add(a.id)) {
          grew = true;
        }
      }
    }
    return ids;
  }

  Iterable<JournalEntryModel> get _sortedEntries =>
      _entries.values.toList()..sort((a, b) {
        final byDate = a.date.compareTo(b.date);
        return byDate != 0 ? byDate : a.number.compareTo(b.number);
      });

  MockResponse _ledger(MockRequest req) {
    final accountId = req.query['accountId'];
    final account = accountId == null ? null : _accountsById[accountId];
    if (account == null) {
      throw const MockApiException.validation({'accountId': 'Conta inválida'});
    }
    final from = _optionalDate(req, 'from');
    final to = _optionalDate(req, 'to');
    final scope = _subtree(account.id);
    var opening = 0;
    var debit = 0;
    var credit = 0;
    final lines = <LedgerLineModel>[];
    for (final e in _sortedEntries) {
      var d = 0;
      var c = 0;
      for (final l in e.lines.where((l) => scope.contains(l.accountId))) {
        d += l.debitMinor;
        c += l.creditMinor;
      }
      if (d == 0 && c == 0) continue;
      if (from != null && e.date.isBefore(from)) {
        opening += d - c;
      } else if (to == null || !e.date.isAfter(to)) {
        debit += d;
        credit += c;
        lines.add(
          LedgerLineModel(
            entryId: e.id,
            number: e.number,
            date: e.date,
            description: e.description,
            debitMinor: d,
            creditMinor: c,
            balanceMinor: opening + debit - credit,
          ),
        );
      }
    }
    return MockResponse.ok(
      LedgerModel(
        accountId: account.id,
        code: account.code,
        name: account.name,
        openingMinor: opening,
        debitMinor: debit,
        creditMinor: credit,
        closingMinor: opening + debit - credit,
        lines: lines,
      ).toJson(),
    );
  }

  MockResponse _trialBalance(MockRequest req) {
    final from = _optionalDate(req, 'from');
    final to = _optionalDate(req, 'to');
    final opening = <String, int>{};
    final debit = <String, int>{};
    final credit = <String, int>{};
    for (final e in _entries.values) {
      final before = from != null && e.date.isBefore(from);
      if (!before && !_inPeriod(e.date, from, to)) continue;
      for (final l in e.lines) {
        if (before) {
          opening.update(
            l.accountId,
            (v) => v + l.debitMinor - l.creditMinor,
            ifAbsent: () => l.debitMinor - l.creditMinor,
          );
        } else {
          debit.update(
            l.accountId,
            (v) => v + l.debitMinor,
            ifAbsent: () => l.debitMinor,
          );
          credit.update(
            l.accountId,
            (v) => v + l.creditMinor,
            ifAbsent: () => l.creditMinor,
          );
        }
      }
    }
    final accounts = _accountsById;
    final ids = {...opening.keys, ...debit.keys}.toList()
      ..sort((a, b) => accounts[a]!.code.compareTo(accounts[b]!.code));
    final rows = [
      for (final id in ids)
        TrialBalanceRowModel(
          accountId: id,
          code: accounts[id]!.code,
          name: accounts[id]!.name,
          openingMinor: opening[id] ?? 0,
          debitMinor: debit[id] ?? 0,
          creditMinor: credit[id] ?? 0,
          closingMinor:
              (opening[id] ?? 0) + (debit[id] ?? 0) - (credit[id] ?? 0),
        ),
    ];
    return MockResponse.ok(
      TrialBalanceModel(
        rows: rows,
        totalDebitMinor: rows.fold(0, (s, r) => s + r.debitMinor),
        totalCreditMinor: rows.fold(0, (s, r) => s + r.creditMinor),
      ).toJson(),
    );
  }

  // ---- Contas a pagar / receber ------------------------------------------

  late final _itemSpec = MockListSpec<OpenItemModel>(
    searchText: (i) => '${i.party} ${i.description}',
    sortable: {'dueDate': (i) => i.dueDate},
    filterable: {'kind': (i) => i.kind.name, 'status': (i) => i.status.name},
    defaultSort: const ['dueDate'],
  );

  MockResponse _listItems(MockRequest req) => mockPaginate(
    _items.values,
    req,
    toJson: (i) => i.toJson(),
    spec: _itemSpec,
  );

  MockResponse _createItem(MockRequest req) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('party')
      ..required('description')
      ..required('issueDate')
      ..required('dueDate')
      ..required('counterAccountId')
      ..check(
        'amountMinor',
        body['amountMinor'] is int && (body['amountMinor'] as int) > 0,
        'Valor inválido',
      )
      ..check(
        'kind',
        OpenItemKind.values.any((k) => k.name == body['kind']),
        'Tipo inválido',
      )
      ..throwIfInvalid();
    final kind = OpenItemKind.values.byName(body['kind'] as String);
    final issue = _date(body['issueDate'], 'issueDate');
    final due = _date(body['dueDate'], 'dueDate');
    if (due.isBefore(issue)) {
      throw const MockApiException.validation({
        'dueDate': 'O vencimento não pode ser anterior à emissão',
      });
    }
    final counter = _accountsById['${body['counterAccountId']}'];
    final expected = kind == OpenItemKind.payable
        ? AccountType.expense
        : AccountType.income;
    if (counter == null || counter.type != expected) {
      throw MockApiException.validation({
        'counterAccountId': kind == OpenItemKind.payable
            ? 'Escolha uma conta de custos'
            : 'Escolha uma conta de proveitos',
      });
    }
    final amount = body['amountMinor'] as int;
    final id = _newId();
    final party = '${body['party']}'.trim();
    final description = '${body['description']}'.trim();
    final payable = kind == OpenItemKind.payable;
    final entry = _post(
      date: issue,
      description: description,
      lines: [
        JournalLineModel(
          accountId: payable ? counter.id : _idOfCode('311'),
          debitMinor: amount,
        ),
        JournalLineModel(
          accountId: payable ? _idOfCode('321') : counter.id,
          creditMinor: amount,
        ),
      ],
      source: JournalSource.openItem,
      sourceRef: 'open-item:$id',
    );
    final item = OpenItemModel(
      id: id,
      kind: kind,
      party: party,
      description: description,
      amountMinor: amount,
      issueDate: issue,
      dueDate: due,
      counterAccountId: counter.id,
      entryId: entry.id,
    );
    _items[id] = item;
    return MockResponse.created(item.toJson());
  }

  MockResponse _settle(MockRequest req) {
    final item =
        _items[req.params['id']] ?? (throw const MockApiException.notFound());
    final body = req.jsonBody;
    MockValidator(body)
      ..required('date')
      ..required('cashAccountId')
      ..check(
        'amountMinor',
        body['amountMinor'] is int && (body['amountMinor'] as int) > 0,
        'Valor inválido',
      )
      ..throwIfInvalid();
    if (item.status == OpenItemStatus.paid) {
      throw const MockApiException.conflict('O título já está liquidado');
    }
    final amount = body['amountMinor'] as int;
    if (amount > item.amountMinor - item.paidMinor) {
      throw const MockApiException.validation({
        'amountMinor': 'Excede o valor em dívida',
      });
    }
    final cash = _accountsById['${body['cashAccountId']}'];
    if (cash == null || cash.type != AccountType.asset) {
      throw const MockApiException.validation({
        'cashAccountId': 'Escolha uma conta de caixa ou banco',
      });
    }
    final payable = item.kind == OpenItemKind.payable;
    final party = _idOfCode(payable ? '321' : '311');
    _post(
      date: _date(body['date'], 'date'),
      description: payable
          ? 'Pagamento — ${item.description}'
          : 'Recebimento — ${item.description}',
      lines: [
        JournalLineModel(
          accountId: payable ? party : cash.id,
          debitMinor: amount,
        ),
        JournalLineModel(
          accountId: payable ? cash.id : party,
          creditMinor: amount,
        ),
      ],
      source: JournalSource.openItem,
      sourceRef: 'open-item:${item.id}:settle',
    );
    final paid = item.paidMinor + amount;
    final updated = item.copyWith(
      paidMinor: paid,
      status: paid == item.amountMinor
          ? OpenItemStatus.paid
          : OpenItemStatus.partiallyPaid,
    );
    _items[item.id] = updated;
    return MockResponse.ok(updated.toJson());
  }
}
