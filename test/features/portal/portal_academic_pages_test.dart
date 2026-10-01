import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/academic/data/mock_api/schedule_mock_handlers.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_mock_handlers.dart';
import 'package:erp_global/features/portal/data/models/portal_academic_models.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_attendance_page.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_documents_page.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_grades_page.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_justification_page.dart';
import 'package:erp_global/features/portal/presentation/pages/portal_schedule_page.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> _pump(
  WidgetTester tester,
  Widget page, {
  Set<String> licensed = const {'grades', 'attendance', 'academic'},
  Size size = const Size(400, 1600),
}) async {
  await PtAoFormatters.initialize();
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final auth = AuthMockHandlers();
  final students = StudentsMockHandlers(count: 60);
  final schedule = ScheduleMockHandlers();
  final handlers = PortalMockHandlers(
    authenticate: auth.authenticate,
    pupilsFor: students.pupilsForPortalUser,
    scheduleFor: (id) {
      final classroom = students.classroomIdOf(id);
      return classroom == null ? [] : schedule.slotsOfClassroom(classroom);
    },
  );
  final container = ProviderContainer(
    overrides: [
      licenseGateProvider.overrideWithValue(
        LicenseGate(enabledModules: {'core', 'guardian_portal', ...licensed}),
      ),
      apiClientProvider.overrideWith((ref) {
        final registry = ref.watch(mockApiRegistryProvider);
        return ApiClient.create(
          baseUrl: 'https://api.test',
          useMockApi: true,
          registry: registry,
          mockConfig: const MockApiConfig.instant(),
          logging: false,
        );
      }),
      mockApiModulesProvider.overrideWithValue([auth, students, handlers]),
    ],
  );
  addTearDown(container.dispose);
  await tester.runAsync(
    () => ApiAuthRepository(
      container.read(apiClientProvider),
      InMemorySessionStorage(),
    ).login(identifier: 'encarregado@erp-global.local', password: 'Dev@12345'),
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(body: page),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('notas: mostra disciplinas, boletins e troca de trimestre', (
    tester,
  ) async {
    await _pump(tester, const PortalGradesPage());
    expect(find.text('Notas e boletins'), findsOneWidget);
    expect(find.text('Língua Portuguesa'), findsOneWidget);
    expect(find.text('Boletins'), findsOneWidget);
    expect(find.text('1.º trimestre'), findsOneWidget);
    await tester.tap(find.text('3.º trim.'));
    await tester.pumpAndSettle();
    // O 3.º trimestre ainda não tem notas.
    expect(find.text('—'), findsWidgets);
    expect(tester.takeException(), isNull);
  });

  testWidgets('módulo não licenciado → secção indisponível', (tester) async {
    await _pump(tester, const PortalGradesPage(), licensed: {});
    expect(find.text('Secção indisponível'), findsOneWidget);
    expect(find.text('Língua Portuguesa'), findsNothing);
  });

  testWidgets('faltas: contagens e atalho de justificação', (tester) async {
    await _pump(tester, const PortalAttendancePage());
    expect(find.textContaining('Falta injustificada:'), findsOneWidget);
    expect(find.text('Justificar falta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('horário: mostra aulas por dia ou estado vazio', (tester) async {
    await _pump(tester, const PortalSchedulePage());
    final hasDay = find.text('Segunda-feira').evaluate().isNotEmpty;
    final empty = find.text('Sem horário disponível').evaluate().isNotEmpty;
    expect(hasDay || empty, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('justificação: valida, envia e lista o pedido pendente', (
    tester,
  ) async {
    await _pump(tester, const PortalJustificationPage());
    expect(find.text('Ainda sem pedidos'), findsOneWidget);

    // Sem escolher a falta → erro no campo.
    await tester.tap(find.text('Enviar pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha a falta a justificar'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<DateTime>));
    await tester.pumpAndSettle();
    // O menu abre sobre o formulário; o item do fim pode ficar fora do ecrã.
    await tester.tap(
      find.byType(DropdownMenuItem<DateTime>).last,
      warnIfMissed: false,
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Consulta médica');
    await tester.tap(find.text('Enviar pedido'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text('Consulta médica'), findsOneWidget);
    expect(find.text('Ainda sem pedidos'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('documentos: pede declaração e mostra estado', (tester) async {
    await _pump(tester, const PortalDocumentsPage());
    expect(find.text('Ainda sem pedidos'), findsOneWidget);

    await tester.tap(find.text('Enviar pedido'));
    await tester.pumpAndSettle();
    expect(find.text('Escolha o documento'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<PortalDocumentKind>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Declaração de notas').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enviar pedido'));
    await tester.runAsync(() => Future<void>.delayed(Duration.zero));
    await tester.pumpAndSettle();

    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text('Declaração de notas'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
