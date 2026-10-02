import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/enrollment_model.dart';
import 'package:erp_global/features/students/data/models/student_document_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_occurrence_model.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/student_file_rules.dart';
import 'package:erp_global/features/students/presentation/pages/student_file_page.dart';
import 'package:erp_global/features/students/presentation/providers/student_file_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';

final _seed = buildStudentsSeed(seed: 42, count: 20);
final _student = _seed.students.first;
final _at = DateTime.utc(2026, 1, 1);

EnrollmentModel _enrollment(
  String id,
  String year,
  String grade,
  DateTime on, {
  EnrollmentStatus status = EnrollmentStatus.confirmed,
}) => EnrollmentModel(
  id: id,
  institutionId: 'mock',
  createdAt: _at,
  updatedAt: _at,
  studentId: 's',
  academicYearId: year,
  gradeId: grade,
  type: EnrollmentType.renewal,
  status: status,
  enrolledOn: on,
);

StudentDocumentModel _doc({DateTime? expires}) => StudentDocumentModel(
  id: 'd',
  institutionId: 'mock',
  createdAt: _at,
  updatedAt: _at,
  studentId: 's',
  type: StudentDocumentType.idCard,
  fileName: 'bi.pdf',
  expiresOn: expires,
);

class _Env {
  _Env() {
    registry.addModule(StudentsMockHandlers(count: 20));
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
  }

  final registry = MockApiRegistry();
  late final ApiClient client;
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('regras', () {
    test('repetência: mesma classe em ano posterior; anuladas não contam', () {
      final g = MockRef.gradeId(3);
      final list = [
        _enrollment('a', 'y1', g, DateTime.utc(2024, 9)),
        _enrollment('b', 'y2', g, DateTime.utc(2025, 9)),
        _enrollment(
          'c',
          'y3',
          MockRef.gradeId(4),
          DateTime.utc(2026, 9),
          status: EnrollmentStatus.cancelled,
        ),
      ];
      expect(repeatedEnrollmentIds(list), {'b'});
      expect(currentEnrollment(list)!.id, 'b');
      expect(currentEnrollment(const []), isNull);
    });

    test('validade do documento', () {
      final now = DateTime.utc(2026, 6, 15, 10);
      expect(documentValidity(_doc(), now), DocumentValidity.noExpiry);
      expect(
        documentValidity(_doc(expires: DateTime.utc(2026, 6, 15)), now),
        DocumentValidity.expiringSoon,
      );
      expect(
        documentValidity(_doc(expires: DateTime.utc(2026, 6, 14)), now),
        DocumentValidity.expired,
      );
      expect(
        documentValidity(_doc(expires: DateTime.utc(2027, 1, 1)), now),
        DocumentValidity.valid,
      );
    });
  });

  group('API mock', () {
    test('documentos: criar, verificar, listar e remover', () async {
      final repo = ApiStudentDocumentRepository(_Env().client);
      final created = (await repo.create(
        _doc().copyWith(
          id: '01JDOC0000000000000000001A',
          studentId: _student.id,
        ),
      )).getOrThrow();
      var list = (await repo.forStudent(_student.id)).getOrThrow();
      expect(list.map((d) => d.id), [created.id]);

      final verified = (await repo.update(
        created.copyWith(verified: true, verifiedBy: 'u1'),
      )).getOrThrow();
      expect(verified.verified, isTrue);
      expect(verified.verifiedBy, 'u1');

      // Verificar sem dizer quem verificou é recusado.
      final bad = await repo.update(created.copyWith(verified: true));
      expect(bad.failureOrNull, isNotNull);

      (await repo.delete(created.id)).getOrThrow();
      list = (await repo.forStudent(_student.id)).getOrThrow();
      expect(list, isEmpty);
    });

    test(
      'ocorrências: ordenadas por data e aluno inexistente dá 404',
      () async {
        final repo = ApiOccurrenceRepository(_Env().client);
        StudentOccurrenceModel occ(String id, int day) =>
            StudentOccurrenceModel(
              id: id,
              institutionId: 'mock',
              createdAt: _at,
              updatedAt: _at,
              studentId: _student.id,
              type: OccurrenceType.praise,
              occurredOn: DateTime.utc(2026, 3, day),
              title: 'Elogio $day',
            );
        (await repo.create(occ('01JOCC0000000000000000001A', 5))).getOrThrow();
        (await repo.create(occ('01JOCC0000000000000000002A', 9))).getOrThrow();
        final list = (await repo.forStudent(_student.id)).getOrThrow();
        expect(list.map((o) => o.title), ['Elogio 9', 'Elogio 5']);
        expect((await repo.forStudent('nope')).failureOrNull, isNotNull);
      },
    );
  });

  group('separadores', () {
    Future<ProviderContainer> pump(
      WidgetTester tester, {
      String tab = 'pathway',
      List<String> permissions = const ['students.*'],
    }) async {
      tester.view.physicalSize = const Size(2600, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final env = _Env();
      final overrides = <Override>[
        sessionPermissionsProvider.overrideWithValue(permissions),
        licenseGateProvider.overrideWithValue(
          const LicenseGate(enabledModules: {'students'}),
        ),
        apiClientProvider.overrideWithValue(env.client),
      ];
      final container = ProviderContainer(overrides: overrides);
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            theme: AppTheme.light(),
            scaffoldMessengerKey: rootMessengerKey,
            builder: (context, child) => ToastHost(child: child!),
            home: Scaffold(
              body: StudentFilePage(studentId: _student.id, initialTab: tab),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('mostra os 7 separadores de #34 e #35', (tester) async {
      await pump(tester);
      for (final id in [
        'identification',
        'guardians',
        'health',
        'pathway',
        'enrollment',
        'discipline',
        'documents',
      ]) {
        expect(find.byKey(Key('student_tab_$id')), findsOneWidget, reason: id);
      }
    });

    testWidgets('Percurso lista a matrícula do seed', (tester) async {
      await pump(tester);
      final e = _seed.enrollments.firstWhere((e) => e.studentId == _student.id);
      expect(find.byKey(Key('pathway_${e.id}')), findsOneWidget);
      expect(find.text('Confirmada'), findsOneWidget);
    });

    testWidgets('Matrícula actual: editar turma e n.º de chamada', (
      tester,
    ) async {
      final c = await pump(tester, tab: 'enrollment');
      expect(find.text('Matrícula actual'), findsOneWidget);
      await tester.tap(find.text('Editar'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'N.º de chamada'),
        '7',
      );
      await tester.tap(find.byKey(const Key('enrollment_shift')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Tarde').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();

      final list = c.read(studentEnrollmentsProvider(_student.id)).requireValue;
      expect(list.first.rollNumber, 7);
      expect(list.first.shiftId, MockRef.afternoonShiftId);
      expect(find.text('Tarde'), findsOneWidget);
    });

    testWidgets('Disciplina: registar ocorrência e remover', (tester) async {
      final c = await pump(tester, tab: 'discipline');
      expect(find.text('Sem ocorrências'), findsOneWidget);
      await tester.tap(find.text('Registar ocorrência'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('Campo obrigatório'), findsWidgets); // título em falta

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Título'),
        'Atraso repetido',
      );
      await tester.tap(find.text('Guardar'));
      await tester.pumpAndSettle();
      expect(find.text('Atraso repetido'), findsOneWidget);
      expect(
        c.read(studentOccurrencesProvider(_student.id)).requireValue,
        hasLength(1),
      );

      await tester.tap(find.byTooltip('Remover ocorrência'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remover').last);
      await tester.pumpAndSettle();
      expect(find.text('Sem ocorrências'), findsOneWidget);
    });

    testWidgets('Documentos: carregar e verificar', (tester) async {
      final c = await pump(tester, tab: 'documents');
      expect(find.text('Sem documentos'), findsOneWidget);
      await tester.tap(find.text('Carregar documento'));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Ficheiro'),
        'bi-aluno.pdf',
      );
      await tester.tap(find.text('Carregar'));
      await tester.pumpAndSettle();
      expect(find.text('bi-aluno.pdf'), findsOneWidget);
      expect(find.text('Por verificar'), findsOneWidget);

      await tester.tap(find.byTooltip('Marcar como verificado'));
      await tester.pumpAndSettle();
      expect(find.text('Verificado'), findsOneWidget);
      final docs = c.read(studentDocumentsProvider(_student.id)).requireValue;
      expect(docs.single.verified, isTrue);
      expect(docs.single.verifiedBy, isNotNull);
    });

    testWidgets('sem students.record.update não há acções de escrita', (
      tester,
    ) async {
      await pump(
        tester,
        tab: 'documents',
        permissions: const ['students.record.read'],
      );
      expect(find.text('Carregar documento'), findsNothing);
    });
  });
}
