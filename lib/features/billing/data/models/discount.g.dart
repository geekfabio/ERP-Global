// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'discount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Discount _$DiscountFromJson(Map<String, dynamic> json) => _Discount(
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
  studentId: json['studentId'] as String,
  kind: $enumDecode(_$DiscountKindEnumMap, json['kind']),
  reason: $enumDecode(_$DiscountReasonEnumMap, json['reason']),
  value: (json['value'] as num).toInt(),
  feeType: $enumDecodeNullable(_$FeeTypeEnumMap, json['feeType']),
  validFrom: const DateOnlyConverter().fromJson(json['validFrom'] as String),
  validUntil: _$JsonConverterFromJson<String, DateTime>(
    json['validUntil'],
    const DateOnlyConverter().fromJson,
  ),
  note: json['note'] as String?,
  status:
      $enumDecodeNullable(_$DiscountStatusEnumMap, json['status']) ??
      DiscountStatus.pending,
  decisionNote: json['decisionNote'] as String?,
  decidedAt: _$JsonConverterFromJson<String, DateTime>(
    json['decidedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$DiscountToJson(_Discount instance) => <String, dynamic>{
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
  'studentId': instance.studentId,
  'kind': _$DiscountKindEnumMap[instance.kind]!,
  'reason': _$DiscountReasonEnumMap[instance.reason]!,
  'value': instance.value,
  'feeType': _$FeeTypeEnumMap[instance.feeType],
  'validFrom': const DateOnlyConverter().toJson(instance.validFrom),
  'validUntil': _$JsonConverterToJson<String, DateTime>(
    instance.validUntil,
    const DateOnlyConverter().toJson,
  ),
  'note': instance.note,
  'status': _$DiscountStatusEnumMap[instance.status]!,
  'decisionNote': instance.decisionNote,
  'decidedAt': _$JsonConverterToJson<String, DateTime>(
    instance.decidedAt,
    const UtcDateTimeConverter().toJson,
  ),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$DiscountKindEnumMap = {
  DiscountKind.percentage: 'percentage',
  DiscountKind.fixed: 'fixed',
};

const _$DiscountReasonEnumMap = {
  DiscountReason.sibling: 'sibling',
  DiscountReason.merit: 'merit',
  DiscountReason.scholarship: 'scholarship',
  DiscountReason.other: 'other',
};

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

const _$DiscountStatusEnumMap = {
  DiscountStatus.pending: 'pending',
  DiscountStatus.approved: 'approved',
  DiscountStatus.rejected: 'rejected',
  DiscountStatus.revoked: 'revoked',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
