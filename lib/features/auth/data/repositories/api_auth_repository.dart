import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/auth_repository.dart';
import '../models/auth_session.dart';
import 'session_storage.dart';

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._client, this._storage);

  final ApiClient _client;
  final SessionStorage _storage;

  @override
  Future<Result<AuthSession>> login({
    required String identifier,
    required String password,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/auth/login',
      data: {'identifier': identifier, 'password': password},
    );
    final data = ApiEnvelope.data(response)! as Map<String, dynamic>;
    _client.tokens.save(
      accessToken: data['accessToken'] as String,
      refreshToken: data['refreshToken'] as String,
    );
    return AuthSession.fromJson(data);
  });

  @override
  Future<Result<AuthSession?>> restoreSession() async {
    final stored = await _storage.readRefreshToken();
    if (stored == null) return const Ok(null);
    final refreshed = await Result.guard(() async {
      final response = await _client.dio.post<dynamic>(
        '/v1/auth/refresh',
        data: {'refreshToken': stored},
      );
      final data = ApiEnvelope.data(response)! as Map<String, dynamic>;
      _client.tokens.save(
        accessToken: data['accessToken'] as String,
        refreshToken: data['refreshToken'] as String,
      );
    });
    if (refreshed.isErr) {
      _client.tokens.clear();
      return const Ok(null);
    }
    return (await me()).map<AuthSession?>((s) => s);
  }

  @override
  Future<Result<AuthSession>> me() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/auth/me');
    return ApiEnvelope.object(response, AuthSession.fromJson);
  });

  @override
  Future<Result<AuthSession>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/auth/change-password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
    return ApiEnvelope.object(response, AuthSession.fromJson);
  });

  @override
  Future<Result<void>> logout() => Result.guard(() async {
    final refresh = _client.tokens.refreshToken;
    try {
      await _client.dio.post<dynamic>(
        '/v1/auth/logout',
        data: {'refreshToken': ?refresh},
      );
    } finally {
      _client.tokens.clear();
    }
  });
}
