// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FeeItem _$FeeItemFromJson(Map<String, dynamic> json) => _FeeItem(
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
  academicYearId: json['academicYearId'] as String,
  gradeId: json['gradeId'] as String,
  type: $enumDecode(_$FeeTypeEnumMap, json['type']),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  status:
      $enumDecodeNullable(_$FeeItemStatusEnumMap, json['status']) ??
      FeeItemStatus.active,
);

Map<String, dynamic> _$FeeItemToJson(_FeeItem instance) => <String, dynamic>{
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
  'academicYearId': instance.academicYearId,
  'gradeId': instance.gradeId,
  'type': _$FeeTypeEnumMap[instance.type]!,
  'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
  'status': _$FeeItemStatusEnumMap[instance.status]!,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$FeeTypeEnumMap = {
  FeeType.enrollment: 'enrollment',
  FeeType.tuition: 'tuition',
  FeeType.uniform: 'uniform',
  FeeType.material: 'material',
  FeeType.exam: 'exam',
  FeeType.transport: 'transport',
  FeeType.cafeteria: 'cafeteria',
  FeeType.other: 'other',
};

const _$FeeItemStatusEnumMap = {
  FeeItemStatus.active: 'active',
  FeeItemStatus.inactive: 'inactive',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
