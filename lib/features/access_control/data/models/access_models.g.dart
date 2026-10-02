// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'access_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ZoneModel _$ZoneModelFromJson(Map<String, dynamic> json) => _ZoneModel(
  id: json['id'] as String,
  campusId: json['campusId'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ZoneModelToJson(_ZoneModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'campusId': instance.campusId,
      'name': instance.name,
      'description': instance.description,
      'isActive': instance.isActive,
    };

_AccessDeviceModel _$AccessDeviceModelFromJson(Map<String, dynamic> json) =>
    _AccessDeviceModel(
      id: json['id'] as String,
      zoneId: json['zoneId'] as String,
      name: json['name'] as String,
      kind:
          $enumDecodeNullable(_$DeviceKindEnumMap, json['kind']) ??
          DeviceKind.reader,
      status:
          $enumDecodeNullable(_$DeviceStatusEnumMap, json['status']) ??
          DeviceStatus.online,
      isActive: json['isActive'] as bool? ?? true,
      lastSeenAt: _$JsonConverterFromJson<String, DateTime>(
        json['lastSeenAt'],
        const UtcDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$AccessDeviceModelToJson(_AccessDeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'zoneId': instance.zoneId,
      'name': instance.name,
      'kind': _$DeviceKindEnumMap[instance.kind]!,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'isActive': instance.isActive,
      'lastSeenAt': _$JsonConverterToJson<String, DateTime>(
        instance.lastSeenAt,
        const UtcDateTimeConverter().toJson,
      ),
    };

const _$DeviceKindEnumMap = {
  DeviceKind.turnstile: 'turnstile',
  DeviceKind.reader: 'reader',
  DeviceKind.door: 'door',
};

const _$DeviceStatusEnumMap = {
  DeviceStatus.online: 'online',
  DeviceStatus.offline: 'offline',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_AccessRuleModel _$AccessRuleModelFromJson(Map<String, dynamic> json) =>
    _AccessRuleModel(
      id: json['id'] as String,
      zoneId: json['zoneId'] as String,
      name: json['name'] as String,
      subject:
          $enumDecodeNullable(_$AccessSubjectEnumMap, json['subject']) ??
          AccessSubject.all,
      days: (json['days'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      startMinute: (json['startMinute'] as num).toInt(),
      endMinute: (json['endMinute'] as num).toInt(),
      requireActiveStudent: json['requireActiveStudent'] as bool? ?? false,
      requireFinancialClear: json['requireFinancialClear'] as bool? ?? false,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$AccessRuleModelToJson(_AccessRuleModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'zoneId': instance.zoneId,
      'name': instance.name,
      'subject': _$AccessSubjectEnumMap[instance.subject]!,
      'days': instance.days,
      'startMinute': instance.startMinute,
      'endMinute': instance.endMinute,
      'requireActiveStudent': instance.requireActiveStudent,
      'requireFinancialClear': instance.requireFinancialClear,
      'isActive': instance.isActive,
    };

const _$AccessSubjectEnumMap = {
  AccessSubject.all: 'all',
  AccessSubject.student: 'student',
  AccessSubject.staff: 'staff',
  AccessSubject.guardian: 'guardian',
};
