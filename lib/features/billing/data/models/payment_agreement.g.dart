// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_agreement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgreementInstallment _$AgreementInstallmentFromJson(
  Map<String, dynamic> json,
) => _AgreementInstallment(
  number: (json['number'] as num).toInt(),
  dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  paid: json['paid'] as bool? ?? false,
);

Map<String, dynamic> _$AgreementInstallmentToJson(
  _AgreementInstallment instance,
) => <String, dynamic>{
  'number': instance.number,
  'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
  'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
  'paid': instance.paid,
};

_PaymentAgreement _$PaymentAgreementFromJson(
  Map<String, dynamic> json,
) => _PaymentAgreement(
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
  chargeIds: (json['chargeIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
  totalMinor: const MinorUnitConverter().fromJson(json['totalMinor']),
  paidMinor: json['paidMinor'] == null
      ? 0
      : const MinorUnitConverter().fromJson(json['paidMinor']),
  installments: (json['installments'] as List<dynamic>)
      .map((e) => AgreementInstallment.fromJson(e as Map<String, dynamic>))
      .toList(),
  status:
      $enumDecodeNullable(_$AgreementStatusEnumMap, json['status']) ??
      AgreementStatus.active,
);

Map<String, dynamic> _$PaymentAgreementToJson(_PaymentAgreement instance) =>
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
      'studentId': instance.studentId,
      'chargeIds': instance.chargeIds,
      'totalMinor': const MinorUnitConverter().toJson(instance.totalMinor),
      'paidMinor': const MinorUnitConverter().toJson(instance.paidMinor),
      'installments': instance.installments.map((e) => e.toJson()).toList(),
      'status': _$AgreementStatusEnumMap[instance.status]!,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$AgreementStatusEnumMap = {
  AgreementStatus.active: 'active',
  AgreementStatus.completed: 'completed',
  AgreementStatus.broken: 'broken',
  AgreementStatus.cancelled: 'cancelled',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
