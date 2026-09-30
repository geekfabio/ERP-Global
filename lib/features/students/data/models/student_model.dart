import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'student_enums.dart';

part 'student_model.freezed.dart';
part 'student_model.g.dart';

/// Ficha de saúde (separador "Saúde").
@freezed
abstract class HealthInfo with _$HealthInfo {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory HealthInfo({
    BloodType? bloodType,
    @Default(<String>[]) List<String> allergies,
    String? medication,
    String? conditions,
    String? insurance,
    @Default(false) bool hasSpecialNeeds,
    String? specialNeedsNotes,
    String? medicalContact,
  }) = _HealthInfo;

  factory HealthInfo.fromJson(Map<String, dynamic> json) =>
      _$HealthInfoFromJson(json);
}

/// Aluno — registo mestre da ficha (docs/03-funcionalidades.md).
@freezed
abstract class StudentModel with _$StudentModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentModel({
    required String id,
    required String institutionId,
    String? campusId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,

    /// N.º de processo (gerado).
    required String processNumber,
    required String fullName,
    String? photoUrl,
    @DateOnlyConverter() required DateTime birthDate,
    String? birthPlace,
    required Gender gender,
    @Default('Angolana') String nationality,

    /// BI, cédula ou passaporte.
    String? idNumber,
    String? nif,
    String? address,
    String? phone,
    String? email,
    String? originSchool,
    @Default(StudentStatus.active) StudentStatus status,
    @Default(HealthInfo()) HealthInfo health,
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);
}
