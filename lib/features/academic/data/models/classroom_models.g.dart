// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'classroom_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RoomModel _$RoomModelFromJson(Map<String, dynamic> json) => _RoomModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  capacity: (json['capacity'] as num).toInt(),
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$RoomModelToJson(_RoomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'capacity': instance.capacity,
      'isActive': instance.isActive,
    };

_ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => _ShiftModel(
  id: json['id'] as String,
  name: json['name'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$ShiftModelToJson(_ShiftModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'isActive': instance.isActive,
    };

_ClassroomModel _$ClassroomModelFromJson(Map<String, dynamic> json) =>
    _ClassroomModel(
      id: json['id'] as String,
      academicYearId: json['academicYearId'] as String,
      gradeId: json['gradeId'] as String,
      courseId: json['courseId'] as String,
      shiftId: json['shiftId'] as String,
      roomId: json['roomId'] as String,
      name: json['name'] as String,
      capacity: (json['capacity'] as num).toInt(),
      enrolledCount: (json['enrolledCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$ClassroomModelToJson(_ClassroomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'academicYearId': instance.academicYearId,
      'gradeId': instance.gradeId,
      'courseId': instance.courseId,
      'shiftId': instance.shiftId,
      'roomId': instance.roomId,
      'name': instance.name,
      'capacity': instance.capacity,
      'enrolledCount': instance.enrolledCount,
    };
