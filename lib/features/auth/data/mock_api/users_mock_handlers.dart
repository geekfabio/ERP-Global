part of 'auth_mock_handlers.dart';

/// Permissão que, além do `super_admin`, autoriza a gestão de contas.
const manageUsersPermission = 'users.account.create';

const _scopeKeys = {
  'campusId',
  'courseId',
  'gradeId',
  'classroomId',
  'subjectId',
};

/// Handlers `/v1/users` (gestão de contas por administração; sem registo público).
extension UsersMockHandlers on AuthMockHandlers {
  void _registerUsers(MockApiRegistry registry) {
    registry
      ..get('/v1/users', _listUsers)
      ..get('/v1/users/{id}', (r) {
        _requireManager(r);
        return MockResponse.ok(_userJson(_accountById(r.params['id'])));
      })
      ..post('/v1/users', _createUser)
      ..patch('/v1/users/{id}', _updateUser)
      ..post('/v1/users/{id}/reset-password', _resetPassword);
  }

  /// Só `super_admin` ou quem tem `users.account.create`.
  MockAccount _requireManager(MockRequest r) {
    final caller = _auth(r);
    final allowed =
        caller.isSuperAdmin ||
        caller.permissions.any((p) => p == '*' || p == manageUsersPermission);
    if (!allowed) throw const MockApiException.forbidden();
    return caller;
  }

  MockAccount _accountById(String? id) =>
      _accounts[id] ?? (throw const MockApiException.notFound());

  Map<String, dynamic> _userJson(MockAccount a, {String? temporaryPassword}) =>
      {
        'user': a.user.toJson(),
        'roles': a.roles,
        'scope': a.scope.toJson(),
        'temporaryPassword': ?temporaryPassword,
      };

  MockResponse _listUsers(MockRequest r) {
    _requireManager(r);
    return mockPaginate<MockAccount>(
      _accounts.values,
      r,
      toJson: _userJson,
      spec: MockListSpec<MockAccount>(
        searchText: (a) =>
            '${a.user.name} ${a.user.email} ${a.roles.join(' ')}',
        sortable: {
          'name': (a) => a.user.name.toLowerCase(),
          'email': (a) => (a.user.email ?? '').toLowerCase(),
        },
        filterable: {
          'isActive': (a) => a.user.isActive,
          'role': (a) => a.roles.first,
        },
        defaultSort: const ['name'],
      ),
    );
  }

  MockResponse _createUser(MockRequest r) {
    final caller = _requireManager(r);
    final body = r.jsonBody;
    _validateFields(body, partial: false).throwIfInvalid();
    _checkUniqueEmail(body['email'], null);

    final now = _now().toUtc();
    final password = _temporaryPassword();
    final roles = _roles(body['roles']);
    final account = MockAccount(
      user: UserModel(
        id: _userIds.ulid(now),
        institutionId: caller.user.institutionId,
        createdAt: now,
        updatedAt: now,
        name: (body['name'] as String).trim(),
        email: _normEmail(body['email']),
        phone: _phone(body['phone']),
        isActive: body['isActive'] as bool? ?? true,
        mustChangePassword: true,
      ),
      profile: authProfileByCode[roles.first]!,
      roles: roles,
      scope: _scope(body['scope']),
      password: password,
    );
    _accounts[account.user.id] = account;
    return MockResponse.created(
      _userJson(account, temporaryPassword: password),
    );
  }

  MockResponse _updateUser(MockRequest r) {
    _requireManager(r);
    final current = _accountById(r.params['id']);
    final body = r.jsonBody;
    _validateFields(body, partial: true).throwIfInvalid();
    if (body.containsKey('email')) {
      _checkUniqueEmail(body['email'], current.user.id);
    }

    final roles = body.containsKey('roles')
        ? _roles(body['roles'])
        : current.roles;
    final active = body['isActive'] as bool? ?? current.user.isActive;
    final losesSuperAdmin =
        current.isSuperAdmin && (!active || !roles.contains('super_admin'));
    if (losesSuperAdmin && !_hasOtherActiveSuperAdmin(current.user.id)) {
      throw const MockApiException.conflict(
        'Tem de existir pelo menos um super_admin activo',
      );
    }

    final scope = body.containsKey('scope')
        ? _scope(body['scope'])
        : current.scope;
    final updated = current.copyWith(
      roles: roles,
      scope: scope,
      user: current.user.copyWith(
        name: body.containsKey('name')
            ? (body['name'] as String).trim()
            : current.user.name,
        email: body.containsKey('email')
            ? _normEmail(body['email'])
            : current.user.email,
        phone: body.containsKey('phone')
            ? _phone(body['phone'])
            : current.user.phone,
        isActive: active,
        updatedAt: _now().toUtc(),
      ),
    );
    _accounts[current.user.id] = updated;
    // Perfis, âmbito ou estado alterados: a sessão anterior deixa de valer.
    if (!active ||
        roles.join(',') != current.roles.join(',') ||
        scope != current.scope) {
      _revokeSessions(current.user.id);
    }
    return MockResponse.ok(_userJson(updated));
  }

  MockResponse _resetPassword(MockRequest r) {
    _requireManager(r);
    final current = _accountById(r.params['id']);
    final password = _temporaryPassword();
    final updated = current.copyWith(
      password: password,
      user: current.user.copyWith(
        mustChangePassword: true,
        updatedAt: _now().toUtc(),
      ),
    );
    _accounts[current.user.id] = updated;
    _revokeSessions(current.user.id);
    return MockResponse.ok(_userJson(updated, temporaryPassword: password));
  }

  MockValidator _validateFields(
    Map<String, dynamic> body, {
    required bool partial,
  }) {
    final v = MockValidator(body);
    if (!partial || body.containsKey('name')) {
      v
        ..required('name')
        ..check('name', body['name'] is String, 'Nome inválido');
    }
    if (!partial || body.containsKey('email')) {
      v
        ..required('email')
        ..check('email', body['email'] is String, 'E-mail inválido')
        ..email('email');
    }
    if (!partial || body.containsKey('roles')) {
      final roles = body['roles'];
      v.check(
        'roles',
        roles is List &&
            roles.isNotEmpty &&
            roles.every((c) => authProfileByCode.containsKey(c)),
        'Atribua pelo menos um perfil válido',
      );
    }
    if (body.containsKey('isActive')) {
      v.check('isActive', body['isActive'] is bool, 'Estado inválido');
    }
    if (body.containsKey('scope')) {
      final scope = body['scope'];
      v.check(
        'scope',
        scope is Map &&
            scope.entries.every(
              (e) =>
                  _scopeKeys.contains(e.key) &&
                  (e.value == null ||
                      (e.value is String && (e.value as String).isNotEmpty)),
            ),
        'Âmbito inválido',
      );
    }
    return v;
  }

  void _checkUniqueEmail(Object? email, String? selfId) {
    final norm = _normEmail(email);
    if (_accounts.values.any(
      (a) => a.user.id != selfId && a.user.email?.toLowerCase() == norm,
    )) {
      throw const MockApiException.conflict('E-mail já utilizado');
    }
  }

  bool _hasOtherActiveSuperAdmin(String userId) => _accounts.values.any(
    (a) => a.user.id != userId && a.user.isActive && a.isSuperAdmin,
  );

  String? _normEmail(Object? v) => (v as String?)?.trim().toLowerCase();

  String? _phone(Object? v) {
    final s = (v as String?)?.trim();
    return s == null || s.isEmpty ? null : s;
  }

  List<String> _roles(Object? v) => (v as List).cast<String>().toSet().toList();

  ScopeModel _scope(Object? v) => ScopeModel.fromJson({
    for (final e in (v as Map? ?? const {}).entries)
      if (e.value != null) e.key as String: e.value,
  });

  String _temporaryPassword() => 'Tmp@${_hex()}';

  /// Invalida os tokens da conta (o utilizador volta a iniciar sessão).
  void _revokeSessions(String userId) {
    _access.removeWhere((_, s) => s.userId == userId);
    _refresh.removeWhere((_, id) => id == userId);
  }
}
