import 'package:freezed_annotation/freezed_annotation.dart';

part 'academic_models.freezed.dart';
part 'academic_models.g.dart';

/// Ciclo de ensino (Iniciação, Primário, I e II Ciclo do Secundário).
@freezed
abstract class LevelModel with _$LevelModel {
  const factory LevelModel({
    required String id,
    required String code,
    required String name,

    /// Posição na sequência dos ciclos (0 = primeiro).
    @Default(0) int order,
  }) = _LevelModel;

  factory LevelModel.fromJson(Map<String, dynamic> json) =>
      _$LevelModelFromJson(json);
}

/// Classe (Iniciação, 1.ª … 12.ª) pertencente a um [LevelModel].
@freezed
abstract class GradeModel with _$GradeModel {
  const factory GradeModel({
    required String id,
    required String levelId,
    required String name,

    /// Número da classe (0 = Iniciação); define a ordenação global.
    @Default(0) int order,
  }) = _GradeModel;

  factory GradeModel.fromJson(Map<String, dynamic> json) =>
      _$GradeModelFromJson(json);
}

/// Curso (Ensino Geral, Ciências Físicas e Biológicas…) leccionado em um ou
/// mais ciclos.
@freezed
abstract class CourseModel with _$CourseModel {
  const factory CourseModel({
    required String id,
    required String code,
    required String name,
    @Default(<String>[]) List<String> levelIds,
    @Default(true) bool isActive,
  }) = _CourseModel;

  factory CourseModel.fromJson(Map<String, dynamic> json) =>
      _$CourseModelFromJson(json);
}

/// Disciplina do catálogo da instituição.
@freezed
abstract class SubjectModel with _$SubjectModel {
  const factory SubjectModel({
    required String id,
    required String code,
    required String name,
    @Default(true) bool isActive,
  }) = _SubjectModel;

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);
}

/// Entrada do currículo: disciplina leccionada num curso × classe.
@freezed
abstract class CurriculumItemModel with _$CurriculumItemModel {
  const factory CurriculumItemModel({
    required String id,
    required String courseId,
    required String gradeId,
    required String subjectId,

    /// Carga horária semanal (tempos lectivos).
    required int weeklyHours,
  }) = _CurriculumItemModel;

  factory CurriculumItemModel.fromJson(Map<String, dynamic> json) =>
      _$CurriculumItemModelFromJson(json);
}
