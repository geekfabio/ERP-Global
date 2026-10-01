import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/access_mock_handlers.dart';
import '../../data/models/access_models.dart';
import '../../data/repositories/api_access_repositories.dart';
import '../../domain/access_repositories.dart';

final zoneRepositoryProvider = Provider<ZoneRepository>(
  (ref) => ApiZoneRepository(ref.watch(apiClientProvider)),
);

final accessRuleRepositoryProvider = Provider<AccessRuleRepository>(
  (ref) => ApiAccessRuleRepository(ref.watch(apiClientProvider)),
);

final accessDeviceRepositoryProvider = Provider<AccessDeviceRepository>(
  (ref) => ApiAccessDeviceRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final accessMockHandlersProvider = Provider<AccessMockHandlers>(
  (ref) => AccessMockHandlers(),
);

/// Percorre as páginas do servidor (as tabelas pesquisam e ordenam localmente).
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

final zoneListProvider = FutureProvider.autoDispose<List<ZoneModel>>((
  ref,
) async {
  final repo = ref.watch(zoneRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

final accessRuleListProvider =
    FutureProvider.autoDispose<List<AccessRuleModel>>((ref) async {
      final repo = ref.watch(accessRuleRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.list(page: page, pageSize: 100)).getOrThrow(),
      );
    }, retry: (_, _) => null);

final accessDeviceListProvider =
    FutureProvider.autoDispose<List<AccessDeviceModel>>((ref) async {
      final repo = ref.watch(accessDeviceRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.list(page: page, pageSize: 100)).getOrThrow(),
      );
    }, retry: (_, _) => null);

/// Campus (`id → nome`); sem permissão ou em falha fica vazio (mostra o id).
final campusNamesProvider = FutureProvider.autoDispose<Map<String, String>>((
  ref,
) async {
  final result = await ref.watch(zoneRepositoryProvider).campuses();
  return result.when(ok: (v) => v, err: (_) => const {});
});
