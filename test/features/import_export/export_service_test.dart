import 'dart:convert';

import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/import_export/data/export/csv_encoder.dart';
import 'package:erp_global/features/import_export/data/export/export_service.dart';
import 'package:erp_global/features/import_export/domain/csv_parser.dart';
import 'package:erp_global/features/import_export/domain/import_table.dart';
import 'package:flutter_test/flutter_test.dart';

ExportDataset _dataset({String permission = 'students.record.export'}) =>
    ExportDataset(
      title: 'Alunos',
      entity: 'students',
      permission: permission,
      columns: const [
        ExportDatasetColumn(key: 'name', label: 'Nome'),
        ExportDatasetColumn(key: 'notes', label: 'Notas'),
        ExportDatasetColumn(
          key: 'health',
          label: 'Saúde',
          permission: 'students.health.read',
        ),
      ],
      rows: const [
        ['João "Zé" Silva', 'a;b', 'asma'],
        ['=HYPERLINK("x")', '-5', 'nenhuma'],
      ],
    );

ExportService _service(List<String> codes, {bool readOnly = false}) =>
    ExportService(
      PermissionService.fromCodes(codes, readOnly: readOnly),
      now: () => DateTime.utc(2026, 3, 5, 9, 7),
    );

void main() {
  group('permissões', () {
    test('sem permissão export devolve PermissionFailure', () async {
      final r = await _service([
        'students.record.read',
      ]).export(_dataset(), ExportFormat.csv);
      expect(r.failureOrNull, isA<PermissionFailure>());
    });

    test('colunas restritas saem só com a permissão da coluna', () async {
      final without = (await _service([
        'students.record.export',
      ]).export(_dataset(), ExportFormat.csv)).getOrThrow();
      expect(without.columnKeys, ['name', 'notes']);
      expect(utf8.decode(without.bytes), isNot(contains('asma')));

      final withHealth = (await _service([
        'students.*',
      ]).export(_dataset(), ExportFormat.csv)).getOrThrow();
      expect(withHealth.columnKeys, ['name', 'notes', 'health']);
      expect(utf8.decode(withHealth.bytes), contains('asma'));
    });

    test('exporta com a licença só de leitura', () async {
      final r = await _service([
        'students.*',
      ], readOnly: true).export(_dataset(), ExportFormat.csv);
      expect(r.isOk, isTrue);
    });

    test('nome do ficheiro inclui entidade, data UTC e extensão', () async {
      final f = (await _service([
        '*',
      ]).export(_dataset(), ExportFormat.xlsx)).getOrThrow();
      expect(f.fileName, 'students-20260305-0907.xlsx');
    });
  });

  group('formatos', () {
    test('CSV: BOM, ; , aspas e neutralização de fórmulas', () async {
      final f = (await _service([
        '*',
      ]).export(_dataset(), ExportFormat.csv)).getOrThrow();
      final text = utf8.decode(f.bytes);
      expect(f.bytes.take(3), [0xEF, 0xBB, 0xBF]);
      final grid = parseCsv(text);
      expect(grid.first, ['Nome', 'Notas', 'Saúde']);
      expect(grid[1], ['João "Zé" Silva', 'a;b', 'asma']);
      expect(grid[2][0], startsWith("'="));
      expect(grid[2][1], '-5');
    });

    test('guardFormula', () {
      expect(guardFormula('+1x'), "'+1x");
      expect(guardFormula('@a'), "'@a");
      expect(guardFormula('-3,5'), '-3,5');
      expect(guardFormula('normal'), 'normal');
    });

    test('Excel: ida e volta pelo leitor do motor de importação', () async {
      final f = (await _service([
        '*',
      ]).export(_dataset(), ExportFormat.xlsx)).getOrThrow();
      final table = ImportTable.fromBytes(f.fileName, f.bytes);
      expect(table.headers, ['Nome', 'Notas', 'Saúde']);
      expect(table.rows, hasLength(2));
      expect(table.rows.first.first, 'João "Zé" Silva');
    });

    test('PDF: cabeçalho %PDF e várias páginas com muitas linhas', () async {
      final big = ExportDataset(
        title: 'Alunos',
        entity: 'students',
        permission: 'students.record.export',
        columns: const [ExportDatasetColumn(key: 'n', label: 'N')],
        rows: [
          for (var i = 0; i < 300; i++) ['linha $i'],
        ],
      );
      final f = (await _service([
        '*',
      ]).export(big, ExportFormat.pdf)).getOrThrow();
      expect(ascii.decode(f.bytes.sublist(0, 5)), '%PDF-');
      expect(f.rowCount, 300);
      expect(f.fileName, endsWith('.pdf'));
    });
  });
}
