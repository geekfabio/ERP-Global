import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/grade_entry_repository.dart';
import '../models/grade_sheet_models.dart';

class ApiGradeEntryRepository implements GradeEntryRepository {
  ApiGradeEntryRepository(this._client);

  final ApiClient _client;

  static const _path = '/v1/grade-sheets';

  @override
  Future<Result<GradeSheetModel>> sheet(GradeSheetKey key) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>(_path, queryParameters: key.toJson()),
      GradeSheetModel.fromJson,
    ),
  );

  @override
  Future<Result<GradeSheetModel>> save(
    GradeSheetKey key,
    List<GradeRowModel> rows, {
    String? justification,
  }) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>(
        _path,
        data: {
          ...key.toJson(),
          'justification': ?justification,
          'rows': [for (final r in rows) r.toJson()],
        },
      ),
      GradeSheetModel.fromJson,
    ),
  );

  @override
  Future<Result<List<GradeChangeModel>>> changes(GradeSheetKey key) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '$_path/changes',
          queryParameters: {'pageSize': 100, ...key.toJson()},
        );
        return ApiEnvelope.page(response, GradeChangeModel.fromJson).items;
      });
}
