import 'package:freezed_annotation/freezed_annotation.dart';

import 'student_enums.dart';

part 'enrollment_rules_model.freezed.dart';
part 'enrollment_rules_model.g.dart';

/// Regras configuráveis da matrícula (valores vêm do servidor).
@freezed
abstract class EnrollmentRulesModel with _$EnrollmentRulesModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory EnrollmentRulesModel({
    /// Idade mínima (anos completos à data da matrícula); não se aplica a
    /// renovações. `0` desactiva.
    @Default(0) int minAgeYears,

    /// Vagas por turma; `0` = sem limite.
    @Default(0) int capacityPerClassroom,

    /// Só documentos verificados contam como entregues.
    @Default(true) bool requireVerifiedDocuments,

    /// Documentos obrigatórios por tipo de matrícula (chave = valor JSON do
    /// [EnrollmentType]: `new_enrollment`, `renewal`, `transfer`, `reentry`).
    @Default(<String, List<StudentDocumentType>>{})
    Map<String, List<StudentDocumentType>> requiredDocuments,
  }) = _EnrollmentRulesModel;

  factory EnrollmentRulesModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentRulesModelFromJson(json);
}

/// Lugares de uma turma.
@freezed
abstract class ClassroomVacancy with _$ClassroomVacancy {
  const factory ClassroomVacancy({
    required String classroomId,

    /// `0` = sem limite.
    required int capacity,
    required int occupied,
  }) = _ClassroomVacancy;

  factory ClassroomVacancy.fromJson(Map<String, dynamic> json) =>
      _$ClassroomVacancyFromJson(json);
}

extension ClassroomVacancyX on ClassroomVacancy {
  bool get hasRoom => capacity == 0 || occupied < capacity;
}
