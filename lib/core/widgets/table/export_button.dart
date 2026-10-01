import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../export/export_contract.dart';

/// Botão "Exportar" com escolha de formato. Não é construído sem permissão
/// [permission], sem módulo `import_export` licenciado ou sem handler.
class ExportButton extends ConsumerWidget {
  const ExportButton({
    super.key,
    required this.permission,
    required this.dataset,
  });

  final String permission;

  /// Recolhe os dados no momento da escolha (ex.: linhas visíveis/seleccionadas).
  final ExportDataset Function() dataset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canExportProvider(permission))) {
      return const SizedBox.shrink();
    }
    return PopupMenuButton<ExportFormat>(
      tooltip: 'Exportar',
      icon: const Icon(Icons.download_outlined),
      onSelected: (f) => ref.read(exportHandlerProvider)?.call(dataset(), f),
      itemBuilder: (_) => [
        for (final f in ExportFormat.values)
          PopupMenuItem(value: f, child: Text(f.label)),
      ],
    );
  }
}

/// Hook `onExport` para [AppDataTable]: `null` (sem botão) se não puder
/// exportar; senão pede o formato e exporta as linhas recebidas.
void Function(List<T> rows)? exportHookFor<T>(
  BuildContext context,
  WidgetRef ref, {
  required String permission,
  required String title,
  required String entity,
  required List<ExportColumn<T>> columns,
}) {
  if (!ref.watch(canExportProvider(permission))) return null;
  return (rows) async {
    final format = await showDialog<ExportFormat>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Exportar como'),
        children: [
          for (final f in ExportFormat.values)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(f),
              child: Text(f.label),
            ),
        ],
      ),
    );
    if (format == null) return;
    await ref
        .read(exportHandlerProvider)
        ?.call(
          ExportDataset.from<T>(
            title: title,
            entity: entity,
            permission: permission,
            columns: columns,
            rows: rows,
          ),
          format,
        );
  };
}
