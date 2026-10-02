import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../data/mock_api/menu_mock_handlers.dart';
import '../../data/models/menu.dart';
import '../../data/repositories/api_menu_repository.dart';
import '../../domain/menu_repository.dart';

final menuRepositoryProvider = Provider<MenuRepository>(
  (ref) => ApiMenuRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final menuMockHandlersProvider = Provider<MenuMockHandlers>(
  (ref) => MenuMockHandlers(),
);

Future<List<T>> _all<T>(MealCrudRepository<T> repository) async {
  final items = <T>[];
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
}

final mealTypeListProvider = FutureProvider.autoDispose<List<MealType>>(
  (ref) => _all(ref.watch(menuRepositoryProvider).types),
  retry: (_, _) => null,
);

final mealItemListProvider = FutureProvider.autoDispose<List<MealItem>>(
  (ref) => _all(ref.watch(menuRepositoryProvider).items),
  retry: (_, _) => null,
);

/// Segunda-feira (UTC) da semana visível no menu semanal.
class MenuWeekNotifier extends Notifier<DateTime> {
  @override
  DateTime build() {
    final now = DateTime.now().toUtc();
    final day = DateTime.utc(now.year, now.month, now.day);
    return day.subtract(Duration(days: day.weekday - DateTime.monday));
  }

  void shift(int weeks) => state = state.add(Duration(days: 7 * weeks));
}

final menuWeekProvider = NotifierProvider<MenuWeekNotifier, DateTime>(
  MenuWeekNotifier.new,
);

String dateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Menus da semana visível (segunda a domingo).
final weekMenusProvider = FutureProvider.autoDispose<List<MealMenu>>((
  ref,
) async {
  final monday = ref.watch(menuWeekProvider);
  final result =
      (await ref
              .watch(menuRepositoryProvider)
              .menus(
                from: dateKey(monday),
                to: dateKey(monday.add(const Duration(days: 6))),
              ))
          .getOrThrow();
  return result.items;
}, retry: (_, _) => null);
