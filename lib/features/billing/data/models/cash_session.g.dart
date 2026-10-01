// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cash_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CashSession _$CashSessionFromJson(Map<String, dynamic> json) => _CashSession(
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
  cashRegisterId: json['cashRegisterId'] as String,
  operatorId: json['operatorId'] as String,
  openedAt: const UtcDateTimeConverter().fromJson(json['openedAt'] as String),
  openingMinor: const MinorUnitConverter().fromJson(json['openingMinor']),
  status:
      $enumDecodeNullable(_$CashSessionStatusEnumMap, json['status']) ??
      CashSessionStatus.open,
  closedAt: _$JsonConverterFromJson<String, DateTime>(
    json['closedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  expectedMinor: (json['expectedMinor'] as num?)?.toInt(),
  countedMinor: (json['countedMinor'] as num?)?.toInt(),
  differenceMinor: (json['differenceMinor'] as num?)?.toInt(),
  closingNotes: json['closingNotes'] as String?,
);

Map<String, dynamic> _$CashSessionToJson(_CashSession instance) =>
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
      'cashRegisterId': instance.cashRegisterId,
      'operatorId': instance.operatorId,
      'openedAt': const UtcDateTimeConverter().toJson(instance.openedAt),
      'openingMinor': const MinorUnitConverter().toJson(instance.openingMinor),
      'status': _$CashSessionStatusEnumMap[instance.status]!,
      'closedAt': _$JsonConverterToJson<String, DateTime>(
        instance.closedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'expectedMinor': instance.expectedMinor,
      'countedMinor': instance.countedMinor,
      'differenceMinor': instance.differenceMinor,
      'closingNotes': instance.closingNotes,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$CashSessionStatusEnumMap = {
  CashSessionStatus.open: 'open',
  CashSessionStatus.closed: 'closed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_CashMovement _$CashMovementFromJson(
  Map<String, dynamic> json,
) => _CashMovement(
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
  sessionId: json['sessionId'] as String,
  type: $enumDecode(_$CashMovementTypeEnumMap, json['type']),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  occurredAt: const UtcDateTimeConverter().fromJson(
    json['occurredAt'] as String,
  ),
  description: json['description'] as String?,
  paymentId: json['paymentId'] as String?,
);

Map<String, dynamic> _$CashMovementToJson(_CashMovement instance) =>
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
      'sessionId': instance.sessionId,
      'type': _$CashMovementTypeEnumMap[instance.type]!,
      'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
      'occurredAt': const UtcDateTimeConverter().toJson(instance.occurredAt),
      'description': instance.description,
      'paymentId': instance.paymentId,
    };

const _$CashMovementTypeEnumMap = {
  CashMovementType.cashPayment: 'cash_payment',
  CashMovementType.supply: 'supply',
  CashMovementType.withdrawal: 'withdrawal',
};
