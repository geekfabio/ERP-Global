import '../../students/data/models/student_summaries_model.dart';
import '../data/models/portal_academic_models.dart';

/// Nome do dia da semana ISO (1 = segunda).
String weekdayName(int weekday) => switch (weekday) {
  1 => 'Segunda-feira',
  2 => 'Terça-feira',
  3 => 'Quarta-feira',
  4 => 'Quinta-feira',
  5 => 'Sexta-feira',
  6 => 'Sábado',
  _ => 'Domingo',
};

/// Aulas agrupadas por dia (ordem do dia) e ordenadas pela hora de início.
Map<int, List<PortalScheduleSlot>> groupByWeekday(
  Iterable<PortalScheduleSlot> slots,
) {
  final sorted = slots.toList()
    ..sort((a, b) {
      final byDay = a.weekday.compareTo(b.weekday);
      return byDay != 0 ? byDay : a.startTime.compareTo(b.startTime);
    });
  final grouped = <int, List<PortalScheduleSlot>>{};
  for (final s in sorted) {
    (grouped[s.weekday] ??= []).add(s);
  }
  return grouped;
}

DateTime _day(DateTime d) => DateTime.utc(d.year, d.month, d.day);

/// Faltas injustificadas ainda sem pedido (pendente ou aprovado), do dia mais
/// recente para o mais antigo: as que o formulário de justificação oferece.
List<DateTime> justifiableAbsences(
  StudentAttendanceSummary attendance,
  Iterable<AbsenceJustificationRequest> requests,
) {
  final requested = {
    for (final r in requests)
      if (r.status != PortalRequestStatus.rejected) _day(r.date),
  };
  final days = {
    for (final r in attendance.records)
      if (r.kind == AttendanceKind.unjustified) _day(r.date),
  }.difference(requested);
  return days.toList()..sort((a, b) => b.compareTo(a));
}

/// Contagem de registos de assiduidade por tipo.
Map<AttendanceKind, int> countByKind(StudentAttendanceSummary attendance) => {
  for (final k in AttendanceKind.values)
    k: attendance.records.where((r) => r.kind == k).length,
};

/// Nota do trimestre [term] (1–3) de uma disciplina.
double? termGrade(SubjectGrades s, int term) => switch (term) {
  1 => s.term1,
  2 => s.term2,
  _ => s.term3,
};
