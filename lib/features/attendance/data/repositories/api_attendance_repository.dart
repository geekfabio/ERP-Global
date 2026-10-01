import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/attendance_repository.dart';
import '../models/attendance_models.dart';

class ApiAttendanceRepository implements AttendanceRepository {
  ApiAttendanceRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<AttendanceSheetModel>> sheet(AttendanceSheetKey key) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.get<dynamic>(
            '/v1/attendance-sheets',
            queryParameters: key.toJson(),
          ),
          AttendanceSheetModel.fromJson,
        ),
      );

  @override
  Future<Result<AttendanceSheetModel>> save(
    AttendanceSheetKey key,
    List<AttendanceRecordModel> rows,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>(
        '/v1/attendance-sheets',
        data: {
          ...key.toJson(),
          'rows': [for (final r in rows) r.toJson()],
        },
      ),
      AttendanceSheetModel.fromJson,
    ),
  );

  @override
  Future<Result<PagedList<AttendanceRecordModel>>> records({
    int page = 1,
    int pageSize = 100,
    String? classroomId,
    String? studentId,
    AttendanceStatus? status,
  }) => Result.guard(
    () async => ApiEnvelope.page(
      await _client.dio.get<dynamic>(
        '/v1/attendance-records',
        queryParameters: {
          'page': page,
          'pageSize': pageSize,
          'filter[classroomId]': ?classroomId,
          'filter[studentId]': ?studentId,
          'filter[status]': ?status?.name,
        },
      ),
      AttendanceRecordModel.fromJson,
    ),
  );

  @override
  Future<Result<AttendanceRecordModel>> justify(String id, String reason) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.request<dynamic>(
            '/v1/attendance-records/$id/justification',
            data: {'reason': reason},
            options: Options(method: 'PUT'),
          ),
          AttendanceRecordModel.fromJson,
        ),
      );

  @override
  Future<Result<AttendanceSettingsModel>> settings() => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>('/v1/attendance-settings'),
      AttendanceSettingsModel.fromJson,
    ),
  );

  @override
  Future<Result<AttendanceSettingsModel>> updateSettings(
    AttendanceSettingsModel settings,
  ) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.put<dynamic>(
        '/v1/attendance-settings',
        data: settings.toJson(),
      ),
      AttendanceSettingsModel.fromJson,
    ),
  );

  @override
  Future<Result<List<AttendanceAlertModel>>> alerts({String? classroomId}) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/attendance-alerts',
          queryParameters: {
            'pageSize': 100,
            'filter[classroomId]': ?classroomId,
          },
        );
        return ApiEnvelope.page(response, AttendanceAlertModel.fromJson).items;
      });
}
