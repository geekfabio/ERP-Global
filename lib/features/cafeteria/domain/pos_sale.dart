import '../data/models/menu.dart';
import '../data/models/wallet.dart';

/// Quem está a ser servido no POS: titular do cartão, carteira, consumo de
/// hoje e alergias declaradas na ficha de saúde do aluno.
class PosCustomer {
  const PosCustomer({
    required this.holderId,
    required this.holderName,
    required this.wallet,
    this.cardUid,
    this.cardBlocked = false,
    this.allergies = const [],
    this.spentTodayMinor = 0,
  });

  final String holderId;
  final String holderName;
  final Wallet wallet;
  final String? cardUid;
  final bool cardBlocked;

  /// Alergias em texto livre (ficha de saúde do aluno).
  final List<String> allergies;

  /// Consumido hoje (UTC), já descontados os estornos.
  final int spentTodayMinor;
}

/// Linha do carrinho: prato e quantidade.
class PosLine {
  const PosLine(this.item, this.quantity);

  final MealItem item;
  final int quantity;

  int get totalMinor => item.priceMinor * quantity;
}

int posTotalMinor(List<PosLine> lines) =>
    lines.fold(0, (sum, l) => sum + l.totalMinor);

/// Motivo que impede a venda (validação local, sem rede).
enum PosBlock {
  emptyCart,
  cardBlocked,
  walletBlocked,
  insufficientBalance,
  dailyLimitExceeded,
}

/// Resultado da validação local de uma venda.
class PosDecision {
  const PosDecision({
    this.blocks = const [],
    this.allergenConflicts = const [],
  });

  final List<PosBlock> blocks;

  /// Alergénios dos pratos que coincidem com as alergias do aluno. Não
  /// bloqueia: exige confirmação explícita do operador.
  final List<Allergen> allergenConflicts;

  bool get approved => blocks.isEmpty;
  bool get hasAllergyAlert => allergenConflicts.isNotEmpty;
}

String _fold(String s) {
  const from = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const to = 'aaaaaeeeeiiiiooooouuuuc';
  final out = StringBuffer();
  for (final ch in s.toLowerCase().trim().split('')) {
    final i = from.indexOf(ch);
    out.write(i < 0 ? ch : to[i]);
  }
  return out.toString();
}

/// Palavras (sem acentos) que identificam cada alergénio em texto livre.
const _allergenKeywords = <Allergen, List<String>>{
  Allergen.gluten: ['gluten', 'trigo', 'celiac'],
  Allergen.lactose: ['lactose', 'leite', 'lacteo'],
  Allergen.eggs: ['ovo'],
  Allergen.fish: ['peixe'],
  Allergen.shellfish: ['marisco', 'crustaceo', 'camarao'],
  Allergen.peanuts: ['amendoim'],
  Allergen.nuts: ['frutos secos', 'frutos de casca', 'noz', 'nozes'],
  Allergen.soy: ['soja'],
  Allergen.celery: ['aipo'],
  Allergen.sesame: ['sesamo'],
};

/// Alergénios que as alergias declaradas ([allergies], texto livre) cobrem.
Set<Allergen> allergensFromText(List<String> allergies) {
  final folded = allergies.map(_fold).toList();
  return {
    for (final e in _allergenKeywords.entries)
      if (e.value.any((k) => folded.any((a) => a.contains(k)))) e.key,
  };
}

/// Valida uma venda 100% localmente (offline): estado do cartão e da
/// carteira, saldo, limite diário e conflito com alergias.
PosDecision evaluatePosSale({
  required PosCustomer customer,
  required List<PosLine> lines,
}) {
  final total = posTotalMinor(lines);
  final wallet = customer.wallet;
  final blocks = <PosBlock>[
    if (lines.isEmpty) PosBlock.emptyCart,
    if (customer.cardBlocked) PosBlock.cardBlocked,
    if (wallet.blocked) PosBlock.walletBlocked,
    if (lines.isNotEmpty && total > wallet.balanceMinor)
      PosBlock.insufficientBalance,
    if (lines.isNotEmpty &&
        wallet.dailyLimitMinor > 0 &&
        customer.spentTodayMinor + total > wallet.dailyLimitMinor)
      PosBlock.dailyLimitExceeded,
  ];
  final covered = allergensFromText(customer.allergies);
  final conflicts = <Allergen>{
    for (final l in lines)
      for (final a in l.item.allergens)
        if (covered.contains(a)) a,
  };
  return PosDecision(
    blocks: blocks,
    allergenConflicts: Allergen.values.where(conflicts.contains).toList(),
  );
}
