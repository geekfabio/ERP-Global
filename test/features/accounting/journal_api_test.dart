import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/accounting/data/mock_api/accounting_mock_handlers.dart';
import 'package:erp_global/features/accounting/data/mock_api/journal_mock_handlers.dart';
import 'package:erp_global/features/accounting/data/models/accounting_models.dart';
import 'package:erp_global/features/accounting/data/models/journal_models.dart';
import 'package:erp_global/features/accounting/data/repositories/api_accounting_repositories.dart';
import 'package:erp_global/features/accounting/data/repositories/api_journal_repositories.dart';
import 'package:erp_global/features/accounting/domain/journal_rules.dart';
import 'package:flutter_test/flutter_test.dart';

typedef _Env = ({
  ApiJournalRepository journal,
  ApiOpenItemRepository items,
  Map<String, AccountModel> byCode,
});

Future<_Env> _env() async {
  final accounting = AccountingMockHandlers();
  final registry = MockApiRegistry()
    ..addModule(accounting)
    ..addModule(JournalMockHandlers(accounting));
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  final accounts = (await ApiAccountRepository(
    client,
  ).list()).getOrThrow().items;
  return (
    journal: ApiJournalRepository(client),
    items: ApiOpenItemRepository(client),
    byCode: {for (final a in accounts) a.code: a},
  );
}

JournalEntryModel _entry(
  Map<String, AccountModel> a,
  List<(String, int, int)> lines, {
  DateTime? date,
}) => JournalEntryModel(
  id: '',
  date: date ?? DateTime.utc(2026, 3, 1),
  description: 'Teste',
  lines: [
    for (final (code, d, c) in lines)
      JournalLineModel(accountId: a[code]!.id, debitMinor: d, creditMinor: c),
  ],
);

String? _code(Result<Object?> r) => r.failureOrNull?.code;

Map<String, String> _fields(Result<Object?> r) =>
    (r.failureOrNull! as ValidationFailure).fields;

void main() {
  group('partidas dobradas', () {
    test('regras: débito = crédito, duas linhas, um lado por linha', () {
      const l = JournalLineModel(accountId: 'a', debitMinor: 10);
      const r = JournalLineModel(accountId: 'b', creditMinor: 10);
      const short = JournalLineModel(accountId: 'b', creditMinor: 9);
      const both = JournalLineModel(
        accountId: 'a',
        debitMinor: 5,
        creditMinor: 5,
      );
      expect(JournalRules.validate(const [l, r]), isEmpty);
      expect(JournalRules.validate(const [l]), contains('lines'));
      expect(JournalRules.validate(const [l, short]), contains('lines'));
      expect(JournalRules.validate(const [both, r]), contains('lines'));
      expect(JournalRules.parseMinor('1500,5'), 150050);
      expect(JournalRules.parseMinor('abc'), isNull);
    });

    test('lança balanceado e rejeita desbalanceado (422)', () async {
      final e = await _env();
      final ok = (await e.journal.create(
        _entry(e.byCode, [('45', 1000, 0), ('721', 0, 1000)]),
      )).getOrThrow();
      expect(ok.number, 5);
      final bad = await e.journal.create(
        _entry(e.byCode, [('45', 1000, 0), ('721', 0, 900)]),
      );
      expect(_fields(bad), contains('lines'));
    });

    test('409 em conta não movimentável e em exercício fechado', () async {
      final e = await _env();
      final parent = await e.journal.create(
        _entry(e.byCode, [('4', 1000, 0), ('721', 0, 1000)]),
      );
      expect(_code(parent), 'CONFLICT');
      final closed = await e.journal.create(
        _entry(e.byCode, [
          ('45', 1000, 0),
          ('721', 0, 1000),
        ], date: DateTime.utc(2025, 6, 1)),
      );
      expect(_code(closed), 'CONFLICT');
    });

    test('estorno inverte e não pode repetir', () async {
      final e = await _env();
      final entry = (await e.journal.create(
        _entry(e.byCode, [('45', 700, 0), ('721', 0, 700)]),
      )).getOrThrow();
      final reversal = (await e.journal.reverse(entry.id)).getOrThrow();
      expect(reversal.reversalOfId, entry.id);
      expect(reversal.lines.first.creditMinor, 700);
      expect(_code(await e.journal.reverse(entry.id)), 'CONFLICT');
      expect(_code(await e.journal.reverse(reversal.id)), 'CONFLICT');
    });
  });

  group('razão e balancete', () {
    test('o balancete fecha sempre: ∑ débitos = ∑ créditos', () async {
      final e = await _env();
      await e.journal.create(
        _entry(e.byCode, [('62', 250, 0), ('45', 0, 250)]),
      );
      final tb = (await e.journal.trialBalance()).getOrThrow();
      expect(tb.totalDebitMinor, tb.totalCreditMinor);
      expect(tb.rows.fold<int>(0, (s, r) => s + r.closingMinor), 0);
    });

    test('razão tem saldo corrido e agrega subcontas', () async {
      final e = await _env();
      final cash = (await e.journal.ledger(e.byCode['45']!.id)).getOrThrow();
      expect(cash.closingMinor, 80000000);
      expect(cash.lines.last.balanceMinor, cash.closingMinor);
      final monetary = (await e.journal.ledger(e.byCode['4']!.id)).getOrThrow();
      expect(monetary.closingMinor, 580000000); // 43 + 45
      final later = (await e.journal.ledger(
        e.byCode['45']!.id,
        from: DateTime.utc(2026, 3, 1),
      )).getOrThrow();
      expect(later.openingMinor, 80000000);
      expect(later.lines, isEmpty);
    });

    test('diário filtra por conta e período', () async {
      final e = await _env();
      final all = (await e.journal.list()).getOrThrow().items;
      expect(all.map((x) => x.number), [1, 2, 3, 4]);
      final cash = (await e.journal.list(
        accountId: e.byCode['45']!.id,
      )).getOrThrow().items;
      expect(cash, hasLength(1));
      final feb = (await e.journal.list(
        from: DateTime.utc(2026, 2),
        to: DateTime.utc(2026, 2, 9),
      )).getOrThrow().items;
      expect(feb.single.number, 2);
    });
  });

  group('eventos de billing', () {
    BillingEventModel ev(
      BillingEventType t, {
      String? method,
      String ref = 'P1',
    }) => BillingEventModel(
      event: t,
      referenceId: ref,
      amountMinor: 5000,
      occurredOn: DateTime.utc(2026, 4, 2),
      method: method,
    );

    test('cobrança e pagamento geram lançamentos, idempotentes', () async {
      final e = await _env();
      final charge = (await e.journal.postBillingEvent(
        ev(BillingEventType.chargeIssued),
      )).getOrThrow();
      expect(charge.source, JournalSource.billing);
      expect(charge.lines.first.accountId, e.byCode['311']!.id);
      final again = (await e.journal.postBillingEvent(
        ev(BillingEventType.chargeIssued),
      )).getOrThrow();
      expect(again.id, charge.id);

      final pay = (await e.journal.postBillingEvent(
        ev(BillingEventType.paymentReceived, method: 'cash'),
      )).getOrThrow();
      expect(pay.lines.first.accountId, e.byCode['45']!.id);
      expect(JournalRules.isBalanced(pay.lines), isTrue);
      expect((await e.journal.list()).getOrThrow().meta.total, 6);
    });

    test('estorno de pagamento anula o lançamento original', () async {
      final e = await _env();
      final pay = (await e.journal.postBillingEvent(
        ev(BillingEventType.paymentReceived),
      )).getOrThrow();
      final rev = (await e.journal.postBillingEvent(
        ev(BillingEventType.paymentReversed),
      )).getOrThrow();
      expect(rev.reversalOfId, pay.id);
      final missing = await e.journal.postBillingEvent(
        ev(BillingEventType.paymentReversed, ref: 'X'),
      );
      expect(_code(missing), 'NOT_FOUND');
    });
  });

  group('contas a pagar/receber', () {
    OpenItemModel payable(_Env e, {String counter = '62'}) => OpenItemModel(
      id: '',
      kind: OpenItemKind.payable,
      party: 'Electricidade',
      description: 'Luz',
      amountMinor: 1000,
      issueDate: DateTime.utc(2026, 5, 1),
      dueDate: DateTime.utc(2026, 5, 20),
      counterAccountId: e.byCode[counter]!.id,
    );

    test('seed tem a receber parcial e a pagar em aberto', () async {
      final e = await _env();
      final items = (await e.items.list()).getOrThrow().items;
      expect(
        items.map((i) => i.status),
        contains(OpenItemStatus.partiallyPaid),
      );
      final pay = (await e.items.list(
        kind: OpenItemKind.payable,
      )).getOrThrow().items;
      expect(pay.single.status, OpenItemStatus.open);
    });

    test('cria a pagar com lançamento e liquida em duas vezes', () async {
      final e = await _env();
      final item = (await e.items.create(payable(e))).getOrThrow();
      expect(item.entryId, isNotNull);
      Future<Result<OpenItemModel>> settle(int amount) => e.items.settle(
        item.id,
        amountMinor: amount,
        date: DateTime.utc(2026, 5, 10),
        cashAccountId: e.byCode['45']!.id,
      );
      expect(
        (await settle(400)).getOrThrow().status,
        OpenItemStatus.partiallyPaid,
      );
      expect(_fields(await settle(700)), contains('amountMinor'));
      expect((await settle(600)).getOrThrow().status, OpenItemStatus.paid);
      expect(_code(await settle(1)), 'CONFLICT');
      final tb = (await e.journal.trialBalance()).getOrThrow();
      expect(tb.totalDebitMinor, tb.totalCreditMinor);
    });

    test('contrapartida tem de ser custo (a pagar)', () async {
      final e = await _env();
      final r = await e.items.create(payable(e, counter: '721'));
      expect(_fields(r), contains('counterAccountId'));
    });
  });
}
