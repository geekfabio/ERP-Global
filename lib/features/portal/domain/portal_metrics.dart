import '../../students/data/models/student_summaries_model.dart';

/// Média geral (0–20) do último trimestre com notas; `null` sem notas.
double? latestTermAverage(StudentGradesSummary grades) {
  for (final term in <double? Function(SubjectGrades)>[
    (s) => s.term3,
    (s) => s.term2,
    (s) => s.term1,
  ]) {
    final values = [for (final s in grades.subjects) ?term(s)];
    if (values.isNotEmpty) {
      return values.reduce((a, b) => a + b) / values.length;
    }
  }
  return null;
}

/// Faltas injustificadas.
int unjustifiedAbsences(StudentAttendanceSummary attendance) => attendance
    .records
    .where((r) => r.kind == AttendanceKind.unjustified)
    .length;

/// Valor em dívida (menor unidade): cobranças por pagar, descontado o já pago.
int outstandingMinor(StudentFinanceSummary finance) => finance.charges
    .where((c) => c.status != StudentChargeStatus.paid)
    .fold(0, (sum, c) => sum + (c.amountMinor - c.paidMinor));

int overdueCount(StudentFinanceSummary finance) => finance.charges
    .where((c) => c.status == StudentChargeStatus.overdue)
    .length;
