import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'export_file.dart';

/// Excel (`.xlsx`) com uma folha; tudo como texto (nunca fórmulas) e
/// cabeçalho a negrito.
Uint8List encodeXlsx(ExportTable table) {
  final book = Excel.createExcel();
  final name = _sheetName(table.title);
  book.rename(book.getDefaultSheet()!, name);
  final sheet = book[name];
  sheet.appendRow([for (final h in table.headers) TextCellValue(h)]);
  final header = CellStyle(bold: true);
  for (var c = 0; c < table.headers.length; c++) {
    sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: 0))
            .cellStyle =
        header;
  }
  for (final row in table.rows) {
    sheet.appendRow([for (final v in row) TextCellValue(v)]);
  }
  return Uint8List.fromList(book.encode()!);
}

/// Nomes de folha: máx. 31 caracteres, sem `[]:*?/\`.
String _sheetName(String title) {
  final clean = title.replaceAll(RegExp(r'[\[\]:*?/\\]'), ' ').trim();
  if (clean.isEmpty) return 'Dados';
  return clean.length > 31 ? clean.substring(0, 31) : clean;
}
