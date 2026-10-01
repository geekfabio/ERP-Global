import '../../../core/errors/result.dart';
import '../data/models/dashboard_metric.dart';

/// Contrato dos dashboards; a UI só conhece esta interface.
abstract interface class ReportsRepository {
  /// Valores dos widgets pedidos; 422 sem ano lectivo.
  Future<Result<List<DashboardMetric>>> dashboard(DashboardQuery query);

  Future<Result<List<CampusOption>>> campuses();
}
