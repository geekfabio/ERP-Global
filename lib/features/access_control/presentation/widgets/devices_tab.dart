import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/access_models.dart';
import '../providers/access_providers.dart';
import 'access_dialogs.dart';
import 'access_labels.dart';
import 'access_table.dart';

/// Dispositivos (leitores, torniquetes, portas) associados às zonas.
class DevicesTab extends ConsumerWidget {
  const DevicesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.read(accessDeviceRepositoryProvider);
    final zones = {
      for (final z in ref.watch(zoneListProvider).value ?? <ZoneModel>[])
        z.id: z.name,
    };
    final can = ref.watch(permissionServiceProvider).canAny;
    void refresh() => ref.invalidate(accessDeviceListProvider);

    Future<void> save(AccessDeviceModel device) async {
      final result = device.id.isEmpty
          ? await repo.create(device)
          : await repo.update(device);
      if (reportResult(
        ref,
        result,
        done: device.id.isEmpty
            ? 'Dispositivo criado'
            : 'Dispositivo actualizado',
      )) {
        refresh();
      }
    }

    Future<void> edit(AccessDeviceModel? device) async {
      final v = await showDeviceDialog(context, zones: zones, device: device);
      if (v != null) await save(v);
    }

    Future<void> remove(AccessDeviceModel d) async {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Eliminar dispositivo',
        message: 'Eliminar "${d.name}"?',
        confirmLabel: 'Eliminar',
        destructive: true,
      );
      if (!ok) return;
      if (reportResult(
        ref,
        await repo.delete(d.id),
        done: 'Dispositivo eliminado',
      )) {
        refresh();
      }
    }

    return AccessListTab<AccessDeviceModel>(
      key: ValueKey(zones.toString()),
      value: ref.watch(accessDeviceListProvider),
      onRetry: refresh,
      createLabel: 'Novo dispositivo',
      createPermission: 'access.device.create',
      onCreate: () => edit(null),
      emptyIcon: Icons.sensors_outlined,
      emptyTitle: 'Sem dispositivos registados',
      rowId: (d) => d.id,
      columns: [
        AppColumn(label: 'Nome', text: (d) => d.name, sortValue: (d) => d.name),
        AppColumn(label: 'Zona', text: (d) => zones[d.zoneId] ?? d.zoneId),
        AppColumn(label: 'Tipo', text: (d) => deviceKindLabel(d.kind)),
        AppColumn(
          label: 'Ligação',
          text: (d) => deviceStatusLabel(d.status),
          cell: (d) => StatusBadge(
            label: deviceStatusLabel(d.status),
            status: deviceStatusBadge(d.status),
          ),
        ),
        AppColumn(
          label: 'Última actividade',
          text: (d) =>
              d.lastSeenAt == null ? '—' : PtAoFormatters.date(d.lastSeenAt!),
        ),
        AppColumn(
          label: 'Estado',
          text: (d) => activeLabel(d.isActive),
          cell: (d) => StatusBadge(
            label: activeLabel(d.isActive),
            status: activeBadge(d.isActive),
          ),
        ),
      ],
      rowActions: [
        if (can('access.device.update')) ...[
          RowAction(label: 'Editar', icon: Icons.edit_outlined, onTap: edit),
          RowAction(
            label: 'Activar / desactivar',
            icon: Icons.toggle_on_outlined,
            onTap: (d) => save(d.copyWith(isActive: !d.isActive)),
          ),
        ],
        if (can('access.device.delete'))
          RowAction(
            label: 'Eliminar',
            icon: Icons.delete_outline,
            onTap: remove,
          ),
      ],
    );
  }
}
