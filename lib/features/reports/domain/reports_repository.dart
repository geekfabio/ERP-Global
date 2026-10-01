import '../../../core/errors/result.dart';
import '../data/models/academic_overview.dart';
import '../data/models/dashboard_metric.dart';
import '../data/models/finance_overview.dart';
import '../data/models/operations_overview.dart';

/// Contrato dos dashboards; a UI só conhece esta interface.
abstract interface class ReportsRepository {
  /// Valores dos widgets pedidos; 422 sem ano lectivo.
  Future<Result<List<DashboardMetric>>> dashboard(DashboardQuery query);

  /// KPIs e desdobramento por classe do dashboard Direcção/Académico.
  Future<Result<AcademicOverview>> academicOverview(AcademicOverviewQuery q);

  /// Receita, dívida, inadimplência e previsto vs. recebido (e contabilidade).
  Future<Result<FinanceOverview>> financeOverview(FinanceOverviewQuery q);

  /// Refeitório, Catracas, RH e Secretaria (secções por módulo licenciado).
  Future<Result<OperationsOverview>> operationsOverview(
    OperationsOverviewQuery q,
  );

  Future<Result<List<CampusOption>>> campuses();
}
