/// Parser de CSV (RFC 4180): aspas, aspas duplas escapadas e quebras de linha
/// dentro de campos. Detecta `;` (Excel pt) ou `,` e ignora o BOM.
List<List<String>> parseCsv(String input, {String? delimiter}) {
  final text = input.startsWith('﻿') ? input.substring(1) : input;
  final sep = delimiter ?? _detectDelimiter(text);
  final rows = <List<String>>[];
  var row = <String>[];
  final cell = StringBuffer();
  var quoted = false;

  void endCell() {
    row.add(cell.toString().trim());
    cell.clear();
  }

  void endRow() {
    endCell();
    if (row.any((c) => c.isNotEmpty)) rows.add(row);
    row = <String>[];
  }

  for (var i = 0; i < text.length; i++) {
    final ch = text[i];
    if (quoted) {
      if (ch == '"') {
        if (i + 1 < text.length && text[i + 1] == '"') {
          cell.write('"');
          i++;
        } else {
          quoted = false;
        }
      } else {
        cell.write(ch);
      }
    } else if (ch == '"') {
      quoted = true;
    } else if (ch == sep) {
      endCell();
    } else if (ch == '\n' || ch == '\r') {
      if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
      endRow();
    } else {
      cell.write(ch);
    }
  }
  if (quoted) throw const FormatException('CSV com aspas por fechar.');
  if (cell.isNotEmpty || row.isNotEmpty) endRow();
  return rows;
}

String _detectDelimiter(String text) {
  final firstLine = text.split(RegExp(r'\r?\n')).first;
  var best = ',';
  var bestCount = -1;
  for (final d in [';', ',', '\t']) {
    final n = d.allMatches(firstLine).length;
    if (n > bestCount) {
      best = d;
      bestCount = n;
    }
  }
  return best;
}

/// Serializa linhas em CSV (`;`), com escape de aspas — usado no relatório de erros.
String writeCsv(List<List<String>> rows) => rows
    .map(
      (r) => r
          .map(
            (c) => c.contains(RegExp(r'[;"\n\r]'))
                ? '"${c.replaceAll('"', '""')}"'
                : c,
          )
          .join(';'),
    )
    .join('\r\n');
