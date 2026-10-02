// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AcademicTotals _$AcademicTotalsFromJson(Map<String, dynamic> json) =>
    _AcademicTotals(
      enrolled: (json['enrolled'] as num).toInt(),
      active: (json['active'] as num).toInt(),
      occupancy: (json['occupancy'] as num).toInt(),
      approvalRate: (json['approvalRate'] as num?)?.toInt(),
      attendanceRate: (json['attendanceRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AcademicTotalsToJson(_AcademicTotals instance) =>
    <String, dynamic>{
      'enrolled': instance.enrolled,
      'active': instance.active,
      'occupancy': instance.occupancy,
      'approvalRate': instance.approvalRate,
      'attendanceRate': instance.attendanceRate,
    };

_AcademicGradeRow _$AcademicGradeRowFromJson(Map<String, dynamic> json) =>
    _AcademicGradeRow(
      gradeId: json['gradeId'] as String,
      label: json['label'] as String,
      enrolled: (json['enrolled'] as num).toInt(),
      active: (json['active'] as num).toInt(),
      capacity: (json['capacity'] as num).toInt(),
      occupancy: (json['occupancy'] as num).toInt(),
      approvalRate: (json['approvalRate'] as num?)?.toInt(),
      attendanceRate: (json['attendanceRate'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AcademicGradeRowToJson(_AcademicGradeRow instance) =>
    <String, dynamic>{
      'gradeId': instance.gradeId,
      'label': instance.label,
      'enrolled': instance.enrolled,
      'active': instance.active,
      'capacity': instance.capacity,
      'occupancy': instance.occupancy,
      'approvalRate': instance.approvalRate,
      'attendanceRate': instance.attendanceRate,
    };

_AcademicOverview _$AcademicOverviewFromJson(Map<String, dynamic> json) =>
    _AcademicOverview(
      totals: AcademicTotals.fromJson(json['totals'] as Map<String, dynamic>),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => AcademicGradeRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      previous: json['previous'] == null
          ? null
          : AcademicTotals.fromJson(json['previous'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AcademicOverviewToJson(_AcademicOverview instance) =>
    <String, dynamic>{
      'totals': instance.totals,
      'rows': instance.rows,
      'previous': instance.previous,
    };
