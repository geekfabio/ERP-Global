// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_card_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReportCardStateModel _$ReportCardStateModelFromJson(
  Map<String, dynamic> json,
) => _ReportCardStateModel(
  studentId: json['studentId'] as String,
  termId: json['termId'] as String,
  remarks: json['remarks'] as String? ?? '',
  sentAt: _$JsonConverterFromJson<String, DateTime>(
    json['sentAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  sentToGuardianIds:
      (json['sentToGuardianIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
);

Map<String, dynamic> _$ReportCardStateModelToJson(
  _ReportCardStateModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'termId': instance.termId,
  'remarks': instance.remarks,
  'sentAt': _$JsonConverterToJson<String, DateTime>(
    instance.sentAt,
    const UtcDateTimeConverter().toJson,
  ),
  'sentToGuardianIds': instance.sentToGuardianIds,
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
