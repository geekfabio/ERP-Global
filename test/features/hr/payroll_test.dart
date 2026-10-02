import 'dart:typed_data';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/pdf/pdf_file_saver.dart';
import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/hr/data/mock_api/hr_mock_handlers.dart';
import 'package:erp_global/features/hr/data/mock_api/payroll_mock_handlers.dart';
import 'package:erp_global/features/hr/data/models/hr_models.dart';
import 'package:erp_global/features/hr/data/models/payroll_models.dart';
import 'package:erp_global/features/hr/data/repositories/api_hr_repositories.dart';
import 'package:erp_global/features/hr/data/repositories/api_payroll_repositories.dart';
import 'package:erp_global/features/hr/domain/payroll_rules.dart';
import 'package:erp_global/features/hr/presentation/pages/hr_page.dart';
import 'package:erp_global/features/hr/presentation/pdf/payslip_pdf_template.dart';
import 'package:erp_global/features/hr/presentation/providers/hr_providers.dart';
import 'package:erp_global/features/hr/presentation/providers/payroll_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client() {
  final hr = HrMockHandlers();
  return ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(hr)
      ..addModule(
        PayrollMockHandlers(
          employeesOf: () => hr.employeesSnapshot,
          contractsOf: () => hr.contractsSnapshot,
        ),
      ),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
}

void expectCode(Result<Object?> r, String code) =>
    expect(r.failureOrNull?.code, code);

class _MemorySaver implements PdfFileSaver {
  String? name;
  int bytes = 0;

  @override
  Future<bool> save({
    required String fileName,
    required Uint8List bytes,
  }) async {
    name = fileName;
    this.bytes = bytes.length;
    return true;
  }
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  test('regras: dias úteis, IRT por escalão e recibo', () {
    expect(
      countWorkdays(DateTime.utc(2026, 8, 3), DateTime.utc(2026, 8, 14)),
      10,
    );
    expect(monthEnd('2026-02'), DateTime.utc(2026, 2, 28));
    expect(monthStart('2026-13'), isNull);
    const b = defaultIrtBrackets;
    expect(computeIrt(5000000, b), 0);
    // 120.000 Kz: 13% do excesso sobre 100.000 = 2.600 Kz
    expect(computeIrt(12000000, b), 260000);
    // 170.000 Kz: 6.500 + 16% de 20.000 = 9.700 Kz
    expect(computeIrt(17000000, b), 970000);

    const settings = PayrollSettings();
    final p = computePayslip(
      id: 'x',
      employeeId: 'e',
      month: '2026-09',
      baseSalary: 22000000,
      absenceDays: 2,
      settings: settings,
    );
    expect(p.absenceDeduction, 2000000);
    expect(p.grossPay, 20000000);
    expect(p.inssEmployee, 600000);
    expect(p.inssEmployer, 1600000);
    expect(p.netPay, p.grossPay - p.inssEmployee - p.irt);
  });

  test('assiduidade: valida e rejeita duplicado no mesmo dia', () async {
    final client = _client();
    final employee = (await apiEmployeeRepository(
      client,
    ).list()).getOrThrow().items.last;
    final repo = apiAttendanceRepository(client);
    final draft = AttendanceRecord(
      id: '',
      employeeId: employee.id,
      date: '2026-09-21',
      status: AttendanceStatus.absent,
    );
    final created = (await repo.create(draft)).getOrThrow();
    expectCode(await repo.create(draft), 'CONFLICT');
    expectCode(
      await repo.create(draft.copyWith(date: '2026-02-30')),
      'VALIDATION_ERROR',
    );
    expectCode(
      await repo.create(draft.copyWith(employeeId: 'x')),
      'VALIDATION_ERROR',
    );
    expect((await repo.delete(created.id)).isOk, isTrue);
  });

  test('férias: dias úteis, sobreposição e saldo anual', () async {
    final client = _client();
    final employee = (await apiEmployeeRepository(
      client,
    ).list()).getOrThrow().items.last;
    final repo = apiLeaveRepository(client);
    final first = (await repo.create(
      LeaveModel(
        id: '',
        employeeId: employee.id,
        startDate: '2026-03-02',
        endDate: '2026-03-13',
      ),
    )).getOrThrow();
    expect(first.days, 10);
    expectCode(
      await repo.create(
        LeaveModel(
          id: '',
          employeeId: employee.id,
          startDate: '2026-03-10',
          endDate: '2026-03-20',
        ),
      ),
      'CONFLICT',
    );
    // 10 gozados; o saldo é 22, logo mais 13 dias úteis ultrapassam-no.
    expectCode(
      await repo.create(
        LeaveModel(
          id: '',
          employeeId: employee.id,
          startDate: '2026-05-04',
          endDate: '2026-05-22',
        ),
      ),
      'CONFLICT',
    );
    expectCode(
      await repo.create(
        LeaveModel(
          id: '',
          employeeId: employee.id,
          startDate: '2026-05-10',
          endDate: '2026-05-09',
        ),
      ),
      'VALIDATION_ERROR',
    );
  });

  test('folha: processa o mês com descontos e respeita as regras', () async {
    final client = _client();
    final payroll = ApiPayrollRepository(client);
    final slips = apiPayslipRepository(client);

    expectCode(await payroll.run('2026-9'), 'VALIDATION_ERROR');
    final run = (await payroll.run('2026-09')).getOrThrow();
    expect(run.count, greaterThan(40));
    final page = (await slips.list(
      pageSize: 100,
      filters: {'month': '2026-09'},
    )).getOrThrow().items;
    expect(page.length, run.count);
    expect(
      page.any((p) => p.absenceDays > 0 && p.absenceDeduction > 0),
      isTrue,
    );
    expect(page.every((p) => p.netPay < p.grossPay && p.irt >= 0), isTrue);
    expect(page.fold<int>(0, (a, p) => a + p.netPay), run.totalNet);

    // Reprocessar não duplica; alterar o INSS altera o líquido.
    final before = page.first;
    final settings = (await payroll.settings()).getOrThrow();
    (await payroll.updateSettings(
      settings.copyWith(inssEmployeeBp: 1000),
    )).getOrThrow();
    final again = (await payroll.run('2026-09')).getOrThrow();
    expect(again.count, run.count);
    expect(again.totalNet, lessThan(run.totalNet));
    final after = (await slips.list(
      pageSize: 100,
      filters: {'employeeId': before.employeeId, 'month': '2026-09'},
    )).getOrThrow().items.single;
    expect(after.inssEmployee, applyBp(after.grossPay, 1000));

    expectCode(
      await payroll.updateSettings(settings.copyWith(inssEmployeeBp: 20000)),
      'VALIDATION_ERROR',
    );
    expectCode(
      await payroll.updateSettings(
        settings.copyWith(
          irtBrackets: const [IrtBracket(from: 100, rateBp: 0)],
        ),
      ),
      'VALIDATION_ERROR',
    );
  });

  test('recibo de vencimento gera PDF', () async {
    const payslip = Payslip(
      id: 'p',
      employeeId: 'e',
      month: '2026-09',
      baseSalary: 22000000,
      absenceDays: 1,
      absenceDeduction: 1000000,
      grossPay: 21000000,
      inssEmployee: 630000,
      inssEmployer: 1680000,
      irt: 2000000,
      netPay: 18370000,
    );
    const employee = EmployeeModel(
      id: 'e',
      employeeNumber: 'F0001',
      fullName: 'Ana Silva',
      email: 'ana@escola.local',
      positionId: 'p',
      hireDate: '2020-01-01',
    );
    const template = PayslipPdfTemplate(
      payslip: payslip,
      employee: employee,
      positionName: 'Professor',
    );
    expect(monthLabel('2026-09'), 'Setembro de 2026');
    expect(template.fileName, 'recibo-vencimento-F0001-2026-09');
    final bytes = await const PdfTemplateEngine().render(
      letterhead: const PdfLetterhead(institutionName: 'Escola'),
      template: template,
      generatedAt: DateTime.utc(2026, 10, 1),
    );
    expect(String.fromCharCodes(bytes.take(4)), '%PDF');
  });

  testWidgets('folha na página RH: processa e exporta o recibo', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2600, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final saver = _MemorySaver();
    final container = ProviderContainer(
      overrides: [
        sessionPermissionsProvider.overrideWithValue(['hr.*']),
        mockApiModulesProvider.overrideWith(
          (ref) => [
            ref.watch(hrMockHandlersProvider),
            ref.watch(payrollMockHandlersProvider),
          ],
        ),
        payrollPdfSaverProvider.overrideWithValue(saver),
        apiClientProvider.overrideWith(
          (ref) => ApiClient.create(
            baseUrl: 'https://api.test',
            useMockApi: true,
            registry: ref.watch(mockApiRegistryProvider),
            mockConfig: const MockApiConfig.instant(),
            logging: false,
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          theme: AppTheme.light(),
          scaffoldMessengerKey: rootMessengerKey,
          builder: (context, child) => ToastHost(child: child!),
          home: const Scaffold(body: HrPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Folha salarial'));
    await tester.pumpAndSettle();
    expect(find.text('Folha ainda não processada neste mês'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('payroll_month')), '2026-09');
    await tester.tap(find.byKey(const Key('payroll_run')));
    await tester.pumpAndSettle();
    expect(find.text('Líquido'), findsWidgets);
    expect(find.text('Folha ainda não processada neste mês'), findsNothing);

    await tester.ensureVisible(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Recibo PDF'));
    await tester.pumpAndSettle();
    expect(saver.name, startsWith('recibo-vencimento-F'));
    expect(saver.bytes, greaterThan(500));
  });
}
