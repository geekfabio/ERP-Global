import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/council_repository.dart';
import '../models/council_models.dart';

class ApiCouncilRepository implements CouncilRepository {
  ApiCouncilRepository(this._client);

  final ApiClient _client;

  static const _path = '/v1/class-councils';

  @override
  Future<Result<CouncilModel>> council(String classroomId, String yearId) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.get<dynamic>(
            _path,
            queryParameters: {'classroomId': classroomId, 'yearId': yearId},
          ),
          CouncilModel.fromJson,
        ),
      );

  @override
  Future<Result<CouncilModel>> decide(
    String classroomId,
    String yearId, {
    required String studentId,
    required FinalResult result,
    required String justification,
  }) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>(
        '$_path/decisions',
        data: {
          'classroomId': classroomId,
          'yearId': yearId,
          'studentId': studentId,
          'result': result.name,
          'justification': justification,
        },
      ),
      CouncilModel.fromJson,
    ),
  );

  @override
  Future<Result<CouncilModel>> approve(
    String classroomId,
    String yearId,
    Map<String, FinalResult> results,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        '$_path/approve',
        data: {
          'classroomId': classroomId,
          'yearId': yearId,
          'results': {for (final e in results.entries) e.key: e.value.name},
        },
      ),
      CouncilModel.fromJson,
    ),
  );
}
