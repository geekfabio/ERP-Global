// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Charge _$ChargeFromJson(Map<String, dynamic> json) => _Charge(
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
  feeItemId: json['feeItemId'] as String,
  dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  discountMinor: json['discountMinor'] == null
      ? 0
      : const MinorUnitConverter().fromJson(json['discountMinor']),
  status:
      $enumDecodeNullable(_$ChargeStatusEnumMap, json['status']) ??
      ChargeStatus.pending,
);

Map<String, dynamic> _$ChargeToJson(_Charge instance) => <String, dynamic>{
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
  'feeItemId': instance.feeItemId,
  'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
  'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
  'discountMinor': const MinorUnitConverter().toJson(instance.discountMinor),
  'status': _$ChargeStatusEnumMap[instance.status]!,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ChargeStatusEnumMap = {
  ChargeStatus.pending: 'pending',
  ChargeStatus.partiallyPaid: 'partially_paid',
  ChargeStatus.paid: 'paid',
  ChargeStatus.overdue: 'overdue',
  ChargeStatus.cancelled: 'cancelled',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
