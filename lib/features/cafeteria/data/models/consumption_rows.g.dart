// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'consumption_rows.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConsumptionRow _$ConsumptionRowFromJson(Map<String, dynamic> json) =>
    _ConsumptionRow(
      key: json['key'] as String,
      label: json['label'] as String?,
      purchaseCount: (json['purchaseCount'] as num).toInt(),
      totalMinor: (json['totalMinor'] as num).toInt(),
    );

Map<String, dynamic> _$ConsumptionRowToJson(_ConsumptionRow instance) =>
    <String, dynamic>{
      'key': instance.key,
      'label': instance.label,
      'purchaseCount': instance.purchaseCount,
      'totalMinor': instance.totalMinor,
    };

_PrepaidBalance _$PrepaidBalanceFromJson(Map<String, dynamic> json) =>
    _PrepaidBalance(
      totalBalanceMinor: (json['totalBalanceMinor'] as num).toInt(),
      walletCount: (json['walletCount'] as num).toInt(),
      blockedCount: (json['blockedCount'] as num).toInt(),
    );

Map<String, dynamic> _$PrepaidBalanceToJson(_PrepaidBalance instance) =>
    <String, dynamic>{
      'totalBalanceMinor': instance.totalBalanceMinor,
      'walletCount': instance.walletCount,
      'blockedCount': instance.blockedCount,
    };
