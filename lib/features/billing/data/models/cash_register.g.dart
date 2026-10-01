// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_register.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CashRegister _$CashRegisterFromJson(
  Map<String, dynamic> json,
) => _CashRegister(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  campusId: json['campusId'] as String?,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  name: json['name'] as String,
  status:
      $enumDecodeNullable(_$CashRegisterStatusEnumMap, json['status']) ??
      CashRegisterStatus.active,
);

Map<String, dynamic> _$CashRegisterToJson(_CashRegister instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'campusId': instance.campusId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'name': instance.name,
      'status': _$CashRegisterStatusEnumMap[instance.status]!,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$CashRegisterStatusEnumMap = {
  CashRegisterStatus.active: 'active',
  CashRegisterStatus.inactive: 'inactive',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
