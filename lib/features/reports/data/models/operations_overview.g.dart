// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operations_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LabeledCount _$LabeledCountFromJson(Map<String, dynamic> json) =>
    _LabeledCount(
      label: json['label'] as String,
      count: (json['count'] as num).toInt(),
    );

Map<String, dynamic> _$LabeledCountToJson(_LabeledCount instance) =>
    <String, dynamic>{'label': instance.label, 'count': instance.count};

_CafeteriaOverview _$CafeteriaOverviewFromJson(Map<String, dynamic> json) =>
    _CafeteriaOverview(
      meals: (json['meals'] as num).toInt(),
      revenue: (json['revenue'] as num).toInt(),
      prepaidBalance: (json['prepaidBalance'] as num).toInt(),
      lowBalanceCards: (json['lowBalanceCards'] as num).toInt(),
      byMeal: (json['byMeal'] as List<dynamic>)
          .map((e) => LabeledCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CafeteriaOverviewToJson(_CafeteriaOverview instance) =>
    <String, dynamic>{
      'meals': instance.meals,
      'revenue': instance.revenue,
      'prepaidBalance': instance.prepaidBalance,
      'lowBalanceCards': instance.lowBalanceCards,
      'byMeal': instance.byMeal,
    };

_HourlyAccess _$HourlyAccessFromJson(Map<String, dynamic> json) =>
    _HourlyAccess(
      hour: (json['hour'] as num).toInt(),
      entries: (json['entries'] as num).toInt(),
      exits: (json['exits'] as num).toInt(),
    );

Map<String, dynamic> _$HourlyAccessToJson(_HourlyAccess instance) =>
    <String, dynamic>{
      'hour': instance.hour,
      'entries': instance.entries,
      'exits': instance.exits,
    };

_AccessOverview _$AccessOverviewFromJson(Map<String, dynamic> json) =>
    _AccessOverview(
      entries: (json['entries'] as num).toInt(),
      exits: (json['exits'] as num).toInt(),
      denied: (json['denied'] as num).toInt(),
      byHour: (json['byHour'] as List<dynamic>)
          .map((e) => HourlyAccess.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AccessOverviewToJson(_AccessOverview instance) =>
    <String, dynamic>{
      'entries': instance.entries,
      'exits': instance.exits,
      'denied': instance.denied,
      'byHour': instance.byHour,
    };

_HrOverview _$HrOverviewFromJson(Map<String, dynamic> json) => _HrOverview(
  activeStaff: (json['activeStaff'] as num).toInt(),
  onLeave: (json['onLeave'] as num).toInt(),
  contractsExpiring: (json['contractsExpiring'] as num).toInt(),
  teachersWithoutContract: (json['teachersWithoutContract'] as num).toInt(),
  byRole: (json['byRole'] as List<dynamic>)
      .map((e) => LabeledCount.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HrOverviewToJson(_HrOverview instance) =>
    <String, dynamic>{
      'activeStaff': instance.activeStaff,
      'onLeave': instance.onLeave,
      'contractsExpiring': instance.contractsExpiring,
      'teachersWithoutContract': instance.teachersWithoutContract,
      'byRole': instance.byRole,
    };

_SecretariatOverview _$SecretariatOverviewFromJson(Map<String, dynamic> json) =>
    _SecretariatOverview(
      totalPending: (json['totalPending'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => LabeledCount.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SecretariatOverviewToJson(
  _SecretariatOverview instance,
) => <String, dynamic>{
  'totalPending': instance.totalPending,
  'items': instance.items,
};

_OperationsOverview _$OperationsOverviewFromJson(Map<String, dynamic> json) =>
    _OperationsOverview(
      cafeteria: json['cafeteria'] == null
          ? null
          : CafeteriaOverview.fromJson(
              json['cafeteria'] as Map<String, dynamic>,
            ),
      access: json['access'] == null
          ? null
          : AccessOverview.fromJson(json['access'] as Map<String, dynamic>),
      hr: json['hr'] == null
          ? null
          : HrOverview.fromJson(json['hr'] as Map<String, dynamic>),
      secretariat: json['secretariat'] == null
          ? null
          : SecretariatOverview.fromJson(
              json['secretariat'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$OperationsOverviewToJson(_OperationsOverview instance) =>
    <String, dynamic>{
      'cafeteria': instance.cafeteria,
      'access': instance.access,
      'hr': instance.hr,
      'secretariat': instance.secretariat,
    };
