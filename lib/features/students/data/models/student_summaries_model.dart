import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'student_summaries_model.freezed.dart';
part 'student_summaries_model.g.dart';

// Vistas de leitura que a ficha do aluno pede a outros módulos (notas,
// presenças, financeiro, cartões). São contratos do `students`: cada módulo
// responde-lhes quando está licenciado; a ficha nunca importa os seus internals.

/// Notas de uma disciplina por trimestre (0–20; `null` = ainda sem nota).
@freezed
abstract class SubjectGrades with _$SubjectGrades {
  const factory SubjectGrades({
    required String subject,
    double? term1,
    double? term2,
    double? term3,
  }) = _SubjectGrades;

  factory SubjectGrades.fromJson(Map<String, dynamic> json) =>
      _$SubjectGradesFromJson(json);
}

/// Boletim emitido.
@freezed
abstract class BulletinRef with _$BulletinRef {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory BulletinRef({
    required String id,
    required String label,
    @DateOnlyConverter() required DateTime issuedOn,
  }) = _BulletinRef;

  factory BulletinRef.fromJson(Map<String, dynamic> json) =>
      _$BulletinRefFromJson(json);
}

@freezed
abstract class StudentGradesSummary with _$StudentGradesSummary {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentGradesSummary({
    @Default(<SubjectGrades>[]) List<SubjectGrades> subjects,
    @Default(<BulletinRef>[]) List<BulletinRef> bulletins,
  }) = _StudentGradesSummary;

  factory StudentGradesSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentGradesSummaryFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum AttendanceKind { present, justified, unjustified, late }

@freezed
abstract class AttendanceRecord with _$AttendanceRecord {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AttendanceRecord({
    @DateOnlyConverter() required DateTime date,
    required AttendanceKind kind,
    String? note,
  }) = _AttendanceRecord;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordFromJson(json);
}

/// Presenças do ano lectivo (os registos vêm do mais recente para o mais antigo).
@freezed
abstract class StudentAttendanceSummary with _$StudentAttendanceSummary {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentAttendanceSummary({
    @Default(<AttendanceRecord>[]) List<AttendanceRecord> records,
  }) = _StudentAttendanceSummary;

  factory StudentAttendanceSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentAttendanceSummaryFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StudentChargeStatus { open, partial, paid, overdue }

/// Cobrança da conta corrente. Dinheiro em `int` (menor unidade).
@freezed
abstract class StudentChargeLine with _$StudentChargeLine {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentChargeLine({
    required String id,
    required String description,
    @DateOnlyConverter() required DateTime dueOn,
    required int amountMinor,
    @Default(0) int paidMinor,
    required StudentChargeStatus status,
  }) = _StudentChargeLine;

  factory StudentChargeLine.fromJson(Map<String, dynamic> json) =>
      _$StudentChargeLineFromJson(json);
}

@freezed
abstract class StudentFinanceSummary with _$StudentFinanceSummary {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentFinanceSummary({
    @Default(<StudentChargeLine>[]) List<StudentChargeLine> charges,

    /// Bolsa/desconto em percentagem (0–100).
    @Default(0) int discountPercent,
  }) = _StudentFinanceSummary;

  factory StudentFinanceSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentFinanceSummaryFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum StudentCardStatus { active, blocked, lost }

@JsonEnum(fieldRename: FieldRename.snake)
enum AccessDirection { entry, exit }

@freezed
abstract class AccessEvent with _$AccessEvent {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AccessEvent({
    @UtcDateTimeConverter() required DateTime at,
    required AccessDirection direction,
    String? gate,
  }) = _AccessEvent;

  factory AccessEvent.fromJson(Map<String, dynamic> json) =>
      _$AccessEventFromJson(json);
}

/// Cartão do aluno, saldo do refeitório e últimas entradas/saídas.
@freezed
abstract class StudentCardSummary with _$StudentCardSummary {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentCardSummary({
    String? cardNumber,
    StudentCardStatus? status,
    @Default(0) int mealBalanceMinor,
    @Default(<AccessEvent>[]) List<AccessEvent> recentAccess,
  }) = _StudentCardSummary;

  factory StudentCardSummary.fromJson(Map<String, dynamic> json) =>
      _$StudentCardSummaryFromJson(json);
}
