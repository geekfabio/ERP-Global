// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TeacherModel _$TeacherModelFromJson(Map<String, dynamic> json) =>
    _TeacherModel(
      id: json['id'] as String,
      employeeNumber: json['employeeNumber'] as String? ?? '',
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      subjectIds:
          (json['subjectIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      classroomIds:
          (json['classroomIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$TeacherModelToJson(_TeacherModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeNumber': instance.employeeNumber,
      'fullName': instance.fullName,
      'email': instance.email,
      'phone': instance.phone,
      'specialty': instance.specialty,
      'subjectIds': instance.subjectIds,
      'classroomIds': instance.classroomIds,
      'isActive': instance.isActive,
    };
