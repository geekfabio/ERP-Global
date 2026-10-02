import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/portal_finance_repository.dart';
import '../models/portal_finance_models.dart';

class ApiPortalFinanceRepository implements PortalFinanceRepository {
  ApiPortalFinanceRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PortalFinance>> finance(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/portal/pupils/$studentId/finance',
        );
        return ApiEnvelope.object(response, PortalFinance.fromJson);
      });

  @override
  Future<Result<PortalPaymentReference>> paymentReference(
    String studentId, {
    List<String> chargeIds = const [],
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/portal/pupils/$studentId/payment-references',
      data: {'chargeIds': chargeIds},
    );
    return ApiEnvelope.object(response, PortalPaymentReference.fromJson);
  });

  @override
  Future<Result<PortalCard>> card(String studentId) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/portal/pupils/$studentId/card',
    );
    return ApiEnvelope.object(response, PortalCard.fromJson);
  });
}
