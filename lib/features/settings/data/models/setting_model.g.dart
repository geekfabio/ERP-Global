// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'setting_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingModel _$SettingModelFromJson(Map<String, dynamic> json) =>
    _SettingModel(
      key: json['key'] as String,
      module: $enumDecode(_$SettingModuleEnumMap, json['module']),
      type: $enumDecode(_$SettingTypeEnumMap, json['type']),
      value: json['value'] as Object,
      min: (json['min'] as num?)?.toInt(),
      max: (json['max'] as num?)?.toInt(),
      options:
          (json['options'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$SettingModelToJson(_SettingModel instance) =>
    <String, dynamic>{
      'key': instance.key,
      'module': _$SettingModuleEnumMap[instance.module]!,
      'type': _$SettingTypeEnumMap[instance.type]!,
      'value': instance.value,
      'min': instance.min,
      'max': instance.max,
      'options': instance.options,
    };

const _$SettingModuleEnumMap = {
  SettingModule.academic: 'academic',
  SettingModule.finance: 'finance',
  SettingModule.tax: 'tax',
};

const _$SettingTypeEnumMap = {
  SettingType.integer: 'integer',
  SettingType.boolean: 'boolean',
  SettingType.text: 'text',
  SettingType.choice: 'choice',
};
