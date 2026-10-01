// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Receipt _$ReceiptFromJson(Map<String, dynamic> json) => _Receipt(
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
  paymentId: json['paymentId'] as String,
  number: json['number'] as String,
  issuedAt: const UtcDateTimeConverter().fromJson(json['issuedAt'] as String),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  status:
      $enumDecodeNullable(_$ReceiptStatusEnumMap, json['status']) ??
      ReceiptStatus.issued,
);

Map<String, dynamic> _$ReceiptToJson(_Receipt instance) => <String, dynamic>{
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
  'paymentId': instance.paymentId,
  'number': instance.number,
  'issuedAt': const UtcDateTimeConverter().toJson(instance.issuedAt),
  'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
  'status': _$ReceiptStatusEnumMap[instance.status]!,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$ReceiptStatusEnumMap = {
  ReceiptStatus.issued: 'issued',
  ReceiptStatus.cancelled: 'cancelled',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
