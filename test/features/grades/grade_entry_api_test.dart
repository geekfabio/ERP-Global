import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/grades/data/mock_api/grade_entry_mock_handlers.dart';
import 'package:erp_global/features/grades/data/mock_api/grades_mock_handlers.dart';
import 'package:erp_global/features/grades/data/models/grade_sheet_models.dart';
import 'package:erp_global/features/grades/data/repositories/api_grade_entry_repository.dart';
import 'package:erp_global/features/grades/domain/grade_entry_repository.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = GradeSheetKey(
  classroomId: 'c1',
  subjectId: 's1',
  termId: 't1',
  gradeId: 'g1',
);

ApiGradeEntryRepository _repo({
  List<String> permissions = const ['grades.entry.write'],
  GradeTermInfo? term,
  DateTime? now,
}) => ApiGradeEntryRepository(
  ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(
        GradesMockHandlers(
          permissions: () => PermissionService.fromCodes(permissions),
          termLookup: (_) => term,
          now: () => now ?? DateTime.utc(2026, 11, 1),
        ),
      ),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  ),
);

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

List<GradeRowModel> _rows(double npt) => [
  GradeRowModel(studentId: 'a1', scores: {'MAC': 12, 'NPP': 14, 'NPT': npt}),
];

void main() {
  test(
    'folha vazia traz o esquema geral e fica aberta sem trimestre',
    () async {
      final sheet = (await _repo().sheet(_key)).getOrThrow();
      expect(sheet.rows, isEmpty);
      expect(sheet.scheme.components.map((c) => c.code), ['MAC', 'NPP', 'NPT']);
      expect(sheet.locked, isFalse);
    },
  );

  test('guarda notas, devolve-as e regista o log de alterações', () async {
    final repo = _repo();
    final saved = (await repo.save(_key, _rows(15))).getOrThrow();
    expect(saved.rows.single.scores['NPT'], 15);
    expect((await repo.sheet(_key)).getOrThrow().rows, hasLength(1));

    await repo.save(_key, _rows(16));
    final changes = (await repo.changes(_key)).getOrThrow();
    expect(changes, hasLength(4));
    final last = changes.first;
    expect([last.componentCode, last.before, last.after], ['NPT', 15, 16]);
    expect(last.afterLock, isFalse);
  });

  test(
    'nota fora da escala ou componente desconhecido dão 422 por campo',
    () async {
      final result = await _repo().save(_key, [
        const GradeRowModel(studentId: 'a1', scores: {'NPT': 21, 'XXX': 5}),
      ]);
      final failure = result.failureOrNull! as ValidationFailure;
      expect(failure.fields.keys, containsAll(['a1.NPT', 'a1.XXX']));
    },
  );

  test('sem permissão de leitura/escrita recebe 403', () async {
    final repo = _repo(permissions: const ['students.record.read']);
    expect((await repo.sheet(_key)).failureOrNull, _code('FORBIDDEN'));
    expect(
      (await repo.save(_key, _rows(10))).failureOrNull,
      _code('FORBIDDEN'),
    );
  });

  test('trimestre fechado: quem só escreve recebe 409', () async {
    final repo = _repo(term: const GradeTermInfo(closed: true));
    expect((await repo.sheet(_key)).getOrThrow().termClosed, isTrue);
    expect((await repo.save(_key, _rows(10))).failureOrNull, _code('CONFLICT'));
  });

  test('prazo terminado bloqueia; hoje ainda é válido', () async {
    final term = GradeTermInfo(
      closed: false,
      deadline: DateTime.utc(2026, 10, 31),
    );
    final late = _repo(term: term, now: DateTime.utc(2026, 11, 1, 0, 1));
    expect((await late.sheet(_key)).getOrThrow().deadlinePassed, isTrue);
    final onTime = _repo(term: term, now: DateTime.utc(2026, 10, 31, 23, 59));
    expect((await onTime.sheet(_key)).getOrThrow().locked, isFalse);
  });

  test('edição pós-fecho exige justificação e fica no log', () async {
    final repo = _repo(
      permissions: const ['grades.entry.approve'],
      term: const GradeTermInfo(closed: true),
    );
    final noReason = await repo.save(_key, _rows(10));
    expect(
      (noReason.failureOrNull! as ValidationFailure).fields,
      contains('justification'),
    );
    final ok = await repo.save(_key, _rows(10), justification: 'Erro de pauta');
    expect(ok.isOk, isTrue);
    final change = (await repo.changes(_key)).getOrThrow().first;
    expect(change.afterLock, isTrue);
    expect(change.justification, 'Erro de pauta');
  });

  test('guardar sem alterações num trimestre fechado não exige nada', () async {
    final repo = _repo(term: const GradeTermInfo(closed: true));
    expect((await repo.save(_key, const [])).isOk, isTrue);
  });
}
