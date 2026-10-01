import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/payment_repository.dart';
import '../models/billing_enums.dart';
import '../models/payment.dart';
import '../models/receipt.dart';
import '../models/student_account.dart';

/// Valor JSON (snake_case) de cada método, como o `@JsonEnum` do modelo.
const paymentMethodWire = <PaymentMethod, String>{
  PaymentMethod.cash: 'cash',
  PaymentMethod.bankTransfer: 'bank_transfer',
  PaymentMethod.card: 'card',
  PaymentMethod.paymentReference: 'payment_reference',
  PaymentMethod.prepaidBalance: 'prepaid_balance',
};

class ApiPaymentRepository implements PaymentRepository {
  ApiPaymentRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<Payment>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/payments',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
      },
    );
    return ApiEnvelope.page(response, Payment.fromJson);
  });

  @override
  Future<Result<PaymentResult>> create({
    required String studentId,
    required PaymentMethod method,
    required int amountMinor,
    List<PaymentAllocation>? allocations,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/payments',
      data: {
        'studentId': studentId,
        'method': paymentMethodWire[method],
        'amountMinor': amountMinor,
        'allocations': ?allocations?.map((a) => a.toJson()).toList(),
      },
    );
    final data = ApiEnvelope.data(response)! as Map<String, dynamic>;
    final receipt = data['receipt'];
    return PaymentResult(
      payment: Payment.fromJson(data['payment'] as Map<String, dynamic>),
      receipt: receipt == null
          ? null
          : Receipt.fromJson(receipt as Map<String, dynamic>),
    );
  });

  @override
  Future<Result<PagedList<Receipt>>> receipts({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    String? paymentId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/receipts',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        'filter[paymentId]': ?paymentId,
      },
    );
    return ApiEnvelope.page(response, Receipt.fromJson);
  });

  @override
  Future<Result<StudentAccount>> account(String studentId) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/student-accounts/$studentId',
        );
        return ApiEnvelope.object(response, StudentAccount.fromJson);
      });
}
