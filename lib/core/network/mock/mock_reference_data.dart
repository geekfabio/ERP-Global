/// Ids de referência partilhados pelas fixtures de todos os módulos, para que os
/// dados mock sejam coerentes entre si (aluno → turma → ano lectivo…). O módulo
/// `academic` (#28/#29) gera o seu seed com estes mesmos ids.
abstract final class MockRef {
  static const institutionId = '01JINSTITUTION000000000001';
  static const campusId = '01JCAMPUS0000000000000001A';

  /// Ano lectivo activo.
  static const academicYearId = '01JYEAR202520260000000001A';
  static const academicYearLabel = '2025/2026';

  /// Classes: Iniciação, 1.ª–13.ª (índice 0 = Iniciação).
  static const gradeCount = 14;

  static String gradeId(int index) =>
      '01JGRADE${index.toString().padLeft(2, '0')}000000000000000A';

  static String gradeLabel(int index) =>
      index == 0 ? 'Iniciação' : '$index.ª classe';

  /// Idade típica de quem frequenta a classe [index] (Iniciação = 5 anos).
  static int gradeAge(int index) => 5 + index;

  static const classroomLetters = ['A', 'B', 'C'];

  static String classroomId(int gradeIndex, int letterIndex) =>
      '01JROOM${gradeIndex.toString().padLeft(2, '0')}${letterIndex}000000000000000A';

  static const morningShiftId = '01JSHIFT00000000000000001A';
  static const afternoonShiftId = '01JSHIFT00000000000000002A';
}
