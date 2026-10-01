import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/academic/period_context.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/security/permission_providers.dart';
import '../../data/mock_api/reports_mock_handlers.dart';
import '../../data/models/dashboard_metric.dart';
import '../../data/models/report_models.dart';
import '../../data/repositories/api_reports_repository.dart';
import '../../domain/dashboard_widget.dart';
import '../../domain/report_catalog.dart';
import '../../domain/reports_repository.dart';

final reportsRepositoryProvider = Provider<ReportsRepository>(
  (ref) => ApiReportsRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock do módulo, registados em `main.dart` (só com mock activo).
final reportsMockHandlersProvider = Provider<ReportsMockHandlers>(
  (ref) => ReportsMockHandlers(
    enabledModules: () => ref.read(enabledModulesProvider),
  ),
);

/// Filtros do dashboard além do ano/trimestre globais (selector da topbar).
class DashboardFilters {
  const DashboardFilters({
    this.campusId,
    this.compare = CompareMode.none,
    this.profile,
  });

  final String? campusId;
  final CompareMode compare;

  /// Perfil "ver como" (só para quem tem acesso total); `null` = o da sessão.
  final String? profile;

  DashboardFilters copyWith({
    String? Function()? campusId,
    CompareMode? compare,
    String? Function()? profile,
  }) => DashboardFilters(
    campusId: campusId != null ? campusId() : this.campusId,
    compare: compare ?? this.compare,
    profile: profile != null ? profile() : this.profile,
  );
}

class DashboardFiltersNotifier extends Notifier<DashboardFilters> {
  @override
  DashboardFilters build() => const DashboardFilters();

  void setCampus(String? id) => state = state.copyWith(campusId: () => id);
  void setCompare(CompareMode mode) => state = state.copyWith(compare: mode);
  void setProfile(String? code) => state = state.copyWith(profile: () => code);
}

final dashboardFiltersProvider =
    NotifierProvider<DashboardFiltersNotifier, DashboardFilters>(
      DashboardFiltersNotifier.new,
    );

/// Perfil em vigor: o escolhido ("ver como") ou o da sessão.
final dashboardProfileProvider = Provider<String?>((ref) {
  final chosen = ref.watch(dashboardFiltersProvider).profile;
  return chosen ?? dashboardProfileFor(ref.watch(sessionRolesProvider));
});

/// Widgets visíveis: perfil ∩ módulos licenciados.
final visibleWidgetsProvider = Provider<List<DashboardWidgetSpec>>(
  (ref) => visibleWidgets(
    ref.watch(dashboardProfileProvider),
    ref.watch(enabledModulesProvider),
  ),
);

/// Período de comparação face ao efectivo: trimestre anterior (no mesmo ano)
/// ou o mesmo trimestre do ano lectivo anterior. `null` se não existir.
({String yearId, String? termId})? comparePeriod(
  PeriodChoices choices,
  EffectivePeriod current,
  CompareMode mode,
) {
  final year = current.year;
  if (year == null || mode == CompareMode.none) return null;
  if (mode == CompareMode.previousTerm) {
    final i = year.terms.indexWhere((t) => t.id == current.term?.id);
    if (i <= 0) return null;
    return (yearId: year.id, termId: year.terms[i - 1].id);
  }
  final years = [...choices.years]..sort((a, b) => b.label.compareTo(a.label));
  final i = years.indexWhere((y) => y.id == year.id);
  if (i < 0 || i + 1 >= years.length) return null;
  final prev = years[i + 1];
  final n = year.terms.indexWhere((t) => t.id == current.term?.id);
  final term = n >= 0 && n < prev.terms.length ? prev.terms[n].id : null;
  return (yearId: prev.id, termId: term);
}

/// Campus para o filtro; sem permissão ou com falha fica vazio.
final campusOptionsProvider = FutureProvider<List<CampusOption>>((ref) async {
  ref.watch(permissionServiceProvider);
  final result = await ref.watch(reportsRepositoryProvider).campuses();
  return result.valueOrNull ?? const [];
}, retry: (_, _) => null);

/// Pedido em vigor; `null` sem perfil, sem widgets ou sem ano lectivo.
final dashboardQueryProvider = Provider<DashboardQuery?>((ref) {
  final profile = ref.watch(dashboardProfileProvider);
  final widgets = ref.watch(visibleWidgetsProvider);
  final period = ref.watch(effectivePeriodProvider);
  final filters = ref.watch(dashboardFiltersProvider);
  final choices =
      ref.watch(periodChoicesProvider).value ?? const PeriodChoices.empty();
  final year = period.year;
  if (profile == null || widgets.isEmpty || year == null) return null;
  final compare = comparePeriod(choices, period, filters.compare);
  return DashboardQuery(
    profile: profile,
    widgetIds: [for (final w in widgets) w.id],
    yearId: year.id,
    termId: period.term?.id,
    campusId: filters.campusId,
    compareYearId: compare?.yearId,
    compareTermId: compare?.termId,
  );
});

/// Valores por id de widget. Falhas chegam à UI como `AsyncError`.
final dashboardMetricsProvider =
    FutureProvider.autoDispose<Map<String, DashboardMetric>>((ref) async {
      final query = ref.watch(dashboardQueryProvider);
      if (query == null) return const {};
      final rows = (await ref.watch(reportsRepositoryProvider).dashboard(query))
          .getOrThrow();
      return {for (final m in rows) m.widgetId: m};
    }, retry: (_, _) => null);

/// Relatórios do catálogo visíveis: módulo licenciado ∩ permissão de leitura,
/// e só com acesso ao catálogo (`reports.report.read`).
final catalogReportsProvider = Provider<List<ReportDefinition>>((ref) {
  final permissions = ref.watch(permissionServiceProvider);
  if (!permissions.canAny(reportsCatalogPermission)) return const [];
  return visibleReports(permissions, ref.watch(enabledModulesProvider));
});

/// Pedido de execução; igualdade por valor para servir de chave de provider.
typedef ReportRunKey = ({String reportId, String? campusId});

final reportRunProvider = FutureProvider.autoDispose
    .family<ReportResult, ReportRunKey>((ref, key) async {
      final report = reportById(key.reportId);
      final permissions = ref.watch(permissionServiceProvider);
      if (report == null || !canRunReport(permissions, report, key.campusId)) {
        throw PermissionFailure();
      }
      final result = await ref
          .watch(reportsRepositoryProvider)
          .runReport(key.reportId, campusId: key.campusId);
      return result.getOrThrow();
    }, retry: (_, _) => null);

final reportSchedulesProvider =
    FutureProvider.autoDispose<List<ReportSchedule>>(
      (ref) async =>
          (await ref.watch(reportsRepositoryProvider).schedules()).getOrThrow(),
      retry: (_, _) => null,
    );
