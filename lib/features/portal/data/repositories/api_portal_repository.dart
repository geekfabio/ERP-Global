import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/portal_repository.dart';
import '../models/portal_models.dart';

class ApiPortalRepository implements PortalRepository {
  ApiPortalRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<PortalPupil>>> pupils() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/portal/pupils');
    final data = ApiEnvelope.data(response)! as List;
    return [
      for (final item in data.cast<Map<String, dynamic>>())
        PortalPupil.fromJson(item),
    ];
  });

  @override
  Future<Result<PortalSummary>> summary(
    String studentId, {
    required Set<String> modules,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/portal/pupils/$studentId/summary',
      queryParameters: {'modules': (modules.toList()..sort()).join(',')},
    );
    return ApiEnvelope.object(response, PortalSummary.fromJson);
  });
}
