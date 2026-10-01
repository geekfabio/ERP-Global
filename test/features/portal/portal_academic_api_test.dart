import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/academic/data/mock_api/schedule_mock_handlers.dart';
import 'package:erp_global/features/auth/data/mock_api/auth_mock_handlers.dart';
import 'package:erp_global/features/auth/data/repositories/api_auth_repository.dart';
import 'package:erp_global/features/auth/data/repositories/session_storage.dart';
import 'package:erp_global/features/portal/data/mock_api/portal_mock_handlers.dart';
import 'package:erp_global/features/portal/data/models/portal_academic_models.dart';
import 'package:erp_global/features/portal/data/repositories/api_portal_repository.dart';
import 'package:erp_global/features/portal/domain/portal_academic_logic.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_summaries_model.dart';
import 'package:flutter_test/flutter_test.dart';

Future<ApiPortalRepository> _repoFor(String profile) async {
  final auth = AuthMockHandlers();
  final students = StudentsMockHandlers(count: 60);
  final schedule = ScheduleMockHandlers();
  final registry = MockApiRegistry()
    ..addModule(auth)
    ..addModule(students)
    ..addModule(
      PortalMockHandlers(
        authenticate: auth.authenticate,
        pupilsFor: students.pupilsForPortalUser,
        scheduleFor: (id) {
          final classroom = students.classroomIdOf(id);
          return classroom == null ? [] : schedule.slotsOfClassroom(classroom);
        },
      ),
    );
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  (await ApiAuthRepository(client, InMemorySessionStorage()).login(
    identifier: '$profile@erp-global.local',
    password: 'Dev@12345',
  )).getOrThrow();
  return ApiPortalRepository(client);
}

void main() {
  late ApiPortalRepository repo;
  late String pupilId;
  late DateTime absence;

  setUp(() async {
    repo = await _repoFor('encarregado');
    pupilId = (await repo.pupils()).getOrThrow().first.student.id;
    final attendance = (await repo.attendance(pupilId)).getOrThrow();
    absence = justifiableAbsences(attendance, const []).first;
  });

  test('lê notas, presenças e horário do educando vinculado', () async {
    final grades = (await repo.grades(pupilId)).getOrThrow();
    expect(grades.subjects, isNotEmpty);
    final attendance = (await repo.attendance(pupilId)).getOrThrow();
    expect(attendance.records, isNotEmpty);
    final slots = (await repo.schedule(pupilId)).getOrThrow();
    expect(slots.every((s) => s.weekday >= 1 && s.weekday <= 6), isTrue);
  });

  test('âmbito: educando de outra conta → 403 em todas as leituras', () async {
    final other = (await (await _repoFor(
      'aluno',
    )).pupils()).getOrThrow().single.student.id;
    for (final r in [
      await repo.grades(other),
      await repo.attendance(other),
      await repo.schedule(other),
      await repo.justifications(other),
      await repo.documentRequests(other),
      await repo.requestJustification(other, date: absence, reason: 'x'),
      await repo.requestDocument(
        other,
        kind: PortalDocumentKind.enrollmentDeclaration,
      ),
    ]) {
      expect(r.failureOrNull?.code, 'FORBIDDEN');
    }
  });

  test('perfil sem portal não lê nada', () async {
    final teacher = await _repoFor('professor');
    expect((await teacher.grades(pupilId)).failureOrNull?.code, 'FORBIDDEN');
  });

  test(
    'justificação: cria pendente, lista e rejeita duplicado (409)',
    () async {
      final created = (await repo.requestJustification(
        pupilId,
        date: absence,
        reason: '  Consulta médica ',
      )).getOrThrow();
      expect(created.status, PortalRequestStatus.pending);
      expect(created.reason, 'Consulta médica');
      expect((await repo.justifications(pupilId)).getOrThrow(), hasLength(1));

      final again = await repo.requestJustification(
        pupilId,
        date: absence,
        reason: 'Outra vez',
      );
      expect(again.failureOrNull?.code, 'CONFLICT');
    },
  );

  test('justificação: motivo vazio e dia sem falta → 422', () async {
    final empty = await repo.requestJustification(
      pupilId,
      date: absence,
      reason: '  ',
    );
    expect(empty.failureOrNull, isA<ValidationFailure>());
    expect((empty.failureOrNull! as ValidationFailure).fields, {
      'reason': isNotNull,
    });

    final attendance = (await repo.attendance(pupilId)).getOrThrow();
    final present = attendance.records
        .firstWhere((r) => r.kind == AttendanceKind.present)
        .date;
    final noAbsence = await repo.requestJustification(
      pupilId,
      date: present,
      reason: 'Motivo',
    );
    expect(noAbsence.failureOrNull, isA<ValidationFailure>());
  });

  test('pedido de documento: cria, bloqueia duplicado pendente', () async {
    final created = (await repo.requestDocument(
      pupilId,
      kind: PortalDocumentKind.gradesDeclaration,
      notes: 'Para a bolsa',
    )).getOrThrow();
    expect(created.kind, PortalDocumentKind.gradesDeclaration);
    expect(created.notes, 'Para a bolsa');
    expect((await repo.documentRequests(pupilId)).getOrThrow(), hasLength(1));

    final dup = await repo.requestDocument(
      pupilId,
      kind: PortalDocumentKind.gradesDeclaration,
    );
    expect(dup.failureOrNull?.code, 'CONFLICT');
    final other = await repo.requestDocument(
      pupilId,
      kind: PortalDocumentKind.enrollmentDeclaration,
    );
    expect(other.isOk, isTrue);
  });

  test('lógica: faltas justificáveis excluem pedidos já feitos', () {
    final summary = StudentAttendanceSummary(
      records: [
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 3),
          kind: AttendanceKind.unjustified,
        ),
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 2),
          kind: AttendanceKind.unjustified,
        ),
        AttendanceRecord(
          date: DateTime.utc(2026, 3, 1),
          kind: AttendanceKind.justified,
        ),
      ],
    );
    final requests = [
      AbsenceJustificationRequest(
        id: '1',
        studentId: 's',
        date: DateTime.utc(2026, 3, 3),
        reason: 'x',
        status: PortalRequestStatus.pending,
        createdAt: DateTime.utc(2026, 3, 4),
      ),
    ];
    expect(justifiableAbsences(summary, requests), [DateTime.utc(2026, 3, 2)]);
    expect(justifiableAbsences(summary, const []), hasLength(2));
  });

  test('lógica: horário agrupado por dia e ordenado por hora', () {
    PortalScheduleSlot s(int d, String t) => PortalScheduleSlot(
      weekday: d,
      startTime: t,
      endTime: '23:00',
      subject: 'X',
    );
    final grouped = groupByWeekday([
      s(3, '09:00'),
      s(1, '10:00'),
      s(1, '08:00'),
    ]);
    expect(grouped.keys, [1, 3]);
    expect(grouped[1]!.map((e) => e.startTime), ['08:00', '10:00']);
    expect(weekdayName(2), 'Terça-feira');
  });
}
