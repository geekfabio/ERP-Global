import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/cards_mock_handlers.dart';
import '../../data/models/card_model.dart';
import '../../data/repositories/api_card_repository.dart';
import '../../domain/card_repository.dart';

final cardRepositoryProvider = Provider<CardRepository>(
  (ref) => ApiCardRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final cardsMockHandlersProvider = Provider<CardsMockHandlers>(
  (ref) => CardsMockHandlers(),
);

/// Todos os cartões (percorre as páginas do servidor); a tabela pesquisa e
/// ordena localmente. Falhas chegam à UI como `AsyncError`.
final cardListProvider = FutureProvider.autoDispose<List<CardModel>>((
  ref,
) async {
  final repository = ref.watch(cardRepositoryProvider);
  final items = <CardModel>[];
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
