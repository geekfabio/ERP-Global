import '../errors/result.dart';
import '../network/api_client.dart';
import '../network/api_envelope.dart';
import 'sync_models.dart';
import 'sync_repository.dart';

/// [SyncRepository] sobre a API (`POST /v1/sync/push`, `GET /v1/sync/{entity}/{id}`).
class ApiSyncRepository implements SyncRepository {
  ApiSyncRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PushResult>> push(OutboxBatch batch) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/sync/push',
      data: {
        'entity': batch.entity,
        'entityId': batch.entityId,
        'operation': batch.operation.name,
        'payload': batch.payload,
        'baseUpdatedAt': batch.baseUpdatedAt,
      },
    );
    final data = ApiEnvelope.data(response);
    final record = data is Map<String, dynamic> ? data['record'] : null;
    return PushResult(record: record is Map<String, dynamic> ? record : null);
  });

  @override
  Future<Result<Map<String, dynamic>>> fetch(String entity, String entityId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/sync/$entity/$entityId',
        );
        return ApiEnvelope.object(response, (json) => json);
      });
}
