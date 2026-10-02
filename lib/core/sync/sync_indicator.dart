import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import '../security/permission_providers.dart';
import '../widgets/feedback/toasts.dart';
import 'sync_controller.dart';
import 'sync_models.dart';
import 'sync_page.dart';
import 'sync_providers.dart';
import 'sync_settings.dart';

String syncModeLabel(SyncMode m) => switch (m) {
  SyncMode.localOnly => 'Apenas local',
  SyncMode.cloudBackup => 'Backup cloud',
  SyncMode.cloudSync => 'Sincronização cloud',
};

String syncModeDescription(SyncMode m) => switch (m) {
  SyncMode.localOnly => 'Os dados ficam só neste dispositivo.',
  SyncMode.cloudBackup => 'As alterações são copiadas para a cloud.',
  SyncMode.cloudSync => 'Os dados sincronizam com a cloud (licenciado).',
};

/// Estado resumido para o indicador.
({IconData icon, String label, Color? color}) _view(
  BuildContext context,
  SyncUiState ui,
  OutboxCounts counts,
) {
  final scheme = Theme.of(context).colorScheme;
  if (!ui.mode.usesCloud) {
    return (icon: Icons.cloud_off_outlined, label: 'Local', color: null);
  }
  if (ui.running) {
    return (icon: Icons.sync, label: 'A sincronizar…', color: null);
  }
  if (counts.error > 0) {
    return (
      icon: Icons.error_outline,
      label: '${counts.error} com erro',
      color: scheme.error,
    );
  }
  if (ui.lastReport?.offline ?? false) {
    return (icon: Icons.cloud_off_outlined, label: 'Sem ligação', color: null);
  }
  if (counts.pending > 0) {
    return (
      icon: Icons.cloud_upload_outlined,
      label: '${counts.pending} pendente(s)',
      color: null,
    );
  }
  return (icon: Icons.cloud_done_outlined, label: 'Sincronizado', color: null);
}

String _hhmm(DateTime t) {
  final l = t.toLocal();
  return '${l.hour.toString().padLeft(2, '0')}:'
      '${l.minute.toString().padLeft(2, '0')}';
}

/// Indicador de sincronização da topbar: modo, pendentes/erros e menu com
/// "Sincronizar agora", configuração e acesso à fila.
class SyncIndicator extends ConsumerWidget {
  const SyncIndicator({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ui = ref.watch(syncControllerProvider);
    // Sem nuvem não toca na base de dados: a outbox só interessa com sync.
    final counts = ui.mode.usesCloud
        ? ref.watch(outboxCountsProvider).value ?? const OutboxCounts()
        : const OutboxCounts();
    final view = _view(context, ui, counts);
    final canManage = ref
        .watch(permissionServiceProvider)
        .canAny(syncManagePermission);
    final last = ui.settings.lastSyncAt;
    return PopupMenuButton<String>(
      key: const Key('sync_indicator'),
      tooltip: 'Sincronização: ${syncModeLabel(ui.mode)}',
      onSelected: (v) => _onSelected(context, ref, v),
      itemBuilder: (_) => [
        PopupMenuItem(
          enabled: false,
          child: Text(
            syncModeLabel(ui.mode) +
                (ui.mode.usesCloud && last != null
                    ? ' · última: ${_hhmm(last)}'
                    : ''),
          ),
        ),
        if (ui.mode.usesCloud)
          PopupMenuItem(
            value: 'now',
            enabled: !ui.running,
            child: const Text('Sincronizar agora'),
          ),
        if (canManage) ...const [
          PopupMenuItem(value: 'queue', child: Text('Ver pendentes')),
          PopupMenuItem(value: 'config', child: Text('Configurar…')),
        ],
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(view.icon, color: view.color),
            if (!compact) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(view.label, style: TextStyle(color: view.color)),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _onSelected(
    BuildContext context,
    WidgetRef ref,
    String value,
  ) async {
    switch (value) {
      case 'now':
        final report = await ref.read(syncActionsProvider).syncNow();
        ref.read(toastProvider.notifier).info(syncReportMessage(report));
      case 'queue':
        context.go('/sync');
      case 'config':
        await showDialog<void>(
          context: context,
          builder: (_) => const SyncSettingsDialog(),
        );
    }
  }
}

/// Escolha do modo e da sincronização automática. Os modos cloud só estão
/// disponíveis com a licença `cloud_sync`.
class SyncSettingsDialog extends ConsumerStatefulWidget {
  const SyncSettingsDialog({super.key});

  @override
  ConsumerState<SyncSettingsDialog> createState() => _SyncSettingsDialogState();
}

class _SyncSettingsDialogState extends ConsumerState<SyncSettingsDialog> {
  late SyncSettings _draft = ref.read(syncControllerProvider).settings;
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final ok = await ref.read(syncControllerProvider.notifier).update(_draft);
    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop();
    } else {
      setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ui = ref.watch(syncControllerProvider);
    final mode = ui.licensed ? _draft.mode : SyncMode.localOnly;
    return AlertDialog(
      title: const Text('Modo de sincronização'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RadioGroup<SyncMode>(
                groupValue: mode,
                onChanged: (m) {
                  if (m != null) {
                    setState(() => _draft = _draft.copyWith(mode: m));
                  }
                },
                child: Column(
                  children: [
                    for (final m in SyncMode.values)
                      RadioListTile<SyncMode>(
                        key: Key('sync_mode_${m.name}'),
                        value: m,
                        enabled: ui.licensed || !m.usesCloud,
                        title: Text(syncModeLabel(m)),
                        subtitle: Text(syncModeDescription(m)),
                      ),
                  ],
                ),
              ),
              if (!ui.licensed)
                const Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Text(
                    'Sem a licença "Sincronização cloud" a app funciona '
                    'apenas em modo local.',
                  ),
                ),
              if (mode.usesCloud) ...[
                SwitchListTile(
                  key: const Key('sync_auto'),
                  title: const Text('Sincronização automática'),
                  value: _draft.auto,
                  onChanged: (v) =>
                      setState(() => _draft = _draft.copyWith(auto: v)),
                ),
                if (_draft.auto)
                  DropdownButtonFormField<int>(
                    key: const Key('sync_interval'),
                    initialValue:
                        syncIntervalOptions.contains(_draft.intervalMinutes)
                        ? _draft.intervalMinutes
                        : 15,
                    decoration: const InputDecoration(labelText: 'Intervalo'),
                    items: [
                      for (final m in syncIntervalOptions)
                        DropdownMenuItem(value: m, child: Text('$m minutos')),
                    ],
                    onChanged: (v) {
                      if (v != null) {
                        setState(
                          () => _draft = _draft.copyWith(intervalMinutes: v),
                        );
                      }
                    },
                  ),
              ],
              if (ui.saveError != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    ui.saveError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _saving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          key: const Key('sync_settings_save'),
          onPressed: _saving || !ui.licensed ? null : _save,
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
