import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/student_duplicates.dart';
import '../../domain/student_repositories.dart';
import '../models/enrollment_model.dart';
import '../models/guardian_model.dart';
import '../models/student_document_model.dart';
import '../models/student_enums.dart';
import '../models/student_model.dart';
import '../models/student_occurrence_model.dart';

/// `snake_case` como no JSON (`newEnrollment` → `new_enrollment`).
String _wire(Enum e) =>
    e.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

List<T> _list<T>(
  Response<dynamic> response,
  T Function(Map<String, dynamic>) fromJson,
) => [
  for (final item in (ApiEnvelope.data(response)! as List))
    fromJson(item as Map<String, dynamic>),
];

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
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/students',
      queryParameters: {if (confirmDuplicate) 'confirmDuplicate': true},
      data: student.toJson(),
    );
    return ApiEnvelope.object(response, StudentModel.fromJson);
  });

  @override
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/students/duplicates',
      queryParameters: {
        'fullName': fullName,
        'birthDate': birthDate.toIso8601String().substring(0, 10),
        if (idNumber != null && idNumber.trim().isNotEmpty)
          'idNumber': idNumber.trim(),
      },
    );
    final data = ApiEnvelope.data(response)! as List;
    return [
      for (final item in data.cast<Map<String, dynamic>>())
        StudentDuplicate(
          student: StudentModel.fromJson(
            item['student'] as Map<String, dynamic>,
          ),
          reason: item['reason'] == 'id_number'
              ? DuplicateReason.idNumber
              : DuplicateReason.nameAndBirth,
        ),
    ];
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
  Future<Result<GuardianLinkModel>> updateLink(GuardianLinkModel link) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/guardian-links/${link.id}',
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

class ApiStudentDocumentRepository implements StudentDocumentRepository {
  ApiStudentDocumentRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<StudentDocumentModel>>> forStudent(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/students/$studentId/documents',
        );
        return _list(response, StudentDocumentModel.fromJson);
      });

  @override
  Future<Result<StudentDocumentModel>> create(StudentDocumentModel document) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/student-documents',
          data: document.toJson(),
        );
        return ApiEnvelope.object(response, StudentDocumentModel.fromJson);
      });

  @override
  Future<Result<StudentDocumentModel>> update(StudentDocumentModel document) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/student-documents/${document.id}',
          data: document.toJson(),
        );
        return ApiEnvelope.object(response, StudentDocumentModel.fromJson);
      });

  @override
  Future<Result<void>> delete(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/student-documents/$id');
  });
}

class ApiOccurrenceRepository implements OccurrenceRepository {
  ApiOccurrenceRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<StudentOccurrenceModel>>> forStudent(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/students/$studentId/occurrences',
        );
        return _list(response, StudentOccurrenceModel.fromJson);
      });

  @override
  Future<Result<StudentOccurrenceModel>> create(
    StudentOccurrenceModel occurrence,
  ) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/student-occurrences',
      data: occurrence.toJson(),
    );
    return ApiEnvelope.object(response, StudentOccurrenceModel.fromJson);
  });

  @override
  Future<Result<void>> delete(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/student-occurrences/$id');
  });
}
