// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScheduleSlotModel _$ScheduleSlotModelFromJson(Map<String, dynamic> json) =>
    _ScheduleSlotModel(
      id: json['id'] as String,
      academicYearId: json['academicYearId'] as String? ?? '',
      classroomId: json['classroomId'] as String,
      subjectId: json['subjectId'] as String,
      teacherId: json['teacherId'] as String,
      roomId: json['roomId'] as String,
      weekday: (json['weekday'] as num).toInt(),
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
    );

Map<String, dynamic> _$ScheduleSlotModelToJson(_ScheduleSlotModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'academicYearId': instance.academicYearId,
      'classroomId': instance.classroomId,
      'subjectId': instance.subjectId,
      'teacherId': instance.teacherId,
      'roomId': instance.roomId,
      'weekday': instance.weekday,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
    };
