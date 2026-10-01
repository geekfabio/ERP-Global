import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/menu_repository.dart';
import '../models/menu.dart';

class _ApiCrud<T> implements MealCrudRepository<T> {
  _ApiCrud(this._client, this._path, this._fromJson, this._toJson);

  final ApiClient _client;
  final String _path;
  final T Function(Map<String, dynamic>) _fromJson;
  final Map<String, dynamic> Function(T) _toJson;

  @override
  Future<Result<PagedList<T>>> list({int page = 1, int pageSize = 100}) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          _path,
          queryParameters: {'page': page, 'pageSize': pageSize},
        );
        return ApiEnvelope.page(response, _fromJson);
      });

  @override
  Future<Result<T>> create(T value) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      _path,
      data: _toJson(value),
    );
    return ApiEnvelope.object(response, _fromJson);
  });

  @override
  Future<Result<T>> update(String id, T value) => Result.guard(() async {
    final response = await _client.dio.patch<dynamic>(
      '$_path/$id',
      data: _toJson(value),
    );
    return ApiEnvelope.object(response, _fromJson);
  });

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('$_path/$id'));
}

class ApiMenuRepository implements MenuRepository {
  ApiMenuRepository(this._client)
    : types = _ApiCrud(
        _client,
        '/v1/meal-types',
        MealType.fromJson,
        (v) => v.toJson(),
      ),
      items = _ApiCrud(
        _client,
        '/v1/meal-items',
        MealItem.fromJson,
        (v) => v.toJson(),
      );

  final ApiClient _client;

  @override
  final MealCrudRepository<MealType> types;

  @override
  final MealCrudRepository<MealItem> items;

  @override
  Future<Result<PagedList<MealMenu>>> menus({
    required String from,
    required String to,
    int page = 1,
    int pageSize = 100,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/meal-menus',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'from': from,
        'to': to,
      },
    );
    return ApiEnvelope.page(response, MealMenu.fromJson);
  });

  @override
  Future<Result<MealMenu>> saveMenu({
    required String date,
    required String mealTypeId,
    required List<String> itemIds,
  }) => Result.guard(() async {
    final response = await _client.dio.put<dynamic>(
      '/v1/meal-menus',
      data: {'date': date, 'mealTypeId': mealTypeId, 'itemIds': itemIds},
    );
    return ApiEnvelope.object(response, MealMenu.fromJson);
  });

  @override
  Future<Result<void>> deleteMenu(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('/v1/meal-menus/$id'));
}
