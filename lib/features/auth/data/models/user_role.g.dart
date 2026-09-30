// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_role.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserRole _$UserRoleFromJson(Map<String, dynamic> json) => _UserRole(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  userId: json['userId'] as String,
  roleId: json['roleId'] as String,
  scope: json['scope'] == null
      ? null
      : ScopeModel.fromJson(json['scope'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserRoleToJson(_UserRole instance) => <String, dynamic>{
  'id': instance.id,
  'institutionId': instance.institutionId,
  'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<String, DateTime>(
    instance.deletedAt,
    const UtcDateTimeConverter().toJson,
  ),
  'syncState': instance.syncState,
  'userId': instance.userId,
  'roleId': instance.roleId,
  'scope': instance.scope?.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
