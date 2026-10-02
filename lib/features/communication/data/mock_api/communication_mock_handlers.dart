import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/notifications/notification_service.dart';
import '../data_mocks/communication_seed.dart';
import '../models/agenda_event_model.dart';
import '../models/announcement_model.dart';
import '../models/communication_enums.dart';
import 'channel_adapters.dart';

/// Handlers de `/v1/announcements`, `/v1/notifications`, `/v1/agenda-events`
/// (docs/07-mock-api.md). Estado mutável em memória; `POST /__mock/reset` repõe o seed.
class CommunicationMockHandlers implements MockApiModule {
  CommunicationMockHandlers({List<ChannelAdapter>? adapters})
    : adapters = {
        for (final a in adapters ?? defaultChannelAdapters()) a.channel: a,
      } {
    _reset();
  }

  /// Adapters de canal (push/SMS/e-mail simulados), por canal.
  final Map<NotificationChannel, ChannelAdapter> adapters;

  late Map<String, AnnouncementModel> _announcements;
  late Map<String, AgendaEventModel> _events;
  late Map<String, Set<String>> _reads;
  late Map<String, DateTime> _readAt;

  void _reset() {
    final s = buildCommunicationSeed();
    _announcements = {for (final a in s.announcements) a.id: a};
    _events = {for (final e in s.events) e.id: e};
    _reads = {};
    _readAt = {};
    for (final a in adapters.values) {
      a.log.clear();
    }
  }

  @override
  void register(MockApiRegistry r) {
    r
      ..onReset(_reset)
      ..get('/v1/announcements', _listAnnouncements)
      ..get('/v1/announcements/{id}', (q) => _ok(_announcement(q)))
      ..post('/v1/announcements', _createAnnouncement)
      ..post('/v1/announcements/{id}/publish', _publishAnnouncement)
      ..post('/v1/announcements/{id}/read', _confirmRead)
      ..get('/v1/announcements/{id}/reads', _listReads)
      ..post('/v1/notifications', _sendNotification)
      ..get('/v1/agenda-events', _listEvents)
      ..post('/v1/agenda-events', _createEvent)
      ..patch('/v1/agenda-events/{id}', _updateEvent)
      ..delete('/v1/agenda-events/{id}', _deleteEvent);
  }

  MockResponse _ok(AnnouncementModel a) => MockResponse.ok(_view(a).toJson());

  /// Contagem de leituras calculada a partir das confirmações.
  AnnouncementModel _view(AnnouncementModel a) =>
      a.copyWith(readCount: (_reads[a.id]?.length ?? 0) + _seedReads(a));

  /// Leituras já existentes no seed (antes das confirmações desta sessão).
  int _seedReads(AnnouncementModel a) => _seedReadCounts[a.id] ?? 0;

  late final Map<String, int> _seedReadCounts = {
    for (final a in buildCommunicationSeed().announcements) a.id: a.readCount,
  };

  // ---- Comunicados ------------------------------------------------------

  late final _announcementSpec = MockListSpec<AnnouncementModel>(
    sortable: {
      'createdAt': (a) => a.createdAt,
      'title': (a) => foldText(a.title),
    },
    filterable: {
      'audience': (a) => a.audience.name,
      'status': (a) => a.status.name,
    },
    searchText: (a) => '${a.title} ${a.body}',
    defaultSort: const ['-createdAt'],
  );

  MockResponse _listAnnouncements(MockRequest req) => mockPaginate(
    _announcements.values.where((a) => a.deletedAt == null).map(_view),
    req,
    toJson: (a) => a.toJson(),
    spec: _announcementSpec,
  );

  AnnouncementModel _announcement(MockRequest req) {
    final a = _announcements[req.params['id']];
    if (a == null || a.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    return a;
  }

  static const _audiences = {'school', 'classroom', 'guardians'};
  static const _channels = {'in_app', 'push', 'sms', 'email'};

  /// Destinatários estimados por público (o servidor real resolve-os pela BD).
  static int _recipients(AnnouncementModel a) => switch (a.audience.name) {
    'school' => 480,
    'classroom' => 28,
    _ => a.classroomId == null ? 350 : 28,
  };

  void _validateAnnouncement(Map<String, dynamic> body) {
    final v = MockValidator(body)
      ..required('title')
      ..required('body')
      ..required('audience');
    v
      ..check(
        'audience',
        !body.containsKey('audience') || _audiences.contains(body['audience']),
        'Público inválido',
      )
      ..check(
        'classroomId',
        body['audience'] != 'classroom' ||
            '${body['classroomId'] ?? ''}'.isNotEmpty,
        'Indique a turma',
      )
      ..check(
        'channels',
        body['channels'] is! List ||
            (body['channels'] as List).every(_channels.contains),
        'Canal inválido',
      )
      ..throwIfInvalid();
  }

  MockResponse _createAnnouncement(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    _validateAnnouncement(body);
    final now = DateTime.now().toUtc();
    body
      ..putIfAbsent('id', _newId)
      ..putIfAbsent('institutionId', () => 'mock')
      ..['createdAt'] = now.toIso8601String()
      ..['updatedAt'] = now.toIso8601String()
      ..remove('readCount')
      ..remove('publishedAt');
    var a = AnnouncementModel.fromJson(body);
    if (_announcements.containsKey(a.id)) {
      throw const MockApiException.conflict('Identificador já existe');
    }
    a = a.copyWith(recipientCount: _recipients(a));
    _announcements[a.id] = a;
    if (a.status == AnnouncementStatus.published) a = _publish(a, now);
    return MockResponse.created(_view(a).toJson());
  }

  MockResponse _publishAnnouncement(MockRequest req) {
    final a = _announcement(req);
    if (a.status == AnnouncementStatus.published) {
      throw const MockApiException.conflict('O comunicado já está publicado');
    }
    return _ok(_publish(a, DateTime.now().toUtc()));
  }

  /// Marca como publicado e entrega pelos canais escolhidos.
  AnnouncementModel _publish(AnnouncementModel a, DateTime now) {
    final published = a.copyWith(
      status: AnnouncementStatus.published,
      publishedAt: now,
      updatedAt: now,
    );
    _announcements[a.id] = published;
    _dispatch(
      channels: [for (final c in a.channels) NotificationChannel.fromWire(c)],
      title: a.title,
      body: a.body,
      count: published.recipientCount,
    );
    return published;
  }

  MockResponse _confirmRead(MockRequest req) {
    final a = _announcement(req);
    final body = req.jsonBody;
    MockValidator(body)
      ..required('userId')
      ..throwIfInvalid();
    if (a.status != AnnouncementStatus.published) {
      throw const MockApiException.conflict('O comunicado não está publicado');
    }
    final userId = body['userId'] as String;
    final key = '${a.id}|$userId';
    _reads.putIfAbsent(a.id, () => {}).add(userId);
    final at = _readAt.putIfAbsent(key, () => DateTime.now().toUtc());
    return MockResponse.ok(
      AnnouncementReadModel(
        announcementId: a.id,
        userId: userId,
        readAt: at,
      ).toJson(),
    );
  }

  MockResponse _listReads(MockRequest req) {
    final a = _announcement(req);
    return MockResponse.ok([
      for (final userId in _reads[a.id] ?? const <String>{})
        AnnouncementReadModel(
          announcementId: a.id,
          userId: userId,
          readAt: _readAt['${a.id}|$userId']!,
        ).toJson(),
    ]);
  }

  // ---- Notificações -----------------------------------------------------

  MockResponse _sendNotification(MockRequest req) {
    final body = req.jsonBody;
    final v = MockValidator(body)
      ..required('sourceModule')
      ..required('title')
      ..required('body');
    final recipients = body['recipientIds'];
    final channels = body['channels'];
    v
      ..check(
        'recipientIds',
        recipients is List && recipients.isNotEmpty,
        'Indique pelo menos um destinatário',
      )
      ..check(
        'channels',
        channels is List &&
            channels.isNotEmpty &&
            channels.every(_channels.contains),
        'Indique canais válidos',
      )
      ..throwIfInvalid();
    final deliveries = _dispatch(
      channels: [
        for (final c in (channels as List).cast<String>())
          NotificationChannel.fromWire(c),
      ],
      title: body['title'] as String,
      body: body['body'] as String,
      count: (recipients as List).length,
    );
    return MockResponse.created({'id': _newId(), 'deliveries': deliveries});
  }

  List<Map<String, Object?>> _dispatch({
    required List<NotificationChannel> channels,
    required String title,
    required String body,
    required int count,
  }) => [
    for (final channel in channels)
      _deliver(adapters[channel]!, title, body, count),
  ];

  Map<String, Object?> _deliver(
    ChannelAdapter adapter,
    String title,
    String body,
    int count,
  ) {
    final r = adapter.deliver(title: title, body: body, recipientCount: count);
    return {
      'channel': adapter.channel.wire,
      'status': r.ok ? 'delivered' : 'failed',
      'count': r.count,
      'error': ?r.error,
    };
  }

  // ---- Agenda -----------------------------------------------------------

  MockResponse _listEvents(MockRequest req) {
    final errors = <String, String>{};
    DateTime? parse(String key) {
      final raw = req.query[key];
      if (raw == null) return null;
      final d = DateTime.tryParse(raw);
      if (d == null) errors[key] = 'Data inválida (ISO-8601)';
      return d?.toUtc();
    }

    final from = parse('from');
    final to = parse('to');
    if (errors.isNotEmpty) throw MockApiException.validation(errors);
    return mockPaginate(
      _events.values.where(
        (e) =>
            e.deletedAt == null &&
            (from == null || !e.startsAt.isBefore(from)) &&
            (to == null || e.startsAt.isBefore(to)),
      ),
      req,
      toJson: (e) => e.toJson(),
      spec: MockListSpec<AgendaEventModel>(
        sortable: {'startsAt': (e) => e.startsAt},
        filterable: {'type': (e) => e.type.name},
        defaultSort: const ['startsAt'],
      ),
    );
  }

  AgendaEventModel _event(MockRequest req) {
    final e = _events[req.params['id']];
    if (e == null || e.deletedAt != null) {
      throw const MockApiException.notFound();
    }
    return e;
  }

  void _validateEvent(Map<String, dynamic> body, {bool partial = false}) {
    final v = MockValidator(body);
    if (!partial) {
      v
        ..required('title')
        ..required('type')
        ..required('startsAt');
    }
    final starts = DateTime.tryParse('${body['startsAt']}');
    final ends = DateTime.tryParse('${body['endsAt']}');
    v
      ..check(
        'type',
        !body.containsKey('type') ||
            const {
              'holiday',
              'exam',
              'meeting',
              'deadline',
              'event',
            }.contains(body['type']),
        'Tipo inválido',
      )
      ..check(
        'endsAt',
        starts == null || ends == null || !ends.isBefore(starts),
        'O fim não pode ser anterior ao início',
      )
      ..throwIfInvalid();
  }

  MockResponse _createEvent(MockRequest req) {
    final body = Map<String, dynamic>.of(req.jsonBody);
    _validateEvent(body);
    final now = DateTime.now().toUtc().toIso8601String();
    body
      ..putIfAbsent('id', _newId)
      ..putIfAbsent('institutionId', () => 'mock')
      ..['createdAt'] = now
      ..['updatedAt'] = now;
    final e = AgendaEventModel.fromJson(body);
    if (_events.containsKey(e.id)) {
      throw const MockApiException.conflict('Identificador já existe');
    }
    _events[e.id] = e;
    return MockResponse.created(e.toJson());
  }

  MockResponse _updateEvent(MockRequest req) {
    final current = _event(req);
    final patch = req.jsonBody;
    _validateEvent(patch, partial: true);
    final updated = AgendaEventModel.fromJson({
      ...current.toJson(),
      ...patch,
      'id': current.id,
      'createdAt': current.createdAt.toIso8601String(),
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    });
    _events[current.id] = updated;
    return MockResponse.ok(updated.toJson());
  }

  MockResponse _deleteEvent(MockRequest req) {
    final e = _event(req);
    _events[e.id] = e.copyWith(deletedAt: DateTime.now().toUtc());
    return MockResponse.ok({'deleted': true});
  }

  int _seq = 0;
  String _newId() =>
      '01JMOCK${DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase().padLeft(9, '0')}${(_seq++).toString().padLeft(11, '0')}'
          .substring(0, 26);
}
