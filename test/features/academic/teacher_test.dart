import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/teacher_mock_handlers.dart';
import 'package:erp_global/features/academic/data/repositories/api_academic_repositories.dart';
import 'package:erp_global/features/academic/presentation/pages/academic_page.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(TeacherMockHandlers())
    ..addModule(AcademicStructureMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void expectCode(Result<Object?> r, String code) =>
    expect(r.failureOrNull?.code, code);

void main() {
  setUpAll(PtAoFormatters.initialize);

  test('seed: ~60 professores com disciplinas e turmas', () async {
    final repo = apiTeacherRepository(_client());
    final page = (await repo.list(pageSize: 100)).getOrThrow();
    expect(page.items.length, 60);
    expect(page.items.every((t) => t.subjectIds.isNotEmpty), isTrue);
    expect(page.items.any((t) => t.classroomIds.isNotEmpty), isTrue);
    final found = (await repo.list(q: page.items.first.fullName)).getOrThrow();
    expect(found.items.map((t) => t.id), contains(page.items.first.id));
  });

  test('criar valida campos, disciplinas e email único', () async {
    final repo = apiTeacherRepository(_client());
    final base = (await repo.list()).getOrThrow().items.first;
    final draft = base.copyWith(
      id: '',
      email: 'novo.prof@escola.local',
      classroomIds: const [],
    );

    expectCode(
      await repo.create(draft.copyWith(fullName: '')),
      'VALIDATION_ERROR',
    );
    expectCode(
      await repo.create(draft.copyWith(subjectIds: const [])),
      'VALIDATION_ERROR',
    );
    expectCode(
      await repo.create(draft.copyWith(email: base.email)),
      'CONFLICT',
    );

    final ok = (await repo.create(draft)).getOrThrow();
    expect(ok.employeeNumber, 'F0061');
    expect(ok.id, isNotEmpty);
  });

  test('actualizar e eliminar respeitam turmas atribuídas', () async {
    final repo = apiTeacherRepository(_client());
    final all = (await repo.list(pageSize: 100)).getOrThrow().items;
    final withClasses = all.firstWhere((t) => t.classroomIds.isNotEmpty);
    final updated = (await repo.update(
      withClasses.id,
      withClasses.copyWith(specialty: 'Mestrado'),
    )).getOrThrow();
    expect(updated.specialty, 'Mestrado');
    expect(updated.employeeNumber, withClasses.employeeNumber);

    expectCode(await repo.delete(withClasses.id), 'CONFLICT');
    final free = withClasses.copyWith(classroomIds: const []);
    expect((await repo.update(withClasses.id, free)).isOk, isTrue);
    expect((await repo.delete(withClasses.id)).isOk, isTrue);
  });

  testWidgets('separador Professores: lista, ficha e criação', (tester) async {
    tester.view.physicalSize = const Size(2600, 1800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        sessionPermissionsProvider.overrideWithValue(['academic.*']),
        mockApiModulesProvider.overrideWith(
          (ref) => [
            AcademicStructureMockHandlers(),
            AcademicMockHandlers(),
            TeacherMockHandlers(),
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
          home: const Scaffold(body: AcademicPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Professores'));
    await tester.pumpAndSettle();
    expect(find.text('Disciplinas'), findsWidgets);
    expect(find.text('Ficha'), findsNothing);

    await tester.tap(find.text('Novo professor'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    expect(find.text('Campo obrigatório'), findsWidgets);
  });
}
