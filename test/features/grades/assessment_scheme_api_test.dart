import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/grades/data/mock_api/grades_mock_handlers.dart';
import 'package:erp_global/features/grades/data/models/assessment_scheme_model.dart';
import 'package:erp_global/features/grades/data/repositories/api_assessment_scheme_repository.dart';
import 'package:flutter_test/flutter_test.dart';

ApiAssessmentSchemeRepository _repo({PermissionService? permissions}) =>
    ApiAssessmentSchemeRepository(
      ApiClient.create(
        baseUrl: 'https://api.test',
        useMockApi: true,
        registry: MockApiRegistry()
          ..addModule(
            GradesMockHandlers(
              permissions: permissions == null ? null : () => permissions,
            ),
          ),
        mockConfig: const MockApiConfig.instant(),
        logging: false,
      ),
    );

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

AssessmentSchemeModel _draft({String? gradeId, int npt = 40, int npp = 30}) =>
    AssessmentSchemeModel(
      id: '',
      name: 'Esquema 12.ª',
      gradeId: gradeId,
      components: [
        const AssessmentComponentModel(code: 'MAC', name: 'MAC', weight: 30),
        AssessmentComponentModel(code: 'NPP', name: 'NPP', weight: npp),
        AssessmentComponentModel(code: 'NPT', name: 'NPT', weight: npt),
      ],
    );

void main() {
  test('lista o esquema geral do seed (escala 0–20, mínimo 10)', () async {
    final page = (await _repo().list()).getOrThrow();
    expect(page.items, hasLength(1));
    final s = page.items.single;
    expect([s.scaleMax, s.minPassing], [20, 10]);
    expect(s.components.map((c) => c.code), ['MAC', 'NPP', 'NPT']);
  });

  test('cria, filtra por classe, actualiza e elimina', () async {
    final repo = _repo();
    final created = (await repo.create(_draft(gradeId: 'g12'))).getOrThrow();
    expect(created.id, isNotEmpty);
    final filtered = (await repo.list(gradeId: 'g12')).getOrThrow();
    expect(filtered.items.single.id, created.id);

    final updated = (await repo.update(
      created.id,
      created.copyWith(minPassing: 12),
    )).getOrThrow();
    expect(updated.minPassing, 12);

    expect((await repo.delete(created.id)).isOk, isTrue);
    expect((await repo.list(gradeId: 'g12')).getOrThrow().items, isEmpty);
  });

  test('422 quando os pesos não somam 100', () async {
    final r = await _repo().create(_draft(gradeId: 'g1', npt: 50));
    expect(r.failureOrNull, _code('VALIDATION_ERROR'));
  });

  test('409 em duplicado para a mesma classe e ao eliminar o geral', () async {
    final repo = _repo();
    await repo.create(_draft(gradeId: 'g1'));
    expect(
      (await repo.create(_draft(gradeId: 'g1'))).failureOrNull,
      _code('CONFLICT'),
    );
    final general = (await repo.list()).getOrThrow().items.firstWhere(
      (s) => s.gradeId == null,
    );
    expect((await repo.delete(general.id)).failureOrNull, _code('CONFLICT'));
  });

  test('404 em esquema inexistente', () async {
    expect((await _repo().delete('nope')).failureOrNull, _code('NOT_FOUND'));
  });

  test('403 sem permissão de escrita', () async {
    final repo = _repo(
      permissions: PermissionService.fromCodes(['grades.scheme.read']),
    );
    expect((await repo.list()).isOk, isTrue);
    expect((await repo.create(_draft())).failureOrNull, _code('FORBIDDEN'));
  });
}
