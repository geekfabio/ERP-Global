import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/academic_repositories.dart';
import '../models/academic_models.dart';
import '../models/assignment_models.dart';
import '../models/classroom_models.dart';
import '../models/schedule_models.dart';
import '../models/teacher_models.dart';

/// Repository genérico sobre um recurso REST (`/v1/<path>`).
class ApiAcademicRepository<T> implements AcademicCrudRepository<T> {
  ApiAcademicRepository(
    this._client,
    this._path, {
    required this.fromJson,
    required this.toJson,
  });

  final ApiClient _client;
  final String _path;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  @override
  Future<Result<PagedList<T>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
    Map<String, String> filters = const {},
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      _path,
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        for (final e in filters.entries) 'filter[${e.key}]': e.value,
      },
    );
    return ApiEnvelope.page(response, fromJson);
  });

  Future<Result<T>> _send(String method, String path, Map<String, dynamic> d) =>
      Result.guard(() async {
        final response = await _client.dio.request<dynamic>(
          path,
          data: d,
          options: Options(method: method),
        );
        return ApiEnvelope.object(response, fromJson);
      });

  @override
  Future<Result<T>> create(T value) => _send('POST', _path, toJson(value));

  @override
  Future<Result<T>> update(String id, T value) =>
      _send('PATCH', '$_path/$id', toJson(value));

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('$_path/$id'));
}

LevelRepository apiLevelRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/levels',
  fromJson: LevelModel.fromJson,
  toJson: (v) => v.toJson(),
);

GradeRepository apiGradeRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/grades',
  fromJson: GradeModel.fromJson,
  toJson: (v) => v.toJson(),
);

CourseRepository apiCourseRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/courses',
  fromJson: CourseModel.fromJson,
  toJson: (v) => v.toJson(),
);

SubjectRepository apiSubjectRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/subjects',
  fromJson: SubjectModel.fromJson,
  toJson: (v) => v.toJson(),
);

CurriculumRepository apiCurriculumRepository(ApiClient c) =>
    ApiAcademicRepository(
      c,
      '/v1/curriculum-items',
      fromJson: CurriculumItemModel.fromJson,
      toJson: (v) => v.toJson(),
    );

RoomRepository apiRoomRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/rooms',
  fromJson: RoomModel.fromJson,
  toJson: (v) => v.toJson(),
);

ShiftRepository apiShiftRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/shifts',
  fromJson: ShiftModel.fromJson,
  toJson: (v) => v.toJson(),
);

ClassroomRepository apiClassroomRepository(ApiClient c) =>
    ApiAcademicRepository(
      c,
      '/v1/classrooms',
      fromJson: ClassroomModel.fromJson,
      toJson: (v) => v.toJson(),
    );

TeacherRepository apiTeacherRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/teachers',
  fromJson: TeacherModel.fromJson,
  toJson: (v) => v.toJson(),
);

TeachingAssignmentRepository apiTeachingAssignmentRepository(ApiClient c) =>
    ApiAcademicRepository(
      c,
      '/v1/teaching-assignments',
      fromJson: TeachingAssignmentModel.fromJson,
      toJson: (v) => v.toJson(),
    );

HomeroomRepository apiHomeroomRepository(ApiClient c) => ApiAcademicRepository(
  c,
  '/v1/homerooms',
  fromJson: HomeroomModel.fromJson,
  toJson: (v) => v.toJson(),
);

ScheduleSlotRepository apiScheduleSlotRepository(ApiClient c) =>
    ApiAcademicRepository(
      c,
      '/v1/schedule-slots',
      fromJson: ScheduleSlotModel.fromJson,
      toJson: (v) => v.toJson(),
    );
