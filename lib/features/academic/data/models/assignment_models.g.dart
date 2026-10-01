// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeachingAssignmentModel _$TeachingAssignmentModelFromJson(
  Map<String, dynamic> json,
) => _TeachingAssignmentModel(
  id: json['id'] as String,
  academicYearId: json['academicYearId'] as String? ?? '',
  teacherId: json['teacherId'] as String,
  classroomId: json['classroomId'] as String,
  subjectId: json['subjectId'] as String,
  weeklyHours: (json['weeklyHours'] as num).toInt(),
  role:
      $enumDecodeNullable(_$AssignmentRoleEnumMap, json['role']) ??
      AssignmentRole.titular,
  validFrom: json['validFrom'] as String?,
  validUntil: json['validUntil'] as String?,
);

Map<String, dynamic> _$TeachingAssignmentModelToJson(
  _TeachingAssignmentModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'academicYearId': instance.academicYearId,
  'teacherId': instance.teacherId,
  'classroomId': instance.classroomId,
  'subjectId': instance.subjectId,
  'weeklyHours': instance.weeklyHours,
  'role': _$AssignmentRoleEnumMap[instance.role]!,
  'validFrom': instance.validFrom,
  'validUntil': instance.validUntil,
};

const _$AssignmentRoleEnumMap = {
  AssignmentRole.titular: 'titular',
  AssignmentRole.substitute: 'substitute',
};

_HomeroomModel _$HomeroomModelFromJson(Map<String, dynamic> json) =>
    _HomeroomModel(
      id: json['id'] as String,
      classroomId: json['classroomId'] as String,
      teacherId: json['teacherId'] as String,
    );

Map<String, dynamic> _$HomeroomModelToJson(_HomeroomModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'teacherId': instance.teacherId,
    };
