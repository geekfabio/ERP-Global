import 'package:dio/dio.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/auth/data/data_mocks/auth_mock_data.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/models/auth_profile.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:flutter_test/flutter_test.dart';

const _admin = 'admin@erp-global.local';

class _Env {
  _Env() {
    registry.addModule(handlers);
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      tokens: PersistentTokenStore(storage),
      logging: false,
    );
    repo = ApiAuthRepository(client, storage);
  }

  var now = DateTime.utc(2026, 5, 1, 10);
  final storage = InMemorySessionStorage();
  final registry = MockApiRegistry();
  late final AuthMockHandlers handlers = AuthMockHandlers(now: () => now);
  late final ApiClient client;
  late final ApiAuthRepository repo;
}

Failure _failure<T>(Result<T> r) => r.failureOrNull!;

void main() {
  test('seed tem 14 perfis e um super_admin', () {
    final seed = buildAuthSeed();
    expect(seed, hasLength(14));
    expect(
      seed.where((a) => a.profile == AuthProfile.superAdmin),
      hasLength(1),
    );
    expect(seed.first.user.email, _admin);
    expect(seed.first.password, 'Admin@12345');
  });

  test('login do super_admin devolve sessão com permissão total', () async {
    final env = _Env();
    final r = await env.repo.login(identifier: _admin, password: 'Admin@12345');
    final session = r.getOrThrow();
    expect(session.roles, ['super_admin']);
    expect(session.permissions, ['*']);
    expect(env.client.tokens.accessToken, isNotNull);
    expect(
      await env.storage.readRefreshToken(),
      env.client.tokens.refreshToken,
    );
  });

  test('todos os perfis fazem login com a password de dev', () async {
    final env = _Env();
    for (final a in env.handlers.accounts) {
      final r = await env.repo.login(
        identifier: mockIdentifierFor(a.profile),
        password: a.password,
      );
      expect(r.isOk, isTrue, reason: a.profile.name);
    }
  });

  test('credenciais erradas → 401 INVALID_CREDENTIALS', () async {
    final env = _Env();
    final r = await env.repo.login(identifier: _admin, password: 'errada');
    final f = _failure(r);
    expect(f, isA<AuthFailure>());
    expect(f.code, 'INVALID_CREDENTIALS');
  });

  test('identifier vazio → 422 com campos', () async {
    final env = _Env();
    final f = _failure(await env.repo.login(identifier: '', password: ''));
    expect(f, isA<ValidationFailure>());
    expect(
      (f as ValidationFailure).fields.keys,
      containsAll(['identifier', 'password']),
    );
  });

  test('não existe endpoint de registo nem de recuperação', () async {
    final env = _Env();
    for (final path in ['/v1/auth/register', '/v1/auth/forgot-password']) {
      await expectLater(
        env.client.dio.post<dynamic>(path, data: {}),
        throwsA(
          isA<DioException>().having(
            (e) => e.response?.statusCode,
            'status',
            404,
          ),
        ),
      );
    }
  });

  test('me sem sessão → 401 UNAUTHENTICATED', () async {
    final env = _Env();
    expect(_failure(await env.repo.me()).code, 'UNAUTHENTICATED');
  });

  test('token expirado → refresh automático e pedido repetido', () async {
    final env = _Env();
    await env.repo.login(identifier: _admin, password: 'Admin@12345');
    final firstAccess = env.client.tokens.accessToken;
    env.now = env.now.add(const Duration(seconds: mockAccessTtlSeconds + 1));
    final r = await env.repo.me();
    expect(r.isOk, isTrue);
    expect(env.client.tokens.accessToken, isNot(firstAccess));
  });

  test('refresh token usado uma vez; reutilização falha', () async {
    final env = _Env();
    await env.repo.login(identifier: _admin, password: 'Admin@12345');
    final old = env.client.tokens.refreshToken;
    env.now = env.now.add(const Duration(hours: 1));
    await env.repo.me(); // roda o refresh token
    final reuse = await Result.guard(
      () => env.client.dio.post<dynamic>(
        '/v1/auth/refresh',
        data: {'refreshToken': old},
      ),
    );
    expect(_failure(reuse).code, 'UNAUTHENTICATED');
  });

  test(
    'restoreSession com refresh token inválido limpa e devolve null',
    () async {
      final env = _Env();
      await env.storage.writeRefreshToken('rt_invalido');
      expect((await env.repo.restoreSession()).getOrThrow(), isNull);
      expect(await env.storage.readRefreshToken(), isNull);
    },
  );

  test('restoreSession com refresh token válido devolve a sessão', () async {
    final env = _Env();
    await env.repo.login(identifier: _admin, password: 'Admin@12345');
    final stored = await env.storage.readRefreshToken();
    final second = _Env();
    // Mesmo estado de servidor: reutiliza o handler da primeira env.
    final client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: env.registry,
      mockConfig: const MockApiConfig.instant(),
      tokens: PersistentTokenStore(second.storage),
      logging: false,
    );
    await second.storage.writeRefreshToken(stored!);
    final repo = ApiAuthRepository(client, second.storage);
    final session = (await repo.restoreSession()).getOrThrow();
    expect(session?.user.email, _admin);
  });

  test('logout invalida o refresh token e limpa a sessão local', () async {
    final env = _Env();
    await env.repo.login(identifier: _admin, password: 'Admin@12345');
    await env.repo.logout();
    expect(env.client.tokens.accessToken, isNull);
    expect(await env.storage.readRefreshToken(), isNull);
  });

  test('change-password valida e limpa mustChangePassword', () async {
    final env = _Env();
    final teacher = env.handlers.accounts.firstWhere(
      (a) => a.profile == AuthProfile.teacher,
    );
    env.handlers.requirePasswordChange(teacher.user.id);
    final id = mockIdentifierFor(AuthProfile.teacher);
    final login = await env.repo.login(identifier: id, password: 'Dev@12345');
    expect(login.getOrThrow().mustChangePassword, isTrue);

    final weak = await env.repo.changePassword(
      currentPassword: 'Dev@12345',
      newPassword: 'curta',
    );
    expect(_failure(weak), isA<ValidationFailure>());

    final ok = await env.repo.changePassword(
      currentPassword: 'Dev@12345',
      newPassword: 'Nova@12345',
    );
    expect(ok.getOrThrow().mustChangePassword, isFalse);
    final relogin = await env.repo.login(
      identifier: id,
      password: 'Nova@12345',
    );
    expect(relogin.isOk, isTrue);
  });

  test('conta desactivada não faz login', () async {
    final env = _Env();
    final teacher = env.handlers.accounts.firstWhere(
      (a) => a.profile == AuthProfile.teacher,
    );
    env.handlers.setActive(teacher.user.id, active: false);
    final r = await env.repo.login(
      identifier: mockIdentifierFor(AuthProfile.teacher),
      password: 'Dev@12345',
    );
    expect(_failure(r).code, 'FORBIDDEN');
  });

  test('nunca desactiva o último super_admin activo', () {
    final env = _Env();
    final admin = env.handlers.accounts.firstWhere(
      (a) => a.profile == AuthProfile.superAdmin,
    );
    expect(
      () => env.handlers.setActive(admin.user.id, active: false),
      throwsA(
        isA<Object>().having((e) => e.toString(), 'msg', contains('CONFLICT')),
      ),
    );
  });

  test('POST /__mock/reset repõe o seed', () async {
    final env = _Env();
    await env.repo.login(identifier: _admin, password: 'Admin@12345');
    await env.repo.changePassword(
      currentPassword: 'Admin@12345',
      newPassword: 'Outra@12345',
    );
    await env.client.dio.post<dynamic>('/__mock/reset');
    final r = await env.repo.login(identifier: _admin, password: 'Admin@12345');
    expect(r.isOk, isTrue);
  });
}
