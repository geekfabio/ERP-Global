import '../../../core/errors/result.dart';
import '../data/models/report_rows.dart';

/// Relatórios financeiros base (calculados, só de leitura).
abstract interface class ReportRepository {
  /// Receita recebida por período/rubrica/campus. [from]/[to] limitam a data
  /// de pagamento (inclusive). 422 se [from] for posterior a [to].
  Future<Result<List<RevenueRow>>> revenue({
    required RevenueGroup group,
    DateTime? from,
    DateTime? to,
    String? campusId,
  });

  /// Previsto vs. recebido por mês de vencimento.
  Future<Result<List<ForecastRow>>> forecast({
    DateTime? from,
    DateTime? to,
    String? campusId,
  });
}
