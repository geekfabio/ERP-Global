import 'package:erp_global/features/cafeteria/data/models/menu.dart';
import 'package:erp_global/features/cafeteria/data/models/wallet.dart';
import 'package:erp_global/features/cafeteria/data/repositories/api_pos_repository.dart';
import 'package:erp_global/features/cafeteria/domain/pos_sale.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2025, 10, 1, 12);

Wallet _wallet({int balance = 500000, int limit = 0, bool blocked = false}) =>
    Wallet(
      id: 'w1',
      holderId: 'h1',
      holderName: 'Ana Silva',
      balanceMinor: balance,
      dailyLimitMinor: limit,
      blocked: blocked,
      createdAt: _now,
      updatedAt: _now,
    );

PosCustomer _customer({
  Wallet? wallet,
  bool cardBlocked = false,
  List<String> allergies = const [],
  int spent = 0,
}) => PosCustomer(
  holderId: 'h1',
  holderName: 'Ana Silva',
  wallet: wallet ?? _wallet(),
  cardBlocked: cardBlocked,
  allergies: allergies,
  spentTodayMinor: spent,
);

MealItem _item(String id, int price, [List<Allergen> a = const []]) => MealItem(
  id: id,
  name: id,
  mealTypeId: 't',
  priceMinor: price,
  allergens: a,
);

void main() {
  test('venda válida é aprovada e o total soma quantidades', () {
    final lines = [
      PosLine(_item('a', 120000), 2),
      PosLine(_item('b', 25000), 1),
    ];
    expect(posTotalMinor(lines), 265000);
    final d = evaluatePosSale(customer: _customer(), lines: lines);
    expect(d.approved, isTrue);
    expect(d.hasAllergyAlert, isFalse);
  });

  test('carrinho vazio, cartão e carteira bloqueados', () {
    final empty = evaluatePosSale(customer: _customer(), lines: const []);
    expect(empty.blocks, [PosBlock.emptyCart]);
    final blocked = evaluatePosSale(
      customer: _customer(wallet: _wallet(blocked: true), cardBlocked: true),
      lines: [PosLine(_item('a', 100), 1)],
    );
    expect(
      blocked.blocks,
      containsAll([PosBlock.cardBlocked, PosBlock.walletBlocked]),
    );
  });

  test('saldo insuficiente e limite diário (com consumo de hoje)', () {
    final lines = [PosLine(_item('a', 120000), 1)];
    expect(
      evaluatePosSale(
        customer: _customer(wallet: _wallet(balance: 100000)),
        lines: lines,
      ).blocks,
      [PosBlock.insufficientBalance],
    );
    expect(
      evaluatePosSale(
        customer: _customer(wallet: _wallet(limit: 150000), spent: 40000),
        lines: lines,
      ).blocks,
      [PosBlock.dailyLimitExceeded],
    );
    expect(
      evaluatePosSale(
        customer: _customer(wallet: _wallet(limit: 150000), spent: 30000),
        lines: lines,
      ).approved,
      isTrue,
    );
  });

  test('alergias em texto livre cruzam com os alergénios dos pratos', () {
    expect(allergensFromText(['Amendoim', 'pólen', 'Lácteos']), {
      Allergen.peanuts,
      Allergen.lactose,
    });
    final d = evaluatePosSale(
      customer: _customer(allergies: ['lactose']),
      lines: [
        PosLine(_item('gelado', 25000, [Allergen.lactose, Allergen.nuts]), 1),
        PosLine(_item('arroz', 110000), 1),
      ],
    );
    expect(d.approved, isTrue);
    expect(d.allergenConflicts, [Allergen.lactose]);
    expect(
      evaluatePosSale(
        customer: _customer(allergies: ['pólen']),
        lines: [
          PosLine(_item('gelado', 25000, [Allergen.lactose]), 1),
        ],
      ).hasAllergyAlert,
      isFalse,
    );
  });

  test('consumo líquido do dia desconta estornos', () {
    WalletTransaction tx(
      String id,
      WalletTransactionType type,
      int v, [
      String? of,
    ]) => WalletTransaction(
      id: id,
      walletId: 'w1',
      type: type,
      amountMinor: v,
      balanceAfterMinor: 0,
      occurredAt: _now,
      refundOfId: of,
    );
    final txs = [
      tx('p1', WalletTransactionType.purchase, 80000),
      tx('p2', WalletTransactionType.purchase, 30000),
      tx('r1', WalletTransactionType.refund, 80000, 'p1'),
      tx('t1', WalletTransactionType.topup, 500000),
    ];
    expect(netSpent(txs), 30000);
  });
}
