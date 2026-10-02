import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/inventory_mock_handlers.dart';
import '../../data/models/inventory_models.dart';
import '../../data/repositories/api_inventory_repositories.dart';
import '../../domain/inventory_repositories.dart';

final assetRepositoryProvider = Provider<AssetRepository>(
  (ref) => ApiAssetRepository(ref.watch(apiClientProvider)),
);

final stockRepositoryProvider = Provider<StockRepository>(
  (ref) => ApiStockRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final inventoryMockHandlersProvider = Provider<InventoryMockHandlers>(
  (ref) => InventoryMockHandlers(),
);

/// Percorre as páginas do servidor (a tabela pesquisa e ordena localmente).
Future<List<T>> _fetchAll<T>(
  Future<PagedList<T>> Function(int page) fetch,
) async {
  final items = <T>[];
  var page = 1;
  while (true) {
    final result = await fetch(page);
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}

/// Todos os bens. Falhas chegam à UI como `AsyncError`.
final assetListProvider = FutureProvider.autoDispose<List<AssetModel>>((
  ref,
) async {
  final repo = ref.watch(assetRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

/// Todos os consumíveis, com `lowStock` calculado pelo servidor.
final stockListProvider = FutureProvider.autoDispose<List<StockItemModel>>((
  ref,
) async {
  final repo = ref.watch(stockRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

/// Manutenções de um bem.
final assetMaintenanceProvider = FutureProvider.autoDispose
    .family<List<MaintenanceModel>, String>(
      (ref, assetId) async =>
          (await ref.watch(assetRepositoryProvider).maintenance(assetId))
              .getOrThrow(),
      retry: (_, _) => null,
    );
