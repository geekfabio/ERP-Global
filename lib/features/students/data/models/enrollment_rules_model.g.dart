// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_rules_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnrollmentRulesModel _$EnrollmentRulesModelFromJson(
  Map<String, dynamic> json,
) => _EnrollmentRulesModel(
  minAgeYears: (json['minAgeYears'] as num?)?.toInt() ?? 0,
  capacityPerClassroom: (json['capacityPerClassroom'] as num?)?.toInt() ?? 0,
  requireVerifiedDocuments: json['requireVerifiedDocuments'] as bool? ?? true,
  requiredDocuments:
      (json['requiredDocuments'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(
          k,
          (e as List<dynamic>)
              .map((e) => $enumDecode(_$StudentDocumentTypeEnumMap, e))
              .toList(),
        ),
      ) ??
      const <String, List<StudentDocumentType>>{},
);

Map<String, dynamic> _$EnrollmentRulesModelToJson(
  _EnrollmentRulesModel instance,
) => <String, dynamic>{
  'minAgeYears': instance.minAgeYears,
  'capacityPerClassroom': instance.capacityPerClassroom,
  'requireVerifiedDocuments': instance.requireVerifiedDocuments,
  'requiredDocuments': instance.requiredDocuments.map(
    (k, e) =>
        MapEntry(k, e.map((e) => _$StudentDocumentTypeEnumMap[e]!).toList()),
  ),
};

const _$StudentDocumentTypeEnumMap = {
  StudentDocumentType.idCard: 'id_card',
  StudentDocumentType.birthCertificate: 'birth_certificate',
  StudentDocumentType.passport: 'passport',
  StudentDocumentType.previousCertificate: 'previous_certificate',
  StudentDocumentType.vaccination: 'vaccination',
  StudentDocumentType.photo: 'photo',
  StudentDocumentType.contract: 'contract',
  StudentDocumentType.other: 'other',
};

_ClassroomVacancy _$ClassroomVacancyFromJson(Map<String, dynamic> json) =>
    _ClassroomVacancy(
      classroomId: json['classroomId'] as String,
      capacity: (json['capacity'] as num).toInt(),
      occupied: (json['occupied'] as num).toInt(),
    );

Map<String, dynamic> _$ClassroomVacancyToJson(_ClassroomVacancy instance) =>
    <String, dynamic>{
      'classroomId': instance.classroomId,
      'capacity': instance.capacity,
      'occupied': instance.occupied,
    };
