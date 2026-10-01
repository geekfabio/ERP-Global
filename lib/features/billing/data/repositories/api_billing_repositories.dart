import 'package:dio/dio.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/events/domain_event.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/billing_repositories.dart';
import '../models/billing_enums.dart';
import '../models/charge.dart';
import '../models/fee_item.dart';

String _feeTypeWire(FeeType t) =>
    t.name.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

class ApiFeeItemRepository implements FeeItemRepository {
  ApiFeeItemRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<FeeItem>>> list({
    int page = 1,
    int pageSize = 20,
    String? academicYearId,
    String? gradeId,
    FeeType? type,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/fee-items',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[academicYearId]': ?academicYearId,
        'filter[gradeId]': ?gradeId,
        if (type != null) 'filter[type]': _feeTypeWire(type),
      },
    );
    return ApiEnvelope.page(response, FeeItem.fromJson);
  });

  @override
  Future<Result<FeeItem>> create(FeeItem item) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/fee-items',
      data: item.toJson(),
    );
    return ApiEnvelope.object(response, FeeItem.fromJson);
  });

  @override
  Future<Result<FeeItem>> update(
    String id, {
    int? amountMinor,
    FeeItemStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.patch<dynamic>(
      '/v1/fee-items/$id',
      data: {'amountMinor': ?amountMinor, 'status': ?status?.name},
    );
    return ApiEnvelope.object(response, FeeItem.fromJson);
  });
}

class ApiBillingPlanRepository implements BillingPlanRepository {
  ApiBillingPlanRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<PagedList<Charge>>> charges({
    int page = 1,
    int pageSize = 20,
    String? studentId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/charges',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
      },
    );
    return ApiEnvelope.page(response, Charge.fromJson);
  });

  @override
  Future<Result<List<Charge>>> generateForEnrollment(
    EnrollmentConfirmed event,
  ) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/billing/enrollment-charges',
      data: {
        'enrollmentId': event.enrollmentId,
        'studentId': event.studentId,
        'academicYearId': event.academicYearId,
        'gradeId': event.gradeId,
        'enrollmentFeeMinor': event.feeMinor,
        'startYear': event.occurredAt.month >= 8
            ? event.occurredAt.year
            : event.occurredAt.year - 1,
      },
    );
    return [
      for (final c in ApiEnvelope.data(response)! as List)
        Charge.fromJson(c as Map<String, dynamic>),
    ];
  });

  @override
  Future<Result<List<LateFeeApplication>>> applyLateFees({DateTime? asOf}) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/billing/late-fees',
          data: {
            if (asOf != null) 'asOf': const DateOnlyConverter().toJson(asOf),
          },
          options: Options(contentType: Headers.jsonContentType),
        );
        return [
          for (final a in ApiEnvelope.data(response)! as List)
            LateFeeApplication(
              chargeId: (a as Map<String, dynamic>)['chargeId'] as String,
              penaltyChargeId: a['penaltyChargeId'] as String,
              penaltyMinor: a['penaltyMinor'] as int,
            ),
        ];
      });
}
