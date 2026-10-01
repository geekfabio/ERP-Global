import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/consumption.dart';
import '../../domain/consumption_repository.dart';
import '../models/consumption_rows.dart';

class ApiConsumptionRepository implements ConsumptionRepository {
  ApiConsumptionRepository(this._client);

  final ApiClient _client;

  static const _date = DateOnlyConverter();

  @override
  Future<Result<List<ConsumptionRow>>> consumption({
    required ConsumptionGroup group,
    DateTime? from,
    DateTime? to,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cafeteria/reports/consumption',
      queryParameters: {
        'groupBy': consumptionGroupWire[group],
        if (from != null) 'from': _date.toJson(from),
        if (to != null) 'to': _date.toJson(to),
      },
    );
    return [
      for (final r in ApiEnvelope.data(response)! as List)
        ConsumptionRow.fromJson(r as Map<String, dynamic>),
    ];
  });

  @override
  Future<Result<PrepaidBalance>> prepaidBalance() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/cafeteria/reports/prepaid-balance',
    );
    return PrepaidBalance.fromJson(
      ApiEnvelope.data(response)! as Map<String, dynamic>,
    );
  });
}
