import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';
import 'student_enums.dart';

part 'student_document_model.freezed.dart';
part 'student_document_model.g.dart';

/// Documento do aluno (BI, cédula, vacinas…) com validade e verificação.
@freezed
abstract class StudentDocumentModel with _$StudentDocumentModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory StudentDocumentModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    @UtcDateTimeConverter() required DateTime updatedAt,
    @UtcDateTimeConverter() DateTime? deletedAt,
    @Default('synced') String syncState,
    required String studentId,
    required StudentDocumentType type,
    required String fileName,
    String? fileUrl,
    @DateOnlyConverter() DateTime? expiresOn,
    @Default(false) bool verified,

    /// Id do utilizador que verificou o documento.
    String? verifiedBy,
    @UtcDateTimeConverter() DateTime? verifiedAt,
  }) = _StudentDocumentModel;

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentDocumentModelFromJson(json);
}
