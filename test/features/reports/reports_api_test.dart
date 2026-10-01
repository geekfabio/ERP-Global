import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/data/models/dashboard_metric.dart';
import 'package:erp_global/features/reports/data/repositories/api_reports_repository.dart';
import 'package:flutter_test/flutter_test.dart';

ApiReportsRepository _repo({Set<String>? licensed}) {
  final registry = MockApiRegistry()
    ..addModule(
      ReportsMockHandlers(
        enabledModules: () => licensed ?? {'billing', 'students'},
      ),
    );
  return ApiReportsRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

DashboardQuery _q({String? compareYear, String? campus}) => DashboardQuery(
  profile: 'financeiro',
  widgetIds: const ['billing.revenue', 'billing.debt'],
  yearId: 'y26',
  termId: 't1',
  campusId: campus,
  compareYearId: compareYear,
  compareTermId: compareYear == null ? null : 't1',
);

void main() {
  test('valores determinísticos, sem comparação por omissão', () async {
    final a = (await _repo().dashboard(_q())).getOrThrow();
    final b = (await _repo().dashboard(_q())).getOrThrow();
    expect(a, hasLength(2));
    expect(a, b);
    expect(a.every((m) => m.previous == null), isTrue);
  });

  test(
    'comparação devolve o valor do outro período; campus altera-o',
    () async {
      final r = _repo();
      final cmp = (await r.dashboard(_q(compareYear: 'y25'))).getOrThrow();
      expect(cmp.every((m) => m.previous != null), isTrue);
      final base = (await r.dashboard(_q())).getOrThrow();
      final other = (await r.dashboard(_q(campus: 'c2'))).getOrThrow();
      expect(other, isNot(base));
    },
  );

  test('módulo não licenciado → 403; ano em falta → 422', () async {
    final denied = await _repo(licensed: {'students'}).dashboard(_q());
    expect(denied.failureOrNull, isA<LicenseFailure>());
    final bad = await _repo().dashboard(
      const DashboardQuery(profile: 'direcao', widgetIds: [], yearId: ''),
    );
    expect(bad.failureOrNull, isA<ValidationFailure>());
  });
}
