import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_metric.freezed.dart';
part 'dashboard_metric.g.dart';

/// Valor de um widget no período pedido (e no de comparação, se houver).
/// Dinheiro em cêntimos; percentagens em pontos inteiros (0–100).
/// [trend]: valores recentes (o último é [value]) para o mini-gráfico; vazio
/// se o servidor não o enviar.
@freezed
abstract class DashboardMetric with _$DashboardMetric {
  const factory DashboardMetric({
    required String widgetId,
    required int value,
    int? previous,
    @Default(<int>[]) List<int> trend,
  }) = _DashboardMetric;

  factory DashboardMetric.fromJson(Map<String, dynamic> json) =>
      _$DashboardMetricFromJson(json);
}

/// Campus para o filtro (subconjunto de `GET /v1/campuses`).
@freezed
abstract class CampusOption with _$CampusOption {
  const factory CampusOption({required String id, required String name}) =
      _CampusOption;

  factory CampusOption.fromJson(Map<String, dynamic> json) =>
      _$CampusOptionFromJson(json);
}

/// Filtros de um pedido de dashboard (igualdade por valor: chave de provider).
class DashboardQuery {
  const DashboardQuery({
    required this.profile,
    required this.widgetIds,
    required this.yearId,
    this.termId,
    this.campusId,
    this.compareYearId,
    this.compareTermId,
  });

  final String profile;
  final List<String> widgetIds;
  final String yearId;
  final String? termId;
  final String? campusId;
  final String? compareYearId;
  final String? compareTermId;

  @override
  bool operator ==(Object other) =>
      other is DashboardQuery &&
      other.profile == profile &&
      other.widgetIds.join(',') == widgetIds.join(',') &&
      other.yearId == yearId &&
      other.termId == termId &&
      other.campusId == campusId &&
      other.compareYearId == compareYearId &&
      other.compareTermId == compareTermId;

  @override
  int get hashCode => Object.hash(
    profile,
    widgetIds.join(','),
    yearId,
    termId,
    campusId,
    compareYearId,
    compareTermId,
  );
}
