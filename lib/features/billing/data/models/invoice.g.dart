// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Invoice _$InvoiceFromJson(Map<String, dynamic> json) => _Invoice(
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
  number: json['number'] as String?,
  issuedAt: _$JsonConverterFromJson<String, DateTime>(
    json['issuedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  status:
      $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
      InvoiceStatus.draft,
  lines:
      (json['lines'] as List<dynamic>?)
          ?.map((e) => InvoiceLine.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <InvoiceLine>[],
  totalMinor: const MinorUnitConverter().fromJson(json['totalMinor']),
);

Map<String, dynamic> _$InvoiceToJson(_Invoice instance) => <String, dynamic>{
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
  'number': instance.number,
  'issuedAt': _$JsonConverterToJson<String, DateTime>(
    instance.issuedAt,
    const UtcDateTimeConverter().toJson,
  ),
  'status': _$InvoiceStatusEnumMap[instance.status]!,
  'lines': instance.lines.map((e) => e.toJson()).toList(),
  'totalMinor': const MinorUnitConverter().toJson(instance.totalMinor),
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.issued: 'issued',
  InvoiceStatus.cancelled: 'cancelled',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_InvoiceLine _$InvoiceLineFromJson(Map<String, dynamic> json) => _InvoiceLine(
  chargeId: json['chargeId'] as String,
  description: json['description'] as String,
  amountMinor: const MinorUnitConverter().fromJson(json['amountMinor']),
);

Map<String, dynamic> _$InvoiceLineToJson(_InvoiceLine instance) =>
    <String, dynamic>{
      'chargeId': instance.chargeId,
      'description': instance.description,
      'amountMinor': const MinorUnitConverter().toJson(instance.amountMinor),
    };
