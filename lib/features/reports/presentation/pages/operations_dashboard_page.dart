import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/cards/app_cards.dart';
import '../../../../core/widgets/charts/app_charts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../data/models/operations_overview.dart';
import '../providers/operations_overview_providers.dart';
import '../widgets/dashboard_filters_bar.dart';

const operationsDashboardExportPermission = 'reports.dashboard.export';

/// Secções do dashboard operacional (uma por módulo licenciado).
enum OperationsSection {
  cafeteria('Refeitório', Icons.restaurant_outlined),
  access('Catracas', Icons.door_sliding_outlined),
  hr('RH', Icons.badge_outlined),
  secretariat('Secretaria', Icons.assignment_outlined);

  const OperationsSection(this.label, this.icon);
  final String label;
  final IconData icon;

  bool available(OperationsOverview o) => switch (this) {
    cafeteria => o.cafeteria != null,
    access => o.access != null,
    hr => o.hr != null,
    secretariat => o.secretariat != null,
  };
}

/// Dashboards operacionais: Refeitório (consumos e saldo pré-pago), Catracas
/// (acessos por hora), RH e pendências da Secretaria.
class OperationsDashboardPage extends ConsumerStatefulWidget {
  const OperationsDashboardPage({super.key});

  @override
  ConsumerState<OperationsDashboardPage> createState() =>
      _OperationsDashboardPageState();
}

class _OperationsDashboardPageState
    extends ConsumerState<OperationsDashboardPage> {
  OperationsSection _section = OperationsSection.cafeteria;

  @override
  Widget build(BuildContext context) {
    final overview = ref.watch(operationsOverviewProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(
              'Dashboard · Operações',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppSpacing.md),
            const DashboardFiltersBar(),
            const SizedBox(height: AppSpacing.lg),
            AsyncValueView<OperationsOverview?>(
              value: overview,
              loading: const SkeletonCard(),
              onRetry: () => ref.invalidate(operationsOverviewProvider),
              data: (data) {
                if (data == null) {
                  return const EmptyState(
                    icon: Icons.event_outlined,
                    title: 'Sem ano lectivo',
                    message: 'Crie um ano lectivo nas definições.',
                  );
                }
                final sections = [
                  for (final s in OperationsSection.values)
                    if (s.available(data)) s,
                ];
                if (sections.isEmpty) {
                  return const EmptyState(
                    icon: Icons.lock_outline,
                    title: 'Sem indicadores',
                    message: 'Nenhum módulo operacional está licenciado.',
                  );
                }
                final current = sections.contains(_section)
                    ? _section
                    : sections.first;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SegmentedButton<OperationsSection>(
                      key: const ValueKey('operations_section'),
                      showSelectedIcon: false,
                      segments: [
                        for (final s in sections)
                          ButtonSegment(
                            value: s,
                            label: Text(s.label),
                            icon: Icon(s.icon),
                          ),
                      ],
                      selected: {current},
                      onSelectionChanged: (s) =>
                          setState(() => _section = s.first),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    switch (current) {
                      OperationsSection.cafeteria => _Cafeteria(
                        data.cafeteria!,
                      ),
                      OperationsSection.access => _Access(data.access!),
                      OperationsSection.hr => _Hr(data.hr!),
                      OperationsSection.secretariat => _Secretariat(
                        data.secretariat!,
                      ),
                    },
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String _n(int v) => PtAoFormatters.number(v);

Widget _kpis(List<Widget> cards) => Wrap(
  spacing: AppSpacing.md,
  runSpacing: AppSpacing.md,
  children: [for (final k in cards) SizedBox(width: 260, child: k)],
);

Widget _tableHeader(
  BuildContext context,
  String title,
  Key exportKey,
  ExportDataset Function() dataset,
) => Wrap(
  spacing: AppSpacing.md,
  runSpacing: AppSpacing.sm,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    Text(title, style: Theme.of(context).textTheme.titleMedium),
    ExportButton(
      key: exportKey,
      permission: operationsDashboardExportPermission,
      dataset: dataset,
    ),
  ],
);

Widget _table(Key key, List<String> headers, List<List<String>> rows) =>
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        key: key,
        columns: [for (final h in headers) DataColumn(label: Text(h))],
        rows: [
          for (final r in rows)
            DataRow(cells: [for (final c in r) DataCell(Text(c))]),
        ],
      ),
    );

ExportDataset _dataset(
  String title,
  String entity,
  List<String> headers,
  List<List<String>> rows,
) => ExportDataset(
  title: title,
  entity: entity,
  permission: operationsDashboardExportPermission,
  columns: [
    for (final (i, h) in headers.indexed)
      ExportDatasetColumn(key: 'c$i', label: h),
  ],
  rows: rows,
);

class _Cafeteria extends StatelessWidget {
  const _Cafeteria(this.data);

  final CafeteriaOverview data;

  static const _headers = ['Refeição', 'Consumos'];

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final m in data.byMeal) [m.label, _n(m.count)],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kpis([
          KpiCard(
            key: const ValueKey('kpi_meals'),
            label: 'Refeições servidas',
            icon: Icons.restaurant_outlined,
            value: data.meals,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_revenue'),
            label: 'Receita do refeitório',
            icon: Icons.payments_outlined,
            value: data.revenue,
            format: PtAoFormatters.currency,
          ),
          KpiCard(
            key: const ValueKey('kpi_prepaid'),
            label: 'Saldo pré-pago',
            icon: Icons.account_balance_wallet_outlined,
            value: data.prepaidBalance,
            format: PtAoFormatters.currency,
          ),
          KpiCard(
            key: const ValueKey('kpi_low_balance'),
            label: 'Cartões com saldo baixo',
            icon: Icons.warning_amber_outlined,
            value: data.lowBalanceCards,
            format: _n,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),
        _tableHeader(
          context,
          'Consumos por refeição',
          const ValueKey('operations_export'),
          () => _dataset(
            'Dashboard Refeitório',
            'cafeteria_dashboard',
            _headers,
            rows,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppBarChart(
          values: [for (final m in data.byMeal) m.count.toDouble()],
          labels: [for (final m in data.byMeal) m.label],
          semanticLabel: 'Consumos por refeição',
        ),
        const SizedBox(height: AppSpacing.lg),
        _table(const ValueKey('operations_table'), _headers, rows),
      ],
    );
  }
}

class _Access extends StatelessWidget {
  const _Access(this.data);

  final AccessOverview data;

  static const _headers = ['Hora', 'Entradas', 'Saídas'];

  @override
  Widget build(BuildContext context) {
    String hour(int h) => '${h.toString().padLeft(2, '0')}:00';
    final rows = [
      for (final h in data.byHour) [hour(h.hour), _n(h.entries), _n(h.exits)],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kpis([
          KpiCard(
            key: const ValueKey('kpi_entries'),
            label: 'Entradas',
            icon: Icons.login_outlined,
            value: data.entries,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_exits'),
            label: 'Saídas',
            icon: Icons.logout_outlined,
            value: data.exits,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_denied'),
            label: 'Acessos recusados',
            icon: Icons.block_outlined,
            value: data.denied,
            format: _n,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),
        _tableHeader(
          context,
          'Acessos por hora',
          const ValueKey('operations_export'),
          () => _dataset(
            'Dashboard Catracas',
            'access_dashboard',
            _headers,
            rows,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppLineChart(
          values: [for (final h in data.byHour) h.entries.toDouble()],
          labels: [for (final h in data.byHour) hour(h.hour)],
          semanticLabel: 'Entradas por hora',
        ),
        const SizedBox(height: AppSpacing.md),
        AppLineChart(
          values: [for (final h in data.byHour) h.exits.toDouble()],
          labels: [for (final h in data.byHour) hour(h.hour)],
          semanticLabel: 'Saídas por hora',
        ),
        const SizedBox(height: AppSpacing.lg),
        _table(const ValueKey('operations_table'), _headers, rows),
      ],
    );
  }
}

class _Hr extends StatelessWidget {
  const _Hr(this.data);

  final HrOverview data;

  static const _headers = ['Cargo', 'Funcionários'];

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final r in data.byRole) [r.label, _n(r.count)],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kpis([
          KpiCard(
            key: const ValueKey('kpi_staff'),
            label: 'Funcionários activos',
            icon: Icons.badge_outlined,
            value: data.activeStaff,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_on_leave'),
            label: 'Em férias ou ausentes',
            icon: Icons.beach_access_outlined,
            value: data.onLeave,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_expiring'),
            label: 'Contratos a expirar',
            icon: Icons.event_busy_outlined,
            value: data.contractsExpiring,
            format: _n,
          ),
          KpiCard(
            key: const ValueKey('kpi_no_contract'),
            label: 'Docentes sem contrato',
            icon: Icons.warning_amber_outlined,
            value: data.teachersWithoutContract,
            format: _n,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),
        _tableHeader(
          context,
          'Funcionários por cargo',
          const ValueKey('operations_export'),
          () => _dataset('Dashboard RH', 'hr_dashboard', _headers, rows),
        ),
        const SizedBox(height: AppSpacing.md),
        AppBarChart(
          values: [for (final r in data.byRole) r.count.toDouble()],
          labels: [for (final r in data.byRole) r.label],
          semanticLabel: 'Funcionários por cargo',
        ),
        const SizedBox(height: AppSpacing.lg),
        _table(const ValueKey('operations_table'), _headers, rows),
      ],
    );
  }
}

class _Secretariat extends StatelessWidget {
  const _Secretariat(this.data);

  final SecretariatOverview data;

  static const _headers = ['Pendência', 'Quantidade'];

  @override
  Widget build(BuildContext context) {
    final rows = [
      for (final i in data.items) [i.label, _n(i.count)],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _kpis([
          KpiCard(
            key: const ValueKey('kpi_pending'),
            label: 'Pendências totais',
            icon: Icons.assignment_late_outlined,
            value: data.totalPending,
            format: _n,
          ),
        ]),
        const SizedBox(height: AppSpacing.xl),
        _tableHeader(
          context,
          'Pendências por tipo',
          const ValueKey('operations_export'),
          () => _dataset(
            'Dashboard Secretaria',
            'secretariat_dashboard',
            _headers,
            rows,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppBarChart(
          values: [for (final i in data.items) i.count.toDouble()],
          labels: [for (final i in data.items) i.label],
          semanticLabel: 'Pendências por tipo',
        ),
        const SizedBox(height: AppSpacing.lg),
        _table(const ValueKey('operations_table'), _headers, rows),
      ],
    );
  }
}
