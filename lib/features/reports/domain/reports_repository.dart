import '../../../core/errors/result.dart';
import '../data/models/academic_overview.dart';
import '../data/models/dashboard_metric.dart';
import '../data/models/finance_overview.dart';
import '../data/models/operations_overview.dart';
import '../data/models/report_models.dart';

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

  /// Dados de um relatório do catálogo; 403 fora do âmbito ou da licença.
  Future<Result<ReportResult>> runReport(String reportId, {String? campusId});

  Future<Result<List<ReportSchedule>>> schedules();

  Future<Result<ReportSchedule>> createSchedule({
    required String reportId,
    required ScheduleFrequency frequency,
    required String format,
    String? campusId,
  });

  Future<Result<ReportSchedule>> setScheduleActive(String id, bool active);

  Future<Result<void>> deleteSchedule(String id);
}
