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

/// Zonas físicas por campus (criar, editar, activar/desactivar, eliminar).
class ZonesTab extends ConsumerWidget {
  const ZonesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(zoneRepositoryProvider);
    final campuses = ref.watch(campusNamesProvider).value ?? const {};
    final can = ref.watch(permissionServiceProvider).canAny;
    void refresh() => ref.invalidate(zoneListProvider);

    Future<void> save(ZoneModel zone) async {
      final result = zone.id.isEmpty
          ? await repo.create(zone)
          : await repo.update(zone);
      if (reportResult(
        ref,
        result,
        done: zone.id.isEmpty ? 'Zona criada' : 'Zona actualizada',
      )) {
        refresh();
      }
    }

    Future<void> edit(ZoneModel? zone) async {
      final v = await showZoneDialog(context, campuses: campuses, zone: zone);
      if (v != null) await save(v);
    }

    Future<void> remove(ZoneModel z) async {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Eliminar zona',
        message: 'Eliminar a zona "${z.name}"?',
        confirmLabel: 'Eliminar',
        destructive: true,
      );
      if (!ok) return;
      if (reportResult(ref, await repo.delete(z.id), done: 'Zona eliminada')) {
        refresh();
      }
    }

    return AccessListTab<ZoneModel>(
      key: ValueKey(campuses.toString()),
      value: ref.watch(zoneListProvider),
      onRetry: refresh,
      createLabel: 'Nova zona',
      createPermission: 'access.zone.create',
      onCreate: () => edit(null),
      emptyIcon: Icons.meeting_room_outlined,
      emptyTitle: 'Sem zonas definidas',
      rowId: (z) => z.id,
      columns: [
        AppColumn(label: 'Nome', text: (z) => z.name, sortValue: (z) => z.name),
        AppColumn(
          label: 'Campus',
          text: (z) => campuses[z.campusId] ?? z.campusId,
        ),
        AppColumn(label: 'Descrição', text: (z) => z.description ?? '—'),
        AppColumn(
          label: 'Estado',
          text: (z) => activeLabel(z.isActive),
          cell: (z) => StatusBadge(
            label: activeLabel(z.isActive),
            status: activeBadge(z.isActive),
          ),
        ),
      ],
      rowActions: [
        if (can('access.zone.update')) ...[
          RowAction(label: 'Editar', icon: Icons.edit_outlined, onTap: edit),
          RowAction(
            label: 'Activar / desactivar',
            icon: Icons.toggle_on_outlined,
            onTap: (z) => save(z.copyWith(isActive: !z.isActive)),
          ),
        ],
        if (can('access.zone.delete'))
          RowAction(
            label: 'Eliminar',
            icon: Icons.delete_outline,
            onTap: remove,
          ),
      ],
    );
  }
}
