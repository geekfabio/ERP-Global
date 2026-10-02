import 'package:json_annotation/json_annotation.dart';

/// Estado do aluno na instituição.
@JsonEnum(fieldRename: FieldRename.snake)
enum StudentStatus {
  active,
  inactive,
  suspended,
  transferred,
  graduated,
  dropout,
}

enum Gender {
  @JsonValue('male')
  male,
  @JsonValue('female')
  female,
}

/// Grupo sanguíneo.
enum BloodType {
  @JsonValue('A+')
  aPositive,
  @JsonValue('A-')
  aNegative,
  @JsonValue('B+')
  bPositive,
  @JsonValue('B-')
  bNegative,
  @JsonValue('AB+')
  abPositive,
  @JsonValue('AB-')
  abNegative,
  @JsonValue('O+')
  oPositive,
  @JsonValue('O-')
  oNegative,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum GuardianRelationship {
  father,
  mother,
  tutor,
  grandparent,
  sibling,
  uncleAunt,
  other,
}

/// Tipo de matrícula (docs/03-funcionalidades.md).
@JsonEnum(fieldRename: FieldRename.snake)
enum EnrollmentType { newEnrollment, renewal, transfer, reentry }

/// Estados da matrícula: candidatura → em análise → aprovada → confirmada
/// (→ concluída); `rejected` e `cancelled` são finais.
@JsonEnum(fieldRename: FieldRename.snake)
enum EnrollmentStatus {
  application,
  underReview,
  approved,
  confirmed,
  rejected,
  cancelled,
  completed,
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StudentDocumentType {
  idCard,
  birthCertificate,
  passport,
  previousCertificate,
  vaccination,
  photo,
  contract,
  other,
}

/// Natureza de uma ocorrência disciplinar.
@JsonEnum(fieldRename: FieldRename.snake)
enum OccurrenceType { praise, warning, incident }
