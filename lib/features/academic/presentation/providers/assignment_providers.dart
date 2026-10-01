import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../data/mock_api/assignment_mock_handlers.dart';
import '../../data/models/academic_models.dart';
import '../../data/models/assignment_models.dart';
import '../../data/models/classroom_models.dart';
import '../../data/models/teacher_models.dart';
import '../../data/repositories/api_academic_repositories.dart';
import '../../domain/academic_repositories.dart';
import 'academic_structure_providers.dart';

final teachingAssignmentRepositoryProvider =
    Provider<TeachingAssignmentRepository>(
      (ref) => apiTeachingAssignmentRepository(ref.watch(apiClientProvider)),
    );

final homeroomRepositoryProvider = Provider<HomeroomRepository>(
  (ref) => apiHomeroomRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock das atribuições, registados em `main.dart` (só com mock activo).
final assignmentMockHandlersProvider = Provider<AssignmentMockHandlers>(
  (ref) => AssignmentMockHandlers(),
);

Future<List<T>> _all<T>(
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

final assignmentListProvider =
    FutureProvider.autoDispose<List<TeachingAssignmentModel>>(
      (ref) => _all(ref.watch(teachingAssignmentRepositoryProvider)),
      retry: (_, _) => null,
    );

final homeroomListProvider = FutureProvider.autoDispose<List<HomeroomModel>>(
  (ref) => _all(ref.watch(homeroomRepositoryProvider)),
  retry: (_, _) => null,
);

/// Todo o currículo (para saber que disciplinas cada turma tem).
final curriculumAllProvider =
    FutureProvider.autoDispose<List<CurriculumItemModel>>(
      (ref) => _all(ref.watch(curriculumRepositoryProvider)),
      retry: (_, _) => null,
    );

/// Professor correspondente à sessão (mesmo email), ou `null`.
final myTeacherProvider = FutureProvider.autoDispose<TeacherModel?>((
  ref,
) async {
  final email = ref.watch(currentSessionProvider)?.user.email?.toLowerCase();
  if (email == null || email.isEmpty) return null;
  final page = (await ref.watch(teacherRepositoryProvider).list(q: email))
      .getOrThrow();
  for (final t in page.items) {
    if (t.email.toLowerCase() == email) return t;
  }
  return null;
}, retry: (_, _) => null);

/// Uma turma do professor: disciplinas que lecciona nela e se é director.
class MyClassroom {
  const MyClassroom({
    required this.classroom,
    required this.assignments,
    required this.isHomeroom,
  });

  final ClassroomModel classroom;
  final List<TeachingAssignmentModel> assignments;
  final bool isHomeroom;
}

/// Turmas de [teacherId]: onde lecciona ou é director (nenhuma de outros).
List<MyClassroom> buildMyClassrooms({
  required String teacherId,
  required List<TeachingAssignmentModel> assignments,
  required List<HomeroomModel> homerooms,
  required List<ClassroomModel> classrooms,
}) {
  final mine = assignments.where((a) => a.teacherId == teacherId);
  final homeroomOf = {
    for (final h in homerooms)
      if (h.teacherId == teacherId) h.classroomId,
  };
  return [
    for (final c in classrooms)
      if (homeroomOf.contains(c.id) || mine.any((a) => a.classroomId == c.id))
        MyClassroom(
          classroom: c,
          assignments: mine.where((a) => a.classroomId == c.id).toList(),
          isHomeroom: homeroomOf.contains(c.id),
        ),
  ];
}

/// "As minhas turmas": o servidor filtra por `teacherId`, por isso o professor
/// só obtém as suas atribuições.
final myClassroomsProvider = FutureProvider.autoDispose<List<MyClassroom>>((
  ref,
) async {
  final teacher = await ref.watch(myTeacherProvider.future);
  if (teacher == null) return const [];
  final assignments = await _all(
    ref.watch(teachingAssignmentRepositoryProvider),
    filters: {'teacherId': teacher.id},
  );
  final homerooms = await _all(
    ref.watch(homeroomRepositoryProvider),
    filters: {'teacherId': teacher.id},
  );
  final classrooms = await ref.watch(classroomListProvider.future);
  return buildMyClassrooms(
    teacherId: teacher.id,
    assignments: assignments,
    homerooms: homerooms,
    classrooms: classrooms,
  );
}, retry: (_, _) => null);
