// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assessment_scheme_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssessmentComponentModel _$AssessmentComponentModelFromJson(
  Map<String, dynamic> json,
) => _AssessmentComponentModel(
  code: json['code'] as String,
  name: json['name'] as String,
  weight: (json['weight'] as num).toInt(),
);

Map<String, dynamic> _$AssessmentComponentModelToJson(
  _AssessmentComponentModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
  'weight': instance.weight,
};

_AssessmentSchemeModel _$AssessmentSchemeModelFromJson(
  Map<String, dynamic> json,
) => _AssessmentSchemeModel(
  id: json['id'] as String,
  name: json['name'] as String,
  gradeId: json['gradeId'] as String?,
  courseId: json['courseId'] as String?,
  scaleMax: (json['scaleMax'] as num?)?.toInt() ?? 20,
  minPassing: (json['minPassing'] as num?)?.toInt() ?? 10,
  rounding:
      $enumDecodeNullable(_$RoundingModeEnumMap, json['rounding']) ??
      RoundingMode.nearest,
  decimals: (json['decimals'] as num?)?.toInt() ?? 0,
  roundTerm: json['roundTerm'] as bool? ?? true,
  components:
      (json['components'] as List<dynamic>?)
          ?.map(
            (e) => AssessmentComponentModel.fromJson(e as Map<String, dynamic>),
          )
          .toList() ??
      const <AssessmentComponentModel>[],
  termWeights:
      (json['termWeights'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      const <int>[],
);

Map<String, dynamic> _$AssessmentSchemeModelToJson(
  _AssessmentSchemeModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'gradeId': instance.gradeId,
  'courseId': instance.courseId,
  'scaleMax': instance.scaleMax,
  'minPassing': instance.minPassing,
  'rounding': _$RoundingModeEnumMap[instance.rounding]!,
  'decimals': instance.decimals,
  'roundTerm': instance.roundTerm,
  'components': instance.components.map((e) => e.toJson()).toList(),
  'termWeights': instance.termWeights,
};

const _$RoundingModeEnumMap = {
  RoundingMode.nearest: 'nearest',
  RoundingMode.up: 'up',
  RoundingMode.down: 'down',
};
