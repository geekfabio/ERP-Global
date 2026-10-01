import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/wallet_repository.dart';
import '../models/wallet.dart';

class ApiWalletRepository implements WalletRepository {
  ApiWalletRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<Wallet>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
    bool? blocked,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/wallets',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
        if (blocked != null) 'filter[blocked]': '$blocked',
      },
    );
    return ApiEnvelope.page(response, Wallet.fromJson);
  });

  Future<Result<T>> _post<T>(
    String path,
    Map<String, dynamic> data,
    T Function(Map<String, dynamic>) fromJson,
  ) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(path, data: data);
    return ApiEnvelope.object(response, fromJson);
  });

  @override
  Future<Result<Wallet>> open({
    required String holderId,
    required String holderName,
    int dailyLimitMinor = 0,
  }) => _post('/v1/wallets', {
    'holderId': holderId,
    'holderName': holderName,
    'dailyLimitMinor': dailyLimitMinor,
  }, Wallet.fromJson);

  @override
  Future<Result<WalletTransaction>> topUp(
    String walletId, {
    required int amountMinor,
    required String method,
    String? reference,
  }) => _post('/v1/wallets/$walletId/topups', {
    'amountMinor': amountMinor,
    'method': method,
    if (reference != null && reference.trim().isNotEmpty)
      'reference': reference.trim(),
  }, WalletTransaction.fromJson);

  @override
  Future<Result<WalletTransaction>> purchase(
    String walletId, {
    required int amountMinor,
    String? description,
  }) => _post('/v1/wallets/$walletId/purchases', {
    'amountMinor': amountMinor,
    'description': ?description,
  }, WalletTransaction.fromJson);

  @override
  Future<Result<WalletTransaction>> refund(
    String walletId, {
    required String transactionId,
    String? reason,
  }) => _post('/v1/wallets/$walletId/refunds', {
    'transactionId': transactionId,
    'reason': ?reason,
  }, WalletTransaction.fromJson);

  @override
  Future<Result<Wallet>> setDailyLimit(String walletId, int dailyLimitMinor) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/wallets/$walletId',
          data: {'dailyLimitMinor': dailyLimitMinor},
        );
        return ApiEnvelope.object(response, Wallet.fromJson);
      });

  @override
  Future<Result<Wallet>> setBlocked(String walletId, {required bool blocked}) =>
      _post(
        '/v1/wallets/$walletId/${blocked ? 'block' : 'unblock'}',
        {},
        Wallet.fromJson,
      );

  @override
  Future<Result<PagedList<WalletTransaction>>> statement(
    String walletId, {
    int page = 1,
    int pageSize = 20,
    DateTime? from,
    DateTime? to,
    WalletTransactionType? type,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/wallets/$walletId/transactions',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        if (from != null) 'from': from.toUtc().toIso8601String(),
        if (to != null) 'to': to.toUtc().toIso8601String(),
        if (type != null) 'filter[type]': type.name,
      },
    );
    return ApiEnvelope.page(response, WalletTransaction.fromJson);
  });
}
