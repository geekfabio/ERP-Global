import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/accounting_models.dart';
import '../providers/accounting_providers.dart';
import 'accounting_form_dialog.dart';

/// Centros de custo: criação, edição, (des)activação e eliminação.
class CostCentersTab extends ConsumerStatefulWidget {
  const CostCentersTab({super.key});

  @override
  ConsumerState<CostCentersTab> createState() => _CostCentersTabState();
}

class _CostCentersTabState extends ConsumerState<CostCentersTab> {
  void _refresh() => ref.invalidate(costCenterListProvider);

  Future<void> _create() async {
    final v = await showAccountingForm(
      context,
      title: 'Novo centro de custo',
      fields: const [
        FormFieldSpec('code', 'Código'),
        FormFieldSpec('name', 'Designação'),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(costCenterRepositoryProvider)
        .create(
          CostCenterModel(
            id: '',
            code: v['code']! as String,
            name: v['name']! as String,
          ),
        );
    if (reportResult(ref, result, done: 'Centro de custo criado')) _refresh();
  }

  Future<void> _rename(CostCenterModel c) async {
    final v = await showAccountingForm(
      context,
      title: 'Editar centro de custo',
      subtitle: c.code,
      fields: [FormFieldSpec('name', 'Designação', initial: c.name)],
    );
    if (v == null) return;
    final result = await ref
        .read(costCenterRepositoryProvider)
        .update(c.id, name: v['name']! as String);
    if (reportResult(ref, result, done: 'Centro de custo actualizado')) {
      _refresh();
    }
  }

  Future<void> _toggle(CostCenterModel c) async {
    final result = await ref
        .read(costCenterRepositoryProvider)
        .update(c.id, isActive: !c.isActive);
    if (reportResult(
      ref,
      result,
      done: c.isActive ? 'Centro desactivado' : 'Centro activado',
    )) {
      _refresh();
    }
  }

  Future<void> _delete(CostCenterModel c) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Eliminar centro de custo',
      message: 'Eliminar ${c.code} · ${c.name}?',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref.read(costCenterRepositoryProvider).delete(c.id);
    if (reportResult(ref, result, done: 'Centro de custo eliminado')) {
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final centers = ref.watch(costCenterListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'accounting.costcenter.create',
              child: AppButton(
                label: 'Novo centro de custo',
                icon: Icons.add,
                onPressed: _create,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<CostCenterModel>>(
            value: centers,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.hub_outlined,
              title: 'Sem centros de custo',
            ),
            data: (items) => ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final c = items[i];
                return ListTile(
                  key: Key('center_${c.code}'),
                  title: Text('${c.code} · ${c.name}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (!c.isActive)
                        const StatusBadge(
                          label: 'Inactivo',
                          status: BadgeStatus.neutral,
                        ),
                      PopupMenuButton<VoidCallback>(
                        tooltip: 'Acções',
                        onSelected: (run) => run(),
                        itemBuilder: (_) => [
                          if (can('accounting.costcenter.update')) ...[
                            PopupMenuItem(
                              value: () => _rename(c),
                              child: const Text('Editar designação'),
                            ),
                            PopupMenuItem(
                              value: () => _toggle(c),
                              child: Text(
                                c.isActive ? 'Desactivar' : 'Activar',
                              ),
                            ),
                          ],
                          if (can('accounting.costcenter.delete'))
                            PopupMenuItem(
                              value: () => _delete(c),
                              child: const Text('Eliminar'),
                            ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
