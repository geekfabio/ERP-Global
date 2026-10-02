import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'academic_document_models.freezed.dart';
part 'academic_document_models.g.dart';

/// Tipo de documento académico emitido pela instituição.
enum DocumentKind { enrollmentDeclaration, attendanceDeclaration, certificate }

/// Ciclo de vida: pedido -> emitido (ou anulado).
enum DocumentStatus { requested, issued, cancelled }

/// Modelo editável de um tipo de documento. O [body] usa marcadores
/// `{{studentName}}`, substituídos na emissão.
@freezed
abstract class DocumentTemplateModel with _$DocumentTemplateModel {
  const factory DocumentTemplateModel({
    required String id,
    required DocumentKind kind,
    required String name,
    required String body,
  }) = _DocumentTemplateModel;

  factory DocumentTemplateModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentTemplateModelFromJson(json);
}

/// Pedido/emissão de um documento. O [number] sequencial e o [content]
/// final só existem depois de emitido; [variables] guarda os dados do aluno
/// no momento do pedido.
@freezed
abstract class AcademicDocumentModel with _$AcademicDocumentModel {
  const factory AcademicDocumentModel({
    required String id,
    required DocumentKind kind,
    required DocumentStatus status,
    required String studentId,
    required String studentName,
    required String processNumber,
    @Default('') String purpose,
    @Default(<String, String>{}) Map<String, String> variables,
    @UtcDateTimeConverter() required DateTime requestedAt,
    String? number,
    String? content,
    @UtcDateTimeConverter() DateTime? issuedAt,
    @UtcDateTimeConverter() DateTime? cancelledAt,
  }) = _AcademicDocumentModel;

  factory AcademicDocumentModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicDocumentModelFromJson(json);
}

/// Resposta pública da verificação por número (sem dados sensíveis).
@freezed
abstract class DocumentVerificationModel with _$DocumentVerificationModel {
  const factory DocumentVerificationModel({
    required String number,
    required DocumentKind kind,
    required DocumentStatus status,
    required String studentName,
    @UtcDateTimeConverter() DateTime? issuedAt,
  }) = _DocumentVerificationModel;

  factory DocumentVerificationModel.fromJson(Map<String, dynamic> json) =>
      _$DocumentVerificationModelFromJson(json);
}
