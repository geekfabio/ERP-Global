import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:erp_global/features/settings/data/models/academic_year_model.dart';
import 'package:erp_global/features/settings/data/models/term_model.dart';
import 'package:erp_global/features/settings/data/repositories/api_academic_repository.dart';
import 'package:erp_global/features/settings/domain/academic_rules.dart';
import 'package:flutter_test/flutter_test.dart';

const _active = MockRef.academicYearId;
const _closed = '01JYEAR202420250000000001A';
const _planned = '01JYEAR202620270000000001A';

ApiAcademicRepository _repo({PermissionService? permissions}) {
  final registry = MockApiRegistry()
    ..addModule(
      AcademicMockHandlers(
        permissions: permissions == null ? null : () => permissions,
        now: () => DateTime.utc(2026, 1, 15),
      ),
    );
  return ApiAcademicRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

PermissionService _perms(List<String> codes) =>
    PermissionService.fromCodes(codes);

Future<TermModel> _term(
  ApiAcademicRepository repo,
  String yearId,
  int i,
) async => (await repo.terms(yearId)).getOrThrow()[i];

void main() {
  group('regras puras', () {
    test('só se avança um passo para a frente', () {
      const s = AcademicYearStatus.values;
      for (final from in s) {
        for (final to in s) {
          final expected = to.index == from.index + 1;
          expect(canTransition(from, to), expected, reason: '$from → $to');
        }
      }
      expect(nextStatus(AcademicYearStatus.closed), isNull);
    });

    test('código exige anos consecutivos', () {
      expect(isValidAcademicYearCode('2026/2027'), isTrue);
      expect(isValidAcademicYearCode('2026/2028'), isFalse);
      expect(isValidAcademicYearCode('2026-2027'), isFalse);
    });

    test('splitYear cobre o ano sem lacunas nem sobreposições', () {
      final start = DateTime.utc(2026, 9, 1);
      final end = DateTime.utc(2027, 7, 31);
      final r = splitYear(start, end, 3);
      expect(r.first.start, start);
      expect(r.last.end, end);
      for (var i = 1; i < r.length; i++) {
        expect(r[i].start, r[i - 1].end.add(const Duration(days: 1)));
      }
    });
  });

  group('ano lectivo', () {
    test('lista o seed (encerrado, activo, planeado)', () async {
      final years = (await _repo().years()).getOrThrow().items;
      expect(years.map((y) => y.status), [
        AcademicYearStatus.planned,
        AcademicYearStatus.active,
        AcademicYearStatus.closed,
      ]);
    });

    test('cria planeado com períodos repartidos', () async {
      final repo = _repo();
      final year = (await repo.createYear({
        'campusId': MockRef.campusId,
        'code': '2027/2028',
        'startDate': '2027-09-01',
        'endDate': '2028-07-31',
        'termCount': 2,
      })).getOrThrow();
      expect(year.status, AcademicYearStatus.planned);
      final terms = (await repo.terms(year.id)).getOrThrow();
      expect(terms.map((t) => t.name), ['1.º Semestre', '2.º Semestre']);
      expect(terms.every((t) => t.status == TermStatus.closed), isTrue);
    });

    test('valida código, datas e duplicados', () async {
      final repo = _repo();
      final bad = await repo.createYear({
        'campusId': MockRef.campusId,
        'code': '2027/2030',
        'startDate': '2027-09-01',
        'endDate': '2027-08-01',
      });
      expect(bad.failureOrNull, _code('VALIDATION_ERROR'));
      final dup = await repo.createYear({
        'campusId': MockRef.campusId,
        'code': '2025/2026',
        'startDate': '2025-09-01',
        'endDate': '2026-07-31',
      });
      expect(dup.failureOrNull, _code('CONFLICT'));
    });

    test('transições inválidas são rejeitadas (409)', () async {
      final repo = _repo();
      // saltar passos
      expect(
        (await repo.transitionYear(
          _planned,
          AcademicYearStatus.closing,
        )).failureOrNull,
        _code('CONFLICT'),
      );
      // recuar
      expect(
        (await repo.transitionYear(
          _active,
          AcademicYearStatus.planned,
        )).failureOrNull,
        _code('CONFLICT'),
      );
      // do estado final não se sai
      expect(
        (await repo.transitionYear(
          _closed,
          AcademicYearStatus.active,
        )).failureOrNull,
        _code('CONFLICT'),
      );
    });

    test('só um activo por campus', () async {
      final repo = _repo();
      final r = await repo.transitionYear(_planned, AcademicYearStatus.active);
      expect(r.failureOrNull, _code('CONFLICT'));
      // depois de o activo passar a em fecho, o planeado pode activar
      (await repo.transitionYear(
        _active,
        AcademicYearStatus.closing,
      )).getOrThrow();
      final ok = (await repo.transitionYear(
        _planned,
        AcademicYearStatus.active,
      )).getOrThrow();
      expect(ok.status, AcademicYearStatus.active);
    });

    test('encerrar exige períodos fechados e congela o ano', () async {
      final repo = _repo();
      (await repo.transitionYear(
        _active,
        AcademicYearStatus.closing,
      )).getOrThrow();
      // 2.º período ainda aberto
      expect(
        (await repo.transitionYear(
          _active,
          AcademicYearStatus.closed,
        )).failureOrNull,
        _code('CONFLICT'),
      );
      final open = await _term(repo, _active, 1);
      (await repo.closeTerm(open.id)).getOrThrow();
      (await repo.transitionYear(
        _active,
        AcademicYearStatus.closed,
      )).getOrThrow();

      // congelado: ano, datas dos períodos e abrir/fechar são rejeitados
      expect(
        (await repo.updateYear(_active, {
          'endDate': '2026-08-31',
        })).failureOrNull,
        _code('CONFLICT'),
      );
      expect(
        (await repo.updateTerm(open.id, {
          'gradesDeadline': '2026-06-30',
        })).failureOrNull,
        _code('CONFLICT'),
      );
      expect((await repo.openTerm(open.id)).failureOrNull, _code('CONFLICT'));
    });

    test('exige permissão para escrever', () async {
      final repo = _repo(permissions: _perms(['core.settings.read']));
      expect(
        (await repo.transitionYear(
          _planned,
          AcademicYearStatus.active,
        )).failureOrNull,
        _code('FORBIDDEN'),
      );
      expect((await repo.years()).isOk, isTrue);
    });
  });

  group('períodos', () {
    test('abrir/fechar; fechar regista closedAt', () async {
      final repo = _repo();
      final third = await _term(repo, _active, 2);
      final opened = (await repo.openTerm(third.id)).getOrThrow();
      expect(opened.status, TermStatus.open);
      expect((await repo.openTerm(third.id)).failureOrNull, _code('CONFLICT'));
      final closed = (await repo.closeTerm(third.id)).getOrThrow();
      expect(closed.status, TermStatus.closed);
      expect(closed.closedAt, DateTime.utc(2026, 1, 15));
      expect((await repo.closeTerm(third.id)).failureOrNull, _code('CONFLICT'));
    });

    test('não abre períodos de um ano planeado', () async {
      final repo = _repo();
      final first = await _term(repo, _planned, 0);
      expect((await repo.openTerm(first.id)).failureOrNull, _code('CONFLICT'));
    });

    test('reabrir exige approve', () async {
      final noApprove = _repo(permissions: _perms(['core.academic.update']));
      final first = await _term(noApprove, _active, 0); // já foi fechado
      expect(first.closedAt, isNotNull);
      expect(
        (await noApprove.openTerm(first.id)).failureOrNull,
        _code('FORBIDDEN'),
      );

      final approver = _repo(permissions: _perms(['core.academic.*']));
      final again = await _term(approver, _active, 0);
      expect(
        (await approver.openTerm(again.id)).getOrThrow().status,
        TermStatus.open,
      );
    });

    test('valida datas e prazo de notas', () async {
      final repo = _repo();
      final t = await _term(repo, _active, 2);
      final okRes = (await repo.updateTerm(t.id, {
        'gradesDeadline': '2026-07-15',
      })).getOrThrow();
      expect(okRes.gradesDeadline, DateTime.utc(2026, 7, 15));

      // prazo antes do início
      expect(
        (await repo.updateTerm(t.id, {
          'gradesDeadline': '2026-01-01',
        })).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
      // sobreposição com o período anterior
      final prev = await _term(repo, _active, 1);
      expect(
        (await repo.updateTerm(t.id, {
          'startDate': prev.endDate.toIso8601String().substring(0, 10),
        })).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
      // fora do ano
      expect(
        (await repo.updateTerm(t.id, {'endDate': '2027-01-31'})).failureOrNull,
        _code('VALIDATION_ERROR'),
      );
    });
  });
}
