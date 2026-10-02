import 'package:freezed_annotation/freezed_annotation.dart';

part 'operations_overview.freezed.dart';
part 'operations_overview.g.dart';

/// Par rótulo/contagem (refeições, cargos, pendências).
@freezed
abstract class LabeledCount with _$LabeledCount {
  const factory LabeledCount({required String label, required int count}) =
      _LabeledCount;

  factory LabeledCount.fromJson(Map<String, dynamic> json) =>
      _$LabeledCountFromJson(json);
}

/// Refeitório: consumos e saldo pré-pago. Dinheiro em cêntimos.
@freezed
abstract class CafeteriaOverview with _$CafeteriaOverview {
  const factory CafeteriaOverview({
    required int meals,
    required int revenue,
    required int prepaidBalance,
    required int lowBalanceCards,
    required List<LabeledCount> byMeal,
  }) = _CafeteriaOverview;

  factory CafeteriaOverview.fromJson(Map<String, dynamic> json) =>
      _$CafeteriaOverviewFromJson(json);
}

/// Acessos de uma hora do dia.
@freezed
abstract class HourlyAccess with _$HourlyAccess {
  const factory HourlyAccess({
    required int hour,
    required int entries,
    required int exits,
  }) = _HourlyAccess;

  factory HourlyAccess.fromJson(Map<String, dynamic> json) =>
      _$HourlyAccessFromJson(json);
}

/// Catracas: entradas, saídas, recusas e distribuição por hora.
@freezed
abstract class AccessOverview with _$AccessOverview {
  const factory AccessOverview({
    required int entries,
    required int exits,
    required int denied,
    required List<HourlyAccess> byHour,
  }) = _AccessOverview;

  factory AccessOverview.fromJson(Map<String, dynamic> json) =>
      _$AccessOverviewFromJson(json);
}

/// Recursos humanos: efectivo, ausências e contratos.
@freezed
abstract class HrOverview with _$HrOverview {
  const factory HrOverview({
    required int activeStaff,
    required int onLeave,
    required int contractsExpiring,
    required int teachersWithoutContract,
    required List<LabeledCount> byRole,
  }) = _HrOverview;

  factory HrOverview.fromJson(Map<String, dynamic> json) =>
      _$HrOverviewFromJson(json);
}

/// Secretaria: pendências por tipo.
@freezed
abstract class SecretariatOverview with _$SecretariatOverview {
  const factory SecretariatOverview({
    required int totalPending,
    required List<LabeledCount> items,
  }) = _SecretariatOverview;

  factory SecretariatOverview.fromJson(Map<String, dynamic> json) =>
      _$SecretariatOverviewFromJson(json);
}

/// Resposta de `GET /v1/reports/operations-overview`. Cada secção é `null`
/// quando o módulo respectivo não está licenciado.
@freezed
abstract class OperationsOverview with _$OperationsOverview {
  const factory OperationsOverview({
    CafeteriaOverview? cafeteria,
    AccessOverview? access,
    HrOverview? hr,
    SecretariatOverview? secretariat,
  }) = _OperationsOverview;

  factory OperationsOverview.fromJson(Map<String, dynamic> json) =>
      _$OperationsOverviewFromJson(json);
}

/// Filtros dos dashboards operacionais (igualdade por valor).
typedef OperationsOverviewQuery = ({
  String yearId,
  String? termId,
  String? campusId,
});
