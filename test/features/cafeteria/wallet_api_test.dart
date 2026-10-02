import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/wallet_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/data/models/wallet.dart';
import 'package:erp_global/features/cafeteria/data/repositories/api_wallet_repository.dart';
import 'package:flutter_test/flutter_test.dart';

const _holder = '01JKHMPQT000000000000000A1';

ApiWalletRepository _repo() {
  final registry = MockApiRegistry()..addModule(WalletMockHandlers());
  return ApiWalletRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

Future<Wallet> _open(ApiWalletRepository r, {int limit = 0}) async =>
    (await r.open(
      holderId: _holder,
      holderName: 'Ana Silva',
      dailyLimitMinor: limit,
    )).getOrThrow();

void main() {
  test(
    'lista paginada e seed coerente (saldo = soma dos movimentos)',
    () async {
      final r = _repo();
      final page = (await r.list(pageSize: 5)).getOrThrow();
      expect(page.items, hasLength(5));
      expect(page.meta.total, 12);
      for (final w in page.items) {
        final txs = (await r.statement(w.id, pageSize: 100)).getOrThrow().items;
        expect(txs.fold<int>(0, (s, t) => s + t.signedMinor), w.balanceMinor);
        expect(w.balanceMinor, greaterThanOrEqualTo(0));
      }
    },
  );

  test('abrir carteira: validação e uma por titular', () async {
    final r = _repo();
    final bad = await r.open(holderId: 'x', holderName: '');
    expect(bad.failureOrNull?.code, 'VALIDATION_ERROR');
    final w = await _open(r);
    expect(w.balanceMinor, 0);
    expect(
      (await r.open(holderId: _holder, holderName: 'Ana')).failureOrNull?.code,
      'CONFLICT',
    );
  });

  test('carregar, consumir e extracto (mais recente primeiro)', () async {
    final r = _repo();
    final w = await _open(r);
    final top = (await r.topUp(
      w.id,
      amountMinor: 100000,
      method: 'cash',
      reference: 'REC-1',
    )).getOrThrow();
    expect(top.balanceAfterMinor, 100000);
    expect(top.reference, 'REC-1');
    final buy = (await r.purchase(
      w.id,
      amountMinor: 30000,
      description: 'Almoço',
    )).getOrThrow();
    expect(buy.balanceAfterMinor, 70000);
    final txs = (await r.statement(w.id)).getOrThrow().items;
    expect(txs.map((t) => t.type), [
      WalletTransactionType.purchase,
      WalletTransactionType.topup,
    ]);
    final onlyTopUps = (await r.statement(
      w.id,
      type: WalletTransactionType.topup,
    )).getOrThrow();
    expect(onlyTopUps.items, hasLength(1));
    final future = (await r.statement(
      w.id,
      from: DateTime.now().toUtc().add(const Duration(days: 1)),
    )).getOrThrow();
    expect(future.items, isEmpty);
  });

  test('o saldo nunca fica negativo', () async {
    final r = _repo();
    final w = await _open(r);
    await r.topUp(w.id, amountMinor: 5000, method: 'cash');
    final over = await r.purchase(w.id, amountMinor: 5001);
    expect(over.failureOrNull?.code, 'VALIDATION_ERROR');
    expect((await r.purchase(w.id, amountMinor: 5000)).isOk, isTrue);
    expect(
      (await r.purchase(w.id, amountMinor: 1)).failureOrNull?.code,
      'VALIDATION_ERROR',
    );
    final wallet = (await r.list(q: 'Ana')).getOrThrow().items.single;
    expect(wallet.balanceMinor, 0);
  });

  test('valores inválidos são rejeitados', () async {
    final r = _repo();
    final w = await _open(r);
    for (final v in [0, -5]) {
      expect(
        (await r.topUp(
          w.id,
          amountMinor: v,
          method: 'cash',
        )).failureOrNull?.code,
        'VALIDATION_ERROR',
      );
    }
    expect(
      (await r.topUp(w.id, amountMinor: 10, method: 'x')).failureOrNull?.code,
      'VALIDATION_ERROR',
    );
  });

  test('limite diário bloqueia o excesso; estorno liberta o limite', () async {
    final r = _repo();
    final w = await _open(r, limit: 10000);
    await r.topUp(w.id, amountMinor: 100000, method: 'cash');
    final first = (await r.purchase(w.id, amountMinor: 8000)).getOrThrow();
    expect(
      (await r.purchase(w.id, amountMinor: 3000)).failureOrNull?.code,
      'CONFLICT',
    );
    await r.refund(w.id, transactionId: first.id, reason: 'Erro');
    expect((await r.purchase(w.id, amountMinor: 3000)).isOk, isTrue);
    final lifted = (await r.setDailyLimit(w.id, 0)).getOrThrow();
    expect(lifted.dailyLimitMinor, 0);
    expect((await r.purchase(w.id, amountMinor: 50000)).isOk, isTrue);
  });

  test('bloqueio impede consumo mas não carregamento', () async {
    final r = _repo();
    final w = await _open(r);
    await r.topUp(w.id, amountMinor: 10000, method: 'card');
    expect(
      (await r.setBlocked(w.id, blocked: true)).getOrThrow().blocked,
      true,
    );
    expect(
      (await r.purchase(w.id, amountMinor: 100)).failureOrNull?.code,
      'CONFLICT',
    );
    expect(
      (await r.topUp(w.id, amountMinor: 100, method: 'cash')).isOk,
      isTrue,
    );
    await r.setBlocked(w.id, blocked: false);
    expect((await r.purchase(w.id, amountMinor: 100)).isOk, isTrue);
  });

  test('estorno devolve o valor, só uma vez e só de consumos', () async {
    final r = _repo();
    final w = await _open(r);
    final top = (await r.topUp(
      w.id,
      amountMinor: 10000,
      method: 'cash',
    )).getOrThrow();
    final buy = (await r.purchase(w.id, amountMinor: 4000)).getOrThrow();
    final refund = (await r.refund(w.id, transactionId: buy.id)).getOrThrow();
    expect(refund.type, WalletTransactionType.refund);
    expect(refund.refundOfId, buy.id);
    expect(refund.balanceAfterMinor, 10000);
    expect(
      (await r.refund(w.id, transactionId: buy.id)).failureOrNull?.code,
      'CONFLICT',
    );
    expect(
      (await r.refund(w.id, transactionId: top.id)).failureOrNull?.code,
      'NOT_FOUND',
    );
  });

  test('carteira inexistente devolve 404', () async {
    final r = _repo();
    expect(
      (await r.topUp(
        '01JNAOEXISTE0000000000000A',
        amountMinor: 1,
        method: 'cash',
      )).failureOrNull?.code,
      'NOT_FOUND',
    );
  });
}
