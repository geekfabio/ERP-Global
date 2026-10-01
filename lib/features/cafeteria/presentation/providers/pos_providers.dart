import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../data/models/menu.dart';
import '../../data/models/wallet.dart';
import '../../data/repositories/api_pos_repository.dart';
import '../../domain/pos_repository.dart';
import '../../domain/pos_sale.dart';
import 'menu_providers.dart';
import 'wallet_providers.dart';

final posRepositoryProvider = Provider<PosRepository>(
  (ref) => ApiPosRepository(
    ref.watch(apiClientProvider),
    ref.watch(walletRepositoryProvider),
  ),
);

/// Estado do POS: cliente identificado, carrinho e último resultado.
class PosState {
  const PosState({
    this.customer,
    this.lines = const [],
    this.busy = false,
    this.error,
    this.lastSale,
  });

  final PosCustomer? customer;
  final List<PosLine> lines;
  final bool busy;
  final String? error;

  /// Venda acabada de registar (dispara a animação de confirmação).
  final WalletTransaction? lastSale;

  int get totalMinor => posTotalMinor(lines);

  PosDecision? get decision => customer == null
      ? null
      : evaluatePosSale(customer: customer!, lines: lines);

  PosState copyWith({
    PosCustomer? customer,
    List<PosLine>? lines,
    bool? busy,
    String? error,
    WalletTransaction? lastSale,
    bool clearCustomer = false,
    bool clearError = false,
    bool clearSale = false,
  }) => PosState(
    customer: clearCustomer ? null : (customer ?? this.customer),
    lines: lines ?? this.lines,
    busy: busy ?? this.busy,
    error: clearError ? null : (error ?? this.error),
    lastSale: clearSale ? null : (lastSale ?? this.lastSale),
  );
}

class PosNotifier extends Notifier<PosState> {
  @override
  PosState build() => const PosState();

  Future<void> _identify(Future<Result<PosCustomer>> Function() read) async {
    state = state.copyWith(busy: true, clearError: true, clearSale: true);
    final result = await read();
    result.when(
      ok: (c) => state = PosState(customer: c),
      err: (f) => state = PosState(customer: state.customer, error: f.message),
    );
  }

  /// Leitura de cartão pelo UID (simulada: digitado ou escolhido).
  Future<void> readCard(String uid) =>
      _identify(() => ref.read(posRepositoryProvider).identifyCard(uid));

  /// Leitura simulada a partir de uma carteira (titular).
  Future<void> readHolder(String holderId) =>
      _identify(() => ref.read(posRepositoryProvider).identifyHolder(holderId));

  void add(MealItem item) {
    final lines = [...state.lines];
    final i = lines.indexWhere((l) => l.item.id == item.id);
    if (i < 0) {
      lines.add(PosLine(item, 1));
    } else {
      lines[i] = PosLine(item, lines[i].quantity + 1);
    }
    state = state.copyWith(lines: lines, clearSale: true);
  }

  void remove(MealItem item) {
    final lines = [...state.lines];
    final i = lines.indexWhere((l) => l.item.id == item.id);
    if (i < 0) return;
    if (lines[i].quantity <= 1) {
      lines.removeAt(i);
    } else {
      lines[i] = PosLine(item, lines[i].quantity - 1);
    }
    state = state.copyWith(lines: lines);
  }

  void clearCart() => state = state.copyWith(lines: const []);

  /// Termina o atendimento (novo cliente).
  void reset() => state = const PosState();

  /// Valida localmente e debita a carteira. Devolve `false` se não aprovou.
  Future<bool> charge() async {
    final customer = state.customer;
    final decision = state.decision;
    if (customer == null || decision == null || !decision.approved) {
      return false;
    }
    state = state.copyWith(busy: true, clearError: true);
    final description = state.lines
        .map((l) => '${l.quantity}× ${l.item.name}')
        .join(', ');
    final result = await ref
        .read(walletRepositoryProvider)
        .purchase(
          customer.wallet.id,
          amountMinor: state.totalMinor,
          description: description,
        );
    switch (result) {
      case Ok(:final value):
        final refreshed = await _reload(customer);
        state = PosState(customer: refreshed ?? customer, lastSale: value);
        ref.invalidate(walletListProvider);
        return true;
      case Err(:final failure):
        state = state.copyWith(busy: false, error: failure.message);
        return false;
    }
  }

  /// Estorna um consumo e actualiza o saldo do cliente.
  Future<bool> refund(WalletTransaction purchase, {String? reason}) async {
    final customer = state.customer;
    if (customer == null) return false;
    state = state.copyWith(busy: true, clearError: true, clearSale: true);
    final result = await ref
        .read(walletRepositoryProvider)
        .refund(customer.wallet.id, transactionId: purchase.id, reason: reason);
    final failure = result.failureOrNull;
    final refreshed = await _reload(customer);
    state = PosState(
      customer: refreshed ?? customer,
      lines: state.lines,
      error: failure?.message,
    );
    ref.invalidate(walletListProvider);
    return failure == null;
  }

  Future<PosCustomer?> _reload(PosCustomer c) async {
    final repository = ref.read(posRepositoryProvider);
    final result = c.cardUid != null
        ? await repository.identifyCard(c.cardUid!)
        : await repository.identifyHolder(c.holderId);
    return result.valueOrNull;
  }
}

final posProvider = NotifierProvider<PosNotifier, PosState>(PosNotifier.new);

/// Movimentos de hoje (UTC) da carteira do cliente atual, mais recente primeiro.
final posTodayProvider = FutureProvider.autoDispose<List<WalletTransaction>>((
  ref,
) async {
  final customer = ref.watch(posProvider.select((s) => s.customer));
  if (customer == null) return const [];
  final now = DateTime.now().toUtc();
  final result = await ref
      .watch(walletRepositoryProvider)
      .statement(
        customer.wallet.id,
        pageSize: 100,
        from: DateTime.utc(now.year, now.month, now.day),
      );
  return result.getOrThrow().items;
}, retry: (_, _) => null);

/// Pratos vendáveis hoje, por tipo de refeição (menu do dia).
class PosCatalog {
  const PosCatalog({required this.types, required this.itemsByType});

  final List<MealType> types;
  final Map<String, List<MealItem>> itemsByType;
}

final posCatalogProvider = FutureProvider.autoDispose<PosCatalog>((ref) async {
  final today = dateKey(DateTime.now());
  final repository = ref.watch(menuRepositoryProvider);
  final types = await ref.watch(mealTypeListProvider.future);
  final items = await ref.watch(mealItemListProvider.future);
  final menus = (await repository.menus(
    from: today,
    to: today,
  )).getOrThrow().items;
  final byId = {for (final i in items.where((i) => i.isActive)) i.id: i};
  return PosCatalog(
    types: types.where((t) => t.isActive).toList(),
    itemsByType: {
      for (final m in menus)
        m.mealTypeId: [
          for (final id in m.itemIds)
            if (byId[id] != null) byId[id]!,
        ],
    },
  );
}, retry: (_, _) => null);
