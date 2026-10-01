/// Disciplina leccionada por um professor numa turma.
class TeacherSubject {
  const TeacherSubject({required this.id, required this.name});

  final String id;
  final String name;
}

/// Turma do professor na vista "As minhas turmas": disciplinas que lecciona
/// nela e se é director de turma.
class TeacherClass {
  const TeacherClass({
    required this.classroomId,
    required this.name,
    required this.gradeName,
    required this.shiftName,
    required this.enrolledCount,
    required this.subjects,
    required this.isHomeroom,
  });

  final String classroomId;

  /// Designação dentro da classe (ex.: `A`).
  final String name;
  final String gradeName;
  final String shiftName;
  final int enrolledCount;
  final List<TeacherSubject> subjects;
  final bool isHomeroom;

  /// Ex.: `10.ª Classe A`.
  String get label => '$gradeName $name'.trim();
}
