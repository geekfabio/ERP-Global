// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agenda_event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgendaEventModel _$AgendaEventModelFromJson(
  Map<String, dynamic> json,
) => _AgendaEventModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  title: json['title'] as String,
  description: json['description'] as String?,
  type: $enumDecode(_$AgendaEventTypeEnumMap, json['type']),
  startsAt: const UtcDateTimeConverter().fromJson(json['startsAt'] as String),
  endsAt: _$JsonConverterFromJson<String, DateTime>(
    json['endsAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  allDay: json['allDay'] as bool? ?? false,
  classroomId: json['classroomId'] as String?,
  location: json['location'] as String?,
);

Map<String, dynamic> _$AgendaEventModelToJson(_AgendaEventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'title': instance.title,
      'description': instance.description,
      'type': _$AgendaEventTypeEnumMap[instance.type]!,
      'startsAt': const UtcDateTimeConverter().toJson(instance.startsAt),
      'endsAt': _$JsonConverterToJson<String, DateTime>(
        instance.endsAt,
        const UtcDateTimeConverter().toJson,
      ),
      'allDay': instance.allDay,
      'classroomId': instance.classroomId,
      'location': instance.location,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$AgendaEventTypeEnumMap = {
  AgendaEventType.holiday: 'holiday',
  AgendaEventType.exam: 'exam',
  AgendaEventType.meeting: 'meeting',
  AgendaEventType.deadline: 'deadline',
  AgendaEventType.event: 'event',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
