import '../data/models/enrollment_model.dart';
import '../data/models/student_document_model.dart';
import '../data/models/student_enums.dart';

/// Ids das matrículas que são repetência: o aluno já tinha frequentado a mesma
/// classe num ano anterior (matrículas anuladas não contam).
Set<String> repeatedEnrollmentIds(List<EnrollmentModel> enrollments) {
  final valid = [
    for (final e in enrollments)
      if (e.status != EnrollmentStatus.cancelled) e,
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
    if (e.status == EnrollmentStatus.cancelled) continue;
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
