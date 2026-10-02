import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/security/permission_service.dart';
import 'csv_encoder.dart';
import 'export_file.dart';
import 'pdf_encoder.dart';
import 'xlsx_encoder.dart';

/// Gera ficheiros CSV/Excel/PDF a partir de um [ExportDataset], respeitando
/// permissões: exige a permissão `export` do dataset e remove as colunas cujo
/// código de permissão a sessão não tem. É a última barreira — a UI só esconde.
class ExportService {
  ExportService(this._permissions, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  final PermissionService _permissions;
  final DateTime Function() _now;

  Future<Result<ExportFile>> export(
    ExportDataset dataset,
    ExportFormat format,
  ) => Result.guard(() async {
    if (!_permissions.canAny(dataset.permission)) throw PermissionFailure();
    final keep = [
      for (var i = 0; i < dataset.columns.length; i++)
        if (_columnAllowed(dataset.columns[i])) i,
    ];
    if (keep.isEmpty) {
      throw PermissionFailure(
        message: 'Não tem permissão para exportar nenhuma coluna.',
      );
    }
    final at = _now();
    final table = ExportTable(
      title: dataset.title,
      headers: [for (final i in keep) dataset.columns[i].label],
      rows: [
        for (final row in dataset.rows) [for (final i in keep) row[i]],
      ],
      generatedAt: at,
    );
    final bytes = switch (format) {
      ExportFormat.csv => encodeCsv(table),
      ExportFormat.xlsx => encodeXlsx(table),
      ExportFormat.pdf => await encodePdf(table),
    };
    return ExportFile(
      fileName: _fileName(dataset.entity, format, at),
      format: format,
      bytes: bytes,
      rowCount: table.rows.length,
      columnKeys: [for (final i in keep) dataset.columns[i].key],
    );
  });

  bool _columnAllowed(ExportDatasetColumn c) =>
      c.permission == null || _permissions.canAny(c.permission!);

  static String _fileName(String entity, ExportFormat f, DateTime at) {
    final safe = entity.replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '-');
    final u = at.toUtc();
    String two(int n) => n.toString().padLeft(2, '0');
    return '$safe-${u.year}${two(u.month)}${two(u.day)}-'
        '${two(u.hour)}${two(u.minute)}.${f.extension}';
  }
}
