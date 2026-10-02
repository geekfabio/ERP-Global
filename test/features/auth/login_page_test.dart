import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/domain/auth_repository.dart';
import 'package:erp_global/features/auth/presentation/pages/login_page.dart';
import 'package:erp_global/features/auth/presentation/providers/active_role.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

AuthSession _session(List<String> roles) => AuthSession.fromJson({
  'user': {
    'id': '01J1',
    'institutionId': '01JI',
    'createdAt': '2026-01-01T00:00:00Z',
    'updatedAt': '2026-01-01T00:00:00Z',
    'name': 'Ana',
  },
  'roles': roles,
  'permissions': <String>[],
  'license': <String, dynamic>{},
});

class _FakeRepo implements AuthRepository {
  _FakeRepo({this.roles = const ['secretaria'], this.fail = false});

  final List<String> roles;
  final bool fail;
  final List<String> attempts = [];

  @override
  Future<Result<AuthSession>> login({
    required String identifier,
    required String password,
  }) async {
    attempts.add(identifier);
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return fail
        ? Err(
            AuthFailure(
              code: 'INVALID_CREDENTIALS',
              message: 'Credenciais inválidas',
            ),
          )
        : Ok(_session(roles));
  }

  @override
  Future<Result<AuthSession?>> restoreSession() async => const Ok(null);
  @override
  Future<Result<AuthSession>> me() async => Ok(_session(roles));
  @override
  Future<Result<AuthSession>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async => Ok(_session(roles));
  @override
  Future<Result<void>> logout() async => const Ok(null);
}

Widget _app(_FakeRepo repo) {
  final router = GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginPage()),
      GoRoute(path: '/dashboard', builder: (_, _) => const Text('PAINEL')),
    ],
  );
  return ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repo)],
    child: MaterialApp.router(theme: AppTheme.light(), routerConfig: router),
  );
}

Future<void> _fill(WidgetTester tester, String id, String pw) async {
  await tester.enterText(find.byType(TextFormField).at(0), id);
  await tester.enterText(find.byType(TextFormField).at(1), pw);
}

void main() {
  test('validação do identificador', () {
    expect(validateLoginIdentifier(''), isNotNull);
    expect(validateLoginIdentifier('abc'), isNotNull);
    expect(validateLoginIdentifier('ana@escola.ao'), isNull);
    expect(validateLoginIdentifier('+244 923 456 789'), isNull);
    expect(validateLoginIdentifier('123'), isNotNull);
  });

  testWidgets('não existe registo nem recuperação de palavra-passe', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_FakeRepo()));
    await tester.pumpAndSettle();
    expect(find.textContaining('Registar'), findsNothing);
    expect(find.textContaining('Esqueci'), findsNothing);
    expect(find.textContaining('Criar conta'), findsNothing);
  });

  testWidgets('campos vazios mostram erros e não chamam o repositório', (
    tester,
  ) async {
    final repo = _FakeRepo();
    await tester.pumpWidget(_app(repo));
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.text('Indique o e-mail ou telefone'), findsOneWidget);
    expect(find.text('Indique a palavra-passe'), findsOneWidget);
    expect(repo.attempts, isEmpty);
  });

  testWidgets('login com sucesso mostra loading e navega', (tester) async {
    final repo = _FakeRepo();
    await tester.pumpWidget(_app(repo));
    await _fill(tester, 'ana@escola.ao', 'Segredo@1');
    await tester.tap(find.text('Entrar'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('PAINEL'), findsOneWidget);
    expect(repo.attempts, ['ana@escola.ao']);
  });

  testWidgets('credenciais erradas mostram mensagem e ficam no login', (
    tester,
  ) async {
    await tester.pumpWidget(_app(_FakeRepo(fail: true)));
    await _fill(tester, 'ana@escola.ao', 'errada');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Credenciais inválidas'), findsOneWidget);
    expect(find.text('PAINEL'), findsNothing);
  });

  testWidgets('vários perfis: escolhe o perfil activo antes de entrar', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(_FakeRepo(roles: ['professor', 'coordenacao'])),
    );
    await _fill(tester, 'ana@escola.ao', 'Segredo@1');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha o perfil'), findsOneWidget);
    expect(find.text('PAINEL'), findsNothing);

    await tester.tap(find.text('Coordenação'));
    await tester.pumpAndSettle();
    expect(find.text('PAINEL'), findsOneWidget);
    final container = ProviderScope.containerOf(
      tester.element(find.text('PAINEL')),
    );
    expect(container.read(activeRoleProvider), 'coordenacao');
  });
}
