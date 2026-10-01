// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'finance_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FinanceTotals _$FinanceTotalsFromJson(Map<String, dynamic> json) =>
    _FinanceTotals(
      collected: (json['collected'] as num).toInt(),
      expected: (json['expected'] as num).toInt(),
      debt: (json['debt'] as num).toInt(),
      defaultRate: (json['defaultRate'] as num).toInt(),
      receivables: (json['receivables'] as num?)?.toInt(),
      payables: (json['payables'] as num?)?.toInt(),
      result: (json['result'] as num?)?.toInt(),
    );

Map<String, dynamic> _$FinanceTotalsToJson(_FinanceTotals instance) =>
    <String, dynamic>{
      'collected': instance.collected,
      'expected': instance.expected,
      'debt': instance.debt,
      'defaultRate': instance.defaultRate,
      'receivables': instance.receivables,
      'payables': instance.payables,
      'result': instance.result,
    };

_FinanceMonthRow _$FinanceMonthRowFromJson(Map<String, dynamic> json) =>
    _FinanceMonthRow(
      month: json['month'] as String,
      label: json['label'] as String,
      expected: (json['expected'] as num).toInt(),
      collected: (json['collected'] as num).toInt(),
      debt: (json['debt'] as num).toInt(),
    );

Map<String, dynamic> _$FinanceMonthRowToJson(_FinanceMonthRow instance) =>
    <String, dynamic>{
      'month': instance.month,
      'label': instance.label,
      'expected': instance.expected,
      'collected': instance.collected,
      'debt': instance.debt,
    };

_FinanceOverview _$FinanceOverviewFromJson(Map<String, dynamic> json) =>
    _FinanceOverview(
      totals: FinanceTotals.fromJson(json['totals'] as Map<String, dynamic>),
      rows: (json['rows'] as List<dynamic>)
          .map((e) => FinanceMonthRow.fromJson(e as Map<String, dynamic>))
          .toList(),
      previous: json['previous'] == null
          ? null
          : FinanceTotals.fromJson(json['previous'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FinanceOverviewToJson(_FinanceOverview instance) =>
    <String, dynamic>{
      'totals': instance.totals,
      'rows': instance.rows,
      'previous': instance.previous,
    };
