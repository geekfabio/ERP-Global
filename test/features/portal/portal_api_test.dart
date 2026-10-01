import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_mock_handlers.dart';
import 'package:erp_global/features/portal/data/repositories/api_portal_repository.dart';
import 'package:erp_global/features/portal/domain/portal_repository.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ApiPortalRepository> _repoFor(String profile) async {
  final auth = AuthMockHandlers();
  final students = StudentsMockHandlers(count: 60);
  final registry = MockApiRegistry()
    ..addModule(auth)
    ..addModule(students)
    ..addModule(
      PortalMockHandlers(
        authenticate: auth.authenticate,
        pupilsFor: students.pupilsForPortalUser,
      ),
    );
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  final login = await ApiAuthRepository(
    client,
    InMemorySessionStorage(),
  ).login(identifier: '$profile@erp-global.local', password: 'Dev@12345');
  login.getOrThrow();
  return ApiPortalRepository(client);
}

void main() {
  test('encarregado vê só os educandos vinculados (multi-educando)', () async {
    final repo = await _repoFor('encarregado');
    final pupils = (await repo.pupils()).getOrThrow();
    expect(pupils.length, greaterThanOrEqualTo(2));
    expect(pupils.every((p) => p.link != null), isTrue);
    expect(pupils.map((p) => p.link!.guardianId).toSet(), hasLength(1));
  });

  test('aluno vê apenas o próprio registo, sem vínculo', () async {
    final repo = await _repoFor('aluno');
    final pupils = (await repo.pupils()).getOrThrow();
    expect(pupils, hasLength(1));
    expect(pupils.single.link, isNull);
  });

  test('resumo só inclui os módulos pedidos', () async {
    final repo = await _repoFor('encarregado');
    final id = (await repo.pupils()).getOrThrow().first.student.id;
    final s = (await repo.summary(
      id,
      modules: {'grades', 'billing'},
    )).getOrThrow();
    expect(s.grades, isNotNull);
    expect(s.finance, isNotNull);
    expect(s.attendance, isNull);
    expect(s.card, isNull);
  });

  test('educando não vinculado → 403 FORBIDDEN', () async {
    final repo = await _repoFor('encarregado');
    final mine = (await repo.pupils()).getOrThrow().map((p) => p.student.id);
    // Qualquer aluno do seed que não seja dos vinculados.
    final other = await _repoFor('aluno');
    final otherId = (await other.pupils()).getOrThrow().single.student.id;
    expect(mine, isNot(contains(otherId)));
    final r = await repo.summary(
      otherId,
      modules: portalSummaryModules.toSet(),
    );
    expect(r.failureOrNull?.code, 'FORBIDDEN');
  });

  test('perfis sem acesso ao portal → 403', () async {
    final repo = await _repoFor('professor');
    expect((await repo.pupils()).failureOrNull?.code, 'FORBIDDEN');
  });
}
