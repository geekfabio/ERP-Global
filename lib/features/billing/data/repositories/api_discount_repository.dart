import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/discount_repository.dart';
import '../models/billing_enums.dart';
import '../models/discount.dart';

class ApiDiscountRepository implements DiscountRepository {
  ApiDiscountRepository(this._client);

  final ApiClient _client;

  static const _date = DateOnlyConverter();

  @override
  Future<Result<PagedList<Discount>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    DiscountStatus? status,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/discounts',
      queryParameters: {
        'page': page,
        'pageSize': pageSize,
        'filter[studentId]': ?studentId,
        'filter[status]': ?status?.name,
      },
    );
    return ApiEnvelope.page(response, Discount.fromJson);
  });

  @override
  Future<Result<Discount>> request({
    required String studentId,
    required DiscountKind kind,
    required DiscountReason reason,
    required int value,
    FeeType? feeType,
    required DateTime validFrom,
    DateTime? validUntil,
    String? note,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/discounts',
      data: {
        'studentId': studentId,
        'kind': kind.name,
        'reason': reason.name,
        'value': value,
        if (feeType != null) 'feeType': feeType.name,
        'validFrom': _date.toJson(validFrom),
        if (validUntil != null) 'validUntil': _date.toJson(validUntil),
        'note': ?note,
      },
    );
    return ApiEnvelope.object(response, Discount.fromJson);
  });

  Future<Result<Discount>> _decide(String id, String action, String? note) =>
      Result.guard(() async {
        final response = await _client.dio.post<dynamic>(
          '/v1/discounts/$id/$action',
          data: {'note': ?note},
        );
        return ApiEnvelope.object(response, Discount.fromJson);
      });

  @override
  Future<Result<Discount>> approve(String id, {String? note}) =>
      _decide(id, 'approve', note);

  @override
  Future<Result<Discount>> reject(String id, {String? note}) =>
      _decide(id, 'reject', note);

  @override
  Future<Result<Discount>> revoke(String id, {String? note}) =>
      _decide(id, 'revoke', note);
}
