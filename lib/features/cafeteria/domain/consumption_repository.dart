import '../../../core/errors/result.dart';
import '../data/models/consumption_rows.dart';

/// Relatórios de consumo do refeitório (calculados, só de leitura).
abstract interface class ConsumptionRepository {
  /// Consumo por turma/dia/refeição. [from]/[to] limitam o dia do consumo
  /// (inclusive). 422 se [from] for posterior a [to].
  Future<Result<List<ConsumptionRow>>> consumption({
    required ConsumptionGroup group,
    DateTime? from,
    DateTime? to,
  });

  /// Saldo total pré-pago das carteiras.
  Future<Result<PrepaidBalance>> prepaidBalance();
}
