import 'dart:convert';
import 'dart:typed_data';

import 'package:excel/excel.dart';

import 'csv_parser.dart';
import 'import_profile.dart';

/// Templates oficiais de importação: cabeçalhos do perfil + uma linha de
/// exemplo. Os cabeçalhos são os rótulos, que o mapeamento automático reconhece.
class ImportTemplate {
  const ImportTemplate._();

  static List<List<String>> _grid(ImportProfile p) => [
    [for (final c in p.columns) c.label],
    [for (final c in p.columns) c.example],
  ];

  static String fileName(ImportProfile p, String ext) =>
      'modelo-importacao-${p.id}.$ext';

  /// CSV com BOM UTF-8 (abre bem no Excel) e separador `;`.
  static Uint8List csv(ImportProfile p) =>
      Uint8List.fromList(utf8.encode('\u{FEFF}${writeCsv(_grid(p))}'));

  /// `.xlsx` com folha de dados (cabeçalho a negrito) e folha de instruções.
  static Uint8List xlsx(ImportProfile p) {
    final book = Excel.createExcel();
    final dataName = p.label;
    book.rename(book.getDefaultSheet()!, dataName);
    final data = book[dataName];
    final grid = _grid(p);
    for (var r = 0; r < grid.length; r++) {
      for (var c = 0; c < grid[r].length; c++) {
        final cell = data.cell(
          CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r),
        );
        cell.value = TextCellValue(grid[r][c]);
        if (r == 0) cell.cellStyle = CellStyle(bold: true);
      }
    }
    final help = book['Instruções'];
    final rows = [
      ['Coluna', 'Obrigatória', 'Exemplo'],
      for (final c in p.columns)
        [c.label, c.required ? 'Sim' : 'Não', c.example],
    ];
    for (var r = 0; r < rows.length; r++) {
      for (var c = 0; c < rows[r].length; c++) {
        help
            .cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r))
            .value = TextCellValue(
          rows[r][c],
        );
      }
    }
    return Uint8List.fromList(book.save()!);
  }
}
