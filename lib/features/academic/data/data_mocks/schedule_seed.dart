import '../../domain/schedule_rules.dart';
import '../models/assignment_models.dart';
import '../models/schedule_models.dart';
import 'classroom_seed.dart';

String _id(int n) => '01JHORA${n.toString().padLeft(4, '0')}'.padRight(26, '0');

String _hhmm(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

/// Horário determinístico sem conflitos: cada hora semanal de uma atribuição
/// titular (limitada a 4 aulas por disciplina) ocupa a primeira janela livre
/// de 1 h no turno da turma, de segunda a sexta.
List<ScheduleSlotModel> buildScheduleSeed({
  required ClassroomSeed classrooms,
  required List<TeachingAssignmentModel> assignments,
}) {
  final shifts = {for (final s in classrooms.shifts) s.id: s};
  final slots = <ScheduleSlotModel>[];
  var offset = 0;
  for (final classroom in classrooms.classrooms) {
    final shift = shifts[classroom.shiftId];
    final from = parseScheduleTime(shift?.startTime);
    final to = parseScheduleTime(shift?.endTime);
    if (shift == null || from == null || to == null) continue;
    final periods = (to - from) ~/ 60;
    if (periods <= 0) continue;
    final own = assignments.where(
      (a) => a.classroomId == classroom.id && a.role == AssignmentRole.titular,
    );
    for (final a in own) {
      for (var k = 0; k < a.weeklyHours.clamp(0, 4); k++) {
        for (var step = 0; step < 5 * periods; step++) {
          final p = offset + step;
          final start = from + 60 * ((p ~/ 5) % periods);
          final candidate = ScheduleSlotModel(
            id: _id(slots.length + 1),
            academicYearId: classroom.academicYearId,
            classroomId: classroom.id,
            subjectId: a.subjectId,
            teacherId: a.teacherId,
            roomId: classroom.roomId,
            weekday: 1 + p % 5,
            startTime: _hhmm(start),
            endTime: _hhmm(start + 60),
          );
          final issue = validateScheduleSlot(
            candidate,
            slots,
            shiftStart: shift.startTime,
            shiftEnd: shift.endTime,
          );
          if (issue == null) {
            slots.add(candidate);
            offset = p + 1;
            break;
          }
        }
      }
    }
  }
  return slots;
}
