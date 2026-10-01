import '../../../../core/network/mock/mock_api_registry.dart';
import '../../../../core/network/mock/mock_types.dart';
import '../../../../core/network/mock/mock_validator.dart';
import '../../../../core/utils/seeded_random.dart';
import '../data_mocks/auth_mock_data.dart';
import '../../../../core/network/mock/mock_query.dart';
import '../../../../core/utils/seed_generator.dart';
import '../models/scope_model.dart';
import '../models/user_model.dart';

part 'users_mock_handlers.dart';

/// Validade do access token (segundos).
const mockAccessTtlSeconds = 900;

/// Handlers `/v1/auth/*`. Sem registo nem recuperação auto-serviço (docs/07-mock-api.md).
class AuthMockHandlers implements MockApiModule {
  AuthMockHandlers({DateTime Function()? now, int seed = 7})
    : _now = now ?? DateTime.now,
      _random = SeededRandom(seed) {
    _seed();
  }

  final DateTime Function() _now;
  final SeededRandom _random;
  final _userIds = SeedGenerator(97);

  final Map<String, MockAccount> _accounts = {};
  final Map<String, ({String userId, DateTime expiresAt})> _access = {};
  final Map<String, String> _refresh = {};

  void _seed() {
    _accounts
      ..clear()
      ..addEntries(buildAuthSeed().map((a) => MapEntry(a.user.id, a)));
    _access.clear();
    _refresh.clear();
  }

  /// Contas actuais (só leitura, para testes e para o módulo de utilizadores #97).
  List<MockAccount> get accounts => List.unmodifiable(_accounts.values);

  /// Activa/desactiva uma conta garantindo sempre ≥ 1 super_admin activo.
  void setActive(String userId, {required bool active}) {
    final account = _accounts[userId];
    if (account == null) throw const MockApiException.notFound();
    if (!active && account.isSuperAdmin) {
      final others = _accounts.values.where(
        (a) => a.isSuperAdmin && a.user.id != userId && a.user.isActive,
      );
      if (others.isEmpty) {
        throw const MockApiException.conflict(
          'Tem de existir pelo menos um super_admin activo',
        );
      }
    }
    _accounts[userId] = account.copyWith(
      user: account.user.copyWith(isActive: active),
    );
  }

  /// Marca a conta para exigir mudança de password no próximo login.
  void requirePasswordChange(String userId) {
    final a = _accounts[userId];
    if (a == null) throw const MockApiException.notFound();
    _accounts[userId] = a.copyWith(
      user: a.user.copyWith(mustChangePassword: true),
    );
  }

  @override
  void register(MockApiRegistry registry) {
    _registerUsers(registry);
    registry
      ..onReset(_seed)
      ..post('/v1/auth/login', _login)
      ..post('/v1/auth/refresh', _refreshTokens)
      ..post('/v1/auth/logout', _logout)
      ..get('/v1/auth/me', (r) => MockResponse.ok(_sessionPayload(_auth(r))))
      ..post('/v1/auth/change-password', _changePassword);
  }

  MockResponse _login(MockRequest req) {
    MockValidator(req.jsonBody)
      ..required('identifier')
      ..required('password')
      ..throwIfInvalid();
    final identifier = (req.jsonBody['identifier'] as String)
        .trim()
        .toLowerCase();
    final account = _accounts.values
        .where((a) => a.user.email?.toLowerCase() == identifier)
        .firstOrNull;
    if (account == null || account.password != req.jsonBody['password']) {
      throw const MockApiException(
        401,
        'INVALID_CREDENTIALS',
        'Credenciais inválidas',
      );
    }
    if (!account.user.isActive) {
      throw const MockApiException.forbidden('Conta desactivada');
    }
    return MockResponse.ok({
      ..._issueTokens(account.user.id),
      ..._sessionPayload(account),
    });
  }

  MockResponse _refreshTokens(MockRequest req) {
    final token = req.jsonBody['refreshToken'];
    final userId = token is String ? _refresh.remove(token) : null;
    if (userId == null) throw const MockApiException.unauthenticated();
    return MockResponse.ok(_issueTokens(userId));
  }

  MockResponse _logout(MockRequest req) {
    final refresh = req.jsonBody['refreshToken'];
    if (refresh is String) _refresh.remove(refresh);
    final bearer = _bearer(req);
    if (bearer != null) _access.remove(bearer);
    return MockResponse.ok({'loggedOut': true});
  }

  MockResponse _changePassword(MockRequest req) {
    final account = _auth(req);
    final body = req.jsonBody;
    final validator = MockValidator(body)
      ..required('currentPassword')
      ..required('newPassword')
      ..minLength('newPassword', 8);
    if (body['currentPassword'] is String &&
        body['currentPassword'] != account.password) {
      validator.errors['currentPassword'] = 'Password actual incorrecta';
    }
    validator
      ..check(
        'newPassword',
        body['newPassword'] != body['currentPassword'],
        'A nova password tem de ser diferente',
      )
      ..throwIfInvalid();
    final updated = account.copyWith(
      password: body['newPassword'] as String,
      user: account.user.copyWith(mustChangePassword: false),
    );
    _accounts[account.user.id] = updated;
    return MockResponse.ok(_sessionPayload(updated));
  }

  Map<String, dynamic> _sessionPayload(MockAccount a) => {
    'user': a.user.toJson(),
    'roles': a.roles,
    'permissions': a.permissions,
    'license': {
      'plan': 'dev',
      'status': 'active',
      'modules': ['*'],
    },
  };

  Map<String, dynamic> _issueTokens(String userId) {
    final access = 'at_${_hex()}';
    final refresh = 'rt_${_hex()}';
    _access[access] = (
      userId: userId,
      expiresAt: _now().add(const Duration(seconds: mockAccessTtlSeconds)),
    );
    _refresh[refresh] = userId;
    return {
      'accessToken': access,
      'refreshToken': refresh,
      'expiresIn': mockAccessTtlSeconds,
    };
  }

  String _hex() => List.generate(
    4,
    (_) => _random.nextInt(0x10000).toRadixString(16).padLeft(4, '0'),
  ).join();

  String? _bearer(MockRequest req) {
    final header = req.headers['Authorization'];
    return header is String && header.startsWith('Bearer ')
        ? header.substring(7)
        : null;
  }

  /// Conta autenticada pelo Bearer: 401 UNAUTHENTICATED / TOKEN_EXPIRED.
  MockAccount _auth(MockRequest req) {
    final token = _bearer(req);
    final session = token == null ? null : _access[token];
    if (session == null) throw const MockApiException.unauthenticated();
    if (!_now().isBefore(session.expiresAt)) {
      throw const MockApiException.tokenExpired();
    }
    final account = _accounts[session.userId];
    if (account == null || !account.user.isActive) {
      throw const MockApiException.unauthenticated();
    }
    return account;
  }
}
