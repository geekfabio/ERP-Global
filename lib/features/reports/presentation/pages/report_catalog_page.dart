import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../data/models/report_models.dart';
import '../../domain/report_catalog.dart';
import '../providers/reports_providers.dart';

/// Texto de uma célula (dinheiro vem em cêntimos).
String reportCellText(String key, String value) =>
    key == 'amount' ? PtAoFormatters.currency(int.parse(value)) : value;

/// Catálogo de relatórios: executar, exportar (CSV/Excel/PDF) e agendar,
/// respeitando licença, permissões, colunas restritas e âmbito (campus).
class ReportCatalogPage extends ConsumerStatefulWidget {
  const ReportCatalogPage({super.key});

  @override
  ConsumerState<ReportCatalogPage> createState() => _ReportCatalogPageState();
}

class _ReportCatalogPageState extends ConsumerState<ReportCatalogPage> {
  String? _reportId;
  String? _campusId;

  @override
  Widget build(BuildContext context) {
    final reports = ref.watch(catalogReportsProvider);
    final text = Theme.of(context).textTheme;
    ReportDefinition? selected;
    for (final r in reports) {
      if (r.id == _reportId) selected = r;
    }
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text('Catálogo de relatórios', style: text.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            if (reports.isEmpty)
              const EmptyState(
                icon: Icons.assignment_outlined,
                title: 'Sem relatórios disponíveis',
                message:
                    'Os relatórios dependem das suas permissões e dos módulos '
                    'licenciados.',
              )
            else ...[
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [
                  for (final r in reports)
                    ChoiceChip(
                      key: ValueKey('report_${r.id}'),
                      label: Text(r.title),
                      selected: r.id == _reportId,
                      onSelected: (_) => setState(() => _reportId = r.id),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              if (selected == null)
                const EmptyState(
                  icon: Icons.touch_app_outlined,
                  title: 'Escolha um relatório',
                )
              else
                _ReportView(
                  key: ValueKey(selected.id),
                  report: selected,
                  campusId: _campusId,
                  onCampus: (id) => setState(() => _campusId = id),
                ),
              const SizedBox(height: AppSpacing.xl),
              const _SchedulesSection(),
            ],
            const SizedBox(height: AppSpacing.xl),
            const _ExistingReports(),
          ],
        ),
      ),
    );
  }
}

class _ReportView extends ConsumerWidget {
  const _ReportView({
    super.key,
    required this.report,
    required this.campusId,
    required this.onCampus,
  });

  final ReportDefinition report;
  final String? campusId;
  final ValueChanged<String?> onCampus;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionServiceProvider);
    final campuses = ref.watch(campusOptionsProvider).value ?? const [];
    final needsCampus = requiresCampus(permissions, report);
    final allowed = canRunReport(permissions, report, campusId);
    final columns = [
      for (final c in report.columns)
        if (c.permission == null || permissions.canAny(c.permission!)) c,
    ];
    final text = Theme.of(context).textTheme;
    final run = ref.watch(
      reportRunProvider((reportId: report.id, campusId: campusId)),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(report.title, style: text.titleLarge)),
            if (allowed) ...[
              ExportButton(
                permission: reportsExportPermission,
                dataset: () => _dataset(run.value),
              ),
              const SizedBox(width: AppSpacing.sm),
              AppButton(
                label: 'Agendar',
                icon: Icons.schedule_outlined,
                variant: AppButtonVariant.secondary,
                onPressed: () => _schedule(context, ref),
              ),
            ],
          ],
        ),
        Text(report.description, style: text.bodyMedium),
        const SizedBox(height: AppSpacing.md),
        DropdownMenu<String?>(
          key: ValueKey('campus_$campusId'),
          label: const Text('Campus'),
          initialSelection: campusId,
          dropdownMenuEntries: [
            if (!needsCampus)
              const DropdownMenuEntry(value: null, label: 'Todos'),
            for (final c in campuses)
              DropdownMenuEntry(value: c.id, label: c.name),
          ],
          onSelected: onCampus,
        ),
        const SizedBox(height: AppSpacing.md),
        if (!allowed)
          const EmptyState(
            icon: Icons.lock_outline,
            title: 'Escolha um campus',
            message: 'O seu acesso a este relatório é limitado por campus.',
          )
        else
          AsyncValueView<ReportResult>(
            value: run,
            loading: const SkeletonCard(),
            onRetry: () => ref.invalidate(reportRunProvider),
            isEmpty: (r) => r.rows.isEmpty,
            empty: const EmptyState(title: 'Sem dados para o âmbito escolhido'),
            data: (result) => _ResultTable(columns: columns, result: result),
          ),
      ],
    );
  }

  ExportDataset _dataset(ReportResult? result) => ExportDataset(
    title: report.title,
    entity: 'report-${report.id}',
    permission: reportsExportPermission,
    columns: [
      for (final c in report.columns)
        ExportDatasetColumn(
          key: c.key,
          label: c.label,
          permission: c.permission,
        ),
    ],
    rows: [
      for (final row in result?.rows ?? const <List<String>>[])
        [
          for (var i = 0; i < report.columns.length; i++)
            reportCellText(report.columns[i].key, row[i]),
        ],
    ],
  );

  Future<void> _schedule(BuildContext context, WidgetRef ref) async {
    final choice = await showDialog<(ScheduleFrequency, ExportFormat)>(
      context: context,
      builder: (_) => const _ScheduleDialog(),
    );
    if (choice == null) return;
    final toast = ref.read(toastProvider.notifier);
    final result = await ref
        .read(reportsRepositoryProvider)
        .createSchedule(
          reportId: report.id,
          frequency: choice.$1,
          format: choice.$2.extension,
          campusId: campusId,
        );
    if (result.valueOrNull == null) {
      toast.error(result.failureOrNull!.message);
      return;
    }
    ref.invalidate(reportSchedulesProvider);
    toast.success('Relatório agendado (${choice.$1.label.toLowerCase()}).');
  }
}

class _ResultTable extends StatelessWidget {
  const _ResultTable({required this.columns, required this.result});

  final List<ReportColumnSpec> columns;
  final ReportResult result;

  @override
  Widget build(BuildContext context) {
    final index = {
      for (var i = 0; i < result.columnKeys.length; i++)
        result.columnKeys[i]: i,
    };
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [for (final c in columns) DataColumn(label: Text(c.label))],
        rows: [
          for (final row in result.rows)
            DataRow(
              cells: [
                for (final c in columns)
                  DataCell(Text(reportCellText(c.key, row[index[c.key]!]))),
              ],
            ),
        ],
      ),
    );
  }
}

class _ScheduleDialog extends StatefulWidget {
  const _ScheduleDialog();

  @override
  State<_ScheduleDialog> createState() => _ScheduleDialogState();
}

class _ScheduleDialogState extends State<_ScheduleDialog> {
  var _frequency = ScheduleFrequency.weekly;
  var _format = ExportFormat.pdf;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Agendar relatório'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<ScheduleFrequency>(
          key: const ValueKey('schedule_frequency'),
          initialValue: _frequency,
          decoration: const InputDecoration(labelText: 'Frequência'),
          items: [
            for (final f in ScheduleFrequency.values)
              DropdownMenuItem(value: f, child: Text(f.label)),
          ],
          onChanged: (f) => setState(() => _frequency = f ?? _frequency),
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<ExportFormat>(
          key: const ValueKey('schedule_format'),
          initialValue: _format,
          decoration: const InputDecoration(labelText: 'Formato'),
          items: [
            for (final f in ExportFormat.values)
              DropdownMenuItem(value: f, child: Text(f.label)),
          ],
          onChanged: (f) => setState(() => _format = f ?? _format),
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop((_frequency, _format)),
        child: const Text('Agendar'),
      ),
    ],
  );
}

class _SchedulesSection extends ConsumerWidget {
  const _SchedulesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(reportSchedulesProvider);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Agendamentos', style: text.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        AsyncValueView<List<ReportSchedule>>(
          value: schedules,
          loading: const SkeletonCard(),
          onRetry: () => ref.invalidate(reportSchedulesProvider),
          isEmpty: (s) => s.isEmpty,
          empty: const EmptyState(
            icon: Icons.schedule_outlined,
            title: 'Sem agendamentos',
          ),
          data: (items) => Column(
            children: [
              for (final s in items)
                Can(
                  permission: reportsCatalogPermission,
                  child: ListTile(
                    key: ValueKey('schedule_${s.id}'),
                    title: Text(reportById(s.reportId)?.title ?? s.reportId),
                    subtitle: Text(
                      '${s.frequency.label} · ${s.format.toUpperCase()} · '
                      'próxima: ${PtAoFormatters.dateTime(s.nextRunAt.toLocal())}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Switch(
                          value: s.active,
                          onChanged: (v) async {
                            await ref
                                .read(reportsRepositoryProvider)
                                .setScheduleActive(s.id, v);
                            ref.invalidate(reportSchedulesProvider);
                          },
                        ),
                        IconButton(
                          tooltip: 'Remover',
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () async {
                            await ref
                                .read(reportsRepositoryProvider)
                                .deleteSchedule(s.id);
                            ref.invalidate(reportSchedulesProvider);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Relatórios e dashboards já existentes noutros ecrãs (só módulos licenciados;
/// cada destino aplica as suas próprias permissões).
const _existingReports = <(String, String, String?, String)>[
  ('Dashboard Direcção e Académico', '/reports/academic', null, 'academic'),
  ('Dashboard Financeiro', '/reports/finance', 'billing', 'finance'),
  ('Dashboard de Operações', '/reports/operations', null, 'operations'),
  ('Receita e previsão', '/billing/reports', 'billing', 'billing'),
  ('Consumo do refeitório', '/cafeteria', 'cafeteria', 'cafeteria'),
];

class _ExistingReports extends ConsumerWidget {
  const _ExistingReports();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(enabledModulesProvider);
    final text = Theme.of(context).textTheme;
    final items = [
      for (final r in _existingReports)
        if (r.$3 == null || enabled.contains(r.$3)) r,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Outros relatórios', style: text.titleLarge),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          children: [
            for (final r in items)
              ActionChip(
                key: ValueKey('existing_${r.$4}'),
                avatar: const Icon(Icons.open_in_new, size: 16),
                label: Text(r.$1),
                onPressed: () => context.go(r.$2),
              ),
          ],
        ),
      ],
    );
  }
}
