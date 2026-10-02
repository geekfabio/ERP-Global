import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/assessment_scheme_repository.dart';
import '../models/assessment_scheme_model.dart';

class ApiAssessmentSchemeRepository implements AssessmentSchemeRepository {
  ApiAssessmentSchemeRepository(this._client);

  final ApiClient _client;

  static const _path = '/v1/assessment-schemes';

  @override
  Future<Result<PagedList<AssessmentSchemeModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? gradeId,
    String? courseId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      _path,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[gradeId]': ?gradeId,
        'filter[courseId]': ?courseId,
      },
    );
    return ApiEnvelope.page(response, AssessmentSchemeModel.fromJson);
  });

  @override
  Future<Result<AssessmentSchemeModel>> create(AssessmentSchemeModel value) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.post<dynamic>(_path, data: value.toJson()),
          AssessmentSchemeModel.fromJson,
        ),
      );

  @override
  Future<Result<AssessmentSchemeModel>> update(
    String id,
    AssessmentSchemeModel value,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.patch<dynamic>('$_path/$id', data: value.toJson()),
      AssessmentSchemeModel.fromJson,
    ),
  );

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('$_path/$id'));
}
