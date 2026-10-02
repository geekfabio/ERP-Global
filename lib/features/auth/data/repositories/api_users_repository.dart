import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/users_repository.dart';
import '../models/managed_user.dart';

class ApiUsersRepository implements UsersRepository {
  ApiUsersRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<ManagedUser>>> list({
    int page = 1,
    int pageSize = 20,
    String query = '',
    String sort = 'name',
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/users',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'sort': sort,
        if (query.trim().isNotEmpty) 'q': query.trim(),
      },
    );
    return ApiEnvelope.page(response, ManagedUser.fromJson);
  });

  @override
  Future<Result<ManagedUser>> get(String id) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.get<dynamic>('/v1/users/$id'),
      ManagedUser.fromJson,
    ),
  );

  @override
  Future<Result<ManagedUser>> create(UserInput input) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('/v1/users', data: input.toJson()),
      ManagedUser.fromJson,
    ),
  );

  @override
  Future<Result<ManagedUser>> update(String id, UserInput input) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.patch<dynamic>(
            '/v1/users/$id',
            data: input.toJson(),
          ),
          ManagedUser.fromJson,
        ),
      );

  @override
  Future<Result<ManagedUser>> setActive(String id, {required bool active}) =>
      Result.guard(
        () async => ApiEnvelope.object(
          await _client.dio.patch<dynamic>(
            '/v1/users/$id',
            data: {'isActive': active},
          ),
          ManagedUser.fromJson,
        ),
      );

  @override
  Future<Result<ManagedUser>> resetPassword(String id) => Result.guard(
    () async => ApiEnvelope.object(
      await _client.dio.post<dynamic>('/v1/users/$id/reset-password'),
      ManagedUser.fromJson,
    ),
  );
}
