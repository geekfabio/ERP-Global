import '../data/models/enrollment_model.dart';
import '../data/models/student_document_model.dart';
import '../data/models/student_enums.dart';
import '../data/models/student_summaries_model.dart';

bool _isVoided(EnrollmentModel e) =>
    e.status == EnrollmentStatus.cancelled ||
    e.status == EnrollmentStatus.rejected;

/// Ids das matrículas que são repetência: o aluno já tinha frequentado a mesma
/// classe num ano anterior (matrículas anuladas não contam).
Set<String> repeatedEnrollmentIds(List<EnrollmentModel> enrollments) {
  final valid = [
    for (final e in enrollments)
      if (!_isVoided(e)) e,
  ]..sort((a, b) => a.enrolledOn.compareTo(b.enrolledOn));
  final seen = <String, String>{}; // classe → ano em que foi frequentada
  final repeated = <String>{};
  for (final e in valid) {
    final year = seen[e.gradeId];
    if (year != null && year != e.academicYearId) repeated.add(e.id);
    seen.putIfAbsent(e.gradeId, () => e.academicYearId);
  }
  return repeated;
}

/// Matrícula actual: a mais recente que não foi anulada.
EnrollmentModel? currentEnrollment(List<EnrollmentModel> enrollments) {
  EnrollmentModel? best;
  for (final e in enrollments) {
    if (_isVoided(e)) continue;
    if (best == null || e.enrolledOn.isAfter(best.enrolledOn)) best = e;
  }
  return best;
}

enum DocumentValidity { noExpiry, valid, expiringSoon, expired }

/// Janela de aviso antes de um documento expirar.
const documentExpiryWarning = Duration(days: 30);

/// Validade do documento em [now] (a data de expiração é o último dia válido).
DocumentValidity documentValidity(StudentDocumentModel d, DateTime now) {
  final expires = d.expiresOn;
  if (expires == null) return DocumentValidity.noExpiry;
  final today = DateTime.utc(now.year, now.month, now.day);
  if (expires.isBefore(today)) return DocumentValidity.expired;
  if (expires.difference(today) <= documentExpiryWarning) {
    return DocumentValidity.expiringSoon;
  }
  return DocumentValidity.valid;
}

/// Média de uma disciplina (só trimestres com nota); `null` se não há notas.
double? subjectAverage(SubjectGrades s) =>
    _mean([?s.term1, ?s.term2, ?s.term3]);

/// Média geral das médias das disciplinas com nota.
double? overallAverage(List<SubjectGrades> subjects) =>
    _mean([for (final s in subjects) ?subjectAverage(s)]);

double? _mean(List<double> values) => values.isEmpty
    ? null
    : values.fold<double>(0, (a, b) => a + b) / values.length;

/// Contagem de presenças por tipo.
Map<AttendanceKind, int> attendanceCounts(List<AttendanceRecord> records) => {
  for (final k in AttendanceKind.values)
    k: records.where((r) => r.kind == k).length,
};

/// Valor em dívida (menor unidade): o que falta pagar das cobranças em aberto.
int outstandingMinor(List<StudentChargeLine> charges) => charges.fold(
  0,
  (sum, c) => sum + (c.amountMinor - c.paidMinor).clamp(0, c.amountMinor),
);

/// Valor das cobranças vencidas e por pagar (menor unidade).
int overdueMinor(List<StudentChargeLine> charges) => charges
    .where((c) => c.status == StudentChargeStatus.overdue)
    .fold(0, (sum, c) => sum + (c.amountMinor - c.paidMinor));
