import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/assignment_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/teacher_mock_handlers.dart';
import 'package:erp_global/features/hr/data/mock_api/hr_mock_handlers.dart';
import 'package:erp_global/features/hr/data/models/hr_models.dart';
import 'package:erp_global/features/hr/data/repositories/api_hr_repositories.dart';
import 'package:erp_global/features/hr/domain/hr_rules.dart';
import 'package:erp_global/features/hr/presentation/pages/hr_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()..addModule(HrMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void expectCode(Result<Object?> r, String code) =>
    expect(r.failureOrNull?.code, code);

void main() {
  setUpAll(PtAoFormatters.initialize);

  test('regras: vigência e sobreposição de contratos', () {
    const open = ContractModel(
      id: 'a',
      employeeId: 'e',
      startDate: '2025-01-01',
      baseSalary: 1,
    );
    const ended = ContractModel(
      id: 'b',
      employeeId: 'e',
      type: ContractType.fixedTerm,
      startDate: '2024-01-01',
      endDate: '2024-12-31',
      baseSalary: 1,
    );
    expect(isContractActiveOn(open, DateTime.utc(2026, 5, 1)), isTrue);
    expect(isContractActiveOn(open, DateTime.utc(2024, 5, 1)), isFalse);
    expect(isContractActiveOn(ended, DateTime.utc(2024, 12, 31)), isTrue);
    expect(isContractActiveOn(ended, DateTime.utc(2025, 1, 1)), isFalse);
    expect(contractsOverlap(open, ended), isFalse);
    expect(contractsOverlap(open, open.copyWith(id: 'c')), isTrue);
    expect(parseIsoDate('2025-02-30'), isNull);
  });

  test('seed: docentes sem contrato são sinalizados', () async {
    final repo = apiEmployeeRepository(_client());
    final all = (await repo.list(pageSize: 100)).getOrThrow().items;
    expect(all.length, 80);
    final flagged = all.where(isTeacherWithoutContract).toList();
    expect(flagged, isNotEmpty);
    expect(flagged.every((e) => e.teacherId != null), isTrue);
    final filtered = (await repo.list(
      pageSize: 100,
      filters: {'hasActiveContract': 'false'},
    )).getOrThrow().items;
    expect(filtered.every((e) => !e.hasActiveContract), isTrue);
  });

  test(
    'criar contrato torna o docente conforme; valida e evita sobreposição',
    () async {
      final client = _client();
      final employees = apiEmployeeRepository(client);
      final contracts = apiContractRepository(client);
      final all = (await employees.list(pageSize: 100)).getOrThrow().items;
      final teacher = all.firstWhere(isTeacherWithoutContract);
      final draft = ContractModel(
        id: '',
        employeeId: teacher.id,
        startDate: '2026-01-01',
        baseSalary: 30000000,
      );

      expectCode(
        await contracts.create(draft.copyWith(baseSalary: 0)),
        'VALIDATION_ERROR',
      );
      expectCode(
        await contracts.create(draft.copyWith(type: ContractType.fixedTerm)),
        'VALIDATION_ERROR',
      );
      expectCode(
        await contracts.create(draft.copyWith(startDate: 'ontem')),
        'VALIDATION_ERROR',
      );
      final ok = (await contracts.create(draft)).getOrThrow();
      expectCode(await contracts.create(draft), 'CONFLICT');

      final after = (await employees.list(
        pageSize: 100,
        filters: {'teacherId': teacher.teacherId!},
      )).getOrThrow().items.single;
      expect(after.hasActiveContract, isTrue);
      expectCode(await employees.delete(teacher.id), 'CONFLICT');
      expect((await contracts.delete(ok.id)).isOk, isTrue);
    },
  );

  test(
    'funcionários: email único, número sequencial e cargos em uso',
    () async {
      final client = _client();
      final employees = apiEmployeeRepository(client);
      final positions = apiPositionRepository(client);
      final base = (await employees.list()).getOrThrow().items.first;
      final draft = base.copyWith(
        id: '',
        email: 'novo.func@escola.local',
        teacherId: null,
      );
      expectCode(
        await employees.create(draft.copyWith(email: base.email)),
        'CONFLICT',
      );
      expectCode(
        await employees.create(draft.copyWith(hireDate: '2020-13-01')),
        'VALIDATION_ERROR',
      );
      expectCode(
        await employees.create(draft.copyWith(positionId: 'x')),
        'VALIDATION_ERROR',
      );
      final created = (await employees.create(draft)).getOrThrow();
      expect(created.employeeNumber, 'F0081');
      expect((await employees.delete(created.id)).isOk, isTrue);

      expectCode(await positions.delete(base.positionId), 'CONFLICT');
      final p = (await positions.create(
        const PositionModel(id: '', name: 'Jardineiro'),
      )).getOrThrow();
      expectCode(
        await positions.create(const PositionModel(id: '', name: 'jardineiro')),
        'CONFLICT',
      );
      expect((await positions.delete(p.id)).isOk, isTrue);
    },
  );

  testWidgets('página RH: aviso de docentes sem contrato e ficha', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(2600, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        sessionPermissionsProvider.overrideWithValue(['hr.*', 'academic.*']),
        mockApiModulesProvider.overrideWith(
          (ref) => [
            HrMockHandlers(),
            TeacherMockHandlers(),
            AcademicStructureMockHandlers(),
            AssignmentMockHandlers(),
          ],
        ),
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
    expect(
      find.byKey(const Key('teachers_without_contract_banner')),
      findsOneWidget,
    );
    expect(find.text('Docente sem contrato'), findsWidgets);

    await tester.ensureVisible(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Acções').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ficha'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('employee_sheet')), findsOneWidget);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Novo funcionário'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);
  });
}
