import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/reports_repository.dart';
import '../models/academic_overview.dart';
import '../models/dashboard_metric.dart';
import '../models/finance_overview.dart';
import '../models/operations_overview.dart';
import '../models/report_models.dart';

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
  Future<Result<FinanceOverview>> financeOverview(FinanceOverviewQuery q) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/reports/finance-overview',
          queryParameters: {
            'yearId': q.yearId,
            if (q.termId != null) 'termId': q.termId,
            if (q.campusId != null) 'campusId': q.campusId,
            if (q.compareYearId != null) 'compareYearId': q.compareYearId,
            if (q.compareTermId != null) 'compareTermId': q.compareTermId,
          },
        );
        return FinanceOverview.fromJson(
          ApiEnvelope.data(response)! as Map<String, dynamic>,
        );
      });

  @override
  Future<Result<OperationsOverview>> operationsOverview(
    OperationsOverviewQuery q,
  ) => Result.guard(() async {
    final response = await _client.dio.get<dynamic>(
      '/v1/reports/operations-overview',
      queryParameters: {
        'yearId': q.yearId,
        if (q.termId != null) 'termId': q.termId,
        if (q.campusId != null) 'campusId': q.campusId,
      },
    );
    return OperationsOverview.fromJson(
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

  @override
  Future<Result<ReportResult>> runReport(String reportId, {String? campusId}) =>
      Result.guard(() async {
        final response = await _client.dio.get<dynamic>(
          '/v1/reports/catalog/$reportId/run',
          queryParameters: {'campusId': ?campusId},
        );
        return ReportResult.fromJson(
          ApiEnvelope.data(response)! as Map<String, dynamic>,
        );
      });

  @override
  Future<Result<List<ReportSchedule>>> schedules() => Result.guard(() async {
    final response = await _client.dio.get<dynamic>('/v1/reports/schedules');
    return (ApiEnvelope.data(response)! as List)
        .cast<Map<String, dynamic>>()
        .map(ReportSchedule.fromJson)
        .toList(growable: false);
  });

  @override
  Future<Result<ReportSchedule>> createSchedule({
    required String reportId,
    required ScheduleFrequency frequency,
    required String format,
    String? campusId,
  }) => Result.guard(() async {
    final response = await _client.dio.post<dynamic>(
      '/v1/reports/schedules',
      data: {
        'reportId': reportId,
        'frequency': frequency.name,
        'format': format,
        'campusId': ?campusId,
      },
    );
    return ReportSchedule.fromJson(
      ApiEnvelope.data(response)! as Map<String, dynamic>,
    );
  });

  @override
  Future<Result<ReportSchedule>> setScheduleActive(String id, bool active) =>
      Result.guard(() async {
        final response = await _client.dio.patch<dynamic>(
          '/v1/reports/schedules/$id',
          data: {'active': active},
        );
        return ReportSchedule.fromJson(
          ApiEnvelope.data(response)! as Map<String, dynamic>,
        );
      });

  @override
  Future<Result<void>> deleteSchedule(String id) => Result.guard(() async {
    await _client.dio.delete<dynamic>('/v1/reports/schedules/$id');
  });
}
