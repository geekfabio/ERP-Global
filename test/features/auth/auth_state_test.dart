import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/auth/domain/auth_repository.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_providers.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Contentor com a Auth API mock real (sem latência) e armazenamento em memória.
ProviderContainer _container({InMemorySessionStorage? storage}) {
  final store = storage ?? InMemorySessionStorage();
  final container = ProviderContainer(
    overrides: [
      sessionStorageProvider.overrideWithValue(store),
      tokenStoreProvider.overrideWith((ref) => PersistentTokenStore(store)),
      mockApiModulesProvider.overrideWith((ref) => [AuthMockHandlers()]),
      apiClientProvider.overrideWith(
        (ref) => ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: ref.watch(mockApiRegistryProvider),
          mockConfig: const MockApiConfig.instant(),
          tokens: ref.watch(tokenStoreProvider),
          logging: false,
        ),
      ),
    ],
  );
  addTearDown(container.dispose);
  return container;
}

void main() {
  const admin = 'admin@erp-global.local';

  test('arranca sem sessão guardada → estado null', () async {
    final c = _container();
    expect(await c.read(authStateProvider.future), isNull);
    expect(c.read(isAuthenticatedProvider), isFalse);
  });

  test('login e logout actualizam o estado', () async {
    final c = _container();
    await c.read(authStateProvider.future);
    final result = await c
        .read(authStateProvider.notifier)
        .login(identifier: admin, password: 'Admin@12345');
    expect(result.isOk, isTrue);
    expect(c.read(isAuthenticatedProvider), isTrue);
    expect(c.read(currentSessionProvider)?.roles, ['super_admin']);

    await c.read(authStateProvider.notifier).logout();
    expect(c.read(isAuthenticatedProvider), isFalse);
    expect(c.read(currentSessionProvider), isNull);
  });

  test('credenciais erradas devolvem Failure e não mudam a sessão', () async {
    final c = _container();
    await c.read(authStateProvider.future);
    final result = await c
        .read(authStateProvider.notifier)
        .login(identifier: admin, password: 'errada');
    expect(result.failureOrNull?.code, 'INVALID_CREDENTIALS');
    expect(c.read(isAuthenticatedProvider), isFalse);
  });

  test('sessão guardada é reaberta no arranque seguinte', () async {
    final storage = InMemorySessionStorage();
    final first = _container(storage: storage);
    await first.read(authStateProvider.future);
    await first
        .read(authStateProvider.notifier)
        .login(identifier: admin, password: 'Admin@12345');
    expect(await storage.readRefreshToken(), isNotNull);

    // Mesmo servidor mock não é partilhável entre contentores; simula-se com um
    // repository que aceita o refresh token guardado.
    final second = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_RestoringRepository()),
      ],
    );
    addTearDown(second.dispose);
    expect((await second.read(authStateProvider.future))?.roles, [
      'super_admin',
    ]);
  });

  test('falha ao restaurar não bloqueia o arranque', () async {
    final c = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_FailingRepository()),
      ],
    );
    addTearDown(c.dispose);
    expect(await c.read(authStateProvider.future), isNull);
  });

  test('logout limpa a sessão local mesmo se o servidor falhar', () async {
    final c = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(_RestoringRepository()),
      ],
    );
    addTearDown(c.dispose);
    await c.read(authStateProvider.future);
    await c.read(authStateProvider.notifier).logout();
    expect(c.read(currentSessionProvider), isNull);
  });
}

AuthSession _session() => AuthSession.fromJson({
  'user': {
    'id': '01J1',
    'institutionId': '01JI',
    'createdAt': '2026-01-01T00:00:00Z',
    'updatedAt': '2026-01-01T00:00:00Z',
    'name': 'Admin',
  },
  'roles': ['super_admin'],
  'permissions': ['*'],
  'license': <String, dynamic>{},
});

class _RestoringRepository implements AuthRepository {
  @override
  Future<Result<AuthSession?>> restoreSession() async => Ok(_session());
  @override
  Future<Result<AuthSession>> login({
    required String identifier,
    required String password,
  }) async => Ok(_session());
  @override
  Future<Result<AuthSession>> me() async => Ok(_session());
  @override
  Future<Result<AuthSession>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => Ok(_session());
  @override
  Future<Result<void>> logout() async => Err(NetworkFailure());
}

class _FailingRepository extends _RestoringRepository {
  @override
  Future<Result<AuthSession?>> restoreSession() async => Err(NetworkFailure());
}
