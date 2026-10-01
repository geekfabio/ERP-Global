import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/access_repositories.dart';
import '../models/access_models.dart';

/// Pedidos partilhados pelos três repositories.
class _Http {
  const _Http(this.client);

  final ApiClient client;

  Future<PagedList<T>> page<T>(
    String path,
    Map<String, dynamic> query,
    T Function(Map<String, dynamic>) fromJson,
  ) async => ApiEnvelope.page(
    await client.dio.get<dynamic>(path, queryParameters: query),
    fromJson,
  );

  Future<T> send<T>(
    String method,
    String path,
    T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic> data,
  ) async => ApiEnvelope.object(
    await client.dio.request<dynamic>(
      path,
      data: data,
      options: Options(method: method),
    ),
    fromJson,
  );
}

Map<String, dynamic> _query(int page, int pageSize, Map<String, String?> f) => {
  'page': page,
  'pageSize': pageSize,
  for (final e in f.entries)
    if (e.value != null && e.value!.trim().isNotEmpty) e.key: e.value!.trim(),
};

class ApiZoneRepository implements ZoneRepository {
  ApiZoneRepository(ApiClient client) : _http = _Http(client);

  final _Http _http;

  @override
  Future<Result<PagedList<ZoneModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    String? campusId,
  }) => Result.guard(
    () => _http.page(
      '/v1/zones',
      _query(page, pageSize, {'q': q, 'filter[campusId]': campusId}),
      ZoneModel.fromJson,
    ),
  );

  @override
  Future<Result<ZoneModel>> create(ZoneModel zone) => Result.guard(
    () => _http.send('POST', '/v1/zones', ZoneModel.fromJson, zone.toBody()),
  );

  @override
  Future<Result<ZoneModel>> update(ZoneModel zone) => Result.guard(
    () => _http.send(
      'PUT',
      '/v1/zones/${zone.id}',
      ZoneModel.fromJson,
      zone.toBody(),
    ),
  );

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _http.client.dio.delete<dynamic>('/v1/zones/$id'));

  @override
  Future<Result<Map<String, String>>> campuses() => Result.guard(() async {
    final response = await _http.client.dio.get<dynamic>(
      '/v1/campuses',
      queryParameters: {'pageSize': 100},
    );
    final list = ApiEnvelope.data(response)! as List;
    return {
      for (final c in list.cast<Map<String, dynamic>>())
        c['id']! as String: c['name']! as String,
    };
  });
}

class ApiAccessRuleRepository implements AccessRuleRepository {
  ApiAccessRuleRepository(ApiClient client) : _http = _Http(client);

  final _Http _http;

  @override
  Future<Result<PagedList<AccessRuleModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
  }) => Result.guard(
    () => _http.page(
      '/v1/access-rules',
      _query(page, pageSize, {'filter[zoneId]': zoneId}),
      AccessRuleModel.fromJson,
    ),
  );

  @override
  Future<Result<AccessRuleModel>> create(AccessRuleModel rule) => Result.guard(
    () => _http.send(
      'POST',
      '/v1/access-rules',
      AccessRuleModel.fromJson,
      rule.toBody(),
    ),
  );

  @override
  Future<Result<AccessRuleModel>> update(AccessRuleModel rule) => Result.guard(
    () => _http.send(
      'PUT',
      '/v1/access-rules/${rule.id}',
      AccessRuleModel.fromJson,
      rule.toBody(),
    ),
  );

  @override
  Future<Result<void>> delete(String id) => Result.guard(
    () => _http.client.dio.delete<dynamic>('/v1/access-rules/$id'),
  );
}

class ApiAccessDeviceRepository implements AccessDeviceRepository {
  ApiAccessDeviceRepository(ApiClient client) : _http = _Http(client);

  final _Http _http;

  @override
  Future<Result<PagedList<AccessDeviceModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? zoneId,
  }) => Result.guard(
    () => _http.page(
      '/v1/access-devices',
      _query(page, pageSize, {'filter[zoneId]': zoneId}),
      AccessDeviceModel.fromJson,
    ),
  );

  @override
  Future<Result<AccessDeviceModel>> create(AccessDeviceModel device) =>
      Result.guard(
        () => _http.send(
          'POST',
          '/v1/access-devices',
          AccessDeviceModel.fromJson,
          device.toBody(),
        ),
      );

  @override
  Future<Result<AccessDeviceModel>> update(AccessDeviceModel device) =>
      Result.guard(
        () => _http.send(
          'PUT',
          '/v1/access-devices/${device.id}',
          AccessDeviceModel.fromJson,
          device.toBody(),
        ),
      );

  @override
  Future<Result<void>> delete(String id) => Result.guard(
    () => _http.client.dio.delete<dynamic>('/v1/access-devices/$id'),
  );
}
