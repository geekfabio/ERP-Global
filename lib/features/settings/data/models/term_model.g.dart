// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'term_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TermModel _$TermModelFromJson(Map<String, dynamic> json) => _TermModel(
  id: json['id'] as String,
  academicYearId: json['academicYearId'] as String,
  name: json['name'] as String,
  order: (json['order'] as num).toInt(),
  startDate: const DateOnlyConverter().fromJson(json['startDate'] as String),
  endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
  gradesDeadline: const DateOnlyConverter().fromJson(
    json['gradesDeadline'] as String,
  ),
  status: $enumDecode(_$TermStatusEnumMap, json['status']),
  closedAt: _$JsonConverterFromJson<String, DateTime>(
    json['closedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$TermModelToJson(
  _TermModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'academicYearId': instance.academicYearId,
  'name': instance.name,
  'order': instance.order,
  'startDate': const DateOnlyConverter().toJson(instance.startDate),
  'endDate': const DateOnlyConverter().toJson(instance.endDate),
  'gradesDeadline': const DateOnlyConverter().toJson(instance.gradesDeadline),
  'status': _$TermStatusEnumMap[instance.status]!,
  'closedAt': _$JsonConverterToJson<String, DateTime>(
    instance.closedAt,
    const UtcDateTimeConverter().toJson,
  ),
};

const _$TermStatusEnumMap = {
  TermStatus.open: 'open',
  TermStatus.closed: 'closed',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
