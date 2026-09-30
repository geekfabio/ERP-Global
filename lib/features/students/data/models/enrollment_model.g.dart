// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'enrollment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_EnrollmentModel _$EnrollmentModelFromJson(
  Map<String, dynamic> json,
) => _EnrollmentModel(
  id: json['id'] as String,
  institutionId: json['institutionId'] as String,
  campusId: json['campusId'] as String?,
  createdAt: const UtcDateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const UtcDateTimeConverter().fromJson(json['updatedAt'] as String),
  deletedAt: _$JsonConverterFromJson<String, DateTime>(
    json['deletedAt'],
    const UtcDateTimeConverter().fromJson,
  ),
  syncState: json['syncState'] as String? ?? 'synced',
  studentId: json['studentId'] as String,
  academicYearId: json['academicYearId'] as String,
  gradeId: json['gradeId'] as String,
  classroomId: json['classroomId'] as String?,
  shiftId: json['shiftId'] as String?,
  rollNumber: (json['rollNumber'] as num?)?.toInt(),
  type: $enumDecode(_$EnrollmentTypeEnumMap, json['type']),
  status:
      $enumDecodeNullable(_$EnrollmentStatusEnumMap, json['status']) ??
      EnrollmentStatus.pending,
  enrolledOn: const DateOnlyConverter().fromJson(json['enrolledOn'] as String),
  feeMinor: (json['feeMinor'] as num?)?.toInt() ?? 0,
  feePaid: json['feePaid'] as bool? ?? false,
  notes: json['notes'] as String?,
);

Map<String, dynamic> _$EnrollmentModelToJson(_EnrollmentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'institutionId': instance.institutionId,
      'campusId': instance.campusId,
      'createdAt': const UtcDateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const UtcDateTimeConverter().toJson(instance.updatedAt),
      'deletedAt': _$JsonConverterToJson<String, DateTime>(
        instance.deletedAt,
        const UtcDateTimeConverter().toJson,
      ),
      'syncState': instance.syncState,
      'studentId': instance.studentId,
      'academicYearId': instance.academicYearId,
      'gradeId': instance.gradeId,
      'classroomId': instance.classroomId,
      'shiftId': instance.shiftId,
      'rollNumber': instance.rollNumber,
      'type': _$EnrollmentTypeEnumMap[instance.type]!,
      'status': _$EnrollmentStatusEnumMap[instance.status]!,
      'enrolledOn': const DateOnlyConverter().toJson(instance.enrolledOn),
      'feeMinor': instance.feeMinor,
      'feePaid': instance.feePaid,
      'notes': instance.notes,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

const _$EnrollmentTypeEnumMap = {
  EnrollmentType.newEnrollment: 'new_enrollment',
  EnrollmentType.renewal: 'renewal',
  EnrollmentType.transfer: 'transfer',
  EnrollmentType.reentry: 'reentry',
};

const _$EnrollmentStatusEnumMap = {
  EnrollmentStatus.pending: 'pending',
  EnrollmentStatus.confirmed: 'confirmed',
  EnrollmentStatus.cancelled: 'cancelled',
  EnrollmentStatus.completed: 'completed',
};

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
