import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/notifications/notification_service.dart';
import '../../domain/communication_repositories.dart';
import '../models/agenda_event_model.dart';
import '../models/announcement_model.dart';
import '../models/communication_enums.dart';

class ApiAnnouncementRepository implements AnnouncementRepository {
  ApiAnnouncementRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AnnouncementModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    AnnouncementAudience? audience,
    AnnouncementStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/announcements',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        if (audience != null) 'filter[audience]': audience.name,
        if (status != null) 'filter[status]': status.name,
      },
    );
    return ApiEnvelope.page(response, AnnouncementModel.fromJson);
  });

  @override
  Future<Result<AnnouncementModel>> get(String id) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/announcements/$id');
    return ApiEnvelope.object(response, AnnouncementModel.fromJson);
  });

  @override
  Future<Result<AnnouncementModel>> create(AnnouncementModel announcement) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/announcements',
          data: announcement.toJson(),
        );
        return ApiEnvelope.object(response, AnnouncementModel.fromJson);
      });

  @override
  Future<Result<AnnouncementModel>> publish(String id) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/announcements/$id/publish',
        );
        return ApiEnvelope.object(response, AnnouncementModel.fromJson);
      });

  @override
  Future<Result<AnnouncementReadModel>> confirmRead(
    String id, {
    required String userId,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/announcements/$id/read',
      data: {'userId': userId},
    );
    return ApiEnvelope.object(response, AnnouncementReadModel.fromJson);
  });

  @override
  Future<Result<List<AnnouncementReadModel>>> reads(String id) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/announcements/$id/reads',
        );
        return [
          for (final r in (ApiEnvelope.data(response)! as List))
            AnnouncementReadModel.fromJson(r as Map<String, dynamic>),
        ];
      });
}

class ApiAgendaRepository implements AgendaRepository {
  ApiAgendaRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AgendaEventModel>>> list({
    int page = 1,
    int pageSize = 50,
    DateTime? from,
    DateTime? to,
    AgendaEventType? type,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/agenda-events',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
        if (type != null) 'filter[type]': type.name,
      },
    );
    return ApiEnvelope.page(response, AgendaEventModel.fromJson);
  });

  @override
  Future<Result<AgendaEventModel>> create(AgendaEventModel event) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/agenda-events',
          data: event.toJson(),
        );
        return ApiEnvelope.object(response, AgendaEventModel.fromJson);
      });

  @override
  Future<Result<AgendaEventModel>> update(AgendaEventModel event) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/agenda-events/${event.id}',
          data: event.toJson(),
        );
        return ApiEnvelope.object(response, AgendaEventModel.fromJson);
      });

  @override
  Future<Result<void>> delete(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/agenda-events/$id');
  });
}

/// Implementação do contrato `core` [NotificationService] sobre a API.
class ApiNotificationService implements NotificationService {
  ApiNotificationService(this._client);

  final ApiClient _client;

  @override
  Future<Result<NotificationReceipt>> send(NotificationRequest request) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/notifications',
          data: request.toJson(),
        );
        return ApiEnvelope.object(response, NotificationReceipt.fromJson);
      });
}
