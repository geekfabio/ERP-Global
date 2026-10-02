import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'csv_parser.dart';

/// Tabela lida do ficheiro: primeira linha = cabeçalhos.
class ImportTable {
  const ImportTable({required this.headers, required this.rows});

  final List<String> headers;

  /// Linhas de dados (sem o cabeçalho), alinhadas com [headers].
  final List<List<String>> rows;

  /// Lê CSV ou Excel (`.xlsx`) pelo nome do ficheiro. Lança [FormatException]
  /// com mensagem pt-AO se o formato não for suportado ou o ficheiro estiver vazio.
  factory ImportTable.fromBytes(String fileName, Uint8List bytes) {
    final dot = fileName.lastIndexOf('.');
    final ext = dot < 0 ? '' : fileName.substring(dot).toLowerCase();
    final grid = switch (ext) {
      '.csv' || '.txt' => parseCsv(utf8.decode(bytes, allowMalformed: true)),
      '.xlsx' => _readXlsx(bytes),
      _ => throw const FormatException(
        'Formato não suportado. Use um ficheiro .csv ou .xlsx.',
      ),
    };
    return ImportTable.fromGrid(grid);
  }

  factory ImportTable.fromGrid(List<List<String>> grid) {
    if (grid.isEmpty) {
      throw const FormatException('O ficheiro não tem dados.');
    }
    final headers = grid.first;
    final width = headers.length;
    final rows = [
      for (final r in grid.skip(1))
        [for (var i = 0; i < width; i++) i < r.length ? r[i] : ''],
    ];
    return ImportTable(headers: headers, rows: rows);
  }
}

List<List<String>> _readXlsx(Uint8List bytes) {
  final Excel book;
  try {
    book = Excel.decodeBytes(bytes);
  } on Object {
    throw const FormatException('Ficheiro Excel inválido ou corrompido.');
  }
  if (book.tables.isEmpty) return const [];
  final sheet = book.tables.values.first;
  return [
    for (final row in sheet.rows)
      if (row.any((c) => c?.value != null))
        [for (final c in row) _cellText(c?.value)],
  ];
}

String _cellText(CellValue? v) => switch (v) {
  null => '',
  DateCellValue() => v.asDateTimeUtc().toIso8601String().substring(0, 10),
  DateTimeCellValue() => v.asDateTimeUtc().toIso8601String(),
  _ => v.toString().trim(),
};
