import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../modules/license_gate.dart';
import '../security/permission_providers.dart';

/// Formatos de exportação suportados.
enum ExportFormat {
  csv('CSV', 'csv', 'text/csv'),
  xlsx(
    'Excel',
    'xlsx',
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  ),
  pdf('PDF', 'pdf', 'application/pdf');

  const ExportFormat(this.label, this.extension, this.mimeType);

  final String label;
  final String extension;
  final String mimeType;
}

/// Coluna exportável de uma tabela. [permission] (ex.: `students.health.read`)
/// restringe a coluna: sem ela, a coluna não sai no ficheiro.
class ExportColumn<T> {
  const ExportColumn({
    required this.key,
    required this.label,
    required this.text,
    this.permission,
  });

  final String key;
  final String label;
  final String Function(T row) text;
  final String? permission;
}

/// Conjunto de dados a exportar, sem tipo de linha (contrato entre módulos).
/// Cada linha tem uma célula por coluna, pela mesma ordem.
class ExportDataset {
  const ExportDataset({
    required this.title,
    required this.entity,
    required this.permission,
    required this.columns,
    required this.rows,
  });

  /// Constrói a partir de linhas tipadas e das [columns] da tabela.
  static ExportDataset from<T>({
    required String title,
    required String entity,
    required String permission,
    required List<ExportColumn<T>> columns,
    required Iterable<T> rows,
  }) => ExportDataset(
    title: title,
    entity: entity,
    permission: permission,
    columns: [
      for (final c in columns)
        ExportDatasetColumn(
          key: c.key,
          label: c.label,
          permission: c.permission,
        ),
    ],
    rows: [
      for (final r in rows) [for (final c in columns) c.text(r)],
    ],
  );

  final String title;

  /// Nome técnico da entidade (auditoria e nome do ficheiro).
  final String entity;

  /// Permissão `export` exigida (ex.: `students.record.export`).
  final String permission;
  final List<ExportDatasetColumn> columns;
  final List<List<String>> rows;
}

class ExportDatasetColumn {
  const ExportDatasetColumn({
    required this.key,
    required this.label,
    this.permission,
  });

  final String key;
  final String label;
  final String? permission;
}

/// Executa a exportação (gerar, guardar, auditar). Ligado em `main.dart` ao
/// módulo `import_export`; sem ele (módulo desligado) não há exportação.
typedef ExportHandler =
    Future<void> Function(ExportDataset dataset, ExportFormat format);

final exportHandlerProvider = Provider<ExportHandler?>((ref) => null);

/// Pode a sessão exportar com [permission]? Exige o handler, o módulo
/// `import_export` licenciado e a permissão (só apresentação; o serviço valida).
final canExportProvider = Provider.family<bool, String>((ref, permission) {
  if (ref.watch(exportHandlerProvider) == null) return false;
  if (!ref.watch(enabledModulesProvider).contains('import_export')) {
    return false;
  }
  return ref.watch(permissionServiceProvider).canAny(permission);
});
