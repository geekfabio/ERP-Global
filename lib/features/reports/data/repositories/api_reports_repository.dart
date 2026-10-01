import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/reports_repository.dart';
import '../models/academic_overview.dart';
import '../models/dashboard_metric.dart';

class ApiReportsRepository implements ReportsRepository {
  ApiReportsRepository(this._client);

  final ApiClient _client;

  @override
  Future<Result<List<DashboardMetric>>> dashboard(DashboardQuery q) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/reports/dashboard',
          queryParameters: {
            'profile': q.profile,
            'widgets': q.widgetIds.join(','),
            'yearId': q.yearId,
            if (q.termId != null) 'termId': q.termId,
            if (q.campusId != null) 'campusId': q.campusId,
            if (q.compareYearId != null) 'compareYearId': q.compareYearId,
            if (q.compareTermId != null) 'compareTermId': q.compareTermId,
          },
        );
        return (ApiEnvelope.data(response)! as List)
            .cast<Map<String, dynamic>>()
            .map(DashboardMetric.fromJson)
            .toList(growable: false);
      });

  @override
  Future<Result<AcademicOverview>> academicOverview(AcademicOverviewQuery q) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/reports/academic-overview',
          queryParameters: {
            'yearId': q.yearId,
            if (q.termId != null) 'termId': q.termId,
            if (q.campusId != null) 'campusId': q.campusId,
            if (q.compareYearId != null) 'compareYearId': q.compareYearId,
            if (q.compareTermId != null) 'compareTermId': q.compareTermId,
          },
        );
        return AcademicOverview.fromJson(
          ApiEnvelope.data(response)! as Map<String, dynamic>,
        );
      });

  @override
  Future<Result<List<CampusOption>>> campuses() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/campuses',
      queryParameters: {'pageSize': 100},
    );
    return ApiEnvelope.page(response, CampusOption.fromJson).items;
  });
}
