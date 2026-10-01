import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../../../core/utils/json_converters.dart';
import '../../domain/report_repository.dart';
import '../../domain/reports.dart';
import '../models/report_rows.dart';

class ApiReportRepository implements ReportRepository {
  ApiReportRepository(this._client);

  final ApiClient _client;

  static const _date = DateOnlyConverter();

  Map<String, Object> _range(DateTime? from, DateTime? to, String? campusId) =>
      {
        if (from != null) 'from': _date.toJson(from),
        if (to != null) 'to': _date.toJson(to),
        'filter[campusId]': ?campusId,
      };

  @override
  Future<Result<List<RevenueRow>>> revenue({
    required RevenueGroup group,
    DateTime? from,
    DateTime? to,
    String? campusId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/billing/reports/revenue',
      queryParameters: {
        'groupBy': revenueGroupWire[group],
        ..._range(from, to, campusId),
      },
    );
    return [
      for (final r in ApiEnvelope.data(response)! as List)
        RevenueRow.fromJson(r as Map<String, dynamic>),
    ];
  });

  @override
  Future<Result<List<ForecastRow>>> forecast({
    DateTime? from,
    DateTime? to,
    String? campusId,
  }) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/billing/reports/forecast',
      queryParameters: _range(from, to, campusId),
    );
    return [
      for (final r in ApiEnvelope.data(response)! as List)
        ForecastRow.fromJson(r as Map<String, dynamic>),
    ];
  });
}
