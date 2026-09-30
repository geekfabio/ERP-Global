import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/presentation/pages/student_file_page.dart';
import 'package:erp_global/features/students/presentation/providers/student_file_providers.dart';
import 'package:erp_global/features/students/presentation/widgets/student_file/student_file_tab.dart';
import 'package:erp_global/features/students/presentation/widgets/student_file/tabs/health_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

final _seed = buildStudentsSeed(seed: 42, count: 20);
final _student = _seed.students.first;

List<Override> _overrides({
  List<String> permissions = const ['students.*'],
  List<StudentFileTab>? tabs,
  Set<String> modules = const {'students'},
}) => [
  sessionPermissionsProvider.overrideWithValue(permissions),
  licenseGateProvider.overrideWithValue(LicenseGate(enabledModules: modules)),
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
  if (tabs != null) studentFileTabsProvider.overrideWithValue(tabs),
];

Future<ProviderContainer> _pump(
  WidgetTester tester, {
  List<Override>? overrides,
  String? initialTab,
}) async {
  tester.view.physicalSize = const Size(2600, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final container = ProviderContainer(overrides: overrides ?? _overrides());
  addTearDown(container.dispose);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: rootMessengerKey,
        builder: (context, child) => ToastHost(child: child!),
        home: Scaffold(
          body: StudentFilePage(studentId: _student.id, initialTab: initialTab),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return container;
}

Finder _field(String label) => find.widgetWithText(TextFormField, label);

void main() {
  setUpAll(PtAoFormatters.initialize);

  test('parseAllergies separa por vírgula/ponto e vírgula e ignora vazios', () {
    expect(parseAllergies(' Amendoim, pólen;; lactose ,'), [
      'Amendoim',
      'pólen',
      'lactose',
    ]);
    expect(parseAllergies(null), isEmpty);
  });

  testWidgets('cabeçalho com nome, processo e estado; 3 separadores', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text(_student.fullName), findsWidgets);
    expect(find.text('Processo n.º ${_student.processNumber}'), findsOneWidget);
    expect(find.text('Activo'), findsOneWidget);
    for (final id in ['identification', 'guardians', 'health']) {
      expect(find.byKey(Key('student_tab_$id')), findsOneWidget);
    }
    // Separador 1 em leitura.
    expect(find.text('Dados de identificação'), findsOneWidget);
  });

  testWidgets('initialTab abre o separador pedido', (tester) async {
    await _pump(tester, initialTab: 'health');
    expect(find.text('Ficha de saúde'), findsOneWidget);
  });

  testWidgets('editar identificação grava pela API e actualiza a ficha', (
    tester,
  ) async {
    final c = await _pump(tester);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Nome completo'), 'Maria da Silva Teste');
    await tester.enterText(_field('Local de nascimento'), 'Huambo');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Maria da Silva Teste'), findsWidgets);
    expect(find.text('Huambo'), findsOneWidget);
    expect(find.text('Guardar'), findsNothing); // voltou à leitura
    final saved = c.read(studentProvider(_student.id)).requireValue;
    expect(saved.fullName, 'Maria da Silva Teste');
    expect(saved.birthPlace, 'Huambo');
  });

  testWidgets('validação: nome curto não grava e mantém a edição', (
    tester,
  ) async {
    final c = await _pump(tester);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Nome completo'), 'Al');
    await tester.enterText(_field('E-mail'), 'invalido');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Indique o nome completo'), findsOneWidget);
    expect(find.text('E-mail inválido'), findsOneWidget);
    final stored = c.read(studentProvider(_student.id)).requireValue;
    expect(stored.fullName, _student.fullName);
  });

  testWidgets('Cancelar descarta alterações', (tester) async {
    await _pump(tester);
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Nome completo'), 'Outro Nome Qualquer');
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();
    expect(find.text('Outro Nome Qualquer'), findsNothing);
    expect(find.text('Editar'), findsOneWidget);
  });

  testWidgets('sem permissão de edição não há botão Editar', (tester) async {
    await _pump(
      tester,
      overrides: _overrides(permissions: ['students.record.read']),
    );
    expect(find.text('Dados de identificação'), findsOneWidget);
    expect(find.text('Editar'), findsNothing);
  });

  testWidgets('separador Saúde oculto sem students.health.read', (
    tester,
  ) async {
    await _pump(
      tester,
      overrides: _overrides(permissions: ['students.record.read']),
    );
    expect(find.byKey(const Key('student_tab_identification')), findsOne);
    expect(find.byKey(const Key('student_tab_health')), findsNothing);
  });

  testWidgets('editar saúde grava grupo sanguíneo e alergias', (tester) async {
    final c = await _pump(tester, initialTab: 'health');
    await tester.tap(find.text('Editar'));
    await tester.pumpAndSettle();
    await tester.enterText(_field('Alergias'), 'Amendoim, pólen');
    await tester.tap(find.byType(DropdownButtonFormField<BloodType?>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('O+').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('Amendoim, pólen'), findsOneWidget);
    expect(find.text('O+'), findsOneWidget);
    final saved = c.read(studentProvider(_student.id)).requireValue;
    expect(saved.health.allergies, ['Amendoim', 'pólen']);
    expect(saved.health.bloodType, BloodType.oPositive);
  });

  testWidgets('separador Encarregados lista vínculos e permite remover', (
    tester,
  ) async {
    final c = await _pump(tester, initialTab: 'guardians');
    final links = _seed.links.where((l) => l.studentId == _student.id).toList();
    expect(links, isNotEmpty);
    final names = {for (final g in _seed.guardians) g.id: g.fullName};
    expect(find.text(names[links.first.guardianId]!), findsOneWidget);

    await tester.tap(find.byTooltip('Remover encarregado').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Remover').last);
    await tester.pumpAndSettle();

    final remaining = c
        .read(studentGuardiansProvider(_student.id))
        .requireValue;
    expect(remaining.length, links.length - 1);
  });

  testWidgets('editar vínculo altera parentesco e responsabilidades', (
    tester,
  ) async {
    final c = await _pump(tester, initialTab: 'guardians');
    await tester.tap(find.byTooltip('Editar encarregado').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Autorizado a recolher'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Guardar').last);
    await tester.pumpAndSettle();

    final first = _seed.links.firstWhere((l) => l.studentId == _student.id);
    final items = c.read(studentGuardiansProvider(_student.id)).requireValue;
    final after = items.firstWhere((g) => g.link.id == first.id).link;
    expect(after.canPickup, !first.canPickup);
  });

  group('padrão de separador (#35/#36)', () {
    StudentFileTab extra({String? module, String permission = 'x.read'}) =>
        StudentFileTab(
          id: 'extra',
          label: 'Extra',
          icon: Icons.star_outline,
          readPermission: permission,
          module: module,
          builder: (_, s) => Text('EXTRA ${s.processNumber}'),
        );

    testWidgets('um separador novo aparece só com registo e permissão', (
      tester,
    ) async {
      await _pump(
        tester,
        overrides: _overrides(
          permissions: ['students.record.read', 'x.read'],
          tabs: [...defaultStudentFileTabs, extra()],
        ),
      );
      expect(find.byKey(const Key('student_tab_extra')), findsOneWidget);
      await tester.tap(find.byKey(const Key('student_tab_extra')));
      await tester.pumpAndSettle();
      expect(find.text('EXTRA ${_student.processNumber}'), findsOneWidget);
    });

    testWidgets('módulo não licenciado esconde o separador', (tester) async {
      await _pump(
        tester,
        overrides: _overrides(
          permissions: ['students.record.read', 'x.read'],
          tabs: [
            ...defaultStudentFileTabs,
            extra(module: 'grades'),
          ],
        ),
      );
      expect(find.byKey(const Key('student_tab_extra')), findsNothing);
    });

    testWidgets('módulo licenciado mostra o separador', (tester) async {
      await _pump(
        tester,
        overrides: _overrides(
          permissions: ['students.record.read', 'x.read'],
          tabs: [
            ...defaultStudentFileTabs,
            extra(module: 'grades'),
          ],
          modules: {'students', 'grades'},
        ),
      );
      expect(find.byKey(const Key('student_tab_extra')), findsOneWidget);
    });
  });
}
