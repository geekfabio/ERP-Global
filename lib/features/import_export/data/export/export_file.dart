import 'dart:typed_data';

import '../../../../core/export/export_contract.dart';

/// Ficheiro gerado, pronto a guardar.
class ExportFile {
  const ExportFile({
    required this.fileName,
    required this.format,
    required this.bytes,
    required this.rowCount,
    required this.columnKeys,
  });

  final String fileName;
  final ExportFormat format;
  final Uint8List bytes;
  final int rowCount;

  /// Colunas que efectivamente saíram (após o filtro por permissão).
  final List<String> columnKeys;
}

/// Tabela já filtrada por permissão que os codificadores escrevem.
class ExportTable {
  const ExportTable({
    required this.title,
    required this.headers,
    required this.rows,
    required this.generatedAt,
  });

  final String title;
  final List<String> headers;
  final List<List<String>> rows;
  final DateTime generatedAt;
}
