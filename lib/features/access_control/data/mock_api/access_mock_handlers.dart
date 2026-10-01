import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seed_generator.dart';
import '../data_mocks/access_seed.dart';
import '../models/access_models.dart';

/// Handlers de `/v1/zones`, `/v1/access-rules` e `/v1/access-devices`
/// (docs/07-mock-api.md). Estado mutável em memória; `POST /__mock/reset`
/// repõe o seed. A validação dos acessos em si é local (ver
/// `domain/access_evaluator.dart`).
class AccessMockHandlers implements MockApiModule {
  AccessMockHandlers() {
    _reset();
  }

  late Map<String, ZoneModel> _zones;
  late Map<String, AccessRuleModel> _rules;
  late Map<String, AccessDeviceModel> _devices;
  late SeedGenerator _ids;

  void _reset() {
    final s = buildAccessSeed();
    _ids = SeedGenerator(690);
    _zones = {for (final z in s.zones) z.id: z};
    _rules = {for (final r in s.rules) r.id: r};
    _devices = {for (final d in s.devices) d.id: d};
  }

  String _newId() => _ids.ulid(DateTime.now().toUtc());

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/zones', _listZones)
      ..post('/v1/zones', _createZone)
      ..put('/v1/zones/{id}', _updateZone)
      ..delete('/v1/zones/{id}', _deleteZone)
      ..get('/v1/access-rules', _listRules)
      ..post('/v1/access-rules', _createRule)
      ..put('/v1/access-rules/{id}', _updateRule)
      ..delete('/v1/access-rules/{id}', _deleteRule)
      ..get('/v1/access-devices', _listDevices)
      ..post('/v1/access-devices', _createDevice)
      ..put('/v1/access-devices/{id}', _updateDevice)
      ..delete('/v1/access-devices/{id}', _deleteDevice);
  }

  static MockResponse _deleted() => MockResponse.ok({'deleted': true});

  // ---- Zonas ------------------------------------------------------------

  late final _zoneSpec = MockListSpec<ZoneModel>(
    searchText: (z) => '${z.name} ${z.description ?? ''}',
    sortable: {'name': (z) => foldText(z.name)},
    filterable: {'campusId': (z) => z.campusId},
    defaultSort: const ['name'],
  );

  MockResponse _listZones(MockRequest req) => mockPaginate(
    _zones.values,
    req,
    toJson: (z) => z.toJson(),
    spec: _zoneSpec,
  );

  ZoneModel _validZone(MockRequest req, {String? id}) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('name')
      ..required('campusId')
      ..throwIfInvalid();
    final name = '${body['name']}'.trim();
    final campusId = '${body['campusId']}'.trim();
    final duplicate = _zones.values.any(
      (z) =>
          z.id != id &&
          z.campusId == campusId &&
          foldText(z.name) == foldText(name),
    );
    if (duplicate) {
      throw const MockApiException.conflict(
        'Já existe uma zona com este nome no campus',
      );
    }
    return ZoneModel(
      id: id ?? _newId(),
      campusId: campusId,
      name: name,
      description: (body['description'] as String?)?.trim(),
      isActive: body['isActive'] as bool? ?? true,
    );
  }

  MockResponse _createZone(MockRequest req) {
    final zone = _validZone(req);
    _zones[zone.id] = zone;
    return MockResponse.created(zone.toJson());
  }

  MockResponse _updateZone(MockRequest req) {
    final id = req.params['id']!;
    if (!_zones.containsKey(id)) throw const MockApiException.notFound();
    final zone = _validZone(req, id: id);
    _zones[id] = zone;
    return MockResponse.ok(zone.toJson());
  }

  MockResponse _deleteZone(MockRequest req) {
    final id = req.params['id']!;
    if (!_zones.containsKey(id)) throw const MockApiException.notFound();
    if (_rules.values.any((r) => r.zoneId == id) ||
        _devices.values.any((d) => d.zoneId == id)) {
      throw const MockApiException.conflict(
        'Remova primeiro as regras e os dispositivos da zona',
      );
    }
    _zones.remove(id);
    return _deleted();
  }

  void _requireZone(String zoneId) {
    if (!_zones.containsKey(zoneId)) {
      throw MockApiException.validation({'zoneId': 'Zona inexistente'});
    }
  }

  // ---- Regras -----------------------------------------------------------

  late final _ruleSpec = MockListSpec<AccessRuleModel>(
    searchText: (r) => r.name,
    sortable: {'name': (r) => foldText(r.name), 'start': (r) => r.startMinute},
    filterable: {'zoneId': (r) => r.zoneId},
    defaultSort: const ['name'],
  );

  MockResponse _listRules(MockRequest req) => mockPaginate(
    _rules.values,
    req,
    toJson: (r) => r.toJson(),
    spec: _ruleSpec,
  );

  AccessRuleModel _validRule(MockRequest req, {String? id}) {
    final body = req.jsonBody;
    final days = body['days'];
    final start = body['startMinute'];
    final end = body['endMinute'];
    final subject = body['subject'];
    MockValidator(body)
      ..required('name')
      ..required('zoneId')
      ..check(
        'days',
        days is List &&
            days.isNotEmpty &&
            days.every((d) => d is int && d >= 1 && d <= 7),
        'Escolha pelo menos um dia',
      )
      ..check(
        'startMinute',
        start is int && start >= 0 && start < 1440,
        'Hora de início inválida',
      )
      ..check(
        'endMinute',
        end is int && end > 0 && end <= 1440,
        'Hora de fim inválida',
      )
      ..check(
        'subject',
        subject == null || AccessSubject.values.any((s) => s.name == subject),
        'Tipo inválido',
      )
      ..throwIfInvalid();
    if ((end as int) <= (start as int)) {
      throw MockApiException.validation({
        'endMinute': 'O fim deve ser depois do início',
      });
    }
    _requireZone('${body['zoneId']}');
    return AccessRuleModel(
      id: id ?? _newId(),
      zoneId: '${body['zoneId']}',
      name: '${body['name']}'.trim(),
      subject: subject == null
          ? AccessSubject.all
          : AccessSubject.values.byName('$subject'),
      days: {...(days as List).cast<int>()}.toList()..sort(),
      startMinute: start,
      endMinute: end,
      requireActiveStudent: body['requireActiveStudent'] as bool? ?? false,
      requireFinancialClear: body['requireFinancialClear'] as bool? ?? false,
      isActive: body['isActive'] as bool? ?? true,
    );
  }

  MockResponse _createRule(MockRequest req) {
    final rule = _validRule(req);
    _rules[rule.id] = rule;
    return MockResponse.created(rule.toJson());
  }

  MockResponse _updateRule(MockRequest req) {
    final id = req.params['id']!;
    if (!_rules.containsKey(id)) throw const MockApiException.notFound();
    final rule = _validRule(req, id: id);
    _rules[id] = rule;
    return MockResponse.ok(rule.toJson());
  }

  MockResponse _deleteRule(MockRequest req) {
    if (_rules.remove(req.params['id']) == null) {
      throw const MockApiException.notFound();
    }
    return _deleted();
  }

  // ---- Dispositivos -----------------------------------------------------

  late final _deviceSpec = MockListSpec<AccessDeviceModel>(
    searchText: (d) => d.name,
    sortable: {'name': (d) => foldText(d.name)},
    filterable: {'zoneId': (d) => d.zoneId, 'status': (d) => d.status.name},
    defaultSort: const ['name'],
  );

  MockResponse _listDevices(MockRequest req) => mockPaginate(
    _devices.values,
    req,
    toJson: (d) => d.toJson(),
    spec: _deviceSpec,
  );

  AccessDeviceModel _validDevice(MockRequest req, {AccessDeviceModel? old}) {
    final body = req.jsonBody;
    MockValidator(body)
      ..required('name')
      ..required('zoneId')
      ..check(
        'kind',
        body['kind'] == null ||
            DeviceKind.values.any((k) => k.name == body['kind']),
        'Tipo inválido',
      )
      ..check(
        'status',
        body['status'] == null ||
            DeviceStatus.values.any((s) => s.name == body['status']),
        'Estado inválido',
      )
      ..throwIfInvalid();
    _requireZone('${body['zoneId']}');
    final name = '${body['name']}'.trim();
    if (_devices.values.any(
      (d) => d.id != old?.id && foldText(d.name) == foldText(name),
    )) {
      throw const MockApiException.conflict(
        'Já existe um dispositivo com este nome',
      );
    }
    return AccessDeviceModel(
      id: old?.id ?? _newId(),
      zoneId: '${body['zoneId']}',
      name: name,
      kind: DeviceKind.values.byName('${body['kind'] ?? 'reader'}'),
      status: DeviceStatus.values.byName('${body['status'] ?? 'online'}'),
      isActive: body['isActive'] as bool? ?? true,
      lastSeenAt: old?.lastSeenAt,
    );
  }

  MockResponse _createDevice(MockRequest req) {
    final device = _validDevice(req);
    _devices[device.id] = device;
    return MockResponse.created(device.toJson());
  }

  MockResponse _updateDevice(MockRequest req) {
    final old = _devices[req.params['id']];
    if (old == null) throw const MockApiException.notFound();
    final device = _validDevice(req, old: old);
    _devices[old.id] = device;
    return MockResponse.ok(device.toJson());
  }

  MockResponse _deleteDevice(MockRequest req) {
    if (_devices.remove(req.params['id']) == null) {
      throw const MockApiException.notFound();
    }
    return _deleted();
  }
}
