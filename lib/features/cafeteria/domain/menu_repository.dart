import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/menu.dart';

/// CRUD simples de uma colecção do refeitório.
abstract interface class MealCrudRepository<T> {
  Future<Result<PagedList<T>>> list({int page = 1, int pageSize = 100});
  Future<Result<T>> create(T value);
  Future<Result<T>> update(String id, T value);
  Future<Result<void>> delete(String id);
}

/// Contrato de menus, tipos de refeição e pratos; a UI só conhece esta interface.
abstract interface class MenuRepository {
  MealCrudRepository<MealType> get types;
  MealCrudRepository<MealItem> get items;

  /// Menus entre [from] e [to] (inclusive, `yyyy-MM-dd`).
  Future<Result<PagedList<MealMenu>>> menus({
    required String from,
    required String to,
    int page = 1,
    int pageSize = 100,
  });

  /// Define os pratos do menu de um dia e tipo de refeição (cria ou substitui).
  Future<Result<MealMenu>> saveMenu({
    required String date,
    required String mealTypeId,
    required List<String> itemIds,
  });

  Future<Result<void>> deleteMenu(String id);
}
