import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/inventory_seed.dart';
import '../models/inventory_models.dart';

/// Handlers de `/v1/assets` e `/v1/stock-items` (docs/07-mock-api.md). Estado
/// mutável em memória; `POST /__mock/reset` repõe o seed.
class InventoryMockHandlers implements MockApiModule {
  InventoryMockHandlers() {
    _reset();
  }

  late Map<String, AssetModel> _assets;
  late Map<String, MaintenanceModel> _maintenance;
  late Map<String, StockItemModel> _stock;
  late SeedGenerator _ids;

  void _reset() {
    final s = buildInventorySeed();
    _ids = SeedGenerator(720);
    _assets = {for (final a in s.assets) a.id: a};
    _maintenance = {for (final m in s.maintenance) m.id: m};
    _stock = {for (final i in s.stock) i.id: i};
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/assets', _listAssets)
      ..post('/v1/assets', _createAsset)
      ..patch('/v1/assets/{id}', _reassign)
      ..post('/v1/assets/{id}/write-off', _writeOff)
      ..get('/v1/assets/{id}/maintenance', _listMaintenance)
      ..post('/v1/assets/{id}/maintenance', _scheduleMaintenance)
      ..post(
        '/v1/assets/{id}/maintenance/{maintenanceId}/complete',
        _completeMaintenance,
      )
      ..get('/v1/stock-items', _listStock)
      ..post('/v1/stock-items', _createStock)
      ..post('/v1/stock-items/{id}/movements', _moveStock);
  }

  // ---- Bens -------------------------------------------------------------

  late final _assetSpec = MockListSpec<AssetModel>(
    searchText: (a) => '${a.tag} ${a.name} ${a.custodian} ${a.location}',
    sortable: {
      'tag': (a) => a.tag,
      'name': (a) => foldText(a.name),
      'acquiredOn': (a) => a.acquiredOn,
    },
    filterable: {
      'status': (a) => a.status.wire,
      'category': (a) => a.category,
      'location': (a) => a.location,
    },
    defaultSort: const ['tag'],
  );

  MockResponse _listAssets(MockRequest req) => mockPaginate(
    _assets.values,
    req,
    toJson: (a) => a.toJson(),
    spec: _assetSpec,
  );

  AssetModel _asset(MockRequest req) =>
      _assets[req.params['id']] ?? (throw const MockApiException.notFound());

  MockResponse _saveAsset(AssetModel a) {
    _assets[a.id] = a;
    return MockResponse.ok(a.toJson());
  }

  MockResponse _createAsset(MockRequest req) {
    final body = req.jsonBody;
    final value = body['valueCents'];
    MockValidator(body)
      ..required('tag')
      ..required('name')
      ..required('category')
      ..required('location')
      ..required('custodian')
      ..required('acquiredOn')
      ..check(
        'valueCents',
        value == null || (value is int && value >= 0),
        'Valor inválido',
      )
      ..throwIfInvalid();
    final tag = '${body['tag']}'.trim().toUpperCase();
    if (_assets.values.any((a) => a.tag == tag)) {
      throw const MockApiException.conflict('Número de património já existe');
    }
    final asset = AssetModel(
      id: _ids.ulid(DateTime.now().toUtc()),
      tag: tag,
      name: '${body['name']}'.trim(),
      category: '${body['category']}'.trim(),
      location: '${body['location']}'.trim(),
      custodian: '${body['custodian']}'.trim(),
      acquiredOn: const DateOnlyConverter().fromJson('${body['acquiredOn']}'),
      valueCents: (value as int?) ?? 0,
    );
    _assets[asset.id] = asset;
    return MockResponse.created(asset.toJson());
  }

  MockResponse _reassign(MockRequest req) {
    final asset = _asset(req);
    final body = req.jsonBody;
    MockValidator(body)
      ..check(
        'custodian',
        !body.containsKey('custodian') ||
            '${body['custodian']}'.trim().isNotEmpty,
        'Campo obrigatório',
      )
      ..check(
        'location',
        !body.containsKey('location') ||
            '${body['location']}'.trim().isNotEmpty,
        'Campo obrigatório',
      )
      ..throwIfInvalid();
    if (asset.status == AssetStatus.writtenOff) {
      throw const MockApiException.conflict('O bem está abatido');
    }
    return _saveAsset(
      asset.copyWith(
        custodian: (body['custodian'] as String?)?.trim() ?? asset.custodian,
        location: (body['location'] as String?)?.trim() ?? asset.location,
      ),
    );
  }

  MockResponse _writeOff(MockRequest req) {
    final asset = _asset(req);
    MockValidator(req.jsonBody)
      ..required('reason', 'Indique o motivo do abate')
      ..throwIfInvalid();
    if (asset.status == AssetStatus.writtenOff) {
      throw const MockApiException.conflict('O bem já foi abatido');
    }
    if (_openMaintenance(asset.id) > 0) {
      throw const MockApiException.conflict(
        'Conclua a manutenção em curso antes de abater',
      );
    }
    return _saveAsset(
      asset.copyWith(
        status: AssetStatus.writtenOff,
        writeOffReason: '${req.jsonBody['reason']}'.trim(),
        writtenOffAt: DateTime.now().toUtc(),
      ),
    );
  }

  // ---- Manutenção -------------------------------------------------------

  int _openMaintenance(String assetId) => _maintenance.values
      .where((m) => m.assetId == assetId && m.status == MaintenanceStatus.open)
      .length;

  MockResponse _listMaintenance(MockRequest req) {
    final asset = _asset(req);
    final list =
        _maintenance.values.where((m) => m.assetId == asset.id).toList()
          ..sort((a, b) => b.scheduledOn.compareTo(a.scheduledOn));
    return MockResponse.ok([for (final m in list) m.toJson()]);
  }

  MockResponse _scheduleMaintenance(MockRequest req) {
    final asset = _asset(req);
    final body = req.jsonBody;
    final cost = body['costCents'];
    MockValidator(body)
      ..required('description')
      ..required('scheduledOn')
      ..check(
        'costCents',
        cost == null || (cost is int && cost >= 0),
        'Custo inválido',
      )
      ..throwIfInvalid();
    if (asset.status == AssetStatus.writtenOff) {
      throw const MockApiException.conflict('O bem está abatido');
    }
    final m = MaintenanceModel(
      id: _ids.ulid(DateTime.now().toUtc()),
      assetId: asset.id,
      description: '${body['description']}'.trim(),
      scheduledOn: const DateOnlyConverter().fromJson('${body['scheduledOn']}'),
      costCents: (cost as int?) ?? 0,
    );
    _maintenance[m.id] = m;
    _assets[asset.id] = asset.copyWith(status: AssetStatus.inMaintenance);
    return MockResponse.created(m.toJson());
  }

  MockResponse _completeMaintenance(MockRequest req) {
    final asset = _asset(req);
    final m = _maintenance[req.params['maintenanceId']];
    if (m == null || m.assetId != asset.id) {
      throw const MockApiException.notFound();
    }
    if (m.status == MaintenanceStatus.done) {
      throw const MockApiException.conflict('A manutenção já foi concluída');
    }
    final done = m.copyWith(
      status: MaintenanceStatus.done,
      completedAt: DateTime.now().toUtc(),
    );
    _maintenance[m.id] = done;
    if (_openMaintenance(asset.id) == 0 &&
        asset.status == AssetStatus.inMaintenance) {
      _assets[asset.id] = asset.copyWith(status: AssetStatus.active);
    }
    return MockResponse.ok(done.toJson());
  }

  // ---- Stock ------------------------------------------------------------

  late final _stockSpec = MockListSpec<StockItemModel>(
    searchText: (i) => '${i.sku} ${i.name}',
    sortable: {'name': (i) => foldText(i.name), 'quantity': (i) => i.quantity},
    filterable: {'lowStock': (i) => i.lowStock},
    defaultSort: const ['name'],
  );

  StockItemModel _view(StockItemModel i) =>
      i.copyWith(lowStock: i.quantity <= i.minQuantity);

  MockResponse _listStock(MockRequest req) => mockPaginate(
    _stock.values.map(_view),
    req,
    toJson: (i) => i.toJson(),
    spec: _stockSpec,
  );

  MockResponse _createStock(MockRequest req) {
    final body = req.jsonBody;
    final qty = body['quantity'];
    final min = body['minQuantity'];
    MockValidator(body)
      ..required('sku')
      ..required('name')
      ..required('unit')
      ..required('location')
      ..check('quantity', qty is int && qty >= 0, 'Quantidade inválida')
      ..check('minQuantity', min is int && min >= 0, 'Mínimo inválido')
      ..throwIfInvalid();
    final sku = '${body['sku']}'.trim().toUpperCase();
    if (_stock.values.any((i) => i.sku == sku)) {
      throw const MockApiException.conflict('SKU já existe');
    }
    final item = _view(
      StockItemModel(
        id: _ids.ulid(DateTime.now().toUtc()),
        sku: sku,
        name: '${body['name']}'.trim(),
        unit: '${body['unit']}'.trim(),
        quantity: qty as int,
        minQuantity: min as int,
        location: '${body['location']}'.trim(),
      ),
    );
    _stock[item.id] = item;
    return MockResponse.created(item.toJson());
  }

  MockResponse _moveStock(MockRequest req) {
    final item =
        _stock[req.params['id']] ?? (throw const MockApiException.notFound());
    final body = req.jsonBody;
    final delta = body['delta'];
    MockValidator(body)
      ..check('delta', delta is int && delta != 0, 'Indique uma quantidade')
      ..required('reason', 'Indique o motivo')
      ..throwIfInvalid();
    final next = item.quantity + (delta as int);
    if (next < 0) {
      throw const MockApiException.conflict('Stock insuficiente');
    }
    final updated = _view(item.copyWith(quantity: next));
    _stock[item.id] = updated;
    return MockResponse.ok(updated.toJson());
  }
}
