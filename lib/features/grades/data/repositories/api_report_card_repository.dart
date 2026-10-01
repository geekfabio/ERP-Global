import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/report_card_repository.dart';
import '../models/report_card_models.dart';

class ApiReportCardRepository implements ReportCardRepository {
  ApiReportCardRepository(this._client);

  final ApiClient _client;

  static const _path = '/v1/report-cards';

  @override
  Future<Result<ReportCardStateModel>> state(String studentId, String termId) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.get<dynamic>(
            _path,
            queryParameters: {'studentId': studentId, 'termId': termId},
          ),
          ReportCardStateModel.fromJson,
        ),
      );

  @override
  Future<Result<ReportCardStateModel>> saveRemarks(
    String studentId,
    String termId,
    String remarks,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>(
        '$_path/remarks',
        data: {'studentId': studentId, 'termId': termId, 'remarks': remarks},
      ),
      ReportCardStateModel.fromJson,
    ),
  );

  @override
  Future<Result<ReportCardStateModel>> send(
    String studentId,
    String termId,
    List<String> guardianIds,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>(
        '$_path/send',
        data: {
          'studentId': studentId,
          'termId': termId,
          'guardianIds': guardianIds,
        },
      ),
      ReportCardStateModel.fromJson,
    ),
  );
}
