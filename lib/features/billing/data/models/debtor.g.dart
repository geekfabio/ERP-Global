// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debtor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Debtor _$DebtorFromJson(Map<String, dynamic> json) => _Debtor(
  studentId: json['studentId'] as String,
  classroomId: json['classroomId'] as String?,
  overdueMinor: const MinorUnitConverter().fromJson(json['overdueMinor']),
  overdueCount: (json['overdueCount'] as num).toInt(),
  oldestDueDate: const DateOnlyConverter().fromJson(
    json['oldestDueDate'] as String,
  ),
  daysOverdue: (json['daysOverdue'] as num).toInt(),
  hasAgreement: json['hasAgreement'] as bool? ?? false,
);

Map<String, dynamic> _$DebtorToJson(_Debtor instance) => <String, dynamic>{
  'studentId': instance.studentId,
  'classroomId': instance.classroomId,
  'overdueMinor': const MinorUnitConverter().toJson(instance.overdueMinor),
  'overdueCount': instance.overdueCount,
  'oldestDueDate': const DateOnlyConverter().toJson(instance.oldestDueDate),
  'daysOverdue': instance.daysOverdue,
  'hasAgreement': instance.hasAgreement,
};
