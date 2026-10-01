import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'assessment_scheme_model.dart';

part 'grade_sheet_models.freezed.dart';
part 'grade_sheet_models.g.dart';

/// Notas de um aluno numa folha: `código do componente → nota`.
/// Componente ausente = ainda não lançado (nunca zero implícito).
@freezed
abstract class GradeRowModel with _$GradeRowModel {
  const factory GradeRowModel({
    required String studentId,
    @Default(<String, double>{}) Map<String, double> scores,
  }) = _GradeRowModel;

  factory GradeRowModel.fromJson(Map<String, dynamic> json) =>
      _$GradeRowModelFromJson(json);
}

/// Folha de notas de turma × disciplina × trimestre, com o esquema aplicável
/// e o estado de bloqueio (trimestre fechado ou prazo terminado).
@freezed
abstract class GradeSheetModel with _$GradeSheetModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GradeSheetModel({
    required String classroomId,
    required String subjectId,
    required String termId,
    required AssessmentSchemeModel scheme,
    @Default(false) bool termClosed,

    /// Prazo de lançamento (`AAAA-MM-DD`), se o trimestre tiver um.
    String? deadline,
    @Default(false) bool deadlinePassed,
    @Default(<GradeRowModel>[]) List<GradeRowModel> rows,
  }) = _GradeSheetModel;

  factory GradeSheetModel.fromJson(Map<String, dynamic> json) =>
      _$GradeSheetModelFromJson(json);
}

extension GradeSheetModelX on GradeSheetModel {
  /// Bloqueada: só se edita com permissão `approve` e justificação.
  bool get locked => termClosed || deadlinePassed;
}

/// Alteração de uma nota (log imutável; `before`/`after` `null` = sem nota).
@freezed
abstract class GradeChangeModel with _$GradeChangeModel {
  const factory GradeChangeModel({
    required String id,
    required String classroomId,
    required String subjectId,
    required String termId,
    required String studentId,
    required String componentCode,
    double? before,
    double? after,

    /// Alteração feita com a folha bloqueada (pós-fecho/prazo).
    @Default(false) bool afterLock,
    String? justification,
    @UtcDateTimeConverter() required DateTime changedAt,
  }) = _GradeChangeModel;

  factory GradeChangeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeChangeModelFromJson(json);
}
