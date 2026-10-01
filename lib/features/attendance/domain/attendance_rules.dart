import '../data/models/attendance_models.dart';

const attendanceRecordWritePermission = 'attendance.record.write';

/// Coordenação/secretaria: todas as turmas, justificações e definições.
const attendanceRecordAllPermission = 'attendance.record.all';

/// Falta com motivo registado.
bool isJustified(AttendanceRecordModel r) =>
    r.status == AttendanceStatus.absent &&
    (r.justification?.trim().isNotEmpty ?? false);

/// Falta sem justificação.
bool isUnjustified(AttendanceRecordModel r) =>
    r.status == AttendanceStatus.absent && !isJustified(r);

String attendanceStatusLabel(AttendanceRecordModel r) => switch (r.status) {
  AttendanceStatus.present => 'Presente',
  AttendanceStatus.late => 'Atraso',
  AttendanceStatus.absent => isJustified(r) ? 'Falta justificada' : 'Falta',
};

/// Formata [d] como `AAAA-MM-DD`.
String attendanceDate(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

/// Faltas injustificadas por aluno. Um dia só conta uma vez: as faltas por
/// aula do mesmo dia contam como uma só falta.
Map<String, int> unjustifiedByStudent(Iterable<AttendanceRecordModel> records) {
  final days = <String, Set<String>>{};
  for (final r in records.where(isUnjustified)) {
    (days[r.studentId] ??= {}).add(r.date);
  }
  return {for (final e in days.entries) e.key: e.value.length};
}

/// Alunos com [limit] ou mais faltas injustificadas (mais faltas primeiro).
List<AttendanceAlertModel> buildAlerts(
  Iterable<AttendanceRecordModel> records,
  int limit,
) {
  final classroomOf = <String, String>{};
  for (final r in records) {
    classroomOf[r.studentId] = r.classroomId;
  }
  return [
    for (final e in unjustifiedByStudent(records).entries)
      if (e.value >= limit)
        AttendanceAlertModel(
          studentId: e.key,
          classroomId: classroomOf[e.key]!,
          unjustified: e.value,
          limit: limit,
        ),
  ]..sort((a, b) => b.unjustified.compareTo(a.unjustified));
}
