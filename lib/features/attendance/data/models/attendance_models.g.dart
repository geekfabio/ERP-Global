// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceRecordModel(
  id: json['id'] as String? ?? '',
  classroomId: json['classroomId'] as String,
  studentId: json['studentId'] as String,
  date: json['date'] as String,
  lessonSlotId: json['lessonSlotId'] as String?,
  status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
  justification: json['justification'] as String?,
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  _AttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'classroomId': instance.classroomId,
  'studentId': instance.studentId,
  'date': instance.date,
  'lessonSlotId': instance.lessonSlotId,
  'status': _$AttendanceStatusEnumMap[instance.status]!,
  'justification': instance.justification,
};

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.late: 'late',
  AttendanceStatus.absent: 'absent',
};

_AttendanceSheetModel _$AttendanceSheetModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceSheetModel(
  classroomId: json['classroomId'] as String,
  date: json['date'] as String,
  lessonSlotId: json['lessonSlotId'] as String?,
  rows:
      (json['rows'] as List<dynamic>?)
          ?.map(
            (e) => AttendanceRecordModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <AttendanceRecordModel>[],
);

Map<String, dynamic> _$AttendanceSheetModelToJson(
  _AttendanceSheetModel instance,
) => <String, dynamic>{
  'classroomId': instance.classroomId,
  'date': instance.date,
  'lessonSlotId': instance.lessonSlotId,
  'rows': instance.rows.map((e) => e.toJson()).toList(),
};

_AttendanceSettingsModel _$AttendanceSettingsModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceSettingsModel(
  absenceLimit: (json['absenceLimit'] as num?)?.toInt() ?? 10,
);

Map<String, dynamic> _$AttendanceSettingsModelToJson(
  _AttendanceSettingsModel instance,
) => <String, dynamic>{'absenceLimit': instance.absenceLimit};

_AttendanceAlertModel _$AttendanceAlertModelFromJson(
  Map<String, dynamic> json,
) => _AttendanceAlertModel(
  studentId: json['studentId'] as String,
  classroomId: json['classroomId'] as String,
  unjustified: (json['unjustified'] as num).toInt(),
  limit: (json['limit'] as num).toInt(),
);

Map<String, dynamic> _$AttendanceAlertModelToJson(
  _AttendanceAlertModel instance,
) => <String, dynamic>{
  'studentId': instance.studentId,
  'classroomId': instance.classroomId,
  'unjustified': instance.unjustified,
  'limit': instance.limit,
};
