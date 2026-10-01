// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_notice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PaymentNotice _$PaymentNoticeFromJson(
  Map<String, dynamic> json,
) => _PaymentNotice(
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
  chargeId: json['chargeId'] as String,
  kind: $enumDecode(_$NoticeKindEnumMap, json['kind']),
  dueDate: const DateOnlyConverter().fromJson(json['dueDate'] as String),
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
  message: json['message'] as String,
  sentAt: const UtcDateTimeConverter().fromJson(json['sentAt'] as String),
);

Map<String, dynamic> _$PaymentNoticeToJson(_PaymentNotice instance) =>
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
      'chargeId': instance.chargeId,
      'kind': _$NoticeKindEnumMap[instance.kind]!,
      'dueDate': const DateOnlyConverter().toJson(instance.dueDate),
      'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
      'message': instance.message,
      'sentAt': const UtcDateTimeConverter().toJson(instance.sentAt),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$NoticeKindEnumMap = {
  NoticeKind.preDue: 'pre_due',
  NoticeKind.postDue: 'post_due',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
