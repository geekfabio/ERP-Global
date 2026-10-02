import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/widgets/feedback/toasts.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/assignment_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/schedule_mock_handlers.dart';
import 'package:erp_global/features/academic/data/mock_api/teacher_mock_handlers.dart';
import 'package:erp_global/features/academic/data/models/schedule_models.dart';
import 'package:erp_global/features/academic/data/repositories/api_academic_repositories.dart';
import 'package:erp_global/features/academic/domain/schedule_rules.dart';
import 'package:erp_global/features/academic/presentation/pages/academic_page.dart';
import 'package:erp_global/features/academic/presentation/providers/schedule_providers.dart';
import 'package:erp_global/features/auth/data/models/auth_session.dart';
import 'package:erp_global/features/auth/data/models/user_model.dart';
import 'package:erp_global/features/auth/presentation/providers/auth_state.dart';
import 'package:erp_global/features/settings/data/mock_api/academic_mock_handlers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

ScheduleSlotModel _s(
  String id, {
  String classroom = 'c1',
  String teacher = 't1',
  String room = 'r1',
  int day = 1,
  String start = '08:00',
  String end = '09:00',
}) => ScheduleSlotModel(
  id: id,
  classroomId: classroom,
  subjectId: 's1',
  teacherId: teacher,
  roomId: room,
  weekday: day,
  startTime: start,
  endTime: end,
);

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()
    ..addModule(ScheduleMockHandlers())
    ..addModule(AssignmentMockHandlers())
    ..addModule(TeacherMockHandlers())
    ..addModule(AcademicStructureMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('validateScheduleSlot', () {
    final base = [_s('1')];

    test('aceita aula sem conflitos e intervalos encostados', () {
      expect(
        validateScheduleSlot(
          _s('x', classroom: 'c2', teacher: 't2', room: 'r2'),
          base,
        ),
        isNull,
      );
      expect(
        validateScheduleSlot(_s('x', start: '09:00', end: '10:00'), base),
        isNull,
      );
    });

    test('conflito de professor, sala e turma', () {
      final teacher = validateScheduleSlot(
        _s('x', classroom: 'c2', room: 'r2'),
        base,
      );
      expect(teacher?.resource, ScheduleConflictResource.teacher);
      expect(teacher?.kind, ScheduleIssueKind.conflict);
      final room = validateScheduleSlot(
        _s('x', classroom: 'c2', teacher: 't2'),
        base,
      );
      expect(room?.resource, ScheduleConflictResource.room);
      final cls = validateScheduleSlot(
        _s('x', teacher: 't2', room: 'r2'),
        base,
      );
      expect(cls?.resource, ScheduleConflictResource.classroom);
    });

    test('sobreposição parcial conflitua; outro dia não', () {
      expect(
        validateScheduleSlot(_s('x', start: '08:30', end: '09:30'), base)?.kind,
        ScheduleIssueKind.conflict,
      );
      expect(validateScheduleSlot(_s('x', day: 2), base), isNull);
    });

    test('devolve todos os conflitos em simultâneo', () {
      expect(findScheduleConflicts(_s('x'), base), hasLength(3));
    });

    test('valida dia, horas e turno', () {
      expect(validateScheduleSlot(_s('x', day: 7), [])?.field, 'weekday');
      expect(
        validateScheduleSlot(_s('x', start: '8h'), [])?.field,
        'startTime',
      );
      expect(validateScheduleSlot(_s('x', end: '08:00'), [])?.field, 'endTime');
      expect(
        validateScheduleSlot(
          _s('x', start: '06:00', end: '07:00'),
          [],
          shiftStart: '07:00',
          shiftEnd: '12:00',
        )?.field,
        'startTime',
      );
    });

    test('scheduleRows junta janelas do turno e aulas existentes', () {
      final rows = scheduleRows(
        [_s('1', start: '07:30', end: '08:30')],
        shiftStart: '07:00',
        shiftEnd: '09:00',
      );
      expect(rows.map((r) => r.$1), ['07:00', '07:30', '08:00']);
    });
  });

  group('Mock API', () {
    test('seed é paginável, sem conflitos e filtrável', () async {
      final c = _client();
      final repo = apiScheduleSlotRepository(c);
      final page = (await repo.list(pageSize: 100)).getOrThrow();
      expect(page.items, isNotEmpty);
      final all = <ScheduleSlotModel>[];
      var p = 1;
      while (true) {
        final r = (await repo.list(page: p, pageSize: 100)).getOrThrow();
        all.addAll(r.items);
        if (!r.meta.hasNext) break;
        p++;
      }
      for (final s in all) {
        expect(
          findScheduleConflicts(s, all.where((o) => o.id != s.id)),
          isEmpty,
          reason: s.id,
        );
      }
      final first = all.first;
      final mine = (await repo.list(
        filters: {'teacherId': first.teacherId},
      )).getOrThrow().items;
      expect(mine.every((s) => s.teacherId == first.teacherId), isTrue);
    });

    test('conflito devolve 409 e não grava; válido grava e apaga', () async {
      final c = _client();
      final repo = apiScheduleSlotRepository(c);
      final first = (await repo.list()).getOrThrow().items.first;
      final before = (await repo.list(pageSize: 100)).getOrThrow().meta.total;

      // Mesmo professor no mesmo intervalo, noutra turma: 409.
      final others = (await repo.list(pageSize: 100)).getOrThrow().items;
      final otherClass = others
          .firstWhere((s) => s.classroomId != first.classroomId)
          .classroomId;
      final clash = await repo.create(
        first.copyWith(id: '', classroomId: otherClass, roomId: first.roomId),
      );
      expect(clash.failureOrNull?.code, anyOf('CONFLICT', 'VALIDATION_ERROR'));
      expect((await repo.list(pageSize: 100)).getOrThrow().meta.total, before);

      // Hora inválida: 422.
      final bad = await repo.create(first.copyWith(id: '', startTime: '25:00'));
      expect(bad.failureOrNull?.code, 'VALIDATION_ERROR');

      // Turma desconhecida: 422.
      final unknown = await repo.create(
        first.copyWith(id: '', classroomId: 'nope'),
      );
      expect(unknown.failureOrNull?.code, 'VALIDATION_ERROR');
    });

    test('criar fora do conflito e eliminar', () async {
      final c = _client();
      final repo = apiScheduleSlotRepository(c);
      final all = (await repo.list(pageSize: 100)).getOrThrow().items;
      final first = all.first;
      // Sábado ainda está livre para toda a gente.
      final created = await repo.create(
        first.copyWith(
          id: '',
          weekday: 6,
          startTime: '07:00',
          endTime: '08:00',
        ),
      );
      expect(created.isOk, isTrue);
      final id = created.getOrThrow().id;
      expect((await repo.delete(id)).isOk, isTrue);
      expect((await repo.delete(id)).failureOrNull?.code, 'NOT_FOUND');
    });
  });

  group('UI', () {
    Future<ProviderContainer> pump(
      WidgetTester tester, {
      required List<String> permissions,
      String? email,
    }) async {
      tester.view.physicalSize = const Size(2600, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final container = ProviderContainer(
        overrides: [
          sessionPermissionsProvider.overrideWithValue(permissions),
          if (email != null)
            currentSessionProvider.overrideWithValue(
              AuthSession(
                user: UserModel(
                  id: 'u',
                  institutionId: 'i',
                  createdAt: DateTime.utc(2026),
                  updatedAt: DateTime.utc(2026),
                  name: 'Prof',
                  email: email,
                ),
                roles: const ['professor'],
                permissions: permissions,
                license: const {},
              ),
            ),
          mockApiModulesProvider.overrideWith(
            (ref) => [
              AcademicStructureMockHandlers(),
              AcademicMockHandlers(),
              TeacherMockHandlers(),
              AssignmentMockHandlers(),
              ScheduleMockHandlers(),
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
      await tester.ensureVisible(find.text('Horários'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Horários'));
      await tester.pumpAndSettle();
      return container;
    }

    testWidgets('grelha mostra dias, aulas e alterna a vista', (tester) async {
      final container = await pump(tester, permissions: ['academic.*']);
      expect(find.text('Segunda'), findsOneWidget);
      expect(find.text('Sábado'), findsOneWidget);
      final slots = await container.read(scheduleListProvider.future);
      expect(slots, isNotEmpty);
      expect(find.byKey(const Key('schedule_view')), findsOneWidget);
      await tester.tap(find.text('Professor'));
      await tester.pumpAndSettle();
      expect(find.text('Segunda'), findsOneWidget);
      await tester.tap(find.text('Sala'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('schedule_view')), findsOneWidget);
    });

    testWidgets('abre uma aula e mostra o detalhe', (tester) async {
      await pump(tester, permissions: ['academic.*']);
      final slot = find.byWidgetPredicate((w) {
        final k = w.key;
        return k is ValueKey<String> && k.value.startsWith('slot_');
      });
      expect(slot, findsWidgets);
      await tester.tap(slot.first);
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('schedule_slot_dialog')), findsOneWidget);
      expect(find.text('Retirar'), findsOneWidget);
    });

    testWidgets('professor vê só o seu horário, sem gestão', (tester) async {
      final email = (await tester.runAsync(() async {
        final c = _client();
        final slot = (await apiScheduleSlotRepository(
          c,
        ).list()).getOrThrow().items.first;
        final teachers = (await apiTeacherRepository(
          c,
        ).list(pageSize: 100)).getOrThrow().items;
        return teachers.firstWhere((t) => t.id == slot.teacherId).email;
      }))!;
      await pump(tester, permissions: ['academic.class.read'], email: email);
      expect(find.byKey(const Key('schedule_view')), findsNothing);
      expect(find.text('O meu horário'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsNothing);
      expect(find.text('Segunda'), findsOneWidget);
    });
  });
}
