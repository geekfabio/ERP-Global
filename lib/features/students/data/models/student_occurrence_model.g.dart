// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_occurrence_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StudentOccurrenceModel _$StudentOccurrenceModelFromJson(
  Map<String, dynamic> json,
) => _StudentOccurrenceModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  studentId: json['studentId'] as String,
  type: $enumDecode(_$OccurrenceTypeEnumMap, json['type']),
  occurredOn: const DateOnlyConverter().fromJson(json['occurredOn'] as String),
  title: json['title'] as String,
  description: json['description'] as String?,
  reportedBy: json['reportedBy'] as String?,
);

Map<String, dynamic> _$StudentOccurrenceModelToJson(
  _StudentOccurrenceModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'institutionId': instance.institutionId,
  'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
  'deletedAt': _$JsonConverterToJson<String, DateTime>(
    instance.deletedAt,
    const UtcDateTimeConverter().toJson,
  ),
  'syncState': instance.syncState,
  'studentId': instance.studentId,
  'type': _$OccurrenceTypeEnumMap[instance.type]!,
  'occurredOn': const DateOnlyConverter().toJson(instance.occurredOn),
  'title': instance.title,
  'description': instance.description,
  'reportedBy': instance.reportedBy,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$OccurrenceTypeEnumMap = {
  OccurrenceType.praise: 'praise',
  OccurrenceType.warning: 'warning',
  OccurrenceType.incident: 'incident',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
