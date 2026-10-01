// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_rows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RevenueRow _$RevenueRowFromJson(Map<String, dynamic> json) => _RevenueRow(
  key: json['key'] as String,
  receivedMinor: const MinorUnitConverter().fromJson(json['receivedMinor']),
  allocationCount: (json['allocationCount'] as num).toInt(),
);

Map<String, dynamic> _$RevenueRowToJson(
  _RevenueRow instance,
) => <String, dynamic>{
  'key': instance.key,
  'receivedMinor': const MinorUnitConverter().toJson(instance.receivedMinor),
  'allocationCount': instance.allocationCount,
};

_ForecastRow _$ForecastRowFromJson(Map<String, dynamic> json) => _ForecastRow(
  period: json['period'] as String,
  expectedMinor: const MinorUnitConverter().fromJson(json['expectedMinor']),
  receivedMinor: const MinorUnitConverter().fromJson(json['receivedMinor']),
  chargeCount: (json['chargeCount'] as num).toInt(),
);

Map<String, dynamic> _$ForecastRowToJson(
  _ForecastRow instance,
) => <String, dynamic>{
  'period': instance.period,
  'expectedMinor': const MinorUnitConverter().toJson(instance.expectedMinor),
  'receivedMinor': const MinorUnitConverter().toJson(instance.receivedMinor),
  'chargeCount': instance.chargeCount,
};
