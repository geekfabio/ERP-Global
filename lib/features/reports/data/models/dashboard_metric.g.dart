// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_metric.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DashboardMetric _$DashboardMetricFromJson(Map<String, dynamic> json) =>
    _DashboardMetric(
      widgetId: json['widgetId'] as String,
      value: (json['value'] as num).toInt(),
      previous: (json['previous'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DashboardMetricToJson(_DashboardMetric instance) =>
    <String, dynamic>{
      'widgetId': instance.widgetId,
      'value': instance.value,
      'previous': instance.previous,
    };

_CampusOption _$CampusOptionFromJson(Map<String, dynamic> json) =>
    _CampusOption(id: json['id'] as String, name: json['name'] as String);

Map<String, dynamic> _$CampusOptionToJson(_CampusOption instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
