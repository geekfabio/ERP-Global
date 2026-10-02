import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/modules/license_gate.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/grades/data/mock_api/council_mock_handlers.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/enrollment_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/repositories/api_renewal_repository.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/renewal_rules.dart';
import 'package:erp_global/features/students/presentation/pages/renewal_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

const _nextYear = '01JYEAR202620270000000001A';

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(StudentsMockHandlers(count: 60))
    ..addModule(AcademicStructureMockHandlers())
    ..addModule(AcademicMockHandlers())
    ..addModule(CouncilMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

/// Turma do seed com mais matrículas confirmadas (e a respectiva classe).
Future<({String classroom, List<EnrollmentModel> rows})> _busiestRoom(
  ApiClient client,
) async {
  final all = (await ApiEnrollmentRepository(
    client,
  ).list(pageSize: 100, academicYearId: MockRef.academicYearId)).getOrThrow();
  final byRoom = <String, List<EnrollmentModel>>{};
  for (final e in all.items) {
    if (e.status == EnrollmentStatus.confirmed && e.classroomId != null) {
      (byRoom[e.classroomId!] ??= []).add(e);
    }
  }
  final best = byRoom.entries.reduce(
    (a, b) => a.value.length >= b.value.length ? a : b,
  );
  return (classroom: best.key, rows: best.value);
}

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('regras puras', () {
    test('acção por omissão conforme o resultado', () {
      expect(defaultRenewalAction('approved'), RenewalAction.promote);
      expect(
        defaultRenewalAction('transitsWithDeficiency'),
        RenewalAction.promote,
      );
      expect(defaultRenewalAction('failed'), RenewalAction.repeat);
      expect(defaultRenewalAction('recourse'), RenewalAction.skip);
      expect(defaultRenewalAction(null), RenewalAction.skip);
    });

    test('classe de destino', () {
      const order = ['g0', 'g1', 'g2'];
      expect(targetGradeFor(RenewalAction.promote, 'g1', order), 'g2');
      expect(targetGradeFor(RenewalAction.repeat, 'g1', order), 'g1');
      expect(targetGradeFor(RenewalAction.skip, 'g1', order), isNull);
      // Última classe: sem seguinte.
      expect(targetGradeFor(RenewalAction.promote, 'g2', order), isNull);
      expect(targetGradeFor(RenewalAction.promote, 'x', order), isNull);
    });
  });

  group('API mock', () {
    late ApiClient client;
    late ApiRenewalRepository repo;
    late String room;
    late List<EnrollmentModel> source;

    setUp(() async {
      client = _client();
      repo = ApiRenewalRepository(client);
      final b = await _busiestRoom(client);
      room = b.classroom;
      source = b.rows;
    });

    Future<void> decide(String studentId, String result) async {
      await client.dio.put<dynamic>(
        '/v1/class-councils/decisions',
        data: {
          'classroomId': room,
          'yearId': MockRef.academicYearId,
          'studentId': studentId,
          'result': result,
          'justification': 'Conselho',
        },
      );
    }

    test('lista anos lectivos', () async {
      final years = (await repo.years()).getOrThrow();
      expect(years.map((y) => y.status), containsAll(['active', 'planned']));
    });

    test('pré-visualização: aprovado avança, reprovado repete', () async {
      await decide(source[0].studentId, 'approved');
      if (source.length > 1) await decide(source[1].studentId, 'failed');
      final preview = (await repo.preview(
        sourceYearId: MockRef.academicYearId,
        targetYearId: _nextYear,
        classroomId: room,
      )).getOrThrow();
      expect(preview.rows, hasLength(source.length));
      final byStudent = {
        for (final r in preview.rows) r.enrollment.studentId: r,
      };
      final a = byStudent[source[0].studentId]!;
      expect(a.action, RenewalAction.promote);
      final order = preview.gradeOrder;
      final index = order.indexOf(a.enrollment.gradeId);
      if (index + 1 < order.length) {
        expect(a.targetGradeId, order[index + 1]);
      }
      if (source.length > 1) {
        final f = byStudent[source[1].studentId]!;
        expect(f.action, RenewalAction.repeat);
        expect(f.targetGradeId, f.enrollment.gradeId);
      }
    });

    test(
      'aplicar cria renovações aprovadas, conclui a origem e é idempotente',
      () async {
        final first = source.first;
        final item = RenewalItem(
          enrollmentId: first.id,
          action: RenewalAction.repeat,
          gradeId: first.gradeId,
        );
        final outcome = (await repo.apply(
          sourceYearId: MockRef.academicYearId,
          targetYearId: _nextYear,
          items: [item],
        )).getOrThrow();
        expect(outcome.created, hasLength(1));
        final created = outcome.created.single;
        expect(created.type, EnrollmentType.renewal);
        expect(created.status, EnrollmentStatus.approved);
        expect(created.academicYearId, _nextYear);
        expect(created.classroomId, isNull);

        final done = (await ApiEnrollmentRepository(
          client,
        ).list(studentId: first.studentId)).getOrThrow().items;
        expect(
          done.firstWhere((e) => e.id == first.id).status,
          EnrollmentStatus.completed,
        );

        // Segunda aplicação: o aluno já tem matrícula no destino.
        final again = (await repo.apply(
          sourceYearId: MockRef.academicYearId,
          targetYearId: _nextYear,
          items: [item],
        )).getOrThrow();
        expect(again.created, isEmpty);
        expect(again.skipped.single.reason, contains('já tem matrícula'));

        final preview = (await repo.preview(
          sourceYearId: MockRef.academicYearId,
          targetYearId: _nextYear,
          classroomId: room,
        )).getOrThrow();
        expect(
          preview.rows
              .firstWhere((r) => r.enrollment.id == first.id)
              .alreadyRenewed,
          isTrue,
        );
      },
    );

    test('valida destino igual à origem e classe incoerente', () async {
      final same = await repo.preview(
        sourceYearId: MockRef.academicYearId,
        targetYearId: MockRef.academicYearId,
        classroomId: room,
      );
      expect(same.failureOrNull?.code, 'VALIDATION_ERROR');
      final wrong = (await repo.apply(
        sourceYearId: MockRef.academicYearId,
        targetYearId: _nextYear,
        items: [
          RenewalItem(
            enrollmentId: source.first.id,
            action: RenewalAction.promote,
            gradeId: source.first.gradeId,
          ),
        ],
      )).getOrThrow();
      expect(wrong.created, isEmpty);
      expect(wrong.skipped, hasLength(1));
    });
  });

  group('página', () {
    testWidgets('pré-visualiza, confirma e aplica', (tester) async {
      tester.view.physicalSize = const Size(2000, 1600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final client = _client();
      final b = (await tester.runAsync(() => _busiestRoom(client)))!;
      final gradeIndex = [
        for (var i = 0; i < MockRef.gradeCount; i++) MockRef.gradeId(i),
      ].indexOf(b.rows.first.gradeId);
      final letter = [
        for (var l = 0; l < MockRef.classroomLetters.length; l++)
          MockRef.classroomId(gradeIndex, l),
      ].indexOf(b.classroom);
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(const ['students.*']),
          licenseGateProvider.overrideWithValue(
            const LicenseGate(enabledModules: {'students'}),
          ),
          apiClientProvider.overrideWithValue(client),
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
            home: const RenewalPage(),
          ),
        ),
      );
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.text('Escolha a turma'), findsOneWidget);

      // Escolhe a turma do seed.
      await tester.tap(find.byKey(const Key('renewal_grade')));
      await tester.pumpAndSettle();
      await tester.tap(find.text(MockRef.gradeLabel(gradeIndex)).last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('renewal_room')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.text('Turma ${MockRef.classroomLetters[letter]}').last,
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('renewal_preview')));
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('renewal_action_0')), findsOneWidget);

      // Sem resultados, todos de fora: escolhe "Repete a classe" no 1.º.
      expect(find.text('De fora: ${b.rows.length}'), findsOneWidget);
      await tester.tap(find.byKey(const Key('renewal_action_0')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Repete a classe').last);
      await tester.pumpAndSettle();
      expect(find.text('Repetem: 1'), findsOneWidget);

      await tester.tap(find.byKey(const Key('renewal_apply')));
      await tester.pumpAndSettle();
      expect(find.text('Aplicar renovação'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(FilledButton, 'Aplicar'),
        ),
      );
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pumpAndSettle();
      expect(find.text('1 matrícula(s) renovada(s)'), findsOneWidget);
      expect(find.text('Já renovado'), findsOneWidget);
    });
  });
}
