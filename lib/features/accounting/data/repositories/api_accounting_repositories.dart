import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/accounting_repositories.dart';
import '../models/accounting_models.dart';

Future<Result<T>> _send<T>(
  ApiClient client,
  String method,
  String path,
  T Function(Map<String, dynamic>) fromJson, {
  Map<String, dynamic>? data,
}) => Result.guard(() async {
  final response = await client.dio.request<dynamic>(
    path,
    data: data,
    options: Options(method: method),
  );
  return ApiEnvelope.object(response, fromJson);
});

Map<String, dynamic> _query(int page, int pageSize, [String? q]) => {
  'page': page,
  'pageSize': pageSize,
  if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
};

class ApiAccountRepository implements AccountRepository {
  ApiAccountRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<AccountModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/accounts',
      queryParameters: _query(page, pageSize, q),
    );
    return ApiEnvelope.page(response, AccountModel.fromJson);
  });

  @override
  Future<Result<AccountModel>> create(AccountModel account) => _send(
    _client,
    'POST',
    '/v1/accounts',
    AccountModel.fromJson,
    data: account.toJson(),
  );

  @override
  Future<Result<AccountModel>> update(
    String id, {
    String? name,
    bool? isActive,
    bool? postable,
  }) => _send(
    _client,
    'PATCH',
    '/v1/accounts/$id',
    AccountModel.fromJson,
    data: {'name': ?name, 'isActive': ?isActive, 'postable': ?postable},
  );

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('/v1/accounts/$id'));
}

class ApiFiscalYearRepository implements FiscalYearRepository {
  ApiFiscalYearRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<FiscalYearModel>>> list({
    int page = 1,
    int pageSize = 50,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/fiscal-years',
      queryParameters: _query(page, pageSize),
    );
    return ApiEnvelope.page(response, FiscalYearModel.fromJson);
  });

  @override
  Future<Result<FiscalYearModel>> create(FiscalYearModel year) => _send(
    _client,
    'POST',
    '/v1/fiscal-years',
    FiscalYearModel.fromJson,
    data: year.toJson(),
  );

  @override
  Future<Result<FiscalYearModel>> close(String id) => _send(
    _client,
    'POST',
    '/v1/fiscal-years/$id/close',
    FiscalYearModel.fromJson,
    data: const {},
  );
}

class ApiCostCenterRepository implements CostCenterRepository {
  ApiCostCenterRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<CostCenterModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? q,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cost-centers',
      queryParameters: _query(page, pageSize, q),
    );
    return ApiEnvelope.page(response, CostCenterModel.fromJson);
  });

  @override
  Future<Result<CostCenterModel>> create(CostCenterModel center) => _send(
    _client,
    'POST',
    '/v1/cost-centers',
    CostCenterModel.fromJson,
    data: center.toJson(),
  );

  @override
  Future<Result<CostCenterModel>> update(
    String id, {
    String? name,
    bool? isActive,
  }) => _send(
    _client,
    'PATCH',
    '/v1/cost-centers/$id',
    CostCenterModel.fromJson,
    data: {'name': ?name, 'isActive': ?isActive},
  );

  @override
  Future<Result<void>> delete(String id) =>
      Result.guard(() => _client.dio.delete<dynamic>('/v1/cost-centers/$id'));
}
