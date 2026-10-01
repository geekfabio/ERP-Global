// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Payment _$PaymentFromJson(Map<String, dynamic> json) => _Payment(
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
  method: $enumDecode(_$PaymentMethodEnumMap, json['method']),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  paidAt: const UtcDateTimeConverter().fromJson(json['paidAt'] as String),
  status:
      $enumDecodeNullable(_$PaymentStatusEnumMap, json['status']) ??
      PaymentStatus.completed,
  allocations:
      (json['allocations'] as List<dynamic>?)
          ?.map((e) => PaymentAllocation.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <PaymentAllocation>[],
);

Map<String, dynamic> _$PaymentToJson(_Payment instance) => <String, dynamic>{
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
  'method': _$PaymentMethodEnumMap[instance.method]!,
  'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
  'paidAt': const UtcDateTimeConverter().toJson(instance.paidAt),
  'status': _$PaymentStatusEnumMap[instance.status]!,
  'allocations': instance.allocations.map((e) => e.toJson()).toList(),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$PaymentMethodEnumMap = {
  PaymentMethod.cash: 'cash',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.paymentReference: 'payment_reference',
  PaymentMethod.prepaidBalance: 'prepaid_balance',
};

const _$PaymentStatusEnumMap = {
  PaymentStatus.pending: 'pending',
  PaymentStatus.completed: 'completed',
  PaymentStatus.failed: 'failed',
  PaymentStatus.reversed: 'reversed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_PaymentAllocation _$PaymentAllocationFromJson(Map<String, dynamic> json) =>
    _PaymentAllocation(
      chargeId: json['chargeId'] as String,
      amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
    );

Map<String, dynamic> _$PaymentAllocationToJson(_PaymentAllocation instance) =>
    <String, dynamic>{
      'chargeId': instance.chargeId,
      'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
    };
