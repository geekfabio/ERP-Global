import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/json_converters.dart';

part 'accounting_models.freezed.dart';
part 'accounting_models.g.dart';

/// Natureza da conta (herdada da conta-mãe nas subcontas).
enum AccountType { asset, liability, equity, income, expense }

/// Estado do exercício: `closed` é terminal.
enum FiscalYearStatus { open, closed }

/// Conta do plano de contas (PGC-AO configurável); a hierarquia é por [parentId].
@freezed
abstract class AccountModel with _$AccountModel {
  const factory AccountModel({
    required String id,

    /// Código único; nas subcontas começa pelo código da conta-mãe.
    required String code,
    required String name,
    required AccountType type,
    String? parentId,

    /// Só as contas movimentáveis aceitam lançamentos (folhas).
    @Default(true) bool postable,
    @Default(true) bool isActive,
  }) = _AccountModel;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);
}

/// Exercício contabilístico (período fiscal).
@freezed
abstract class FiscalYearModel with _$FiscalYearModel {
  const factory FiscalYearModel({
    required String id,
    required String name,
    @DateOnlyConverter() required DateTime startDate,
    @DateOnlyConverter() required DateTime endDate,
    @Default(FiscalYearStatus.open) FiscalYearStatus status,
    @UtcDateTimeConverter() DateTime? closedAt,
  }) = _FiscalYearModel;

  factory FiscalYearModel.fromJson(Map<String, dynamic> json) =>
      _$FiscalYearModelFromJson(json);
}

/// Centro de custo (departamento, campus, projecto…).
@freezed
abstract class CostCenterModel with _$CostCenterModel {
  const factory CostCenterModel({
    required String id,
    required String code,
    required String name,
    @Default(true) bool isActive,
  }) = _CostCenterModel;

  factory CostCenterModel.fromJson(Map<String, dynamic> json) =>
      _$CostCenterModelFromJson(json);
}
