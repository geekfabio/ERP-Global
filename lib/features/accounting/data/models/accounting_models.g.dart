// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'accounting_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountModel _$AccountModelFromJson(Map<String, dynamic> json) =>
    _AccountModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      type: $enumDecode(_$AccountTypeEnumMap, json['type']),
      parentId: json['parentId'] as String?,
      postable: json['postable'] as bool? ?? true,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$AccountModelToJson(_AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'type': _$AccountTypeEnumMap[instance.type]!,
      'parentId': instance.parentId,
      'postable': instance.postable,
      'isActive': instance.isActive,
    };

const _$AccountTypeEnumMap = {
  AccountType.asset: 'asset',
  AccountType.liability: 'liability',
  AccountType.equity: 'equity',
  AccountType.income: 'income',
  AccountType.expense: 'expense',
};

_FiscalYearModel _$FiscalYearModelFromJson(Map<String, dynamic> json) =>
    _FiscalYearModel(
      id: json['id'] as String,
      name: json['name'] as String,
      startDate: const DateOnlyConverter().fromJson(
        json['startDate'] as String,
      ),
      endDate: const DateOnlyConverter().fromJson(json['endDate'] as String),
      status:
          $enumDecodeNullable(_$FiscalYearStatusEnumMap, json['status']) ??
          FiscalYearStatus.open,
      closedAt: _$JsonConverterFromJson<String, DateTime>(
        json['closedAt'],
        const UtcDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$FiscalYearModelToJson(_FiscalYearModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': const DateOnlyConverter().toJson(instance.startDate),
      'endDate': const DateOnlyConverter().toJson(instance.endDate),
      'status': _$FiscalYearStatusEnumMap[instance.status]!,
      'closedAt': _$JsonConverterToJson<String, DateTime>(
        instance.closedAt,
        const UtcDateTimeConverter().toJson,
      ),
    };

const _$FiscalYearStatusEnumMap = {
  FiscalYearStatus.open: 'open',
  FiscalYearStatus.closed: 'closed',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_CostCenterModel _$CostCenterModelFromJson(Map<String, dynamic> json) =>
    _CostCenterModel(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$CostCenterModelToJson(_CostCenterModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'name': instance.name,
      'isActive': instance.isActive,
    };
