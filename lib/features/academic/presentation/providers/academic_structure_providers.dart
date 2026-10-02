import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../data/mock_api/academic_structure_mock_handlers.dart';
import '../../data/mock_api/teacher_mock_handlers.dart';
import '../../data/models/academic_models.dart';
import '../../data/models/classroom_models.dart';
import '../../data/models/teacher_models.dart';
import '../../data/repositories/api_academic_repositories.dart';
import '../../domain/academic_repositories.dart';

final levelRepositoryProvider = Provider<LevelRepository>(
  (ref) => apiLevelRepository(ref.watch(apiClientProvider)),
);
final gradeRepositoryProvider = Provider<GradeRepository>(
  (ref) => apiGradeRepository(ref.watch(apiClientProvider)),
);
final courseRepositoryProvider = Provider<CourseRepository>(
  (ref) => apiCourseRepository(ref.watch(apiClientProvider)),
);
final subjectRepositoryProvider = Provider<SubjectRepository>(
  (ref) => apiSubjectRepository(ref.watch(apiClientProvider)),
);
final curriculumRepositoryProvider = Provider<CurriculumRepository>(
  (ref) => apiCurriculumRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock da estrutura académica, registados em `main.dart` (só com mock activo).
final academicStructureMockHandlersProvider =
    Provider<AcademicStructureMockHandlers>(
      (ref) => AcademicStructureMockHandlers(),
    );

/// Percorre as páginas do servidor (as tabelas e os selectores são locais).
Future<List<T>> _fetchAll<T>(
  AcademicCrudRepository<T> repo, {
  Map<String, String> filters = const {},
}) async {
  final items = <T>[];
  var page = 1;
  while (true) {
    final PagedList<T> result = (await repo.list(
      page: page,
      filters: filters,
    )).getOrThrow();
    items.addAll(result.items);
    if (!result.meta.hasNext) return items;
    page++;
  }
}

final levelListProvider = FutureProvider.autoDispose<List<LevelModel>>(
  (ref) => _fetchAll(ref.watch(levelRepositoryProvider)),
  retry: (_, _) => null,
);

final gradeListProvider = FutureProvider.autoDispose<List<GradeModel>>(
  (ref) => _fetchAll(ref.watch(gradeRepositoryProvider)),
  retry: (_, _) => null,
);

final courseListProvider = FutureProvider.autoDispose<List<CourseModel>>(
  (ref) => _fetchAll(ref.watch(courseRepositoryProvider)),
  retry: (_, _) => null,
);

final subjectListProvider = FutureProvider.autoDispose<List<SubjectModel>>(
  (ref) => _fetchAll(ref.watch(subjectRepositoryProvider)),
  retry: (_, _) => null,
);

/// Currículo de um curso × classe (`courseId`, `gradeId`).
final curriculumProvider = FutureProvider.autoDispose
    .family<List<CurriculumItemModel>, ({String courseId, String gradeId})>(
      (ref, key) => _fetchAll(
        ref.watch(curriculumRepositoryProvider),
        filters: {'courseId': key.courseId, 'gradeId': key.gradeId},
      ),
      retry: (_, _) => null,
    );

final roomRepositoryProvider = Provider<RoomRepository>(
  (ref) => apiRoomRepository(ref.watch(apiClientProvider)),
);
final shiftRepositoryProvider = Provider<ShiftRepository>(
  (ref) => apiShiftRepository(ref.watch(apiClientProvider)),
);
final classroomRepositoryProvider = Provider<ClassroomRepository>(
  (ref) => apiClassroomRepository(ref.watch(apiClientProvider)),
);

final roomListProvider = FutureProvider.autoDispose<List<RoomModel>>(
  (ref) => _fetchAll(ref.watch(roomRepositoryProvider)),
  retry: (_, _) => null,
);

final shiftListProvider = FutureProvider.autoDispose<List<ShiftModel>>(
  (ref) => _fetchAll(ref.watch(shiftRepositoryProvider)),
  retry: (_, _) => null,
);

final classroomListProvider = FutureProvider.autoDispose<List<ClassroomModel>>(
  (ref) => _fetchAll(ref.watch(classroomRepositoryProvider)),
  retry: (_, _) => null,
);

final teacherRepositoryProvider = Provider<TeacherRepository>(
  (ref) => apiTeacherRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock dos professores, registados em `main.dart` (só com mock activo).
final teacherMockHandlersProvider = Provider<TeacherMockHandlers>(
  (ref) => TeacherMockHandlers(),
);

final teacherListProvider = FutureProvider.autoDispose<List<TeacherModel>>(
  (ref) => _fetchAll(ref.watch(teacherRepositoryProvider)),
  retry: (_, _) => null,
);
