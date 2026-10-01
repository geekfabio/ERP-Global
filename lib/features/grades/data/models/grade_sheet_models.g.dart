// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade_sheet_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GradeRowModel _$GradeRowModelFromJson(Map<String, dynamic> json) =>
    _GradeRowModel(
      studentId: json['studentId'] as String,
      scores:
          (json['scores'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const <String, double>{},
    );

Map<String, dynamic> _$GradeRowModelToJson(_GradeRowModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'scores': instance.scores,
    };

_GradeSheetModel _$GradeSheetModelFromJson(Map<String, dynamic> json) =>
    _GradeSheetModel(
      classroomId: json['classroomId'] as String,
      subjectId: json['subjectId'] as String,
      termId: json['termId'] as String,
      scheme: AssessmentSchemeModel.fromJson(
        json['scheme'] as Map<String, dynamic>,
      ),
      termClosed: json['termClosed'] as bool? ?? false,
      deadline: json['deadline'] as String?,
      deadlinePassed: json['deadlinePassed'] as bool? ?? false,
      rows:
          (json['rows'] as List<dynamic>?)
              ?.map((e) => GradeRowModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <GradeRowModel>[],
    );

Map<String, dynamic> _$GradeSheetModelToJson(_GradeSheetModel instance) =>
    <String, dynamic>{
      'classroomId': instance.classroomId,
      'subjectId': instance.subjectId,
      'termId': instance.termId,
      'scheme': instance.scheme.toJson(),
      'termClosed': instance.termClosed,
      'deadline': instance.deadline,
      'deadlinePassed': instance.deadlinePassed,
      'rows': instance.rows.map((e) => e.toJson()).toList(),
    };

_GradeChangeModel _$GradeChangeModelFromJson(Map<String, dynamic> json) =>
    _GradeChangeModel(
      id: json['id'] as String,
      classroomId: json['classroomId'] as String,
      subjectId: json['subjectId'] as String,
      termId: json['termId'] as String,
      studentId: json['studentId'] as String,
      componentCode: json['componentCode'] as String,
      before: (json['before'] as num?)?.toDouble(),
      after: (json['after'] as num?)?.toDouble(),
      afterLock: json['afterLock'] as bool? ?? false,
      justification: json['justification'] as String?,
      changedAt: const UtcDateTimeConverter().fromJson(
        json['changedAt'] as String,
      ),
    );

Map<String, dynamic> _$GradeChangeModelToJson(_GradeChangeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classroomId': instance.classroomId,
      'subjectId': instance.subjectId,
      'termId': instance.termId,
      'studentId': instance.studentId,
      'componentCode': instance.componentCode,
      'before': instance.before,
      'after': instance.after,
      'afterLock': instance.afterLock,
      'justification': instance.justification,
      'changedAt': const UtcDateTimeConverter().toJson(instance.changedAt),
    };
