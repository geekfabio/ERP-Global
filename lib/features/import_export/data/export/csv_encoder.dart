import 'dart:convert';
import 'dart:typed_data';

import 'export_file.dart';

/// Neutraliza células que o Excel interpretaria como fórmula (`=`, `+`, `-`,
/// `@`, tab, CR) prefixando uma plica; números simples (`-5`) ficam intactos.
String guardFormula(String value) {
  if (value.isEmpty || !'=+-@\t\r'.contains(value[0])) return value;
  if (num.tryParse(value.replaceAll(',', '.')) != null) return value;
  return "'$value";
}

/// CSV UTF-8 com BOM e `;` (Excel pt-AO), aspas RFC 4180 e CRLF.
Uint8List encodeCsv(ExportTable table) {
  String esc(String v) {
    final s = guardFormula(v);
    return s.contains(RegExp('[;"\r\n]')) ? '"${s.replaceAll('"', '""')}"' : s;
  }

  final out = StringBuffer('﻿')
    ..write(table.headers.map(esc).join(';'))
    ..write('\r\n');
  for (final row in table.rows) {
    out
      ..write(row.map(esc).join(';'))
      ..write('\r\n');
  }
  return Uint8List.fromList(utf8.encode(out.toString()));
}
