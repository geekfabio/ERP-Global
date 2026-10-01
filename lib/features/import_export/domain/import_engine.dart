import 'csv_parser.dart';
import 'import_profile.dart';
import 'import_table.dart';

/// Mapeamento: chave da coluna do perfil → índice da coluna no ficheiro (`null` = não mapeada).
typedef ColumnMapping = Map<String, int?>;

/// Linha validada (`lineNumber` é o da linha no ficheiro, 1 = cabeçalho).
class ImportRowResult {
  const ImportRowResult({
    required this.lineNumber,
    required this.raw,
    required this.record,
    required this.errors,
  });

  final int lineNumber;
  final List<String> raw;

  /// Registo convertido, pronto a enviar (só campos preenchidos).
  final Map<String, Object?> record;
  final List<ImportRowError> errors;

  bool get isValid => errors.isEmpty;
}

/// Resultado da validação local de todo o ficheiro (nada é gravado).
class ImportPreview {
  const ImportPreview({required this.rows});

  final List<ImportRowResult> rows;

  List<ImportRowResult> get valid => rows.where((r) => r.isValid).toList();
  List<ImportRowResult> get invalid => rows.where((r) => !r.isValid).toList();
}

/// Motor: mapeia colunas, valida linha a linha e gera o relatório de erros.
class ImportEngine {
  const ImportEngine();

  static String _norm(String s) => s
      .toLowerCase()
      .replaceAll(RegExp('[áàâã]'), 'a')
      .replaceAll(RegExp('[éê]'), 'e')
      .replaceAll('í', 'i')
      .replaceAll(RegExp('[óôõ]'), 'o')
      .replaceAll('ú', 'u')
      .replaceAll('ç', 'c')
      .replaceAll(RegExp('[^a-z0-9]'), '');

  /// Associa cada coluna do perfil ao cabeçalho com o mesmo nome/rótulo/alias.
  ColumnMapping autoMap(ImportProfile profile, List<String> headers) {
    final normalized = [for (final h in headers) _norm(h)];
    final used = <int>{};
    final mapping = <String, int?>{};
    for (final c in profile.columns) {
      final names = {c.key, c.label, ...c.aliases}.map(_norm).toSet();
      var found = -1;
      for (var i = 0; i < normalized.length; i++) {
        if (!used.contains(i) && names.contains(normalized[i])) {
          found = i;
          break;
        }
      }
      mapping[c.key] = found < 0 ? null : found;
      if (found >= 0) used.add(found);
    }
    return mapping;
  }

  /// Colunas obrigatórias sem mapeamento (impedem avançar).
  List<ImportColumn> missingRequired(
    ImportProfile profile,
    ColumnMapping mapping,
  ) => [
    for (final c in profile.columns)
      if (c.required && mapping[c.key] == null) c,
  ];

  ImportPreview validate(
    ImportProfile profile,
    ImportTable table,
    ColumnMapping mapping,
  ) {
    final results = <ImportRowResult>[];
    for (var n = 0; n < table.rows.length; n++) {
      final raw = table.rows[n];
      final errors = <ImportRowError>[];
      final record = <String, Object?>{};
      for (final c in profile.columns) {
        final index = mapping[c.key];
        final text = index == null || index >= raw.length
            ? ''
            : raw[index].trim();
        if (text.isEmpty) {
          if (c.required) {
            errors.add(
              ImportRowError(field: c.key, message: 'Campo obrigatório'),
            );
          }
          continue;
        }
        try {
          record[c.key] = c.parse == null ? text : c.parse!(text);
        } on FormatException catch (e) {
          errors.add(ImportRowError(field: c.key, message: e.message));
        }
      }
      if (errors.isEmpty) {
        profile
            .validateRecord(record)
            .forEach(
              (k, v) => errors.add(ImportRowError(field: k, message: v)),
            );
      }
      results.add(
        ImportRowResult(
          lineNumber: n + 2,
          raw: raw,
          record: record,
          errors: errors,
        ),
      );
    }
    return ImportPreview(rows: results);
  }

  /// CSV com uma linha por erro: linha, campo e mensagem.
  String errorReportCsv(ImportProfile profile, ImportPreview preview) {
    final label = {for (final c in profile.columns) c.key: c.label};
    return writeCsv([
      ['Linha', 'Campo', 'Erro'],
      for (final r in preview.invalid)
        for (final e in r.errors)
          [r.lineNumber.toString(), label[e.field] ?? e.field, e.message],
    ]);
  }
}
