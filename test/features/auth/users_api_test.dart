import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/models/managed_user.dart';
import 'package:erp_global/features/auth/data/models/scope_model.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/api_users_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _Env {
  _Env() {
    registry.addModule(AuthMockHandlers());
  }

  final registry = MockApiRegistry();

  ApiClient _client() => ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    tokens: PersistentTokenStore(InMemorySessionStorage()),
    logging: false,
  );

  /// Cliente autenticado como [identifier] (um cliente por sessão).
  Future<(ApiUsersRepository, ApiAuthRepository)> signIn(
    String identifier,
    String password,
  ) async {
    final client = _client();
    final auth = ApiAuthRepository(client, InMemorySessionStorage());
    final r = await auth.login(identifier: identifier, password: password);
    expect(r.isOk, isTrue, reason: '$identifier: ${r.failureOrNull}');
    return (ApiUsersRepository(client), auth);
  }

  Future<ApiUsersRepository> admin() async =>
      (await signIn('admin@erp-global.local', 'Admin@12345')).$1;
}

const _teacher = UserInput(
  name: 'Maria Professora',
  email: 'Maria.Prof@escola.ao',
  phone: '923456789',
  roles: ['professor'],
);

void main() {
  test('super_admin lista contas paginadas, pesquisa e ordena', () async {
    final users = await _Env().admin();
    final page = (await users.list(pageSize: 5)).getOrThrow();
    expect(page.items, hasLength(5));
    expect(page.meta.total, 14);
    final found = (await users.list(query: 'financeiro')).getOrThrow();
    expect(found.items.single.roles, ['financeiro']);
    final desc = (await users.list(sort: '-name', pageSize: 3)).getOrThrow();
    expect(
      desc.items.first.user.name.compareTo(desc.items.last.user.name) > 0,
      isTrue,
    );
  });

  test('super_admin cria professor que consegue iniciar sessão', () async {
    final env = _Env();
    final users = await env.admin();
    final created = (await users.create(_teacher)).getOrThrow();
    expect(created.user.email, 'maria.prof@escola.ao');
    expect(created.user.isActive, isTrue);
    expect(created.user.mustChangePassword, isTrue);
    expect(created.roles, ['professor']);
    final temp = created.temporaryPassword!;

    // O novo professor entra com a password temporária e tem de a mudar.
    final (_, auth) = await env.signIn('maria.prof@escola.ao', temp);
    final session = (await auth.me()).getOrThrow();
    expect(session.roles, ['professor']);
    expect(session.mustChangePassword, isTrue);
    expect(session.permissions, contains('grades.entry.write'));
  });

  test('perfis múltiplos somam permissões', () async {
    final env = _Env();
    final users = await env.admin();
    final created = (await users.create(
      const UserInput(
        name: 'Ana Dupla',
        email: 'ana@escola.ao',
        roles: ['professor', 'financeiro'],
      ),
    )).getOrThrow();
    final (_, auth) = await env.signIn(
      'ana@escola.ao',
      created.temporaryPassword!,
    );
    final session = (await auth.me()).getOrThrow();
    expect(session.roles, ['professor', 'financeiro']);
    expect(
      session.permissions,
      containsAll(['grades.entry.write', 'billing.invoice.create']),
    );
  });

  test('validação 422 por campo e e-mail duplicado 409', () async {
    final users = await _Env().admin();
    final bad = await users.create(
      const UserInput(name: '', email: 'invalido', roles: []),
    );
    final failure = bad.failureOrNull! as ValidationFailure;
    expect(failure.fields.keys, containsAll(['name', 'email', 'roles']));

    final dup = await users.create(
      const UserInput(
        name: 'Outro Admin',
        email: 'ADMIN@erp-global.local',
        roles: ['secretaria'],
      ),
    );
    expect(dup.failureOrNull!.code, 'CONFLICT');
  });

  test('perfis sem permissão recebem 403 em todos os endpoints', () async {
    final env = _Env();
    final (users, _) = await env.signIn(
      'professor@erp-global.local',
      'Dev@12345',
    );
    expect((await users.list()).failureOrNull, isA<PermissionFailure>());
    expect(
      (await users.create(_teacher)).failureOrNull,
      isA<PermissionFailure>(),
    );
    expect(
      (await users.resetPassword('qualquer')).failureOrNull,
      isA<PermissionFailure>(),
    );
  });

  test('editar actualiza dados, perfis e âmbito', () async {
    final users = await _Env().admin();
    final created = (await users.create(_teacher)).getOrThrow();
    final updated = (await users.update(
      created.user.id,
      const UserInput(
        name: 'Maria Coordenadora',
        email: 'maria.prof@escola.ao',
        roles: ['coordenacao', 'professor'],
        scope: ScopeModel(campusId: '01JCAMPUS0000000000000001A'),
      ),
    )).getOrThrow();
    expect(updated.user.name, 'Maria Coordenadora');
    expect(updated.roles, ['coordenacao', 'professor']);
    expect(updated.scope.campusId, '01JCAMPUS0000000000000001A');
    expect(updated.user.phone, isNull);
    expect((await users.get(created.user.id)).getOrThrow().roles, hasLength(2));
  });

  test('desactivar impede o login; activar volta a permitir', () async {
    final env = _Env();
    final users = await env.admin();
    final created = (await users.create(_teacher)).getOrThrow();
    final id = created.user.id;
    final pwd = created.temporaryPassword!;

    await users.setActive(id, active: false);
    final client = env._client();
    final denied = await ApiAuthRepository(
      client,
      InMemorySessionStorage(),
    ).login(identifier: 'maria.prof@escola.ao', password: pwd);
    expect(denied.failureOrNull, isA<PermissionFailure>());

    await users.setActive(id, active: true);
    await env.signIn('maria.prof@escola.ao', pwd);
  });

  test(
    'o último super_admin activo não pode ser desactivado nem despromovido',
    () async {
      final env = _Env();
      final users = await env.admin();
      final admin = (await users.list(
        query: 'Super',
      )).getOrThrow().items.single;

      final off = await users.setActive(admin.user.id, active: false);
      expect(off.failureOrNull!.code, 'CONFLICT');
      final demote = await users.update(
        admin.user.id,
        UserInput(
          name: admin.user.name,
          email: admin.user.email!,
          roles: const ['direcao'],
        ),
      );
      expect(demote.failureOrNull!.code, 'CONFLICT');

      // Com um segundo super_admin activo já é possível.
      final second = (await users.create(
        const UserInput(
          name: 'Segundo Admin',
          email: 'admin2@escola.ao',
          roles: ['super_admin'],
        ),
      )).getOrThrow();
      expect(
        (await users.setActive(admin.user.id, active: false)).isOk,
        isTrue,
      );
      // E agora o segundo é o último (pedido feito por ele próprio).
      final (asSecond, _) = await env.signIn(
        'admin2@escola.ao',
        second.temporaryPassword!,
      );
      final last = await asSecond.setActive(second.user.id, active: false);
      expect(last.failureOrNull!.code, 'CONFLICT');
    },
  );

  test(
    'repor password gera temporária, obriga a mudar e termina a sessão',
    () async {
      final env = _Env();
      final users = await env.admin();
      final created = (await users.create(_teacher)).getOrThrow();
      final (_, auth) = await env.signIn(
        'maria.prof@escola.ao',
        created.temporaryPassword!,
      );
      await auth.changePassword(
        currentPassword: created.temporaryPassword!,
        newPassword: 'MinhaNova@123',
      );
      expect((await auth.me()).getOrThrow().mustChangePassword, isFalse);

      final reset = (await users.resetPassword(created.user.id)).getOrThrow();
      expect(reset.temporaryPassword, isNot(created.temporaryPassword));
      expect(reset.user.mustChangePassword, isTrue);
      // A sessão anterior deixou de valer.
      expect((await auth.me()).failureOrNull, isA<AuthFailure>());
      final (_, again) = await env.signIn(
        'maria.prof@escola.ao',
        reset.temporaryPassword!,
      );
      expect((await again.me()).getOrThrow().mustChangePassword, isTrue);
    },
  );

  test('conta inexistente → 404', () async {
    final users = await _Env().admin();
    expect((await users.get('nao-existe')).failureOrNull!.code, 'NOT_FOUND');
    expect(
      (await users.resetPassword('nao-existe')).failureOrNull!.code,
      'NOT_FOUND',
    );
  });
}
