import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'inventory_models.freezed.dart';
part 'inventory_models.g.dart';

/// Estado do bem: `written_off` é terminal (abate).
enum AssetStatus {
  active,
  @JsonValue('in_maintenance')
  inMaintenance,
  @JsonValue('written_off')
  writtenOff,
}

/// Valor no formato da API (`filter[status]`).
extension AssetStatusWire on AssetStatus {
  String get wire => switch (this) {
    AssetStatus.active => 'active',
    AssetStatus.inMaintenance => 'in_maintenance',
    AssetStatus.writtenOff => 'written_off',
  };
}

enum MaintenanceStatus { open, done }

/// Bem patrimonial (mobiliário, equipamento, viaturas…).
@freezed
abstract class AssetModel with _$AssetModel {
  const factory AssetModel({
    required String id,

    /// Número de património (único).
    required String tag,
    required String name,
    required String category,
    required String location,

    /// Responsável (nome) pelo bem.
    required String custodian,
    @Default(AssetStatus.active) AssetStatus status,
    @DateOnlyConverter() required DateTime acquiredOn,

    /// Valor de aquisição na menor unidade (Kz × 100).
    @Default(0) int valueCents,
    String? writeOffReason,
    @UtcDateTimeConverter() DateTime? writtenOffAt,
  }) = _AssetModel;

  factory AssetModel.fromJson(Map<String, dynamic> json) =>
      _$AssetModelFromJson(json);
}

/// Intervenção de manutenção de um bem.
@freezed
abstract class MaintenanceModel with _$MaintenanceModel {
  const factory MaintenanceModel({
    required String id,
    required String assetId,
    required String description,
    @DateOnlyConverter() required DateTime scheduledOn,
    @Default(0) int costCents,
    @Default(MaintenanceStatus.open) MaintenanceStatus status,
    @UtcDateTimeConverter() DateTime? completedAt,
  }) = _MaintenanceModel;

  factory MaintenanceModel.fromJson(Map<String, dynamic> json) =>
      _$MaintenanceModelFromJson(json);
}

/// Consumível em stock, com quantidade mínima para alerta.
@freezed
abstract class StockItemModel with _$StockItemModel {
  const factory StockItemModel({
    required String id,
    required String sku,
    required String name,

    /// Unidade de medida (un, cx, resma…).
    required String unit,
    required int quantity,
    required int minQuantity,
    required String location,

    /// Calculado pelo servidor: `quantity <= minQuantity`.
    @Default(false) bool lowStock,
  }) = _StockItemModel;

  factory StockItemModel.fromJson(Map<String, dynamic> json) =>
      _$StockItemModelFromJson(json);
}
