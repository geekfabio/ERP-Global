import '../errors/result.dart';
import '../network/api_client.dart';
import '../network/api_envelope.dart';
import 'audit_log_model.dart';
import 'audit_repository.dart';

class ApiAuditRepository implements AuditRepository {
  ApiAuditRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AuditLogModel>>> list(AuditQuery q) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/audit-logs',
          queryParameters: {
            'page': q.page,
            'pageSize': q.pageSize,
            if (q.q != null && q.q!.trim().isNotEmpty) 'q': q.q!.trim(),
            if (q.entity != null) 'filter[entity]': q.entity,
            if (q.action != null) 'filter[action]': q.action!.name,
            if (q.actorId != null) 'filter[actorId]': q.actorId,
            if (q.from != null) 'from': q.from!.toUtc().toIso8601String(),
            if (q.to != null) 'to': q.to!.toUtc().toIso8601String(),
          },
        );
        return ApiEnvelope.page(response, AuditLogModel.fromJson);
      });

  @override
  Future<Result<AuditLogModel>> record(AuditLogModel entry) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/audit-logs',
          data: entry.toJson(),
        );
        return ApiEnvelope.object(response, AuditLogModel.fromJson);
      });
}
