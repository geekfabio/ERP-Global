import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/library_mock_handlers.dart';
import '../../data/models/library_models.dart';
import '../../data/repositories/api_library_repositories.dart';
import '../../domain/library_repositories.dart';

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => ApiBookRepository(ref.watch(apiClientProvider)),
);

final circulationRepositoryProvider = Provider<CirculationRepository>(
  (ref) => ApiCirculationRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final libraryMockHandlersProvider = Provider<LibraryMockHandlers>(
  (ref) => LibraryMockHandlers(),
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

/// Falhas chegam à UI como `AsyncError`.
final bookListProvider = FutureProvider.autoDispose<List<BookModel>>((ref) {
  final repo = ref.watch(bookRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.list(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

final bookCopiesProvider = FutureProvider.autoDispose
    .family<List<CopyModel>, String>(
      (ref, bookId) async =>
          (await ref.watch(bookRepositoryProvider).copies(bookId)).getOrThrow(),
      retry: (_, _) => null,
    );

final loanListProvider = FutureProvider.autoDispose<List<LoanModel>>((ref) {
  final repo = ref.watch(circulationRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.loans(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

final fineListProvider = FutureProvider.autoDispose<List<FineModel>>((ref) {
  final repo = ref.watch(circulationRepositoryProvider);
  return _fetchAll(
    (page) async => (await repo.fines(page: page, pageSize: 100)).getOrThrow(),
  );
}, retry: (_, _) => null);

final reservationListProvider =
    FutureProvider.autoDispose<List<ReservationModel>>((ref) {
      final repo = ref.watch(circulationRepositoryProvider);
      return _fetchAll(
        (page) async =>
            (await repo.reservations(page: page, pageSize: 100)).getOrThrow(),
      );
    }, retry: (_, _) => null);
