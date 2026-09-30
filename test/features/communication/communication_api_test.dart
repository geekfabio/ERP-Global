import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/notifications/notification_service.dart';
import 'package:erp_global/features/communication/data/mock_api/communication_mock_handlers.dart';
import 'package:erp_global/features/communication/data/models/agenda_event_model.dart';
import 'package:erp_global/features/communication/data/models/announcement_model.dart';
import 'package:erp_global/features/communication/data/models/communication_enums.dart';
import 'package:erp_global/features/communication/data/repositories/api_communication_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

class _Env {
  _Env() {
    registry.addModule(handlers);
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
    announcements = ApiAnnouncementRepository(client);
    agenda = ApiAgendaRepository(client);
    notifications = ApiNotificationService(client);
  }

  final registry = MockApiRegistry();
  final handlers = CommunicationMockHandlers();
  late final ApiClient client;
  late final ApiAnnouncementRepository announcements;
  late final ApiAgendaRepository agenda;
  late final ApiNotificationService notifications;
}

AnnouncementModel _draft({
  String id = '01JNEWANN00000000000000001',
  AnnouncementAudience audience = AnnouncementAudience.school,
  String? classroomId,
  List<String> channels = const ['in_app'],
  String body = 'Corpo',
  bool receipt = false,
  AnnouncementStatus status = AnnouncementStatus.published,
}) {
  final now = DateTime.utc(2026, 2, 1);
  return AnnouncementModel(
    id: id,
    institutionId: MockRef.institutionId,
    createdAt: now,
    updatedAt: now,
    title: 'Título',
    body: body,
    audience: audience,
    classroomId: classroomId,
    channels: channels,
    requiresReadReceipt: receipt,
    status: status,
  );
}

Failure _failure<T>(Result<T> r) => r.failureOrNull!;

void main() {
  group('comunicados', () {
    test('lista o seed paginado com envelope e filtra por público', () async {
      final env = _Env();
      final all = (await env.announcements.list()).getOrThrow();
      expect(all.meta.total, 3);
      final guardians = (await env.announcements.list(
        audience: AnnouncementAudience.guardians,
      )).getOrThrow();
      expect(guardians.items.single.title, 'Propinas de Fevereiro');
    });

    test('publicar entrega pelos adapters dos canais escolhidos', () async {
      final env = _Env();
      final created = (await env.announcements.create(
        _draft(channels: const ['in_app', 'push', 'email'], body: 'Olá'),
      )).getOrThrow();
      expect(created.status, AnnouncementStatus.published);
      expect(created.publishedAt, isNotNull);
      expect(created.recipientCount, 480);
      final a = env.handlers.adapters;
      expect(a[NotificationChannel.push]!.log.single.count, 480);
      expect(a[NotificationChannel.email]!.log, hasLength(1));
      expect(a[NotificationChannel.sms]!.log, isEmpty);
    });

    test('rascunho só entrega ao ser publicado; 409 se repetir', () async {
      final env = _Env();
      final draft = (await env.announcements.create(
        _draft(status: AnnouncementStatus.draft, channels: const ['push']),
      )).getOrThrow();
      final push = env.handlers.adapters[NotificationChannel.push]!;
      expect(draft.status, AnnouncementStatus.draft);
      expect(push.log, isEmpty);

      final published = (await env.announcements.publish(
        draft.id,
      )).getOrThrow();
      expect(published.status, AnnouncementStatus.published);
      expect(push.log, hasLength(1));
      final again = await env.announcements.publish(draft.id);
      expect(_failure(again).code, 'CONFLICT');
    });

    test('valida público por turma (422 com campos)', () async {
      final env = _Env();
      final r = await env.announcements.create(
        _draft(audience: AnnouncementAudience.classroom),
      );
      expect(_failure(r).code, 'VALIDATION_ERROR');
    });

    test('confirmação de leitura é idempotente e conta uma vez', () async {
      final env = _Env();
      const id = '01JANN02000000000000000000';
      final before = (await env.announcements.get(id)).getOrThrow().readCount;
      final r1 = (await env.announcements.confirmRead(
        id,
        userId: 'u1',
      )).getOrThrow();
      final r2 = (await env.announcements.confirmRead(
        id,
        userId: 'u1',
      )).getOrThrow();
      expect(r2.readAt, r1.readAt);
      await env.announcements.confirmRead(id, userId: 'u2');
      final after = (await env.announcements.get(id)).getOrThrow().readCount;
      expect(after, before + 2);
      final reads = (await env.announcements.reads(id)).getOrThrow();
      expect(reads.map((r) => r.userId), containsAll(['u1', 'u2']));
    });

    test('404 para comunicado inexistente', () async {
      final r = await _Env().announcements.get('nao-existe');
      expect(_failure(r).code, 'NOT_FOUND');
    });

    test('reset repõe o seed', () async {
      final env = _Env();
      await env.announcements.create(_draft());
      await env.client.dio.post<dynamic>('/__mock/reset');
      final all = (await env.announcements.list()).getOrThrow();
      expect(all.meta.total, 3);
    });
  });

  group('NotificationService', () {
    test('envia por vários canais e devolve recibo', () async {
      final env = _Env();
      final receipt = (await env.notifications.send(
        const NotificationRequest(
          sourceModule: 'billing',
          recipientIds: ['u1', 'u2'],
          title: 'Fatura',
          body: 'Tem uma fatura em aberto',
          channels: [NotificationChannel.inApp, NotificationChannel.sms],
          data: {'invoiceId': 'x'},
        ),
      )).getOrThrow();
      expect(receipt.allDelivered, isTrue);
      expect(receipt.deliveries.map((d) => d.count), [2, 2]);
      expect(
        env.handlers.adapters[NotificationChannel.sms]!.log.single.title,
        'Fatura',
      );
    });

    test('falha num canal não impede os restantes', () async {
      final env = _Env();
      final receipt = (await env.notifications.send(
        NotificationRequest(
          sourceModule: 'academic',
          recipientIds: const ['u1'],
          title: 'Aviso',
          body: 'x' * 400,
          channels: const [NotificationChannel.inApp, NotificationChannel.sms],
        ),
      )).getOrThrow();
      expect(receipt.allDelivered, isFalse);
      final sms = receipt.deliveries.singleWhere(
        (d) => d.channel == NotificationChannel.sms,
      );
      expect(sms.delivered, isFalse);
      expect(sms.error, contains('SMS'));
      expect(receipt.deliveries.first.delivered, isTrue);
    });

    test('sem destinatários é 422', () async {
      final r = await _Env().notifications.send(
        const NotificationRequest(
          sourceModule: 'billing',
          recipientIds: [],
          title: 't',
          body: 'b',
        ),
      );
      expect(_failure(r).code, 'VALIDATION_ERROR');
    });

    test('canal faz roundtrip no formato da API', () {
      for (final c in NotificationChannel.values) {
        expect(NotificationChannel.fromWire(c.wire), c);
      }
      expect(NotificationChannel.inApp.wire, 'in_app');
    });
  });

  group('agenda', () {
    AgendaEventModel event({DateTime? ends}) => AgendaEventModel(
      id: '01JNEWEVT00000000000000001',
      institutionId: MockRef.institutionId,
      createdAt: DateTime.utc(2026),
      updatedAt: DateTime.utc(2026),
      title: 'Excursão',
      type: AgendaEventType.event,
      startsAt: DateTime.utc(2026, 5, 10, 8),
      endsAt: ends,
    );

    test('lista por ordem cronológica e filtra por intervalo', () async {
      final env = _Env();
      final all = (await env.agenda.list()).getOrThrow();
      final dates = all.items.map((e) => e.startsAt).toList();
      expect(dates, [...dates]..sort());
      final feb = (await env.agenda.list(
        from: DateTime.utc(2026, 2),
        to: DateTime.utc(2026, 3),
      )).getOrThrow();
      expect(feb.items.map((e) => e.title), [
        'Limite de pagamento de propinas',
        'Reunião de pais',
      ]);
      final exams = (await env.agenda.list(
        type: AgendaEventType.exam,
      )).getOrThrow();
      expect(exams.meta.total, 1);
    });

    test('criar, actualizar e remover', () async {
      final env = _Env();
      final created = (await env.agenda.create(event())).getOrThrow();
      final updated = (await env.agenda.update(
        created.copyWith(title: 'Excursão ao museu'),
      )).getOrThrow();
      expect(updated.title, 'Excursão ao museu');
      expect((await env.agenda.delete(created.id)).isOk, isTrue);
      final gone = (await env.agenda.list()).getOrThrow();
      expect(gone.items.any((e) => e.id == created.id), isFalse);
      expect(_failure(await env.agenda.delete(created.id)).code, 'NOT_FOUND');
    });

    test('fim anterior ao início é 422', () async {
      final r = await _Env().agenda.create(
        event(ends: DateTime.utc(2026, 5, 9)),
      );
      expect(_failure(r).code, 'VALIDATION_ERROR');
    });
  });
}
