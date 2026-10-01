import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/inventory_models.dart';
import '../providers/inventory_providers.dart';
import 'inventory_form_dialog.dart';

/// Histórico de manutenção de um bem, com agendar e concluir.
Future<void> showMaintenanceDialog(BuildContext context, AssetModel asset) =>
    showDialog<void>(
      context: context,
      builder: (_) => _MaintenanceDialog(asset: asset),
    );

class _MaintenanceDialog extends ConsumerWidget {
  const _MaintenanceDialog({required this.asset});

  final AssetModel asset;

  Future<void> _schedule(BuildContext context, WidgetRef ref) async {
    final v = await showInventoryForm(
      context,
      title: 'Agendar manutenção',
      subtitle: '${asset.tag} · ${asset.name}',
      fields: const [
        FormFieldSpec('description', 'Descrição'),
        FormFieldSpec('scheduledOn', 'Data prevista', kind: FieldKind.date),
        FormFieldSpec(
          'costCents',
          'Custo estimado',
          kind: FieldKind.money,
          required: false,
        ),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(assetRepositoryProvider)
        .scheduleMaintenance(
          asset.id,
          description: v['description']! as String,
          scheduledOn: v['scheduledOn']! as DateTime,
          costCents: v['costCents']! as int,
        );
    _after(ref, result.failureOrNull?.message, 'Manutenção agendada');
  }

  Future<void> _complete(WidgetRef ref, MaintenanceModel m) async {
    final result = await ref
        .read(assetRepositoryProvider)
        .completeMaintenance(asset.id, m.id);
    _after(ref, result.failureOrNull?.message, 'Manutenção concluída');
  }

  void _after(WidgetRef ref, String? error, String done) {
    final toast = ref.read(toastProvider.notifier);
    if (error != null) {
      toast.error(error);
      return;
    }
    toast.success(done);
    ref
      ..invalidate(assetMaintenanceProvider(asset.id))
      ..invalidate(assetListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(assetMaintenanceProvider(asset.id));
    return AlertDialog(
      title: Text('Manutenção · ${asset.name}'),
      content: SizedBox(
        width: 520,
        height: 320,
        child: AsyncValueView<List<MaintenanceModel>>(
          value: list,
          onRetry: () => ref.invalidate(assetMaintenanceProvider(asset.id)),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.build_outlined,
            title: 'Sem manutenções',
          ),
          data: (items) => ListView(
            children: [
              for (final m in items)
                ListTile(
                  title: Text(m.description),
                  subtitle: Text(
                    '${PtAoFormatters.date(m.scheduledOn)} · '
                    '${PtAoFormatters.currency(m.costCents)}',
                  ),
                  trailing: m.status == MaintenanceStatus.done
                      ? const StatusBadge(
                          label: 'Concluída',
                          status: BadgeStatus.success,
                        )
                      : Can(
                          permission: 'inventory.asset.maintain',
                          fallback: const StatusBadge(
                            label: 'Em curso',
                            status: BadgeStatus.warning,
                          ),
                          child: TextButton(
                            onPressed: () => _complete(ref, m),
                            child: const Text('Concluir'),
                          ),
                        ),
                ),
            ],
          ),
        ),
      ),
      actionsPadding: const EdgeInsets.all(AppSpacing.md),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
        if (asset.status != AssetStatus.writtenOff)
          Can(
            permission: 'inventory.asset.maintain',
            child: FilledButton(
              onPressed: () => _schedule(context, ref),
              child: const Text('Agendar'),
            ),
          ),
      ],
    );
  }
}
