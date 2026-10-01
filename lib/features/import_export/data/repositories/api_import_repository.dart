import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/import_repository.dart';

class ApiImportRepository implements ImportRepository {
  ApiImportRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<ImportCommitResult>> commit(
    String entity,
    List<Map<String, Object?>> records,
  ) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/imports/$entity',
      data: {'records': records},
    );
    return ApiEnvelope.object(response, (json) {
      final rejected = (json['rejected'] as List).cast<Map<String, dynamic>>();
      return ImportCommitResult(
        imported: json['imported'] as int,
        rejected: [
          for (final r in rejected)
            ImportRejection(
              index: r['index'] as int,
              errors: (r['errors'] as Map).map(
                (k, v) => MapEntry(k as String, v.toString()),
              ),
            ),
        ],
      );
    });
  });
}
