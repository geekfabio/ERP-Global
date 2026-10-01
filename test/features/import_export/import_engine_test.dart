import 'dart:convert';
import 'dart:typed_data';

import 'package:erp_global/features/import_export/domain/csv_parser.dart';
import 'package:erp_global/features/import_export/domain/import_engine.dart';
import 'package:erp_global/features/import_export/domain/import_table.dart';
import 'package:erp_global/features/import_export/domain/profiles/students_import_profile.dart';
import 'package:flutter_test/flutter_test.dart';

const _csv =
    'Nome;Data de Nascimento;Sexo;BI;Telefone\n'
    'Ana Paulo;12/03/2012;F;004567890LA041;923456789\n'
    '"Silva, João";31/02/2011;M;;\n'
    ';05/05/2010;X;123;12\n';

void main() {
  const profile = StudentsImportProfile();
  const engine = ImportEngine();

  test('parseCsv detecta delimitador, aspas e BOM', () {
    final rows = parseCsv('﻿a,b\n"x, y","z ""q"""\r\n');
    expect(rows, [
      ['a', 'b'],
      ['x, y', 'z "q"'],
    ]);
    expect(() => parseCsv('a,"b'), throwsFormatException);
  });

  test('autoMap reconhece cabeçalhos por alias, sem acentos', () {
    final table = ImportTable.fromGrid(parseCsv(_csv));
    final m = engine.autoMap(profile, table.headers);
    expect(m['fullName'], 0);
    expect(m['birthDate'], 1);
    expect(m['gender'], 2);
    expect(m['biNumber'], 3);
    expect(m['guardianPhone'], 4);
  });

  test('validação por linha e relatório de erros', () {
    final table = ImportTable.fromGrid(parseCsv(_csv));
    final mapping = engine.autoMap(profile, table.headers);
    final preview = engine.validate(profile, table, mapping);

    expect(preview.valid.length, 1);
    expect(preview.valid.single.record['gender'], 'female');
    expect(
      preview.valid.single.record['birthDate'],
      '2012-03-12T00:00:00.000Z',
    );

    expect(preview.invalid.map((r) => r.lineNumber), [3, 4]);
    expect(preview.rows[1].errors.single.message, 'Data inexistente');
    expect(preview.rows[2].errors.map((e) => e.field).toSet(), {
      'fullName',
      'gender',
      'biNumber',
      'guardianPhone',
    });

    final report = engine.errorReportCsv(profile, preview);
    expect(report.split('\r\n').first, 'Linha;Campo;Erro');
    expect(report, contains('3;Data de nascimento;Data inexistente'));
  });

  test('colunas obrigatórias sem mapeamento são reportadas', () {
    final missing = engine.missingRequired(profile, {'fullName': 0});
    expect(missing.map((c) => c.key), ['birthDate', 'gender']);
  });

  test('ImportTable rejeita formato desconhecido e ficheiro vazio', () {
    expect(
      () =>
          ImportTable.fromBytes('a.pdf', Uint8List.fromList(utf8.encode('x'))),
      throwsFormatException,
    );
    expect(() => ImportTable.fromGrid(const []), throwsFormatException);
  });
}
