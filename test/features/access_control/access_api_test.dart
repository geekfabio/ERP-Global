import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/access_control/data/mock_api/access_mock_handlers.dart';
import 'package:erp_global/features/access_control/data/models/access_models.dart';
import 'package:erp_global/features/access_control/data/repositories/api_access_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

({
  ApiZoneRepository zones,
  ApiAccessRuleRepository rules,
  ApiAccessDeviceRepository devices,
})
_env() {
  final registry = MockApiRegistry()..addModule(AccessMockHandlers());
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return (
    zones: ApiZoneRepository(client),
    rules: ApiAccessRuleRepository(client),
    devices: ApiAccessDeviceRepository(client),
  );
}

void main() {
  test('lista zonas do seed, paginadas', () async {
    final page = (await _env().zones.list(pageSize: 2)).getOrThrow();
    expect(page.items, hasLength(2));
    expect(page.meta.total, 4);
  });

  test('zona: cria, duplicado dá 409 e edita', () async {
    final r = _env().zones;
    final created = (await r.create(
      const ZoneModel(id: '', campusId: 'c1', name: 'Ginásio'),
    )).getOrThrow();
    expect(created.id, isNotEmpty);

    final dup = await r.create(
      const ZoneModel(id: '', campusId: 'c1', name: 'ginásio'),
    );
    expect(dup.failureOrNull, isA<UnknownFailure>());

    final updated = (await r.update(
      created.copyWith(isActive: false),
    )).getOrThrow();
    expect(updated.isActive, isFalse);
  });

  test('zona com regras ou dispositivos não é eliminada (409)', () async {
    final env = _env();
    final zone = (await env.zones.list()).getOrThrow().items.first;
    expect((await env.zones.delete(zone.id)).isOk, isFalse);
  });

  test('regra: valida dias, horas e zona (422)', () async {
    final env = _env();
    final zone = (await env.zones.list()).getOrThrow().items.first;
    AccessRuleModel rule({
      List<int> days = const [1],
      int start = 480,
      int end = 600,
      String? zoneId,
    }) => AccessRuleModel(
      id: '',
      zoneId: zoneId ?? zone.id,
      name: 'Nova',
      days: days,
      startMinute: start,
      endMinute: end,
    );

    for (final bad in [
      rule(days: const []),
      rule(days: const [8]),
      rule(start: 600, end: 600),
      rule(end: 1441),
      rule(zoneId: 'inexistente'),
    ]) {
      final result = await env.rules.create(bad);
      expect(result.failureOrNull, isA<ValidationFailure>());
    }
    final ok = (await env.rules.create(
      rule(days: const [3, 1, 3]),
    )).getOrThrow();
    expect(ok.days, [1, 3]);
    expect((await env.rules.delete(ok.id)).isOk, isTrue);
  });

  test('dispositivo: cria, filtra por zona e elimina', () async {
    final env = _env();
    final zone = (await env.zones.list()).getOrThrow().items.first;
    final created = (await env.devices.create(
      AccessDeviceModel(id: '', zoneId: zone.id, name: 'Porta B'),
    )).getOrThrow();
    final byZone = (await env.devices.list(zoneId: zone.id)).getOrThrow();
    expect(byZone.items.map((d) => d.id), contains(created.id));
    expect((await env.devices.delete(created.id)).isOk, isTrue);
  });
}
