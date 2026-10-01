import '../../../../core/utils/seed_generator.dart';
import '../../../students/data/data_mocks/students_seed.dart';
import '../../domain/attendance_rules.dart';
import '../models/attendance_models.dart';

/// Limite de faltas injustificadas do seed (baixo, para o alerta aparecer).
const attendanceSeedLimit = 5;

/// Registos do dia dos últimos 15 dias úteis antes de [now], para os primeiros
/// [students] alunos matriculados. Determinístico: mesma [seed] e [now] → os
/// mesmos registos. Um aluno em cada 13 falta muito (acima do limite).
List<AttendanceRecordModel> buildAttendanceSeed({
  required DateTime now,
  int seed = 45,
  int students = 60,
}) {
  final base = buildStudentsSeed();
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(now.year, now.month, now.day);
  final days = <DateTime>[];
  for (var d = at.subtract(const Duration(days: 1)); days.length < 15;) {
    if (d.weekday <= DateTime.friday) days.add(d);
    d = d.subtract(const Duration(days: 1));
  }
  final records = <AttendanceRecordModel>[];
  final enrollments = base.enrollments
      .where((e) => e.classroomId != null)
      .take(students)
      .toList();
  for (final (i, e) in enrollments.indexed) {
    final heavy = i % 13 == 0;
    for (final day in days) {
      final roll = gen.random.nextInt(100);
      final status = roll < (heavy ? 40 : 4)
          ? AttendanceStatus.absent
          : roll < (heavy ? 45 : 12)
          ? AttendanceStatus.late
          : AttendanceStatus.present;
      records.add(
        AttendanceRecordModel(
          id: gen.ulid(day),
          classroomId: e.classroomId!,
          studentId: e.studentId,
          date: attendanceDate(day),
          status: status,
          // Faltas dos alunos "normais" costumam vir justificadas.
          justification: status == AttendanceStatus.absent && !heavy
              ? 'Doença'
              : null,
        ),
      );
    }
  }
  return records;
}
