import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/export/export_contract.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/api_envelope.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:erp_global/features/students/domain/student_duplicates.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:erp_global/features/students/presentation/pages/students_list_page.dart';
import 'package:erp_global/features/students/presentation/providers/student_list_providers.dart';
import 'package:erp_global/features/students/presentation/providers/student_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

List<Override> _overrides({
  List<String> permissions = const ['students.*'],
  int count = 60,
  StudentRepository? repo,
}) => [
  sessionPermissionsProvider.overrideWithValue(permissions),
  mockApiModulesProvider.overrideWith(
    (ref) => [StudentsMockHandlers(count: count)],
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
  if (repo != null) studentRepositoryProvider.overrideWithValue(repo),
];

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Override>? overrides,
  // Larga: a fonte de teste (Ahem) ocupa muito mais do que a real.
  Size size = const Size(2600, 1200),
  ExportHandler? exportHandler,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      ...(overrides ?? _overrides()),
      if (exportHandler != null) ...[
        exportHandlerProvider.overrideWithValue(exportHandler),
        licenseGateProvider.overrideWithValue(
          const LicenseGate(enabledModules: {'import_export'}),
        ),
      ],
    ],
  );
  addTearDown(container.dispose);
  final router = GoRouter(
    initialLocation: '/students',
    routes: [
      GoRoute(
        path: '/students',
        builder: (_, _) => Scaffold(body: StudentsListPage()),
        routes: [
          GoRoute(path: 'new', builder: (_, _) => const Text('NOVO')),
          GoRoute(
            path: ':id',
            builder: (_, s) => Text('FICHA ${s.pathParameters['id']}'),
          ),
        ],
      ),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Future<void> _select(WidgetTester tester, String key, String option) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

StudentQuery _q(ProviderContainer c) => c.read(studentListQueryProvider);

class _FlakyRepo implements StudentRepository {
  int calls = 0;

  @override
  Future<Result<PagedList<StudentModel>>> list(StudentQuery query) async {
    calls++;
    return calls == 1
        ? Err(NetworkFailure())
        : Ok(
            PagedList(
              items: const [],
              meta: const PageMeta(page: 1, pageSize: 20, total: 0),
            ),
          );
  }

  @override
  Future<Result<StudentModel>> get(String id) => throw UnimplementedError();
  @override
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  }) => throw UnimplementedError();
  @override
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) => throw UnimplementedError();
  @override
  Future<Result<StudentModel>> update(StudentModel student) =>
      throw UnimplementedError();
  @override
  Future<Result<void>> delete(String id) => throw UnimplementedError();
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('StudentListQueryNotifier', () {
    test('filtros combináveis e voltam à página 1', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(studentListQueryProvider.notifier);
      n.setPage(4);
      expect(_q(c).page, 4);
      n.setStatus(StudentStatus.active);
      n.setGender(Gender.female);
      n.setSearch('  ana ');
      n.setGrade(MockRef.gradeId(3));
      expect(_q(c).page, 1);
      expect(_q(c).status, StudentStatus.active);
      expect(_q(c).gender, Gender.female);
      expect(_q(c).q, 'ana');
      expect(_q(c).gradeId, MockRef.gradeId(3));
      expect(n.hasFilters, isTrue);
    });

    test('mudar de classe limpa a turma; filtro vazio limpa a pesquisa', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(studentListQueryProvider.notifier);
      n.setGrade(MockRef.gradeId(2));
      n.setClassroom(MockRef.classroomId(2, 1));
      expect(_q(c).classroomId, MockRef.classroomId(2, 1));
      n.setGrade(MockRef.gradeId(3));
      expect(_q(c).classroomId, isNull);
      n.setSearch('x');
      n.setSearch('   ');
      expect(_q(c).q, isNull);
    });

    test('ordenação alterna asc/desc e limpar filtros mantém a ordenação', () {
      final c = ProviderContainer();
      addTearDown(c.dispose);
      final n = c.read(studentListQueryProvider.notifier);
      n.toggleSort('processNumber');
      expect(_q(c).sort, ['processNumber']);
      n.toggleSort('processNumber');
      expect(_q(c).sort, ['-processNumber']);
      n.toggleSort('fullName');
      expect(_q(c).sort, ['fullName']);
      n.setStatus(StudentStatus.inactive);
      n.clearFilters();
      expect(n.hasFilters, isFalse);
      expect(_q(c).sort, ['fullName']);
    });
  });

  group('página', () {
    testWidgets('mostra a primeira página, estados e total', (tester) async {
      await _pump(tester);
      expect(find.text('Alunos'), findsOneWidget);
      expect(find.text('60 alunos'), findsOneWidget);
      expect(find.text('1 / 3'), findsOneWidget);
      expect(find.text('Processo'), findsOneWidget);
      expect(find.textContaining('2026/'), findsWidgets);
    });

    testWidgets('mostra esqueleto enquanto carrega', (tester) async {
      tester.view.physicalSize = const Size(1280, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(overrides: _overrides());
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            home: const Scaffold(body: StudentsListPage()),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Título do registo'), findsWidgets); // skeleton
      await tester.pumpAndSettle();
      expect(find.text('60 alunos'), findsOneWidget);
    });

    testWidgets('pesquisa com debounce filtra no servidor', (tester) async {
      final c = await _pump(tester);
      final first = (await c.read(studentListProvider.future)).items.first;
      await tester.enterText(
        find.byKey(const Key('students_search')),
        first.processNumber,
      );
      // Ainda não aplicou (debounce de 300 ms).
      expect(_q(c).q, isNull);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(_q(c).q, first.processNumber);
      expect(find.text('1 alunos'), findsOneWidget);
      expect(find.text(first.fullName), findsOneWidget);
    });

    testWidgets('filtros combináveis: estado + género + limpar', (
      tester,
    ) async {
      final c = await _pump(tester, overrides: _overrides(count: 200));
      await _select(tester, 'filter_status', 'Inactivo');
      expect(_q(c).status, StudentStatus.inactive);
      final onlyInactive = (await c.read(
        studentListProvider.future,
      )).meta.total;
      expect(onlyInactive, greaterThan(0));

      await _select(tester, 'filter_gender', 'Feminino');
      expect(_q(c).gender, Gender.female);
      final both = (await c.read(studentListProvider.future)).meta.total;
      expect(both, lessThanOrEqualTo(onlyInactive));

      await tester.tap(find.text('Limpar filtros'));
      await tester.pumpAndSettle();
      expect(_q(c).status, isNull);
      expect(_q(c).gender, isNull);
      expect(find.text('Limpar filtros'), findsNothing);
    });

    testWidgets('turma só depois de escolher a classe', (tester) async {
      final c = await _pump(tester, overrides: _overrides(count: 200));
      final turma = tester.widget<DropdownButtonFormField<String?>>(
        find.byKey(const Key('filter_classroom')),
      );
      expect(turma.onChanged, isNull);

      await _select(tester, 'filter_grade', '5.ª classe');
      expect(_q(c).gradeId, MockRef.gradeId(5));
      await _select(tester, 'filter_classroom', 'Turma B');
      expect(_q(c).classroomId, MockRef.classroomId(5, 1));

      await _select(tester, 'filter_grade', '6.ª classe');
      expect(_q(c).classroomId, isNull);
    });

    testWidgets('sem resultados: estado vazio com limpar filtros', (
      tester,
    ) async {
      final c = await _pump(tester);
      await tester.enterText(
        find.byKey(const Key('students_search')),
        'zzzzzz',
      );
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pumpAndSettle();
      expect(find.text('Nenhum aluno encontrado'), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, 'Limpar filtros'));
      await tester.pumpAndSettle();
      expect(_q(c).q, isNull);
      expect(find.text('60 alunos'), findsOneWidget);
    });

    testWidgets('ordenar ao tocar no cabeçalho e paginar', (tester) async {
      final c = await _pump(tester);
      await tester.tap(find.text('Nome'));
      await tester.pumpAndSettle();
      expect(_q(c).sort, ['-fullName']);
      await tester.tap(find.byTooltip('Página seguinte'));
      await tester.pumpAndSettle();
      expect(_q(c).page, 2);
      expect(find.text('2 / 3'), findsOneWidget);
      await tester.tap(find.byTooltip('Página anterior'));
      await tester.pumpAndSettle();
      expect(_q(c).page, 1);
    });

    testWidgets('abrir a ficha ao tocar na linha', (tester) async {
      final c = await _pump(tester);
      final first = (await c.read(studentListProvider.future)).items.first;
      await tester.tap(find.text(first.fullName));
      await tester.pumpAndSettle();
      expect(find.text('FICHA ${first.id}'), findsOneWidget);
    });

    testWidgets('em compact mostra cartões', (tester) async {
      await _pump(tester, size: const Size(400, 900));
      expect(find.byType(DataTable), findsNothing);
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('exportar entrega a página visível e as colunas permitidas', (
      tester,
    ) async {
      ExportDataset? got;
      ExportFormat? fmt;
      await _pump(
        tester,
        exportHandler: (d, f) async {
          got = d;
          fmt = f;
        },
        overrides: _overrides(permissions: ['students.*']),
      );
      await tester.tap(find.byTooltip('Exportar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('PDF'));
      await tester.pumpAndSettle();
      expect(fmt, ExportFormat.pdf);
      expect(got!.rows, hasLength(20));
      expect(got!.permission, 'students.record.export');
      expect(
        got!.columns.any((c) => c.permission == 'students.health.read'),
        isTrue,
      );
    });

    testWidgets('sem permissão export não há botão', (tester) async {
      await _pump(
        tester,
        exportHandler: (d, f) async {},
        overrides: _overrides(
          permissions: ['students.record.read', 'students.record.create'],
        ),
      );
      expect(find.byTooltip('Exportar'), findsNothing);
    });

    testWidgets('sem módulo/handler de exportação não há botão', (
      tester,
    ) async {
      await _pump(tester);
      expect(find.byTooltip('Exportar'), findsNothing);
    });

    testWidgets('erro mostra retry e recupera', (tester) async {
      final repo = _FlakyRepo();
      await _pump(tester, overrides: _overrides(repo: repo));
      expect(find.text('Tentar novamente'), findsOneWidget);
      await tester.tap(find.text('Tentar novamente'));
      await tester.pumpAndSettle();
      expect(repo.calls, 2);
      expect(find.text('Nenhum aluno encontrado'), findsOneWidget);
    });
  });

  group('permissões', () {
    testWidgets('novo aluno só com permissão de criar', (tester) async {
      await _pump(
        tester,
        overrides: _overrides(permissions: ['students.record.read']),
      );
      expect(find.text('Novo aluno'), findsNothing);
    });

    testWidgets('novo aluno navega para o cadastro', (tester) async {
      await _pump(
        tester,
        overrides: _overrides(permissions: ['students.record.create']),
      );
      await tester.tap(find.text('Novo aluno'));
      await tester.pumpAndSettle();
      expect(find.text('NOVO'), findsOneWidget);
    });

    testWidgets('remover só aparece com permissão de apagar', (tester) async {
      await _pump(
        tester,
        overrides: _overrides(permissions: ['students.record.read']),
      );
      await tester.tap(find.byTooltip('Acções').first);
      await tester.pumpAndSettle();
      expect(find.text('Ver ficha'), findsOneWidget);
      expect(find.text('Remover'), findsNothing);
    });

    testWidgets('remover pede confirmação, remove e actualiza a lista', (
      tester,
    ) async {
      final c = await _pump(
        tester,
        overrides: _overrides(permissions: ['students.*']),
      );
      final first = (await c.read(studentListProvider.future)).items.first;
      await tester.tap(find.byTooltip('Acções').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();
      expect(find.textContaining(first.fullName), findsWidgets);

      // Cancelar não remove.
      await tester.tap(find.text('Cancelar'));
      await tester.pumpAndSettle();
      expect(find.text('60 alunos'), findsOneWidget);

      await tester.tap(find.byTooltip('Acções').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Remover'));
      await tester.pumpAndSettle();
      expect(find.text('Aluno removido'), findsOneWidget);
      expect(find.text('59 alunos'), findsOneWidget);
      expect(find.text(first.fullName), findsNothing);
    });
  });
}
