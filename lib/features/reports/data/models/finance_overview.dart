import 'package:freezed_annotation/freezed_annotation.dart';

part 'finance_overview.freezed.dart';
part 'finance_overview.g.dart';

/// Totais financeiros do período. Dinheiro em cêntimos; percentagens em pontos
/// inteiros (0–100). Os campos de contabilidade são `null` sem o módulo
/// `accounting` licenciado.
@freezed
abstract class FinanceTotals with _$FinanceTotals {
  const factory FinanceTotals({
    required int collected,
    required int expected,
    required int debt,
    required int defaultRate,
    int? receivables,
    int? payables,
    int? result,
  }) = _FinanceTotals;

  factory FinanceTotals.fromJson(Map<String, dynamic> json) =>
      _$FinanceTotalsFromJson(json);
}

/// Linha mensal: previsto vs. recebido e dívida do mês.
@freezed
abstract class FinanceMonthRow with _$FinanceMonthRow {
  const factory FinanceMonthRow({
    required String month,
    required String label,
    required int expected,
    required int collected,
    required int debt,
  }) = _FinanceMonthRow;

  factory FinanceMonthRow.fromJson(Map<String, dynamic> json) =>
      _$FinanceMonthRowFromJson(json);
}

/// Resposta de `GET /v1/reports/finance-overview` (agregada no servidor).
@freezed
abstract class FinanceOverview with _$FinanceOverview {
  const factory FinanceOverview({
    required FinanceTotals totals,
    required List<FinanceMonthRow> rows,
    FinanceTotals? previous,
  }) = _FinanceOverview;

  factory FinanceOverview.fromJson(Map<String, dynamic> json) =>
      _$FinanceOverviewFromJson(json);
}

/// Filtros do dashboard financeiro (igualdade por valor).
typedef FinanceOverviewQuery = ({
  String yearId,
  String? termId,
  String? campusId,
  String? compareYearId,
  String? compareTermId,
});
