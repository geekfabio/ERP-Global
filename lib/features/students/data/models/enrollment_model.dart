import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'student_enums.dart';

part 'enrollment_model.freezed.dart';
part 'enrollment_model.g.dart';

/// Matrícula de um aluno num ano lectivo. Os ids de ano, classe, turma e turno
/// referem entidades do módulo `academic` (sem dependência de código).
@freezed
abstract class EnrollmentModel with _$EnrollmentModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory EnrollmentModel({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String academicYearId,
    required String gradeId,
    String? classroomId,
    String? shiftId,

    /// N.º de chamada na turma.
    int? rollNumber,
    required EnrollmentType type,
    @Default(EnrollmentStatus.application) EnrollmentStatus status,
    @DateOnlyConverter() required DateTime enrolledOn,

    /// Taxa de matrícula na menor unidade (cêntimos); nunca `double`.
    @Default(0) int feeMinor,
    @Default(false) bool feePaid,
    String? notes,
  }) = _EnrollmentModel;

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) =>
      _$EnrollmentModelFromJson(json);
}
