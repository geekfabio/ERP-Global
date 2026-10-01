// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'credit_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CreditNote _$CreditNoteFromJson(Map<String, dynamic> json) => _CreditNote(
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
  invoiceId: json['invoiceId'] as String,
  number: json['number'] as String,
  series: json['series'] as String,
  issuedAt: const UtcDateTimeConverter().fromJson(json['issuedAt'] as String),
  reason: json['reason'] as String,
  totalMinor: const MinorUnitConverter().fromJson(json['totalMinor']),
);

Map<String, dynamic> _$CreditNoteToJson(_CreditNote instance) =>
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
      'invoiceId': instance.invoiceId,
      'number': instance.number,
      'series': instance.series,
      'issuedAt': const UtcDateTimeConverter().toJson(instance.issuedAt),
      'reason': instance.reason,
      'totalMinor': const MinorUnitConverter().toJson(instance.totalMinor),
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
