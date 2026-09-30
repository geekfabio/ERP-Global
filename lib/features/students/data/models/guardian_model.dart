import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'student_enums.dart';

part 'guardian_model.freezed.dart';
part 'guardian_model.g.dart';

/// Encarregado de educação (pessoa). A ligação ao aluno é o [GuardianLink].
@freezed
abstract class GuardianModel with _$GuardianModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GuardianModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String fullName,
    String? idNumber,
    String? nif,
    required String phone,
    String? email,
    String? address,
    String? profession,

    /// Conta de utilizador do portal (perfil `encarregado`), se existir.
    String? userId,
  }) = _GuardianModel;

  factory GuardianModel.fromJson(Map<String, dynamic> json) =>
      _$GuardianModelFromJson(json);
}

/// Vínculo aluno↔encarregado (N:N): parentesco e responsabilidades.
@freezed
abstract class GuardianLinkModel with _$GuardianLinkModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory GuardianLinkModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required String guardianId,
    required GuardianRelationship relationship,
    @Default(false) bool isFinancialResponsible,
    @Default(false) bool isEmergency,
    @Default(false) bool canPickup,

    /// Fim da validade do vínculo (acesso ao portal); `null` = sem fim.
    @UtcDateTimeConverter() DateTime? validUntil,
    @Default(false) bool verified,
  }) = _GuardianLinkModel;

  factory GuardianLinkModel.fromJson(Map<String, dynamic> json) =>
      _$GuardianLinkModelFromJson(json);
}
