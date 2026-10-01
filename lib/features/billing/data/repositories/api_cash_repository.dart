import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/cash_repository.dart';
import '../models/billing_enums.dart';
import '../models/cash_register.dart';
import '../models/cash_session.dart';

/// Valor JSON (snake_case) de cada tipo de movimento.
const cashMovementTypeWire = <CashMovementType, String>{
  CashMovementType.cashPayment: 'cash_payment',
  CashMovementType.supply: 'supply',
  CashMovementType.withdrawal: 'withdrawal',
};

class ApiCashRepository implements CashRepository {
  ApiCashRepository(this._client);

  final ApiClient _client;

  Future<List<T>> _all<T>(
    String path,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final all = <T>[];
    var page = 1;
    while (true) {
      final response = await _client.dio.get<dynamic>(
        path,
        queryParameters: {'page': page, 'pageSize': 100},
      );
      final r = ApiEnvelope.page(response, fromJson);
      all.addAll(r.items);
      if (!r.meta.hasNext) return all;
      page++;
    }
  }

  @override
  Future<Result<List<CashRegister>>> registers() =>
      Result.guard(() => _all('/v1/cash-registers', CashRegister.fromJson));

  @override
  Future<Result<PagedList<CashSession>>> sessions({
    int page = 1,
    int pageSize = 20,
    CashSessionStatus? status,
    String? operatorId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cash-sessions',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[status]': ?status?.name,
        'filter[operatorId]': ?operatorId,
      },
    );
    return ApiEnvelope.page(response, CashSession.fromJson);
  });

  @override
  Future<Result<CashSession>> open({
    required String cashRegisterId,
    required String operatorId,
    required int openingMinor,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/cash-sessions',
      data: {
        'cashRegisterId': cashRegisterId,
        'operatorId': operatorId,
        'openingMinor': openingMinor,
      },
    );
    return ApiEnvelope.object(response, CashSession.fromJson);
  });

  @override
  Future<Result<List<CashMovement>>> movements(String sessionId) =>
      Result.guard(
        () => _all(
          '/v1/cash-sessions/$sessionId/movements',
          CashMovement.fromJson,
        ),
      );

  @override
  Future<Result<CashMovement>> addMovement({
    required String sessionId,
    required CashMovementType type,
    required int amountMinor,
    String? description,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/cash-sessions/$sessionId/movements',
      data: {
        'type': cashMovementTypeWire[type],
        'amountMinor': amountMinor,
        'description': ?description,
      },
    );
    return ApiEnvelope.object(response, CashMovement.fromJson);
  });

  @override
  Future<Result<CashSession>> close({
    required String sessionId,
    required int countedMinor,
    String? notes,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/cash-sessions/$sessionId/close',
      data: {'countedMinor': countedMinor, 'notes': ?notes},
    );
    return ApiEnvelope.object(response, CashSession.fromJson);
  });
}
