import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/utils/seed_generator.dart';
import '../models/access_models.dart';

/// Zonas, regras e dispositivos de desenvolvimento (mesma seed → mesmos dados).
class AccessSeed {
  const AccessSeed({
    required this.zones,
    required this.rules,
    required this.devices,
  });

  final List<ZoneModel> zones;
  final List<AccessRuleModel> rules;
  final List<AccessDeviceModel> devices;
}

const _zoneNames = [
  ('Portaria principal', 'Entrada de alunos e funcionários'),
  ('Biblioteca', 'Sala de leitura e empréstimos'),
  ('Laboratório', 'Laboratório de informática e ciências'),
  ('Secretaria', 'Atendimento administrativo'),
];

AccessSeed buildAccessSeed({int seed = 69}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 9, 1);
  final zones = <ZoneModel>[];
  final devices = <AccessDeviceModel>[];
  for (var i = 0; i < _zoneNames.length; i++) {
    final (name, description) = _zoneNames[i];
    final zone = ZoneModel(
      id: gen.ulid(at.add(Duration(minutes: i))),
      campusId: MockRef.campusId,
      name: name,
      description: description,
      isActive: i != 3,
    );
    zones.add(zone);
    devices.add(
      AccessDeviceModel(
        id: gen.ulid(at.add(Duration(hours: i))),
        zoneId: zone.id,
        name: i == 0 ? 'Torniquete 1' : 'Leitor ${zone.name}',
        kind: i == 0 ? DeviceKind.turnstile : DeviceKind.reader,
        status: i == 2 ? DeviceStatus.offline : DeviceStatus.online,
        lastSeenAt: at.add(Duration(days: 30, hours: i)),
      ),
    );
  }
  final rules = [
    AccessRuleModel(
      id: gen.ulid(at.add(const Duration(days: 1))),
      zoneId: zones[0].id,
      name: 'Alunos — horário lectivo',
      subject: AccessSubject.student,
      days: const [1, 2, 3, 4, 5],
      startMinute: 7 * 60,
      endMinute: 18 * 60,
      requireActiveStudent: true,
    ),
    AccessRuleModel(
      id: gen.ulid(at.add(const Duration(days: 2))),
      zoneId: zones[0].id,
      name: 'Funcionários',
      subject: AccessSubject.staff,
      days: const [1, 2, 3, 4, 5, 6],
      startMinute: 6 * 60,
      endMinute: 20 * 60,
    ),
    AccessRuleModel(
      id: gen.ulid(at.add(const Duration(days: 3))),
      zoneId: zones[1].id,
      name: 'Biblioteca — sem pendências',
      subject: AccessSubject.student,
      days: const [1, 2, 3, 4, 5],
      startMinute: 8 * 60,
      endMinute: 17 * 60,
      requireActiveStudent: true,
      requireFinancialClear: true,
    ),
    AccessRuleModel(
      id: gen.ulid(at.add(const Duration(days: 4))),
      zoneId: zones[2].id,
      name: 'Laboratório — aulas',
      days: const [2, 4],
      startMinute: 9 * 60,
      endMinute: 15 * 60,
    ),
  ];
  return AccessSeed(zones: zones, rules: rules, devices: devices);
}
