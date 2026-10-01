import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/wallet_mock_handlers.dart';
import '../../data/models/wallet.dart';
import '../../data/repositories/api_wallet_repository.dart';
import '../../domain/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>(
  (ref) => ApiWalletRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final walletMockHandlersProvider = Provider<WalletMockHandlers>(
  (ref) => WalletMockHandlers(),
);

/// Todas as carteiras (percorre as páginas do servidor); a tabela pesquisa e
/// ordena localmente. Falhas chegam à UI como `AsyncError`.
final walletListProvider = FutureProvider.autoDispose<List<Wallet>>((
  ref,
) async {
  final repository = ref.watch(walletRepositoryProvider);
  final items = <Wallet>[];
  var page = 1;
  while (true) {
    final result = (await repository.list(
      page: page,
      pageSize: 100,
    )).getOrThrow();
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}, retry: (_, _) => null);

/// Extracto completo de uma carteira (mais recente primeiro).
final walletStatementProvider = FutureProvider.autoDispose
    .family<List<WalletTransaction>, String>((ref, walletId) async {
      final repository = ref.watch(walletRepositoryProvider);
      final items = <WalletTransaction>[];
      var page = 1;
      while (true) {
        final result = (await repository.statement(
          walletId,
          page: page,
          pageSize: 100,
        )).getOrThrow();
        items.addAll(result.items);
        if (!result.meta.hasNext) return items;
        page++;
      }
    }, retry: (_, _) => null);
