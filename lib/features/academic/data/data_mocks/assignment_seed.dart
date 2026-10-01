import '../../domain/assignment_rules.dart';
import '../models/assignment_models.dart';
import '../models/teacher_models.dart';
import 'academic_seed.dart';
import 'classroom_seed.dart';

class AssignmentSeed {
  const AssignmentSeed({required this.assignments, required this.homerooms});

  final List<TeachingAssignmentModel> assignments;
  final List<HomeroomModel> homerooms;
}

String _id(String prefix, int n) =>
    '01J$prefix${n.toString().padLeft(4, '0')}'.padRight(26, '0');

/// Atribuições determinísticas: por cada turma, as disciplinas do currículo
/// ficam com um professor activo que a lecciona e tem carga livre (carga
/// semanal ≤ [kMaxTeacherWeeklyHours]); algumas ficam por atribuir.
/// Cada turma tem director (o titular da primeira disciplina atribuída).
AssignmentSeed buildAssignmentSeed({
  required AcademicSeed academic,
  required ClassroomSeed classrooms,
  required List<TeacherModel> teachers,
}) {
  final load = <String, int>{};
  final assignments = <TeachingAssignmentModel>[];
  final homerooms = <HomeroomModel>[];
  var n = 0;
  var cursor = 0;
  for (final classroom in classrooms.classrooms) {
    final items = academic.curriculum.where(
      (c) => c.courseId == classroom.courseId && c.gradeId == classroom.gradeId,
    );
    String? homeroom;
    for (final item in items) {
      final candidates = teachers
          .where((t) => t.isActive && t.subjectIds.contains(item.subjectId))
          .toList();
      if (candidates.isEmpty) continue;
      for (var k = 0; k < candidates.length; k++) {
        final teacher = candidates[(cursor + k) % candidates.length];
        if ((load[teacher.id] ?? 0) + item.weeklyHours >
            kMaxTeacherWeeklyHours) {
          continue;
        }
        load[teacher.id] = (load[teacher.id] ?? 0) + item.weeklyHours;
        n++;
        assignments.add(
          TeachingAssignmentModel(
            id: _id('ATRI', n),
            academicYearId: classroom.academicYearId,
            teacherId: teacher.id,
            classroomId: classroom.id,
            subjectId: item.subjectId,
            weeklyHours: item.weeklyHours,
          ),
        );
        homeroom ??= teacher.id;
        break;
      }
      cursor++;
    }
    if (homeroom != null) {
      homerooms.add(
        HomeroomModel(
          id: _id('DIRT', homerooms.length + 1),
          classroomId: classroom.id,
          teacherId: homeroom,
        ),
      );
    }
  }
  return AssignmentSeed(assignments: assignments, homerooms: homerooms);
}
