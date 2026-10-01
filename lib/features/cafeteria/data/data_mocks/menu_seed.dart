import '../../../../core/utils/seed_generator.dart';
import '../models/menu.dart';

/// `yyyy-MM-dd` de uma data (só dia).
String menuDateKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Segunda-feira da semana de [d] (UTC, sem hora).
DateTime mondayOf(DateTime d) {
  final day = DateTime.utc(d.year, d.month, d.day);
  return day.subtract(Duration(days: day.weekday - DateTime.monday));
}

/// Tipos, pratos e menu da semana de [weekStart] (segunda a sexta).
({List<MealType> types, List<MealItem> items, List<MealMenu> menus})
buildMenuSeed(DateTime weekStart, {int seed = 66}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 9, 1, 8);
  String id(int i) => gen.ulid(at.add(Duration(minutes: i)));

  final types = [
    MealType(
      id: id(0),
      name: 'Pequeno-almoço',
      startTime: '07:00',
      endTime: '08:00',
      priceMinor: 50000,
    ),
    MealType(
      id: id(1),
      name: 'Almoço',
      startTime: '12:00',
      endTime: '14:00',
      priceMinor: 120000,
    ),
    MealType(
      id: id(2),
      name: 'Lanche',
      startTime: '15:30',
      endTime: '16:30',
      priceMinor: 40000,
    ),
  ];

  MealItem item(
    int i,
    String name,
    MealType t,
    int price, [
    List<Allergen>? a,
  ]) => MealItem(
    id: id(10 + i),
    name: name,
    mealTypeId: t.id,
    priceMinor: price,
    allergens: a ?? const [],
  );

  final items = [
    item(0, 'Pão com ovo', types[0], 30000, [Allergen.gluten, Allergen.eggs]),
    item(1, 'Chá com leite', types[0], 20000, [Allergen.lactose]),
    item(2, 'Funge com peixe', types[1], 120000, [Allergen.fish]),
    item(3, 'Arroz com frango', types[1], 110000),
    item(4, 'Feijão com carne', types[1], 115000, [Allergen.celery]),
    item(5, 'Gelado', types[1], 25000, [Allergen.lactose, Allergen.nuts]),
    item(6, 'Sandes de queijo', types[2], 40000, [
      Allergen.gluten,
      Allergen.lactose,
    ]),
    item(7, 'Sumo natural', types[2], 25000),
  ];

  final menus = <MealMenu>[];
  var n = 0;
  for (var d = 0; d < 5; d++) {
    final date = menuDateKey(weekStart.add(Duration(days: d)));
    List<String> ids(List<int> ix) => [for (final i in ix) items[i].id];
    menus
      ..add(
        MealMenu(
          id: id(100 + n++),
          date: date,
          mealTypeId: types[0].id,
          itemIds: ids([0, 1]),
        ),
      )
      ..add(
        MealMenu(
          id: id(100 + n++),
          date: date,
          mealTypeId: types[1].id,
          itemIds: ids([2 + d % 3, 5]),
        ),
      )
      ..add(
        MealMenu(
          id: id(100 + n++),
          date: date,
          mealTypeId: types[2].id,
          itemIds: ids([6, 7]),
        ),
      );
  }
  return (types: types, items: items, menus: menus);
}
