// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoleModel _$RoleModelFromJson(Map<String, dynamic> json) => _RoleModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  code: $enumDecode(_$AuthProfileEnumMap, json['code']),
  permissions:
      (json['permissions'] as List<dynamic>?)
          ?.map((e) => PermissionModel.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PermissionModel>[],
);

Map<String, dynamic> _$RoleModelToJson(_RoleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'code': _$AuthProfileEnumMap[instance.code]!,
      'permissions': instance.permissions.map((e) => e.toJson()).toList(),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$AuthProfileEnumMap = {
  AuthProfile.superAdmin: 'super_admin',
  AuthProfile.management: 'direcao',
  AuthProfile.coordination: 'coordenacao',
  AuthProfile.academicOffice: 'secretaria',
  AuthProfile.teacher: 'professor',
  AuthProfile.homeroomTeacher: 'diretor_turma',
  AuthProfile.finance: 'financeiro',
  AuthProfile.accountant: 'contabilista',
  AuthProfile.humanResources: 'rh',
  AuthProfile.cafeteria: 'refeitorio',
  AuthProfile.security: 'seguranca',
  AuthProfile.librarian: 'bibliotecario',
  AuthProfile.guardian: 'encarregado',
  AuthProfile.student: 'aluno',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
