import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../network/api_envelope.dart';
import '../utils/pt_ao_formatters.dart';
import '../widgets/permissions/can.dart';
import '../widgets/states/app_states.dart';
import '../widgets/status_badge.dart';
import 'audit_log_model.dart';
import 'audit_providers.dart';
import 'audit_repository.dart';

/// Permissão para consultar a auditoria (`super_admin` tem `*`).
const auditReadPermission = 'core.audit.read';

String auditActionLabel(AuditAction a) => switch (a) {
  AuditAction.create => 'Criação',
  AuditAction.update => 'Alteração',
  AuditAction.delete => 'Remoção',
  AuditAction.approve => 'Aprovação',
  AuditAction.reopen => 'Reabertura',
  AuditAction.cancel => 'Anulação',
  AuditAction.other => 'Outra',
};

BadgeStatus auditActionBadge(AuditAction a) => switch (a) {
  AuditAction.create || AuditAction.approve => BadgeStatus.success,
  AuditAction.update || AuditAction.reopen => BadgeStatus.info,
  AuditAction.delete || AuditAction.cancel => BadgeStatus.danger,
  AuditAction.other => BadgeStatus.neutral,
};

/// Nome apresentado dos recursos auditados; desconhecidos aparecem como vêm.
const auditEntityLabels = <String, String>{
  'student': 'Aluno',
  'invoice': 'Factura',
  'grade': 'Nota',
  'enrollment': 'Matrícula',
  'user': 'Utilizador',
};

String _entityLabel(String entity) => auditEntityLabels[entity] ?? entity;

/// Consulta da auditoria com filtros (texto, recurso, acção, datas) e paginação
/// no servidor. Só para quem tem [auditReadPermission].
class AuditPage extends ConsumerStatefulWidget {
  const AuditPage({super.key});

  @override
  ConsumerState<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends ConsumerState<AuditPage> {
  final _search = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      ref.read(auditQueryProvider.notifier).setSearch(text);
    });
  }

  void _clear() {
    _debounce?.cancel();
    _search.clear();
    ref.read(auditQueryProvider.notifier).clear();
  }

  Future<void> _pickRange() async {
    final query = ref.read(auditQueryProvider);
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: query.from == null || query.to == null
          ? null
          : DateTimeRange(
              start: query.from!,
              end: query.to!.subtract(const Duration(days: 1)),
            ),
    );
    if (picked == null || !mounted) return;
    // Dia de calendário em UTC, como o servidor o compara.
    DateTime utc(DateTime d) => DateTime.utc(d.year, d.month, d.day);
    ref
        .read(auditQueryProvider.notifier)
        .setRange(utc(picked.start), utc(picked.end));
  }

  @override
  Widget build(BuildContext context) => Can(
    permission: auditReadPermission,
    fallback: const EmptyState(
      icon: Icons.lock_outline,
      title: 'Sem permissão',
      message: 'O seu perfil não pode consultar a auditoria.',
    ),
    child: _body(context),
  );

  Widget _body(BuildContext context) {
    final list = ref.watch(auditListProvider);
    final query = ref.watch(auditQueryProvider);
    final notifier = ref.read(auditQueryProvider.notifier);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Text(
                  'Auditoria',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              _Filters(
                controller: _search,
                query: query,
                onSearch: _onSearch,
                onRange: _pickRange,
                onClear: _clear,
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<PagedList<AuditLogModel>>(
                  value: list,
                  onRetry: () => ref.invalidate(auditListProvider),
                  isEmpty: (d) => d.items.isEmpty,
                  empty: EmptyState(
                    icon: Icons.history_outlined,
                    title: 'Sem registos de auditoria',
                    message: query.hasFilters
                        ? 'Experimente alterar ou limpar os filtros.'
                        : 'Ainda não há acções registadas.',
                    actionLabel: query.hasFilters ? 'Limpar filtros' : null,
                    onAction: query.hasFilters ? _clear : null,
                  ),
                  data: (page) => _Results(page: page),
                ),
              ),
              list.when(
                data: (p) => _Paginator(
                  meta: p.meta,
                  pageSize: query.pageSize,
                  onPage: notifier.setPage,
                  onPageSize: notifier.setPageSize,
                ),
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters({
    required this.controller,
    required this.query,
    required this.onSearch,
    required this.onRange,
    required this.onClear,
  });

  final TextEditingController controller;
  final AuditQuery query;
  final ValueChanged<String> onSearch;
  final VoidCallback onRange;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final n = ref.read(auditQueryProvider.notifier);
    final range = query.from == null || query.to == null
        ? 'Período'
        : '${PtAoFormatters.date(query.from!)} – '
              '${PtAoFormatters.date(query.to!.subtract(const Duration(days: 1)))}';
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        SizedBox(
          width: 320,
          child: TextField(
            key: const Key('audit_search'),
            controller: controller,
            onChanged: onSearch,
            decoration: const InputDecoration(
              labelText: 'Pesquisar (utilizador ou recurso)',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        _Drop<String>(
          fieldKey: const Key('audit_filter_entity'),
          label: 'Recurso',
          value: query.entity,
          options: auditEntityLabels,
          onChanged: n.setEntity,
        ),
        _Drop<AuditAction>(
          fieldKey: const Key('audit_filter_action'),
          label: 'Acção',
          value: query.action,
          options: {for (final a in AuditAction.values) a: auditActionLabel(a)},
          onChanged: n.setAction,
        ),
        OutlinedButton.icon(
          key: const Key('audit_filter_range'),
          onPressed: onRange,
          icon: const Icon(Icons.date_range_outlined),
          label: Text(range),
        ),
        if (query.hasFilters)
          TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.filter_alt_off_outlined),
            label: const Text('Limpar filtros'),
          ),
      ],
    );
  }
}

/// Selector com opção "Todos" (`null`).
class _Drop<T> extends StatelessWidget {
  const _Drop({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final Key fieldKey;
  final String label;
  final T? value;
  final Map<T, String> options;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 200,
    child: DropdownButtonFormField<T?>(
      key: fieldKey,
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        DropdownMenuItem<T?>(child: const Text('Todos')),
        for (final e in options.entries)
          DropdownMenuItem<T?>(value: e.key, child: Text(e.value)),
      ],
      onChanged: onChanged,
    ),
  );
}

class _Results extends StatelessWidget {
  const _Results({required this.page});

  final PagedList<AuditLogModel> page;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) =>
        constraints.maxWidth >= AppBreakpoints.medium
        ? _Table(page: page)
        : _Cards(page: page),
  );
}

Future<void> _showDetail(
  BuildContext context,
  AuditLogModel log,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(
      '${auditActionLabel(log.action)} · ${_entityLabel(log.entity)}',
    ),
    content: SizedBox(
      width: 560,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${log.actorName} · ${PtAoFormatters.dateTime(log.createdAt)}',
            ),
            if (log.entityId != null) Text('ID: ${log.entityId}'),
            const SizedBox(height: AppSpacing.md),
            _Json(title: 'Antes', data: log.before),
            const SizedBox(height: AppSpacing.md),
            _Json(title: 'Depois', data: log.after),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Fechar'),
      ),
    ],
  ),
);

class _Json extends StatelessWidget {
  const _Json({required this.title, required this.data});

  final String title;
  final Map<String, dynamic>? data;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleSmall),
      const SizedBox(height: AppSpacing.xs),
      SelectableText(
        data == null ? '—' : const JsonEncoder.withIndent('  ').convert(data),
        style: const TextStyle(fontFamily: 'monospace'),
      ),
    ],
  );
}

class _Table extends StatelessWidget {
  const _Table({required this.page});

  final PagedList<AuditLogModel> page;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Data')),
          DataColumn(label: Text('Utilizador')),
          DataColumn(label: Text('Acção')),
          DataColumn(label: Text('Recurso')),
          DataColumn(label: Text('Identificador')),
        ],
        rows: [
          for (final l in page.items)
            DataRow(
              onSelectChanged: (_) => _showDetail(context, l),
              cells: [
                DataCell(Text(PtAoFormatters.dateTime(l.createdAt))),
                DataCell(Text(l.actorName)),
                DataCell(
                  StatusBadge(
                    label: auditActionLabel(l.action),
                    status: auditActionBadge(l.action),
                  ),
                ),
                DataCell(Text(_entityLabel(l.entity))),
                DataCell(Text(l.entityId ?? '—')),
              ],
            ),
        ],
      ),
    ),
  );
}

class _Cards extends StatelessWidget {
  const _Cards({required this.page});

  final PagedList<AuditLogModel> page;

  @override
  Widget build(BuildContext context) => ListView.builder(
    itemCount: page.items.length,
    itemBuilder: (context, i) {
      final l = page.items[i];
      return Card(
        child: ListTile(
          onTap: () => _showDetail(context, l),
          title: Text('${_entityLabel(l.entity)} · ${l.actorName}'),
          subtitle: Text(PtAoFormatters.dateTime(l.createdAt)),
          trailing: StatusBadge(
            label: auditActionLabel(l.action),
            status: auditActionBadge(l.action),
          ),
        ),
      );
    },
  );
}

class _Paginator extends StatelessWidget {
  const _Paginator({
    required this.meta,
    required this.pageSize,
    required this.onPage,
    required this.onPageSize,
  });

  final PageMeta meta;
  final int pageSize;
  final ValueChanged<int> onPage;
  final ValueChanged<int> onPageSize;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(AppSpacing.sm),
    child: Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.md,
      children: [
        Text('${meta.total} registos'),
        DropdownButton<int>(
          value: const [10, 20, 50, 100].contains(pageSize) ? pageSize : null,
          items: [
            for (final s in const [10, 20, 50, 100])
              DropdownMenuItem(value: s, child: Text('$s / página')),
          ],
          onChanged: (v) => v == null ? null : onPageSize(v),
        ),
        IconButton(
          tooltip: 'Página anterior',
          icon: const Icon(Icons.chevron_left),
          onPressed: meta.page > 1 ? () => onPage(meta.page - 1) : null,
        ),
        Text('${meta.page} / ${meta.totalPages == 0 ? 1 : meta.totalPages}'),
        IconButton(
          tooltip: 'Página seguinte',
          icon: const Icon(Icons.chevron_right),
          onPressed: meta.hasNext ? () => onPage(meta.page + 1) : null,
        ),
      ],
    ),
  );
}
