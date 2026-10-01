import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/import_export/data/export/export_service.dart';
import 'package:erp_global/features/reports/data/mock_api/reports_mock_handlers.dart';
import 'package:erp_global/features/reports/data/models/report_models.dart';
import 'package:erp_global/features/reports/data/repositories/api_reports_repository.dart';
import 'package:erp_global/features/reports/domain/report_catalog.dart';
import 'package:erp_global/features/reports/presentation/pages/report_catalog_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client({Set<String>? licensed}) => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(
      ReportsMockHandlers(
        enabledModules: () => licensed ?? {'students', 'billing'},
        now: () => DateTime.utc(2026, 3, 10),
      ),
    ),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('catálogo', () {
    test('mostra só módulos licenciados com permissão de leitura', () {
      final all = PermissionService.fromCodes(['*']);
      expect(visibleReports(all, {'students', 'billing'}).map((r) => r.id), [
        'students.roster',
        'billing.debtors',
      ]);
      final secretary = PermissionService.fromCodes(['students.record.read']);
      expect(visibleReports(secretary, {'students', 'billing'}), hasLength(1));
      expect(visibleReports(secretary, {'billing'}), isEmpty);
    });

    test('concessão por campus exige campus no pedido', () {
      final scoped = PermissionService([
        const PermissionGrant(
          'students.record.read',
          PermissionScope(campusId: 'c1'),
        ),
      ]);
      final report = reportById('students.roster')!;
      expect(requiresCampus(scoped, report), isTrue);
      expect(canRunReport(scoped, report, null), isFalse);
      expect(canRunReport(scoped, report, 'c2'), isFalse);
      expect(canRunReport(scoped, report, 'c1'), isTrue);
    });

    test('exportação remove colunas sem permissão', () async {
      final report = reportById('students.roster')!;
      final dataset = ExportDataset(
        title: report.title,
        entity: 'report-${report.id}',
        permission: reportsExportPermission,
        columns: [
          for (final c in report.columns)
            ExportDatasetColumn(
              key: c.key,
              label: c.label,
              permission: c.permission,
            ),
        ],
        rows: const [
          ['1', 'Ana', '1.ª A', 'Campus', 'Asma'],
        ],
      );
      final service = ExportService(
        PermissionService.fromCodes([reportsExportPermission]),
      );
      final file = (await service.export(
        dataset,
        ExportFormat.csv,
      )).getOrThrow();
      expect(file.columnKeys, isNot(contains('health')));
      final denied = await ExportService(
        PermissionService.fromCodes(['students.record.read']),
      ).export(dataset, ExportFormat.csv);
      expect(denied.failureOrNull, isA<PermissionFailure>());
    });
  });

  group('API mock', () {
    test('executa relatório e filtra por campus', () async {
      final repo = ApiReportsRepository(_client());
      final all = (await repo.runReport('billing.debtors')).getOrThrow();
      expect(all.rows, hasLength(12));
      expect(all.columnKeys, ['student', 'campus', 'invoices', 'amount']);
      final other = (await repo.runReport(
        'billing.debtors',
        campusId: 'outro',
      )).getOrThrow();
      expect(other.rows, isEmpty);
    });

    test('módulo não licenciado e relatório desconhecido', () async {
      final repo = ApiReportsRepository(_client());
      expect(
        (await repo.runReport('library.loans')).failureOrNull,
        isA<LicenseFailure>(),
      );
      expect((await repo.runReport('x.y')).failureOrNull, isNotNull);
    });

    test('agendamentos: criar, pausar, remover e validar', () async {
      final repo = ApiReportsRepository(_client());
      final created = (await repo.createSchedule(
        reportId: 'students.roster',
        frequency: ScheduleFrequency.weekly,
        format: 'pdf',
      )).getOrThrow();
      expect(created.active, isTrue);
      expect(created.nextRunAt, DateTime.utc(2026, 3, 17));
      expect((await repo.schedules()).getOrThrow(), hasLength(1));
      final paused = (await repo.setScheduleActive(
        created.id,
        false,
      )).getOrThrow();
      expect(paused.active, isFalse);
      expect(
        (await repo.createSchedule(
          reportId: 'students.roster',
          frequency: ScheduleFrequency.daily,
          format: 'doc',
        )).failureOrNull,
        isA<ValidationFailure>(),
      );
      (await repo.deleteSchedule(created.id)).getOrThrow();
      expect((await repo.schedules()).getOrThrow(), isEmpty);
      expect((await repo.deleteSchedule(created.id)).failureOrNull, isNotNull);
    });
  });

  testWidgets('página lista relatórios, executa e agenda', (tester) async {
    tester.view.physicalSize = const Size(2000, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          licenseGateProvider.overrideWithValue(
            const LicenseGate(enabledModules: {'students', 'billing'}),
          ),
          permissionServiceProvider.overrideWithValue(
            PermissionService.fromCodes([
              reportsCatalogPermission,
              'students.record.read',
            ]),
          ),
          apiClientProvider.overrideWith((ref) => _client()),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: ReportCatalogPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Lista de alunos por turma'), findsOneWidget);
    expect(find.text('Devedores'), findsNothing);
    expect(find.text('Sem agendamentos'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('report_students.roster')));
    await tester.pumpAndSettle();
    expect(find.text('Aluno 001'), findsOneWidget);
    // Coluna restrita não aparece sem `students.health.read`.
    expect(find.text('Observações de saúde'), findsNothing);

    await tester.tap(find.text('Agendar'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Agendar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Semanal · PDF'), findsOneWidget);
    // Ligações para relatórios existentes, só de módulos licenciados.
    expect(find.byKey(const ValueKey('existing_billing')), findsOneWidget);
    expect(find.byKey(const ValueKey('existing_cafeteria')), findsNothing);
  });
}
