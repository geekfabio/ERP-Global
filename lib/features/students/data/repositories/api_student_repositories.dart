import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/student_repositories.dart';
import '../models/enrollment_model.dart';
import '../models/guardian_model.dart';
import '../models/student_enums.dart';
import '../models/student_model.dart';

/// `snake_case` como no JSON (`newEnrollment` → `new_enrollment`).
String _wire(Enum e) =>
    e.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

class ApiStudentRepository implements StudentRepository {
  ApiStudentRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<StudentModel>>> list(StudentQuery q) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/students',
          queryParameters: {
            'page': q.page,
            'pageSize': q.pageSize,
            if (q.q != null && q.q!.trim().isNotEmpty) 'q': q.q!.trim(),
            if (q.status != null) 'filter[status]': _wire(q.status!),
            if (q.gender != null) 'filter[gender]': _wire(q.gender!),
            if (q.gradeId != null) 'filter[gradeId]': q.gradeId,
            if (q.classroomId != null) 'filter[classroomId]': q.classroomId,
            if (q.sort.isNotEmpty) 'sort': q.sort.join(','),
          },
        );
        return ApiEnvelope.page(response, StudentModel.fromJson);
      });

  @override
  Future<Result<StudentModel>> get(String id) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/students/$id');
    return ApiEnvelope.object(response, StudentModel.fromJson);
  });

  @override
  Future<Result<StudentModel>> create(StudentModel student) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/students',
          data: student.toJson(),
        );
        return ApiEnvelope.object(response, StudentModel.fromJson);
      });

  @override
  Future<Result<StudentModel>> update(StudentModel student) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/students/${student.id}',
          data: student.toJson(),
        );
        return ApiEnvelope.object(response, StudentModel.fromJson);
      });

  @override
  Future<Result<void>> delete(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/students/$id');
  });
}

class ApiGuardianRepository implements GuardianRepository {
  ApiGuardianRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<GuardianModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/guardians',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
      },
    );
    return ApiEnvelope.page(response, GuardianModel.fromJson);
  });

  @override
  Future<Result<GuardianModel>> create(GuardianModel guardian) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/guardians',
          data: guardian.toJson(),
        );
        return ApiEnvelope.object(response, GuardianModel.fromJson);
      });

  @override
  Future<Result<List<StudentGuardian>>> forStudent(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/students/$studentId/guardians',
        );
        final data = ApiEnvelope.data(response)! as List;
        return [
          for (final item in data.cast<Map<String, dynamic>>())
            StudentGuardian(
              guardian: GuardianModel.fromJson(
                item['guardian'] as Map<String, dynamic>,
              ),
              link: GuardianLinkModel.fromJson(
                item['link'] as Map<String, dynamic>,
              ),
            ),
        ];
      });

  @override
  Future<Result<GuardianLinkModel>> link(GuardianLinkModel link) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/guardian-links',
          data: link.toJson(),
        );
        return ApiEnvelope.object(response, GuardianLinkModel.fromJson);
      });

  @override
  Future<Result<void>> unlink(String linkId) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/guardian-links/$linkId');
  });
}

class ApiEnrollmentRepository implements EnrollmentRepository {
  ApiEnrollmentRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<EnrollmentModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    String? academicYearId,
    String? gradeId,
    EnrollmentStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/enrollments',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        'filter[academicYearId]': ?academicYearId,
        'filter[gradeId]': ?gradeId,
        if (status != null) 'filter[status]': _wire(status),
      },
    );
    return ApiEnvelope.page(response, EnrollmentModel.fromJson);
  });

  @override
  Future<Result<EnrollmentModel>> create(EnrollmentModel enrollment) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/enrollments',
          data: enrollment.toJson(),
        );
        return ApiEnvelope.object(response, EnrollmentModel.fromJson);
      });

  @override
  Future<Result<EnrollmentModel>> update(EnrollmentModel enrollment) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/enrollments/${enrollment.id}',
          data: enrollment.toJson(),
        );
        return ApiEnvelope.object(response, EnrollmentModel.fromJson);
      });
}
