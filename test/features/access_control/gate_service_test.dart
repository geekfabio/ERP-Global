import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/notifications/notification_service.dart';
import 'package:erp_global/features/access_control/data/devices/mock_access_device_adapter.dart';
import 'package:erp_global/features/access_control/data/mock_api/access_mock_handlers.dart';
import 'package:erp_global/features/access_control/data/models/access_log_model.dart';
import 'package:erp_global/features/access_control/data/models/access_models.dart';
import 'package:erp_global/features/access_control/data/repositories/api_access_log_repository.dart';
import 'package:erp_global/features/access_control/data/repositories/api_access_repositories.dart';
import 'package:erp_global/features/access_control/domain/access_device_adapter.dart';
import 'package:erp_global/features/access_control/domain/access_evaluator.dart';
import 'package:erp_global/features/access_control/domain/gate_service.dart';
import 'package:erp_global/features/cards/data/mock_api/cards_mock_handlers.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeNotifier implements NotificationService {
  final sent = <NotificationRequest>[];

  @override
  Future<Result<NotificationReceipt>> send(NotificationRequest request) async {
    sent.add(request);
    return const Ok(NotificationReceipt(id: 'n1', deliveries: []));
  }
}

class _Env {
  _Env({
    required this.client,
    required this.adapter,
    required this.logs,
    required this.device,
    required this.zone,
    required this.rules,
    required this.notifier,
  });

  final ApiClient client;
  final MockAccessDeviceAdapter adapter;
  final ApiAccessLogRepository logs;
  final AccessDeviceModel device;
  final ZoneModel zone;
  final List<AccessRuleModel> rules;
  final _FakeNotifier notifier;

  GateService service({bool communication = true}) => GateService(
    adapter: adapter,
    holders: ApiAccessHolderResolver(client),
    logs: logs,
    notifier: communication ? notifier : null,
  );

  Future<Result<GateOutcome>> read(
    GateService service,
    String uid, {
    DateTime? at,
    GateDirection direction = GateDirection.entry,
  }) => service.process(
    DeviceCardRead(deviceId: device.id, cardUid: uid, readAt: at ?? _monday9),
    device: device,
    zone: zone,
    rules: rules,
    direction: direction,
  );

  /// Aluno activo com cartão novo e um encarregado com conta no portal.
  Future<({String studentId, String uid})> studentWithCard() async {
    final dio = client.dio;
    final list =
        (await dio.get<Map<String, dynamic>>(
              '/v1/students',
              queryParameters: {'pageSize': 50},
            )).data!['data']!
            as List;
    final student = list.cast<Map<String, dynamic>>().firstWhere(
      (s) => s['status'] == 'active',
    );
    final studentId = student['id'] as String;
    const uid = 'RFID-9001';
    await dio.post<dynamic>(
      '/v1/cards',
      data: {
        'uid': uid,
        'holderId': studentId,
        'holderName': student['fullName'],
        'holderType': 'student',
      },
    );
    final guardian =
        (await dio.post<Map<String, dynamic>>(
              '/v1/guardians',
              data: {
                'fullName': 'Maria Encarregada',
                'phone': '+244923000000',
                'userId': '01HZZZZZZZZZZZZZZZZZZZZZZZ',
              },
            )).data!['data']!
            as Map<String, dynamic>;
    await dio.post<dynamic>(
      '/v1/guardian-links',
      data: {
        'studentId': studentId,
        'guardianId': guardian['id'],
        'relationship': 'mother',
      },
    );
    return (studentId: studentId, uid: uid);
  }
}

// Segunda-feira 09:00 (hora local): dentro do horário da portaria.
final _monday9 = DateTime(2025, 9, 1, 9);

Future<_Env> _env() async {
  final registry = MockApiRegistry()
    ..addModule(AccessMockHandlers())
    ..addModule(CardsMockHandlers())
    ..addModule(StudentsMockHandlers(count: 20));
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  final zones = (await ApiZoneRepository(client).list()).getOrThrow().items;
  final zone = zones.firstWhere((z) => z.name == 'Portaria principal');
  final devices = (await ApiAccessDeviceRepository(
    client,
  ).list(zoneId: zone.id)).getOrThrow().items;
  final rules = (await ApiAccessRuleRepository(
    client,
  ).list()).getOrThrow().items;
  return _Env(
    client: client,
    adapter: MockAccessDeviceAdapter(),
    logs: ApiAccessLogRepository(client),
    device: devices.first,
    zone: zone,
    rules: rules,
    notifier: _FakeNotifier(),
  );
}

void main() {
  test('cartão desconhecido: negado, regista e fecha o dispositivo', () async {
    final env = await _env();
    final outcome = (await env.read(env.service(), 'NAO-EXISTE')).getOrThrow();
    expect(outcome.reason, AccessReason.unknownCard);
    expect(outcome.allowed, isFalse);
    expect(env.adapter.signals.single.open, isFalse);

    final page = (await env.logs.list()).getOrThrow();
    expect(page.items.single.allowed, isFalse);
    expect(page.items.single.reason, 'unknownCard');
  });

  test(
    'aluno dentro do horário: permitido, abre e avisa o encarregado',
    () async {
      final env = await _env();
      final card = await env.studentWithCard();
      final outcome = (await env.read(env.service(), card.uid)).getOrThrow();

      expect(outcome.allowed, isTrue);
      expect(outcome.guardianAlerted, isTrue);
      expect(env.adapter.signals.single.open, isTrue);
      expect(env.notifier.sent, hasLength(1));
      final sent = env.notifier.sent.single;
      expect(sent.sourceModule, 'access_control');
      expect(sent.recipientIds, ['01HZZZZZZZZZZZZZZZZZZZZZZZ']);
      expect(sent.data['studentId'], card.studentId);
      expect(sent.body, contains('entrou em Portaria principal às 09:00'));

      final log = (await env.logs.list()).getOrThrow().items.single;
      expect(log.allowed, isTrue);
      expect(log.guardianAlerted, isTrue);
      expect(log.holderId, card.studentId);
    },
  );

  test('sem communication activo não avisa mas regista a passagem', () async {
    final env = await _env();
    final card = await env.studentWithCard();
    final outcome = (await env.read(
      env.service(communication: false),
      card.uid,
      direction: GateDirection.exit,
    )).getOrThrow();

    expect(outcome.allowed, isTrue);
    expect(outcome.guardianAlerted, isFalse);
    expect(env.notifier.sent, isEmpty);
    final log = (await env.logs.list()).getOrThrow().items.single;
    expect(log.direction, GateDirection.exit);
  });

  test('fora do horário: negado e sem alerta', () async {
    final env = await _env();
    final card = await env.studentWithCard();
    final sunday = DateTime(2025, 9, 7, 9);
    final outcome = (await env.read(
      env.service(),
      card.uid,
      at: sunday,
    )).getOrThrow();

    expect(outcome.reason, AccessReason.outsideSchedule);
    expect(env.notifier.sent, isEmpty);
  });

  test('registos: filtra por permitido e valida o corpo', () async {
    final env = await _env();
    await env.read(env.service(), 'NAO-EXISTE');
    final denied = (await env.logs.list(allowed: false)).getOrThrow();
    expect(denied.meta.total, 1);
    expect((await env.logs.list(allowed: true)).getOrThrow().meta.total, 0);

    final invalid = await env.logs.record(
      AccessLogModel(
        id: '',
        zoneId: 'inexistente',
        cardUid: 'X',
        allowed: true,
        reason: 'granted',
        occurredAt: DateTime.utc(2025, 9, 1),
      ),
    );
    expect(invalid.isErr, isTrue);
  });

  test('adaptador mock emite leituras no stream', () async {
    final adapter = MockAccessDeviceAdapter();
    final future = adapter.reads.first;
    adapter.simulateRead('d1', 'RFID-1');
    final read = await future;
    expect(read.deviceId, 'd1');
    expect(read.cardUid, 'RFID-1');
    await adapter.dispose();
  });
}
