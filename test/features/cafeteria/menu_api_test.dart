import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/cafeteria/data/mock_api/menu_mock_handlers.dart';
import 'package:erp_global/features/cafeteria/data/models/menu.dart';
import 'package:erp_global/features/cafeteria/data/repositories/api_menu_repository.dart';
import 'package:flutter_test/flutter_test.dart';

// Segunda-feira fixa: o seed cobre a semana do relógio injectado.
final _clock = DateTime.utc(2025, 9, 3);

ApiMenuRepository _repo() {
  final registry = MenuMockHandlers(clock: () => _clock);
  return ApiMenuRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: MockApiRegistry()..addModule(registry),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

void main() {
  test('seed: tipos por horário e menu semanal de segunda a sexta', () async {
    final r = _repo();
    final types = (await r.types.list()).getOrThrow().items;
    expect(types.map((t) => t.name), ['Pequeno-almoço', 'Almoço', 'Lanche']);
    final menus = (await r.menus(
      from: '2025-09-01',
      to: '2025-09-07',
    )).getOrThrow().items;
    expect(menus, hasLength(15));
    expect(
      (await r.menus(from: '2025-09-08', to: '2025-09-14')).getOrThrow().items,
      isEmpty,
    );
    final items = (await r.items.list()).getOrThrow().items;
    expect(items.any((i) => i.allergens.isNotEmpty), isTrue);
  });

  test('tipo de refeição: validação, duplicado e eliminação', () async {
    final r = _repo();
    const bad = MealType(id: '', name: '', startTime: '9h', endTime: '08:00');
    expect((await r.types.create(bad)).failureOrNull?.code, 'VALIDATION_ERROR');
    const inverted = MealType(
      id: '',
      name: 'Ceia',
      startTime: '20:00',
      endTime: '19:00',
    );
    expect(
      (await r.types.create(inverted)).failureOrNull?.code,
      'VALIDATION_ERROR',
    );
    const ok = MealType(
      id: '',
      name: 'Ceia',
      startTime: '19:00',
      endTime: '20:00',
      priceMinor: 70000,
    );
    final created = (await r.types.create(ok)).getOrThrow();
    expect(created.priceMinor, 70000);
    expect((await r.types.create(ok)).failureOrNull?.code, 'CONFLICT');
    final edited = (await r.types.update(
      created.id,
      created.copyWith(priceMinor: 80000),
    )).getOrThrow();
    expect(edited.priceMinor, 80000);
    expect((await r.types.delete(created.id)).isOk, isTrue);
    // Tipo com pratos não se elimina.
    final lunch = (await r.types.list()).getOrThrow().items[1];
    expect((await r.types.delete(lunch.id)).failureOrNull?.code, 'CONFLICT');
  });

  test('pratos: alergénios por item e remoção retira-o dos menus', () async {
    final r = _repo();
    final lunch = (await r.types.list()).getOrThrow().items[1];
    final created = (await r.items.create(
      MealItem(
        id: '',
        name: 'Camarão grelhado',
        mealTypeId: lunch.id,
        priceMinor: 200000,
        allergens: const [Allergen.shellfish],
      ),
    )).getOrThrow();
    expect(created.allergens, [Allergen.shellfish]);
    final invalid = await r.items.create(
      const MealItem(id: '', name: 'X', mealTypeId: 'nope'),
    );
    expect(invalid.failureOrNull?.code, 'VALIDATION_ERROR');

    final saved = (await r.saveMenu(
      date: '2025-09-01',
      mealTypeId: lunch.id,
      itemIds: [created.id],
    )).getOrThrow();
    // Substitui o menu existente do mesmo dia/refeição (não duplica).
    final week = (await r.menus(
      from: '2025-09-01',
      to: '2025-09-01',
    )).getOrThrow().items;
    expect(week.where((m) => m.mealTypeId == lunch.id), hasLength(1));

    await r.items.delete(created.id);
    final after = (await r.menus(
      from: '2025-09-01',
      to: '2025-09-01',
    )).getOrThrow().items.firstWhere((m) => m.id == saved.id);
    expect(after.itemIds, isEmpty);
  });

  test('menu: prato de outro tipo ou data inválida são rejeitados', () async {
    final r = _repo();
    final types = (await r.types.list()).getOrThrow().items;
    final items = (await r.items.list()).getOrThrow().items;
    final breakfast = items.firstWhere((i) => i.mealTypeId == types[0].id);
    final wrongType = await r.saveMenu(
      date: '2025-09-02',
      mealTypeId: types[1].id,
      itemIds: [breakfast.id],
    );
    expect(wrongType.failureOrNull?.code, 'VALIDATION_ERROR');
    final badDate = await r.saveMenu(
      date: '02/09/2025',
      mealTypeId: types[1].id,
      itemIds: const [],
    );
    expect(badDate.failureOrNull?.code, 'VALIDATION_ERROR');
    final menus = (await r.menus(
      from: '2025-09-01',
      to: '2025-09-07',
    )).getOrThrow().items;
    expect((await r.deleteMenu(menus.first.id)).isOk, isTrue);
    expect(
      (await r.deleteMenu(menus.first.id)).failureOrNull?.code,
      'NOT_FOUND',
    );
  });
}
