import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_models.freezed.dart';
part 'assignment_models.g.dart';

/// Papel do professor numa atribuição turma × disciplina.
enum AssignmentRole {
  /// Professor titular (um por turma × disciplina).
  @JsonValue('titular')
  titular,

  /// Substituto, sempre com período de validade.
  @JsonValue('substitute')
  substitute,
}

/// Atribuição Professor ↔ Turma ↔ Disciplina (docs/06-modelo-de-dados.md).
@freezed
abstract class TeachingAssignmentModel with _$TeachingAssignmentModel {
  const factory TeachingAssignmentModel({
    required String id,

    /// Derivado da turma pelo servidor.
    @Default('') String academicYearId,
    required String teacherId,
    required String classroomId,
    required String subjectId,

    /// Carga horária semanal em horas.
    required int weeklyHours,
    @Default(AssignmentRole.titular) AssignmentRole role,

    /// Início da validade (`AAAA-MM-DD`); obrigatório no substituto.
    String? validFrom,

    /// Fim da validade (`AAAA-MM-DD`); obrigatório no substituto.
    String? validUntil,
  }) = _TeachingAssignmentModel;

  factory TeachingAssignmentModel.fromJson(Map<String, dynamic> json) =>
      _$TeachingAssignmentModelFromJson(json);
}

/// Director de turma (um por turma).
@freezed
abstract class HomeroomModel with _$HomeroomModel {
  const factory HomeroomModel({
    required String id,
    required String classroomId,
    required String teacherId,
  }) = _HomeroomModel;

  factory HomeroomModel.fromJson(Map<String, dynamic> json) =>
      _$HomeroomModelFromJson(json);
}
