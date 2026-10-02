import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/menu_seed.dart';
import '../models/menu.dart';

/// Handlers de `/v1/meal-types`, `/v1/meal-items` e `/v1/meal-menus`
/// (docs/07-mock-api.md). Estado em memória; `POST /__mock/reset` repõe o seed.
/// O seed do menu cobre a semana corrente do relógio injectado.
class MenuMockHandlers implements MockApiModule {
  MenuMockHandlers({DateTime Function()? clock})
    : _clock = clock ?? (() => DateTime.now().toUtc()) {
    _reset();
  }

  final DateTime Function() _clock;

  static final _time = RegExp(r'^([01]\d|2[0-3]):[0-5]\d$');
  static final _date = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  /// Tipos de refeição actuais (para relatórios calculados).
  List<MealType> get allMealTypes => _types.values.toList();

  late Map<String, MealType> _types;
  late Map<String, MealItem> _items;
  late Map<String, MealMenu> _menus;
  late SeedGenerator _ids;

  void _reset() {
    _ids = SeedGenerator(660);
    final seed = buildMenuSeed(mondayOf(_clock()));
    _types = {for (final t in seed.types) t.id: t};
    _items = {for (final i in seed.items) i.id: i};
    _menus = {for (final m in seed.menus) m.id: m};
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/meal-types', _listTypes)
      ..post('/v1/meal-types', (req) => _saveType(req, null))
      ..patch('/v1/meal-types/{id}', (req) => _saveType(req, _typeId(req)))
      ..delete('/v1/meal-types/{id}', _deleteType)
      ..get('/v1/meal-items', _listItems)
      ..post('/v1/meal-items', (req) => _saveItem(req, null))
      ..patch('/v1/meal-items/{id}', (req) => _saveItem(req, _itemId(req)))
      ..delete('/v1/meal-items/{id}', _deleteItem)
      ..get('/v1/meal-menus', _listMenus)
      ..put('/v1/meal-menus', _saveMenu)
      ..delete('/v1/meal-menus/{id}', _deleteMenu);
  }

  String _newId() => _ids.ulid(_clock());

  String _typeId(MockRequest req) {
    final id = req.params['id']!;
    if (!_types.containsKey(id)) throw const MockApiException.notFound();
    return id;
  }

  String _itemId(MockRequest req) {
    final id = req.params['id']!;
    if (!_items.containsKey(id)) throw const MockApiException.notFound();
    return id;
  }

  void _validatePrice(MockValidator v, Map<String, dynamic> body) {
    final p = body['priceMinor'] ?? 0;
    v.check('priceMinor', p is int && p >= 0, 'Preço inválido');
  }

  // --- Tipos de refeição -------------------------------------------------

  late final _typeSpec = MockListSpec<MealType>(
    sortable: {
      'startTime': (t) => t.startTime,
      'name': (t) => foldText(t.name),
    },
    defaultSort: const ['startTime'],
  );

  MockResponse _listTypes(MockRequest req) => mockPaginate(
    _types.values,
    req,
    toJson: (t) => t.toJson(),
    spec: _typeSpec,
  );

  MockResponse _saveType(MockRequest req, String? id) {
    final body = req.jsonBody;
    final v = MockValidator(body)
      ..required('name')
      ..check('startTime', _time.hasMatch('${body['startTime']}'), 'Use HH:mm')
      ..check('endTime', _time.hasMatch('${body['endTime']}'), 'Use HH:mm');
    _validatePrice(v, body);
    if (v.isValid) {
      v.check(
        'endTime',
        '${body['endTime']}'.compareTo('${body['startTime']}') > 0,
        'O fim deve ser depois do início',
      );
    }
    v.throwIfInvalid();
    final name = '${body['name']}'.trim();
    final dup = _types.values.any(
      (t) => t.id != id && foldText(t.name) == foldText(name),
    );
    if (dup) throw const MockApiException.conflict('Tipo de refeição repetido');
    final type = MealType(
      id: id ?? _newId(),
      name: name,
      startTime: '${body['startTime']}',
      endTime: '${body['endTime']}',
      priceMinor: (body['priceMinor'] ?? 0) as int,
      isActive: (body['isActive'] ?? true) as bool,
    );
    _types[type.id] = type;
    return id == null
        ? MockResponse.created(type.toJson())
        : MockResponse.ok(type.toJson());
  }

  MockResponse _deleteType(MockRequest req) {
    final id = _typeId(req);
    if (_items.values.any((i) => i.mealTypeId == id)) {
      throw const MockApiException.conflict(
        'Existem pratos deste tipo de refeição',
      );
    }
    _menus.removeWhere((_, m) => m.mealTypeId == id);
    _types.remove(id);
    return MockResponse.ok(null);
  }

  // --- Pratos ---------------------------------------------------------------

  late final _itemSpec = MockListSpec<MealItem>(
    searchText: (i) => i.name,
    sortable: {'name': (i) => foldText(i.name)},
    filterable: {'mealTypeId': (i) => i.mealTypeId},
    defaultSort: const ['name'],
  );

  MockResponse _listItems(MockRequest req) => mockPaginate(
    _items.values,
    req,
    toJson: (i) => i.toJson(),
    spec: _itemSpec,
  );

  MockResponse _saveItem(MockRequest req, String? id) {
    final body = req.jsonBody;
    final allergens = body['allergens'] ?? const <Object?>[];
    final known = Allergen.values.map((a) => a.name).toSet();
    final v = MockValidator(body)
      ..required('name')
      ..check(
        'mealTypeId',
        _types.containsKey(body['mealTypeId']),
        'Tipo de refeição inválido',
      )
      ..check(
        'allergens',
        allergens is List && allergens.every(known.contains),
        'Alergénio inválido',
      );
    _validatePrice(v, body);
    v.throwIfInvalid();
    final item = MealItem(
      id: id ?? _newId(),
      name: '${body['name']}'.trim(),
      mealTypeId: '${body['mealTypeId']}',
      priceMinor: (body['priceMinor'] ?? 0) as int,
      allergens: [
        for (final a in (allergens as List).toSet())
          Allergen.values.byName('$a'),
      ],
      isActive: (body['isActive'] ?? true) as bool,
    );
    _items[item.id] = item;
    return id == null
        ? MockResponse.created(item.toJson())
        : MockResponse.ok(item.toJson());
  }

  MockResponse _deleteItem(MockRequest req) {
    final id = _itemId(req);
    _items.remove(id);
    // Retira o prato dos menus que o usam.
    for (final m in _menus.values.toList()) {
      if (m.itemIds.contains(id)) {
        _menus[m.id] = m.copyWith(
          itemIds: [
            for (final i in m.itemIds)
              if (i != id) i,
          ],
        );
      }
    }
    return MockResponse.ok(null);
  }

  // --- Menus ----------------------------------------------------------------

  late final _menuSpec = MockListSpec<MealMenu>(
    sortable: {'date': (m) => m.date},
    filterable: {'mealTypeId': (m) => m.mealTypeId},
    defaultSort: const ['date'],
  );

  MockResponse _listMenus(MockRequest req) {
    final from = req.query['from'] ?? '';
    final to = req.query['to'] ?? '';
    return mockPaginate(
      _menus.values.where(
        (m) =>
            (from.isEmpty || m.date.compareTo(from) >= 0) &&
            (to.isEmpty || m.date.compareTo(to) <= 0),
      ),
      req,
      toJson: (m) => m.toJson(),
      spec: _menuSpec,
    );
  }

  MockResponse _saveMenu(MockRequest req) {
    final body = req.jsonBody;
    final date = '${body['date']}';
    final ids = body['itemIds'];
    final v = MockValidator(body)
      ..check(
        'date',
        _date.hasMatch(date) && DateTime.tryParse(date) != null,
        'Data inválida',
      )
      ..check(
        'mealTypeId',
        _types.containsKey(body['mealTypeId']),
        'Tipo de refeição inválido',
      )
      ..check('itemIds', ids is List, 'Indique os pratos');
    v.throwIfInvalid();
    final typeId = '${body['mealTypeId']}';
    final itemIds = [for (final i in (ids as List).toSet()) '$i'];
    v.check(
      'itemIds',
      itemIds.every((i) => _items[i]?.mealTypeId == typeId),
      'Pratos inexistentes ou de outro tipo de refeição',
    );
    v.throwIfInvalid();
    final existing = _menus.values
        .where((m) => m.date == date && m.mealTypeId == typeId)
        .firstOrNull;
    final menu = MealMenu(
      id: existing?.id ?? _newId(),
      date: date,
      mealTypeId: typeId,
      itemIds: itemIds,
    );
    _menus[menu.id] = menu;
    return MockResponse.ok(menu.toJson());
  }

  MockResponse _deleteMenu(MockRequest req) {
    if (_menus.remove(req.params['id']) == null) {
      throw const MockApiException.notFound();
    }
    return MockResponse.ok(null);
  }
}
