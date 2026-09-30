import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/core/widgets/forms/stepper_form.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:erp_global/features/students/presentation/pages/student_wizard_page.dart';
import 'package:erp_global/features/students/presentation/providers/student_providers.dart';
import 'package:erp_global/features/students/presentation/providers/student_wizard_providers.dart';
import 'package:erp_global/features/students/presentation/widgets/student_wizard/student_wizard_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

final _existing = buildStudentsSeed(seed: 42, count: 20).students.first;

Map<String, Object?> _draft({
  String? name,
  String? birth,
  String? bi,
  bool withExtras = true,
}) => {
  WizardKeys.fullName: name ?? 'Kiala Domingos Pedro',
  WizardKeys.birthDate: birth ?? '2013-04-05',
  WizardKeys.gender: 'male',
  WizardKeys.nationality: 'Angolana',
  WizardKeys.idNumber: ?bi,
  if (withExtras) ...{
    WizardKeys.guardians: [
      const WizardGuardian(
        fullName: 'Rosa Pedro',
        phone: '923456789',
        relationship: GuardianRelationship.mother,
      ).toMap(),
    ],
    WizardKeys.documents: ['idCard'],
  },
};

class _Env {
  _Env(Map<String, Object?>? draft) : store = InMemoryDraftStore() {
    if (draft != null) store.save(draft);
  }

  final InMemoryDraftStore store;

  List<Override> get overrides => [
    studentWizardDraftStoreProvider.overrideWithValue(store),
    mockApiModulesProvider.overrideWith(
      (ref) => [StudentsMockHandlers(count: 20)],
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
  ];
}

Future<ProviderContainer> _pump(
  WidgetTester tester,
  _Env env, {
  List<String> permissions = const ['students.*'],
}) async {
  tester.view.physicalSize = const Size(2600, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(
    overrides: [
      ...env.overrides,
      sessionPermissionsProvider.overrideWithValue(permissions),
    ],
  );
  addTearDown(container.dispose);
  final router = GoRouter(
    initialLocation: '/students/new',
    routes: [
      GoRoute(
        path: '/students/new',
        builder: (_, _) => const Scaffold(body: StudentWizardPage()),
      ),
      GoRoute(
        path: '/students',
        builder: (_, _) => const Scaffold(body: Text('lista')),
      ),
      GoRoute(
        path: '/students/:id',
        builder: (_, s) =>
            Scaffold(body: Text('ficha ${s.pathParameters['id']}')),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        routerConfig: router,
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

/// Avança até ao resumo (4 passos) e carrega em "Registar aluno".
Future<void> _submit(WidgetTester tester) async {
  for (var i = 0; i < 4; i++) {
    await tester.tap(find.text('Seguinte'));
    await tester.pumpAndSettle();
  }
  await tester.tap(find.text('Registar aluno').last);
  await tester.pumpAndSettle();
}

/// Chamadas ao repository fora do `pump`: o mock usa temporizadores reais.
Future<int> _total(WidgetTester tester, ProviderContainer c) async =>
    (await tester.runAsync(
      () => c
          .read(studentRepositoryProvider)
          .list(const StudentQuery(pageSize: 100)),
    ))!.getOrThrow().meta.total;

void main() {
  setUpAll(PtAoFormatters.initialize);

  testWidgets('regista o aluno com encarregado e documento e abre a ficha', (
    tester,
  ) async {
    final env = _Env(_draft());
    final container = await _pump(tester, env);
    expect(find.text('Rascunho restaurado.'), findsOneWidget);
    expect(find.text('Kiala Domingos Pedro'), findsOneWidget);

    await _submit(tester);

    expect(find.textContaining('ficha '), findsOneWidget);
    expect(await _total(tester, container), 21);
    final (created, guardians) = (await tester.runAsync(() async {
      final c =
          (await container
                  .read(studentRepositoryProvider)
                  .list(const StudentQuery(q: 'Kiala Domingos Pedro')))
              .getOrThrow()
              .items
              .single;
      final g =
          (await container.read(guardianRepositoryProvider).forStudent(c.id))
              .getOrThrow();
      return (c, g);
    }))!;
    expect(created.fullName, 'Kiala Domingos Pedro');
    expect(guardians.single.guardian.fullName, 'Rosa Pedro');
    // Rascunho limpo depois de gravar.
    expect(await env.store.load(), isNull);
  });

  testWidgets('nome + nascimento repetidos: alerta; cancelar não grava', (
    tester,
  ) async {
    final env = _Env(
      _draft(
        name: _existing.fullName,
        birth: formatWizardDate(_existing.birthDate),
        withExtras: false,
      ),
    );
    final container = await _pump(tester, env);
    await _submit(tester);

    expect(find.text('Possível duplicado'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ficha '), findsNothing);
    expect(await _total(tester, container), 20);
    // O rascunho mantém-se para corrigir.
    expect(await env.store.load(), isNotNull);

    // Confirmar grava mesmo assim.
    await tester.tap(find.text('Registar aluno').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Registar mesmo assim'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ficha '), findsOneWidget);
    expect(await _total(tester, container), 21);
  });

  testWidgets('BI repetido: bloqueia e não grava', (tester) async {
    final env = _Env(
      _draft(
        name: 'Outro Nome Completo',
        bi: _existing.idNumber,
        withExtras: false,
      ),
    );
    final container = await _pump(tester, env);
    await _submit(tester);

    expect(find.text('Aluno já registado'), findsOneWidget);
    expect(find.text('Registar mesmo assim'), findsNothing);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();
    expect(await _total(tester, container), 20);
    expect(find.textContaining('ficha '), findsNothing);
  });

  testWidgets('descartar rascunho limpa os campos e o armazenamento', (
    tester,
  ) async {
    final env = _Env(_draft(withExtras: false));
    await _pump(tester, env);
    await tester.tap(find.text('Descartar rascunho'));
    await tester.pumpAndSettle();
    expect(find.text('Rascunho restaurado.'), findsNothing);
    expect(find.text('Kiala Domingos Pedro'), findsNothing);
    expect(await env.store.load(), isNull);
  });

  testWidgets('escrever num campo guarda o rascunho', (tester) async {
    final env = _Env(null);
    await _pump(tester, env);
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nome completo'),
      'Ana Maria',
    );
    expect((await env.store.load())?[WizardKeys.fullName], 'Ana Maria');
  });

  testWidgets('sem permissão de criar, não mostra o formulário', (
    tester,
  ) async {
    await _pump(
      tester,
      _Env(null),
      permissions: const ['students.record.read'],
    );
    expect(find.text('Sem permissão'), findsOneWidget);
    expect(find.text('Novo aluno'), findsNothing);
  });
}
