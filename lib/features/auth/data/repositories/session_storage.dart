import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../core/network/api_client.dart';

/// Guarda o refresh token entre execuções.
abstract interface class SessionStorage {
  Future<String?> readRefreshToken();
  Future<void> writeRefreshToken(String token);
  Future<void> clear();
}

class SecureSessionStorage implements SessionStorage {
  SecureSessionStorage([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'erp_refresh_token';
  final FlutterSecureStorage _storage;

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _key);

  @override
  Future<void> writeRefreshToken(String token) =>
      _storage.write(key: _key, value: token);

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

class InMemorySessionStorage implements SessionStorage {
  String? _token;

  @override
  Future<String?> readRefreshToken() async => _token;

  @override
  Future<void> writeRefreshToken(String token) async => _token = token;

  @override
  Future<void> clear() async => _token = null;
}

/// [TokenStore] que espelha o refresh token no [SessionStorage], incluindo as
/// rotações feitas pelo interceptor de refresh.
class PersistentTokenStore extends InMemoryTokenStore {
  PersistentTokenStore(this._storage);

  final SessionStorage _storage;

  @override
  void save({required String accessToken, required String refreshToken}) {
    super.save(accessToken: accessToken, refreshToken: refreshToken);
    unawaited(_storage.writeRefreshToken(refreshToken));
  }

  @override
  void clear() {
    super.clear();
    unawaited(_storage.clear());
  }
}
