import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/inventory_repositories.dart';
import '../models/inventory_models.dart';

class ApiAssetRepository implements AssetRepository {
  ApiAssetRepository(this._client);

  final ApiClient _client;

  Future<Result<T>> _send<T>(
    String method,
    String path,
    T Function(Map<String, dynamic>) fromJson, {
    Map<String, dynamic>? data,
  }) => Result.guard(() async {
    final response = await _client.dio.request<dynamic>(
      path,
      data: data,
      options: Options(method: method),
    );
    return ApiEnvelope.object(response, fromJson);
  });

  @override
  Future<Result<PagedList<AssetModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    AssetStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/assets',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        if (status != null) 'filter[status]': status.wire,
      },
    );
    return ApiEnvelope.page(response, AssetModel.fromJson);
  });

  @override
  Future<Result<AssetModel>> create(AssetModel asset) =>
      _send('POST', '/v1/assets', AssetModel.fromJson, data: asset.toJson());

  @override
  Future<Result<AssetModel>> reassign(
    String id, {
    String? custodian,
    String? location,
  }) => _send(
    'PATCH',
    '/v1/assets/$id',
    AssetModel.fromJson,
    data: {'custodian': ?custodian, 'location': ?location},
  );

  @override
  Future<Result<AssetModel>> writeOff(String id, {required String reason}) =>
      _send(
        'POST',
        '/v1/assets/$id/write-off',
        AssetModel.fromJson,
        data: {'reason': reason},
      );

  @override
  Future<Result<List<MaintenanceModel>>> maintenance(String id) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/assets/$id/maintenance',
        );
        return [
          for (final m in ApiEnvelope.data(response)! as List)
            MaintenanceModel.fromJson(m as Map<String, dynamic>),
        ];
      });

  @override
  Future<Result<MaintenanceModel>> scheduleMaintenance(
    String id, {
    required String description,
    required DateTime scheduledOn,
    int costCents = 0,
  }) => _send(
    'POST',
    '/v1/assets/$id/maintenance',
    MaintenanceModel.fromJson,
    data: {
      'description': description,
      'scheduledOn': const DateOnlyConverter().toJson(scheduledOn),
      'costCents': costCents,
    },
  );

  @override
  Future<Result<MaintenanceModel>> completeMaintenance(
    String assetId,
    String maintenanceId,
  ) => _send(
    'POST',
    '/v1/assets/$assetId/maintenance/$maintenanceId/complete',
    MaintenanceModel.fromJson,
    data: const {},
  );
}

class ApiStockRepository implements StockRepository {
  ApiStockRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<StockItemModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    bool lowOnly = false,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/stock-items',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        if (lowOnly) 'filter[lowStock]': 'true',
      },
    );
    return ApiEnvelope.page(response, StockItemModel.fromJson);
  });

  @override
  Future<Result<StockItemModel>> create(StockItemModel item) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/stock-items',
          data: item.toJson(),
        );
        return ApiEnvelope.object(response, StockItemModel.fromJson);
      });

  @override
  Future<Result<StockItemModel>> move(
    String id, {
    required int delta,
    required String reason,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/stock-items/$id/movements',
      data: {'delta': delta, 'reason': reason},
    );
    return ApiEnvelope.object(response, StockItemModel.fromJson);
  });
}
