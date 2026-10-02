import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_tokens.dart';
import '../utils/pt_ao_formatters.dart';
import '../widgets/feedback/app_dialogs.dart';
import '../widgets/feedback/toasts.dart';
import '../widgets/permissions/can.dart';
import '../widgets/states/app_states.dart';
import '../widgets/status_badge.dart';
import 'sync_engine.dart';
import 'sync_models.dart';
import 'sync_providers.dart';

/// Permissão para ver e tratar a fila de sincronização (`super_admin` tem `*`).
const syncManagePermission = 'core.sync.manage';

/// Nome apresentado das entidades; desconhecidas aparecem como vêm.
const syncEntityLabels = <String, String>{
  'student': 'Aluno',
  'invoice': 'Factura',
  'grade': 'Nota',
  'enrollment': 'Matrícula',
  'user': 'Utilizador',
};

String syncEntityLabel(String entity) => syncEntityLabels[entity] ?? entity;

String syncOperationLabel(SyncOperation o) => switch (o) {
  SyncOperation.create => 'Criação',
  SyncOperation.update => 'Alteração',
  SyncOperation.delete => 'Remoção',
};

String syncStatusLabel(SyncStatus s) => switch (s) {
  SyncStatus.ok => 'Sincronizado',
  SyncStatus.pending => 'Pendente',
  SyncStatus.error => 'Erro',
};

BadgeStatus syncStatusBadge(SyncStatus s) => switch (s) {
  SyncStatus.ok => BadgeStatus.success,
  SyncStatus.pending => BadgeStatus.warning,
  SyncStatus.error => BadgeStatus.danger,
};

/// Resumo de uma execução para o utilizador (pt-AO).
String syncReportMessage(SyncReport r) {
  if (r.offline) return 'Sem ligação. As alterações ficam pendentes.';
  if (r.authRequired) return 'Sessão inválida. Inicie sessão novamente.';
  final parts = <String>[
    '${r.synced} sincronizado(s)',
    if (r.failed > 0) '${r.failed} com erro',
    if (r.conflicts.isNotEmpty)
      '${r.conflicts.length} conflito(s) resolvido(s)',
  ];
  return parts.join(' · ');
}

/// Registos por enviar ou com erro, com acções de repetir e descartar.
class SyncPage extends ConsumerWidget {
  const SyncPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Can(
    permission: syncManagePermission,
    fallback: const EmptyState(
      icon: Icons.lock_outline,
      title: 'Sem permissão',
      message: 'O seu perfil não pode consultar a sincronização.',
    ),
    child: _Body(entries: ref.watch(outboxEntriesProvider)),
  );
}

/// Uma linha por registo (várias edições do mesmo registo valem uma).
class _Row {
  _Row(this.entity, this.entityId);

  final String entity;
  final String entityId;
  final List<OutboxEntry> entries = [];

  SyncStatus get status => entries.any((e) => e.status == OutboxStatus.error)
      ? SyncStatus.error
      : SyncStatus.pending;

  OutboxEntry get last => entries.last;
  String? get error => entries
      .lastWhere(
        (e) => e.status == OutboxStatus.error,
        orElse: () => entries.last,
      )
      .lastError;
  SyncOperation get operation => entries.last.operation == SyncOperation.delete
      ? SyncOperation.delete
      : entries.first.operation;
}

List<_Row> _rows(List<OutboxEntry> entries) {
  final map = <String, _Row>{};
  for (final e in entries) {
    map
        .putIfAbsent(
          '${e.entity}/${e.entityId}',
          () => _Row(e.entity, e.entityId),
        )
        .entries
        .add(e);
  }
  return map.values.toList();
}

class _Body extends ConsumerWidget {
  const _Body({required this.entries});

  final AsyncValue<List<OutboxEntry>> entries;

  Future<void> _run(WidgetRef ref, Future<SyncReport> Function() action) async {
    final report = await action();
    ref.read(toastProvider.notifier).info(syncReportMessage(report));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(syncActionsProvider);
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
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runSpacing: AppSpacing.sm,
                  children: [
                    Text(
                      'Sincronização',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        OutlinedButton.icon(
                          key: const Key('sync_retry_all'),
                          onPressed: () => _run(ref, actions.retryAll),
                          icon: const Icon(Icons.replay),
                          label: const Text('Repetir erros'),
                        ),
                        FilledButton.icon(
                          key: const Key('sync_now'),
                          onPressed: () => _run(ref, actions.syncNow),
                          icon: const Icon(Icons.sync),
                          label: const Text('Sincronizar agora'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<OutboxEntry>>(
                  value: entries,
                  onRetry: () => ref.invalidate(outboxEntriesProvider),
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.cloud_done_outlined,
                    title: 'Tudo sincronizado',
                    message: 'Não há alterações por enviar nem erros.',
                  ),
                  data: (list) => _List(rows: _rows(list)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.rows});

  final List<_Row> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ListView.separated(
    itemCount: rows.length,
    separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
    itemBuilder: (context, i) {
      final r = rows[i];
      final isError = r.status == SyncStatus.error;
      return Card(
        child: ListTile(
          key: Key('sync_row_${r.entity}_${r.entityId}'),
          title: Text(
            '${syncEntityLabel(r.entity)} · ${syncOperationLabel(r.operation)}',
          ),
          subtitle: Text(
            [
              'ID: ${r.entityId}',
              PtAoFormatters.dateTime(r.last.createdAt),
              if (isError && r.error != null) r.error!,
            ].join('\n'),
          ),
          isThreeLine: isError,
          trailing: Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              StatusBadge(
                label: syncStatusLabel(r.status),
                status: syncStatusBadge(r.status),
              ),
              if (isError)
                IconButton(
                  key: Key('sync_retry_${r.entityId}'),
                  tooltip: 'Repetir',
                  icon: const Icon(Icons.replay),
                  onPressed: () async {
                    final report = await ref
                        .read(syncActionsProvider)
                        .retry(r.entity, r.entityId);
                    ref
                        .read(toastProvider.notifier)
                        .info(syncReportMessage(report));
                  },
                ),
              IconButton(
                key: Key('sync_discard_${r.entityId}'),
                tooltip: 'Descartar alterações',
                icon: const Icon(Icons.delete_outline),
                onPressed: () => _discard(context, ref, r),
              ),
            ],
          ),
        ),
      );
    },
  );

  Future<void> _discard(BuildContext context, WidgetRef ref, _Row r) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Descartar alterações?',
      message:
          'As alterações locais deste registo perdem-se e fica a versão do '
          'servidor (ou o registo é removido, se nunca foi enviado).',
      confirmLabel: 'Descartar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref
        .read(syncActionsProvider)
        .discard(r.entity, r.entityId);
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success('Alterações descartadas.'),
      err: (f) => toast.error(f.message),
    );
  }
}
