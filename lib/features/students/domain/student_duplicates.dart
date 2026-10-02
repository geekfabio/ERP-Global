import '../../../core/network/mock/mock_query.dart' show foldText;
import '../data/models/student_model.dart';

/// Porque é que um aluno existente parece o mesmo que o novo.
enum DuplicateReason {
  /// Mesmo BI/cédula/passaporte — impede o registo (409 `CONFLICT`).
  idNumber,

  /// Mesmo nome e data de nascimento — alerta; o utilizador decide.
  nameAndBirth,
}

class StudentDuplicate {
  const StudentDuplicate({required this.student, required this.reason});

  final StudentModel student;
  final DuplicateReason reason;

  /// Só o BI repetido bloqueia o registo.
  bool get blocking => reason == DuplicateReason.idNumber;
}

/// Nome comparável: sem acentos, maiúsculas nem espaços repetidos.
String normalizeStudentName(String name) =>
    foldText(name).trim().replaceAll(RegExp(r'\s+'), ' ');

/// BI comparável: sem espaços/hífenes, maiúsculas.
String normalizeIdNumber(String id) =>
    id.replaceAll(RegExp(r'[\s-]'), '').toUpperCase();

/// Regra de duplicados (docs/03): mesmo BI, ou mesmo nome + data de nascimento.
/// Ignora alunos removidos e o próprio [exceptId]. O BI tem prioridade.
List<StudentDuplicate> findStudentDuplicates(
  Iterable<StudentModel> existing, {
  required String fullName,
  required DateTime birthDate,
  String? idNumber,
  String? exceptId,
}) {
  final name = normalizeStudentName(fullName);
  final id = idNumber == null ? '' : normalizeIdNumber(idNumber);
  final found = <StudentDuplicate>[];
  for (final s in existing) {
    if (s.deletedAt != null || s.id == exceptId) continue;
    if (id.isNotEmpty &&
        s.idNumber != null &&
        normalizeIdNumber(s.idNumber!) == id) {
      found.add(StudentDuplicate(student: s, reason: DuplicateReason.idNumber));
    } else if (name.isNotEmpty &&
        normalizeStudentName(s.fullName) == name &&
        s.birthDate.year == birthDate.year &&
        s.birthDate.month == birthDate.month &&
        s.birthDate.day == birthDate.day) {
      found.add(
        StudentDuplicate(student: s, reason: DuplicateReason.nameAndBirth),
      );
    }
  }
  return found;
}
