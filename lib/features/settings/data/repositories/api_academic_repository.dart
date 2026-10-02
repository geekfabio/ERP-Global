import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/academic_repository.dart';
import '../models/academic_year_model.dart';
import '../models/term_model.dart';

class ApiAcademicRepository implements AcademicRepository {
  ApiAcademicRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AcademicYearModel>>> years({
    int page = 1,
    int pageSize = 100,
  }) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        '/v1/academic-years',
        queryParameters: {'page': page, 'pageSize': pageSize, 'sort': '-code'},
      ),
      AcademicYearModel.fromJson,
    ),
  );

  @override
  Future<Result<AcademicYearModel>> createYear(Map<String, dynamic> values) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.post<dynamic>('/v1/academic-years', data: values),
          AcademicYearModel.fromJson,
        ),
      );

  @override
  Future<Result<AcademicYearModel>> updateYear(
    String id,
    Map<String, dynamic> values,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.patch<dynamic>('/v1/academic-years/$id', data: values),
      AcademicYearModel.fromJson,
    ),
  );

  @override
  Future<Result<AcademicYearModel>> transitionYear(
    String id,
    AcademicYearStatus to,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        '/v1/academic-years/$id/transition',
        data: {'to': to.name},
      ),
      AcademicYearModel.fromJson,
    ),
  );

  @override
  Future<Result<List<TermModel>>> terms(String yearId) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        '/v1/academic-years/$yearId/terms',
        queryParameters: {'pageSize': 100, 'sort': 'order'},
      ),
      TermModel.fromJson,
    ).items,
  );

  @override
  Future<Result<TermModel>> updateTerm(
    String id,
    Map<String, dynamic> values,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.patch<dynamic>('/v1/terms/$id', data: values),
      TermModel.fromJson,
    ),
  );

  @override
  Future<Result<TermModel>> openTerm(String id) => _action(id, 'open');

  @override
  Future<Result<TermModel>> closeTerm(String id) => _action(id, 'close');

  Future<Result<TermModel>> _action(String id, String action) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('/v1/terms/$id/$action'),
      TermModel.fromJson,
    ),
  );
}
