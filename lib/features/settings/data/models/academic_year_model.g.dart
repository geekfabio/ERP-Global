// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_year_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AcademicYearModel _$AcademicYearModelFromJson(Map<String, dynamic> json) =>
    _AcademicYearModel(
      id: json['id'] as String,
      institutionId: json['institutionId'] as String,
      campusId: json['campusId'] as String,
      code: json['code'] as String,
      startDate: const DateOnlyConverter().fromJson(
        json['startDate'] as String,
      ),
      endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
      status: $enumDecode(_$AcademicYearStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$AcademicYearModelToJson(_AcademicYearModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'campusId': instance.campusId,
      'code': instance.code,
      'startDate': const DateOnlyConverter().toJson(instance.startDate),
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'status': _$AcademicYearStatusEnumMap[instance.status]!,
    };

const _$AcademicYearStatusEnumMap = {
  AcademicYearStatus.planned: 'planned',
  AcademicYearStatus.active: 'active',
  AcademicYearStatus.closing: 'closing',
  AcademicYearStatus.closed: 'closed',
};
