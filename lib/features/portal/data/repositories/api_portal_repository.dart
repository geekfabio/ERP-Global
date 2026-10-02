import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../domain/portal_repository.dart';
import '../models/portal_academic_models.dart';
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

  String _base(String studentId) => '/v1/portal/pupils/$studentId';

  Future<List<T>> _list<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final response = await _client.dio.get<dynamic>(path);
    final data = ApiEnvelope.data(response)! as List;
    return [
      for (final item in data.cast<Map<String, dynamic>>()) fromJson(item),
    ];
  }

  @override
  Future<Result<StudentGradesSummary>> grades(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '${_base(studentId)}/grades',
        );
        return ApiEnvelope.object(response, StudentGradesSummary.fromJson);
      });

  @override
  Future<Result<StudentAttendanceSummary>> attendance(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '${_base(studentId)}/attendance',
        );
        return ApiEnvelope.object(response, StudentAttendanceSummary.fromJson);
      });

  @override
  Future<Result<List<PortalScheduleSlot>>> schedule(String studentId) =>
      Result.guard(
        () =>
            _list('${_base(studentId)}/schedule', PortalScheduleSlot.fromJson),
      );

  @override
  Future<Result<List<AbsenceJustificationRequest>>> justifications(
    String studentId,
  ) => Result.guard(
    () => _list(
      '${_base(studentId)}/absence-justifications',
      AbsenceJustificationRequest.fromJson,
    ),
  );

  @override
  Future<Result<AbsenceJustificationRequest>> requestJustification(
    String studentId, {
    required DateTime date,
    required String reason,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '${_base(studentId)}/absence-justifications',
      data: {'date': date.toIso8601String().substring(0, 10), 'reason': reason},
    );
    return ApiEnvelope.object(response, AbsenceJustificationRequest.fromJson);
  });

  @override
  Future<Result<List<PortalDocumentRequest>>> documentRequests(
    String studentId,
  ) => Result.guard(
    () => _list(
      '${_base(studentId)}/document-requests',
      PortalDocumentRequest.fromJson,
    ),
  );

  @override
  Future<Result<PortalDocumentRequest>> requestDocument(
    String studentId, {
    required PortalDocumentKind kind,
    String? notes,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '${_base(studentId)}/document-requests',
      data: {'kind': kind.code, 'notes': ?notes},
    );
    return ApiEnvelope.object(response, PortalDocumentRequest.fromJson);
  });
}
