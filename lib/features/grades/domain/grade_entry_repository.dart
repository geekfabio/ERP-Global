import '../../../core/errors/result.dart';
import '../data/models/grade_sheet_models.dart';

const gradeEntryReadPermission = 'grades.entry.read';
const gradeEntryWritePermission = 'grades.entry.write';
const gradeEntryApprovePermission = 'grades.entry.approve';

/// Identifica uma folha de notas. [gradeId]/[courseId] servem ao servidor
/// para escolher o esquema de avaliação aplicável.
class GradeSheetKey {
  const GradeSheetKey({
    required this.classroomId,
    required this.subjectId,
    required this.termId,
    this.gradeId,
    this.courseId,
  });

  final String classroomId;
  final String subjectId;
  final String termId;
  final String? gradeId;
  final String? courseId;

  Map<String, dynamic> toJson() => {
    'classroomId': classroomId,
    'subjectId': subjectId,
    'termId': termId,
    'gradeId': ?gradeId,
    'courseId': ?courseId,
  };

  @override
  bool operator ==(Object other) =>
      other is GradeSheetKey &&
      other.classroomId == classroomId &&
      other.subjectId == subjectId &&
      other.termId == termId &&
      other.gradeId == gradeId &&
      other.courseId == courseId;

  @override
  int get hashCode =>
      Object.hash(classroomId, subjectId, termId, gradeId, courseId);
}

/// Leitura com `grades.entry.read`, `write` ou `approve`; escrita com `write`.
/// Com a folha bloqueada (trimestre fechado ou prazo terminado) só `approve`
/// escreve, e a justificação é obrigatória (422 `justification`).
/// Erros: 422 por `<studentId>.<componente>` (nota fora da escala), 403.
abstract interface class GradeEntryRepository {
  Future<Result<GradeSheetModel>> sheet(GradeSheetKey key);

  /// Grava as notas de [rows]; devolve a folha actualizada.
  Future<Result<GradeSheetModel>> save(
    GradeSheetKey key,
    List<GradeRowModel> rows, {
    String? justification,
  });

  Future<Result<List<GradeChangeModel>>> changes(GradeSheetKey key);
}
