import '../../../../core/utils/seed_generator.dart';
import '../models/wallet.dart';
import 'menu_seed.dart';

/// Carteiras e movimentos de desenvolvimento (mesma seed → mesmos dados).
/// O saldo de cada carteira é a soma dos seus movimentos.
({List<Wallet> wallets, List<WalletTransaction> transactions}) buildWalletSeed({
  int seed = 65,
  int count = 12,
}) {
  final gen = SeedGenerator(seed);
  final mealIds = {
    for (final t in buildMenuSeed(DateTime.utc(2025, 9, 1)).types) t.name: t.id,
  };
  const classes = ['7.ª A', '7.ª B', '8.ª A'];
  final at = DateTime.utc(2025, 9, 1, 8);
  final wallets = <Wallet>[];
  final txs = <WalletTransaction>[];
  for (var i = 0; i < count; i++) {
    final id = gen.ulid(at.add(Duration(hours: i)));
    var balance = 0;
    var t = at.add(Duration(days: i));
    void add(
      WalletTransactionType type,
      int amount, {
      String? method,
      String? description,
      String? meal,
    }) {
      balance += type == WalletTransactionType.purchase ? -amount : amount;
      t = t.add(const Duration(hours: 5));
      txs.add(
        WalletTransaction(
          id: gen.ulid(t),
          walletId: id,
          type: type,
          amountMinor: amount,
          balanceAfterMinor: balance,
          occurredAt: t,
          method: method,
          description: description,
          mealTypeId: meal == null ? null : mealIds[meal],
          className: meal == null ? null : classes[i % classes.length],
        ),
      );
    }

    add(WalletTransactionType.topup, 500000, method: 'cash');
    add(
      WalletTransactionType.purchase,
      80000,
      description: 'Almoço',
      meal: 'Almoço',
    );
    add(
      WalletTransactionType.purchase,
      30000,
      description: 'Lanche',
      meal: 'Lanche',
    );
    if (i.isEven) {
      add(WalletTransactionType.topup, 200000, method: 'bank_transfer');
    }
    wallets.add(
      Wallet(
        id: id,
        holderId: gen.ulid(at.add(Duration(minutes: i))),
        holderName: gen.fullName(),
        balanceMinor: balance,
        dailyLimitMinor: i % 3 == 0 ? 150000 : 0,
        blocked: i % 5 == 4,
        createdAt: at.add(Duration(days: i)),
        updatedAt: t,
      ),
    );
  }
  return (wallets: wallets, transactions: txs);
}
