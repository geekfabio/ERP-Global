// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'academic_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LevelModel _$LevelModelFromJson(Map<String, dynamic> json) => _LevelModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$LevelModelToJson(_LevelModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'order': instance.order,
    };

_GradeModel _$GradeModelFromJson(Map<String, dynamic> json) => _GradeModel(
  id: json['id'] as String,
  levelId: json['levelId'] as String,
  name: json['name'] as String,
  order: (json['order'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$GradeModelToJson(_GradeModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'levelId': instance.levelId,
      'name': instance.name,
      'order': instance.order,
    };

_CourseModel _$CourseModelFromJson(Map<String, dynamic> json) => _CourseModel(
  id: json['id'] as String,
  code: json['code'] as String,
  name: json['name'] as String,
  levelIds:
      (json['levelIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  isActive: json['isActive'] as bool? ?? true,
);

Map<String, dynamic> _$CourseModelToJson(_CourseModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'levelIds': instance.levelIds,
      'isActive': instance.isActive,
    };

_SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) =>
    _SubjectModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$SubjectModelToJson(_SubjectModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'isActive': instance.isActive,
    };

_CurriculumItemModel _$CurriculumItemModelFromJson(Map<String, dynamic> json) =>
    _CurriculumItemModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      gradeId: json['gradeId'] as String,
      subjectId: json['subjectId'] as String,
      weeklyHours: (json['weeklyHours'] as num).toInt(),
    );

Map<String, dynamic> _$CurriculumItemModelToJson(
  _CurriculumItemModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'courseId': instance.courseId,
  'gradeId': instance.gradeId,
  'subjectId': instance.subjectId,
  'weeklyHours': instance.weeklyHours,
};
