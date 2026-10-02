import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/access_models.dart';
import '../providers/access_providers.dart';
import 'access_dialogs.dart';
import 'access_labels.dart';
import 'access_table.dart';

/// Regras de acesso por zona: dias, horário, tipo de pessoa e condições
/// de aluno activo / situação financeira.
class RulesTab extends ConsumerWidget {
  const RulesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(accessRuleRepositoryProvider);
    final zones = {
      for (final z in ref.watch(zoneListProvider).value ?? <ZoneModel>[])
        z.id: z.name,
    };
    final can = ref.watch(permissionServiceProvider).canAny;
    void refresh() => ref.invalidate(accessRuleListProvider);

    Future<void> save(AccessRuleModel rule) async {
      final result = rule.id.isEmpty
          ? await repo.create(rule)
          : await repo.update(rule);
      if (reportResult(
        ref,
        result,
        done: rule.id.isEmpty ? 'Regra criada' : 'Regra actualizada',
      )) {
        refresh();
      }
    }

    Future<void> edit(AccessRuleModel? rule) async {
      final v = await showRuleDialog(context, zones: zones, rule: rule);
      if (v != null) await save(v);
    }

    Future<void> remove(AccessRuleModel r) async {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Eliminar regra',
        message: 'Eliminar a regra "${r.name}"?',
        confirmLabel: 'Eliminar',
        destructive: true,
      );
      if (!ok) return;
      if (reportResult(ref, await repo.delete(r.id), done: 'Regra eliminada')) {
        refresh();
      }
    }

    return AccessListTab<AccessRuleModel>(
      key: ValueKey(zones.toString()),
      value: ref.watch(accessRuleListProvider),
      onRetry: refresh,
      createLabel: 'Nova regra',
      createPermission: 'access.rule.create',
      onCreate: () => edit(null),
      emptyIcon: Icons.schedule_outlined,
      emptyTitle: 'Sem regras de acesso',
      rowId: (r) => r.id,
      columns: [
        AppColumn(label: 'Nome', text: (r) => r.name, sortValue: (r) => r.name),
        AppColumn(label: 'Zona', text: (r) => zones[r.zoneId] ?? r.zoneId),
        AppColumn(label: 'Aplica-se a', text: (r) => subjectLabel(r.subject)),
        AppColumn(label: 'Horário', text: ruleWindowLabel),
        AppColumn(
          label: 'Condições',
          text: (r) => [
            if (r.requireActiveStudent) 'Aluno activo',
            if (r.requireFinancialClear) 'Sem pendências',
          ].join(' · ').ifEmpty('—'),
        ),
        AppColumn(
          label: 'Estado',
          text: (r) => activeLabel(r.isActive),
          cell: (r) => StatusBadge(
            label: activeLabel(r.isActive),
            status: activeBadge(r.isActive),
          ),
        ),
      ],
      rowActions: [
        if (can('access.rule.update')) ...[
          RowAction(label: 'Editar', icon: Icons.edit_outlined, onTap: edit),
          RowAction(
            label: 'Activar / desactivar',
            icon: Icons.toggle_on_outlined,
            onTap: (r) => save(r.copyWith(isActive: !r.isActive)),
          ),
        ],
        if (can('access.rule.delete'))
          RowAction(
            label: 'Eliminar',
            icon: Icons.delete_outline,
            onTap: remove,
          ),
      ],
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
