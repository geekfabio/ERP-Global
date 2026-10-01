import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/import_export/data/mock_api/import_mock_handlers.dart';
import 'package:erp_global/features/import_export/data/repositories/api_import_repository.dart';
import 'package:erp_global/features/import_export/domain/import_engine.dart';
import 'package:erp_global/features/import_export/domain/import_profile.dart';
import 'package:erp_global/features/import_export/domain/import_table.dart';
import 'package:erp_global/features/import_export/domain/profiles/classes_import_profile.dart';
import 'package:erp_global/features/import_export/domain/profiles/grades_import_profile.dart';
import 'package:erp_global/features/import_export/domain/profiles/payments_import_profile.dart';
import 'package:erp_global/features/import_export/domain/profiles/teachers_import_profile.dart';
import 'package:flutter_test/flutter_test.dart';

const _engine = ImportEngine();

ImportPreview _preview(ImportProfile p, List<List<String>> grid) {
  final table = ImportTable.fromGrid(grid);
  return _engine.validate(p, table, _engine.autoMap(p, table.headers));
}

ApiImportRepository _repo(ImportMockHandlers handlers) {
  final registry = MockApiRegistry()..addModule(handlers);
  return ApiImportRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

void main() {
  test('professores: lista de disciplinas e e-mail validados', () {
    final p = _preview(const TeachersImportProfile(), [
      ['Nome completo', 'E-mail', 'Disciplinas'],
      ['Rui Manuel', 'rui@escola.ao', 'MAT | FIS'],
      ['Ana', 'invalido', ''],
    ]);
    expect(p.valid.single.record['subjects'], ['MAT', 'FIS']);
    expect(p.invalid.single.errors.single.field, 'email');
  });

  test('turmas: turno e capacidade', () {
    final p = _preview(const ClassesImportProfile(), [
      ['Turma', 'Classe', 'Turno', 'Capacidade'],
      ['7.ª A', '7.ª classe', 'Manhã', '35'],
      ['7.ª B', '7.ª classe', 'Madrugada', '0'],
    ]);
    expect(p.valid.single.record['shift'], 'morning');
    expect(p.valid.single.record['capacity'], 35);
    expect(p.invalid.single.errors.map((e) => e.field), ['shift', 'capacity']);
  });

  test('notas: vírgula decimal e limites', () {
    final p = _preview(const GradesImportProfile(), [
      ['Aluno', 'Turma', 'Disciplina', 'Trimestre', 'Componente', 'Nota'],
      ['1', '7.ª A', 'MAT', 'T1', 'MAC', '14,5'],
      ['2', '7.ª A', 'MAT', 'T1', 'MAC', 'abc'],
    ]);
    expect(p.valid.single.record['score'], 14.5);
    expect(p.invalid.single.errors.single.field, 'score');
  });

  test('financeiro: valor em cêntimos (int) e método', () {
    final p = _preview(const PaymentsImportProfile(), [
      ['Aluno', 'Valor', 'Método', 'Data'],
      ['1', '25 000,50', 'Transferência', '05/02/2026'],
      ['2', '0', 'Cheque', '05/02/2026'],
    ]);
    final rec = p.valid.single.record;
    expect(rec['amountMinor'], 2500050);
    expect(rec['method'], 'bankTransfer');
    expect(p.invalid.single.errors.map((e) => e.field), ['method']);
    expect(
      const PaymentsImportProfile().validateRecord({'amountMinor': 0}),
      isNotEmpty,
    );
  });

  test(
    'servidor: notas só em trimestre aberto; reimportar não duplica',
    () async {
      final handlers = ImportMockHandlers(
        termLookup: (ref) => switch (ref) {
          'T1' => false,
          'T2' => true,
          _ => null,
        },
      );
      final repo = _repo(handlers);
      Map<String, Object?> grade(String term, double score) => {
        'studentRef': '1',
        'classroom': '7.ª A',
        'subject': 'MAT',
        'term': term,
        'component': 'MAC',
        'score': score,
      };
      final result = (await repo.commit('grades', [
        grade('T1', 12),
        grade('T2', 14),
        grade('T9', 10),
      ])).getOrThrow();
      expect(result.imported, 1);
      expect(result.rejected.map((r) => r.errors['term']), [
        'Trimestre fechado: não aceita notas',
        'Trimestre não encontrado',
      ]);
      // Reimportar a mesma nota substitui, não duplica.
      await repo.commit('grades', [grade('T1', 15)]);
      expect(handlers.stored('grades'), hasLength(1));
      expect(handlers.stored('grades').single['score'], 15.0);
    },
  );

  test('servidor: duplicados de professores, turmas e pagamentos', () async {
    final handlers = ImportMockHandlers();
    final repo = _repo(handlers);
    final teacher = {'fullName': 'Rui', 'email': 'rui@escola.ao'};
    expect((await repo.commit('teachers', [teacher])).getOrThrow().imported, 1);
    final again = (await repo.commit('teachers', [teacher])).getOrThrow();
    expect(again.imported, 0);
    expect(again.rejected.single.errors['email'], 'E-mail já registado');

    final room = {'name': '7.ª A', 'grade': '7', 'capacity': 30};
    final rooms = (await repo.commit('classrooms', [room, room])).getOrThrow();
    expect(rooms.imported, 1);

    final pay = {
      'studentRef': '1',
      'amountMinor': 100,
      'method': 'cash',
      'paidAt': '2026-02-05',
      'reference': 'R1',
    };
    final pays = (await repo.commit('payments', [
      pay,
      {...pay, 'reference': 'R2', 'amountMinor': 0},
      pay,
    ])).getOrThrow();
    expect(pays.imported, 1);
    expect(pays.rejected, hasLength(2));
  });
}
