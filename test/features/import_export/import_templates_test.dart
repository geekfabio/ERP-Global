import 'package:erp_global/features/import_export/domain/import_engine.dart';
import 'package:erp_global/features/import_export/domain/import_profile.dart';
import 'package:erp_global/features/import_export/domain/import_table.dart';
import 'package:erp_global/features/import_export/domain/import_template.dart';
import 'package:erp_global/features/import_export/domain/profiles/guardians_import_profile.dart';
import 'package:erp_global/features/import_export/domain/profiles/students_import_profile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const engine = ImportEngine();
  const profiles = <ImportProfile>[
    StudentsImportProfile(),
    GuardiansImportProfile(),
  ];

  for (final p in profiles) {
    test('templates .csv e .xlsx de ${p.id} reimportam sem erros', () {
      for (final (name, bytes) in [
        ('m.csv', ImportTemplate.csv(p)),
        ('m.xlsx', ImportTemplate.xlsx(p)),
      ]) {
        final table = ImportTable.fromBytes(name, bytes);
        final mapping = engine.autoMap(p, table.headers);
        expect(mapping.values.every((i) => i != null), isTrue, reason: name);
        final preview = engine.validate(p, table, mapping);
        expect(preview.rows, hasLength(1), reason: name);
        expect(preview.invalid, isEmpty, reason: name);
      }
    });
  }

  test('encarregados: erros por linha', () {
    const p = GuardiansImportProfile();
    final table = ImportTable.fromGrid([
      ['Nome completo', 'Telefone', 'E-mail', 'Parentesco', 'BI do aluno'],
      ['Maria', '923456789', 'm@x.ao', 'Mãe', '004567890LA041'],
      ['', '12', 'invalido', 'Primo', ''],
      ['Rui', '923456780', '', 'Pai', ''],
    ]);
    final preview = engine.validate(p, table, engine.autoMap(p, table.headers));
    expect(preview.valid, hasLength(1));
    expect(preview.valid.single.record['relationship'], 'mother');
    expect(preview.rows[1].errors.map((e) => e.field), [
      'fullName',
      'phone',
      'email',
      'relationship',
    ]);
    expect(preview.rows[2].errors.single.field, 'studentBi');
    expect(preview.rows[2].lineNumber, 4);
  });
}
