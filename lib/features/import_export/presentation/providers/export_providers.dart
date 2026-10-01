import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../data/export/export_file_saver.dart';
import '../../data/export/export_service.dart';

final exportServiceProvider = Provider<ExportService>(
  (ref) => ExportService(ref.watch(permissionServiceProvider)),
);

final exportFileSaverProvider = Provider<ExportFileSaver>(
  (ref) => const PickerExportFileSaver(),
);

/// Handler ligado a [exportHandlerProvider] em `main.dart`: gera o ficheiro
/// (validando permissões), pede onde guardar, avisa o utilizador e audita.
final exportRunnerProvider = Provider<ExportHandler>((ref) {
  return (dataset, format) async {
    final toast = ref.read(toastProvider.notifier);
    final result = await ref
        .read(exportServiceProvider)
        .export(dataset, format);
    final file = result.valueOrNull;
    if (file == null) {
      toast.error(result.failureOrNull!.message);
      return;
    }
    try {
      if (!await ref.read(exportFileSaverProvider).save(file)) return;
    } on Object {
      toast.error('Não foi possível guardar o ficheiro.');
      return;
    }
    toast.success('${file.rowCount} registos exportados (${format.label}).');
    // Exportar dados pessoais é sensível: fica em auditoria (não anula a acção).
    unawaited(
      ref
          .read(auditServiceProvider)
          .record(
            entity: dataset.entity,
            action: AuditAction.other,
            after: {
              'event': 'export',
              'format': format.extension,
              'rows': file.rowCount,
              'columns': file.columnKeys,
            },
          ),
    );
  };
});
