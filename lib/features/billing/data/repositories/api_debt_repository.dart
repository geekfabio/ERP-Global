import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/debt_repository.dart';
import '../models/billing_enums.dart';
import '../models/debtor.dart';
import '../models/payment_agreement.dart';
import '../models/payment_notice.dart';

/// Valor JSON (snake_case) de cada tipo de aviso.
const noticeKindWire = <NoticeKind, String>{
  NoticeKind.preDue: 'pre_due',
  NoticeKind.postDue: 'post_due',
};

class ApiDebtRepository implements DebtRepository {
  ApiDebtRepository(this._client);

  final ApiClient _client;

  static const _date = DateOnlyConverter();

  @override
  Future<Result<PagedList<Debtor>>> debtors({
    int page = 1,
    int pageSize = 20,
    String? classroomId,
    String? month,
    DateTime? asOf,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/billing/debtors',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[classroomId]': ?classroomId,
        'filter[month]': ?month,
        if (asOf != null) 'asOf': _date.toJson(asOf),
      },
    );
    return ApiEnvelope.page(response, Debtor.fromJson);
  });

  @override
  Future<Result<PagedList<PaymentNotice>>> notices({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    NoticeKind? kind,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/billing/notices',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        if (kind != null) 'filter[kind]': noticeKindWire[kind],
      },
    );
    return ApiEnvelope.page(response, PaymentNotice.fromJson);
  });

  @override
  Future<Result<List<PaymentNotice>>> runNotices({
    DateTime? asOf,
    int preDueDays = 3,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/billing/notices/run',
      data: {
        if (asOf != null) 'asOf': _date.toJson(asOf),
        'preDueDays': preDueDays,
      },
    );
    return [
      for (final n in ApiEnvelope.data(response)! as List)
        PaymentNotice.fromJson(n as Map<String, dynamic>),
    ];
  });

  @override
  Future<Result<PagedList<PaymentAgreement>>> agreements({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    AgreementStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/payment-agreements',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        'filter[status]': ?status?.name,
      },
    );
    return ApiEnvelope.page(response, PaymentAgreement.fromJson);
  });

  @override
  Future<Result<PaymentAgreement>> createAgreement({
    required String studentId,
    List<String>? chargeIds,
    required int installmentCount,
    required DateTime firstDueDate,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/payment-agreements',
      data: {
        'studentId': studentId,
        'chargeIds': ?chargeIds,
        'installmentCount': installmentCount,
        'firstDueDate': _date.toJson(firstDueDate),
      },
    );
    return ApiEnvelope.object(response, PaymentAgreement.fromJson);
  });

  @override
  Future<Result<PaymentAgreement>> cancelAgreement(String id) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/payment-agreements/$id/cancel',
        );
        return ApiEnvelope.object(response, PaymentAgreement.fromJson);
      });
}
