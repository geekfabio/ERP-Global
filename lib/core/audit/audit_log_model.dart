import 'package:freezed_annotation/freezed_annotation.dart';

import '../utils/json_converters.dart';

part 'audit_log_model.freezed.dart';
part 'audit_log_model.g.dart';

/// Acção auditada (valores em `snake_case` no JSON).
@JsonEnum(fieldRename: FieldRename.snake)
enum AuditAction { create, update, delete, approve, reopen, cancel, other }

/// Entrada imutável do registo de auditoria: quem, quando, o quê, antes/depois.
@freezed
abstract class AuditLogModel with _$AuditLogModel {
  // O Freezed transfere esta anotação para a classe gerada.
  // ignore: invalid_annotation_target
  @JsonSerializable(explicitToJson: true)
  const factory AuditLogModel({
    required String id,
    required String institutionId,
    @UtcDateTimeConverter() required DateTime createdAt,
    required String actorId,
    required String actorName,

    /// Recurso afectado (`student`, `invoice`, `grade`…).
    required String entity,
    String? entityId,
    required AuditAction action,

    /// Estado anterior e posterior (`null` em criação/remoção, respectivamente).
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) = _AuditLogModel;

  factory AuditLogModel.fromJson(Map<String, dynamic> json) =>
      _$AuditLogModelFromJson(json);
}
