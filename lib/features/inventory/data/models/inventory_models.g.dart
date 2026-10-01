// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AssetModel _$AssetModelFromJson(Map<String, dynamic> json) => _AssetModel(
  id: json['id'] as String,
  tag: json['tag'] as String,
  name: json['name'] as String,
  category: json['category'] as String,
  location: json['location'] as String,
  custodian: json['custodian'] as String,
  status:
      $enumDecodeNullable(_$AssetStatusEnumMap, json['status']) ??
      AssetStatus.active,
  acquiredOn: const DateOnlyConverter().fromJson(json['acquiredOn'] as String),
  valueCents: (json['valueCents'] as num?)?.toInt() ?? 0,
  writeOffReason: json['writeOffReason'] as String?,
  writtenOffAt: _$JsonConverterFromJson<String, DateTime>(
    json['writtenOffAt'],
    const UtcDateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$AssetModelToJson(_AssetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tag': instance.tag,
      'name': instance.name,
      'category': instance.category,
      'location': instance.location,
      'custodian': instance.custodian,
      'status': _$AssetStatusEnumMap[instance.status]!,
      'acquiredOn': const DateOnlyConverter().toJson(instance.acquiredOn),
      'valueCents': instance.valueCents,
      'writeOffReason': instance.writeOffReason,
      'writtenOffAt': _$JsonConverterToJson<String, DateTime>(
        instance.writtenOffAt,
        const UtcDateTimeConverter().toJson,
      ),
    };

const _$AssetStatusEnumMap = {
  AssetStatus.active: 'active',
  AssetStatus.inMaintenance: 'in_maintenance',
  AssetStatus.writtenOff: 'written_off',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_MaintenanceModel _$MaintenanceModelFromJson(Map<String, dynamic> json) =>
    _MaintenanceModel(
      id: json['id'] as String,
      assetId: json['assetId'] as String,
      description: json['description'] as String,
      scheduledOn: const DateOnlyConverter().fromJson(
        json['scheduledOn'] as String,
      ),
      costCents: (json['costCents'] as num?)?.toInt() ?? 0,
      status:
          $enumDecodeNullable(_$MaintenanceStatusEnumMap, json['status']) ??
          MaintenanceStatus.open,
      completedAt: _$JsonConverterFromJson<String, DateTime>(
        json['completedAt'],
        const UtcDateTimeConverter().fromJson,
      ),
    );

Map<String, dynamic> _$MaintenanceModelToJson(_MaintenanceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'assetId': instance.assetId,
      'description': instance.description,
      'scheduledOn': const DateOnlyConverter().toJson(instance.scheduledOn),
      'costCents': instance.costCents,
      'status': _$MaintenanceStatusEnumMap[instance.status]!,
      'completedAt': _$JsonConverterToJson<String, DateTime>(
        instance.completedAt,
        const UtcDateTimeConverter().toJson,
      ),
    };

const _$MaintenanceStatusEnumMap = {
  MaintenanceStatus.open: 'open',
  MaintenanceStatus.done: 'done',
};

_StockItemModel _$StockItemModelFromJson(Map<String, dynamic> json) =>
    _StockItemModel(
      id: json['id'] as String,
      sku: json['sku'] as String,
      name: json['name'] as String,
      unit: json['unit'] as String,
      quantity: (json['quantity'] as num).toInt(),
      minQuantity: (json['minQuantity'] as num).toInt(),
      location: json['location'] as String,
      lowStock: json['lowStock'] as bool? ?? false,
    );

Map<String, dynamic> _$StockItemModelToJson(_StockItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sku': instance.sku,
      'name': instance.name,
      'unit': instance.unit,
      'quantity': instance.quantity,
      'minQuantity': instance.minQuantity,
      'location': instance.location,
      'lowStock': instance.lowStock,
    };
