import '../data/models/assignment_models.dart';

/// Carga horária semanal máxima de um professor (soma das atribuições do ano).
const kMaxTeacherWeeklyHours = 24;

/// Tipo de falha de validação, mapeado para 422 (campo) ou 409 (conflito).
enum AssignmentIssueKind { validation, conflict }

class AssignmentIssue {
  const AssignmentIssue(this.kind, this.field, this.message);

  final AssignmentIssueKind kind;
  final String field;
  final String message;
}

DateTime? _date(String? s) =>
    s == null || s.isEmpty ? null : DateTime.tryParse(s);

/// Valida [candidate] contra as outras atribuições do mesmo ano ([others],
/// sem o próprio registo). Devolve `null` se for válida.
///
/// Regras: horas > 0; titular único por turma × disciplina; substituto só com
/// titular, outro professor e validade `de ≤ até`; sem duplicados do mesmo
/// professor; carga máxima semanal.
AssignmentIssue? validateAssignment(
  TeachingAssignmentModel candidate,
  Iterable<TeachingAssignmentModel> others, {
  int maxWeeklyHours = kMaxTeacherWeeklyHours,
}) {
  AssignmentIssue invalid(String field, String message) =>
      AssignmentIssue(AssignmentIssueKind.validation, field, message);
  AssignmentIssue conflict(String field, String message) =>
      AssignmentIssue(AssignmentIssueKind.conflict, field, message);

  if (candidate.weeklyHours <= 0) {
    return invalid('weeklyHours', 'A carga horária deve ser superior a zero');
  }
  final cell = others
      .where(
        (o) =>
            o.classroomId == candidate.classroomId &&
            o.subjectId == candidate.subjectId,
      )
      .toList();

  if (candidate.role == AssignmentRole.substitute) {
    final from = _date(candidate.validFrom);
    final until = _date(candidate.validUntil);
    if (from == null) {
      return invalid('validFrom', 'Indique o início (AAAA-MM-DD)');
    }
    if (until == null) {
      return invalid('validUntil', 'Indique o fim (AAAA-MM-DD)');
    }
    if (until.isBefore(from)) {
      return invalid('validUntil', 'O fim não pode ser anterior ao início');
    }
    final titular = cell.where((o) => o.role == AssignmentRole.titular);
    if (titular.isEmpty) {
      return invalid('role', 'Atribua primeiro o professor titular');
    }
    if (titular.any((o) => o.teacherId == candidate.teacherId)) {
      return invalid('teacherId', 'O substituto deve ser outro professor');
    }
  } else if (cell.any((o) => o.role == AssignmentRole.titular)) {
    return conflict(
      'role',
      'Esta turma já tem professor titular na disciplina',
    );
  }

  if (cell.any((o) => o.teacherId == candidate.teacherId)) {
    return conflict(
      'teacherId',
      'O professor já está atribuído a esta disciplina',
    );
  }

  final load = teacherLoad(others, candidate.teacherId);
  if (load + candidate.weeklyHours > maxWeeklyHours) {
    return conflict(
      'weeklyHours',
      'Carga máxima excedida: $load h + ${candidate.weeklyHours} h '
          '> $maxWeeklyHours h semanais',
    );
  }
  return null;
}

/// Carga horária semanal total do professor.
int teacherLoad(Iterable<TeachingAssignmentModel> all, String teacherId) => all
    .where((a) => a.teacherId == teacherId)
    .fold<int>(0, (sum, a) => sum + a.weeklyHours);
