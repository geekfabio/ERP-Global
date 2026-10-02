// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_log_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditLogModel _$AuditLogModelFromJson(Map<String, dynamic> json) =>
    _AuditLogModel(
      id: json['id'] as String,
      institutionId: json['institutionId'] as String,
      createdAt: const UtcDateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
      actorId: json['actorId'] as String,
      actorName: json['actorName'] as String,
      entity: json['entity'] as String,
      entityId: json['entityId'] as String?,
      action: $enumDecode(_$AuditActionEnumMap, json['action']),
      before: json['before'] as Map<String, dynamic>?,
      after: json['after'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$AuditLogModelToJson(_AuditLogModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'actorId': instance.actorId,
      'actorName': instance.actorName,
      'entity': instance.entity,
      'entityId': instance.entityId,
      'action': _$AuditActionEnumMap[instance.action]!,
      'before': instance.before,
      'after': instance.after,
    };

const _$AuditActionEnumMap = {
  AuditAction.create: 'create',
  AuditAction.update: 'update',
  AuditAction.delete: 'delete',
  AuditAction.approve: 'approve',
  AuditAction.reopen: 'reopen',
  AuditAction.cancel: 'cancel',
  AuditAction.other: 'other',
};
