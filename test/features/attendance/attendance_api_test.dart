import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/attendance/data/mock_api/attendance_mock_handlers.dart';
import 'package:erp_global/features/attendance/data/models/attendance_models.dart';
import 'package:erp_global/features/attendance/data/repositories/api_attendance_repository.dart';
import 'package:erp_global/features/attendance/domain/attendance_repository.dart';
import 'package:erp_global/features/attendance/domain/attendance_rules.dart';
import 'package:flutter_test/flutter_test.dart';

const _key = AttendanceSheetKey(classroomId: 'c1', date: '2026-10-01');
const _lesson = AttendanceSheetKey(
  classroomId: 'c1',
  date: '2026-10-01',
  lessonSlotId: 'slot1',
);

ApiAttendanceRepository _repo({
  List<String> permissions = const ['attendance.record.write'],
  AttendanceAccess? access,
  bool withSeed = false,
}) => ApiAttendanceRepository(
  ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(
        AttendanceMockHandlers(
          permissions: () => PermissionService.fromCodes(permissions),
          access: access,
          now: () => DateTime.utc(2026, 10, 1, 12),
          withSeed: withSeed,
        ),
      ),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  ),
);

Matcher _code(String code) =>
    isA<Failure>().having((f) => f.code, 'code', code);

AttendanceRecordModel _row(String id, AttendanceStatus s, {String? why}) =>
    AttendanceRecordModel(
      classroomId: 'c1',
      studentId: id,
      date: '2026-10-01',
      status: s,
      justification: why,
    );

void main() {
  test('guarda a folha do dia e devolve-a ordenada por aluno', () async {
    final repo = _repo();
    final saved = (await repo.save(_key, [
      _row('b', AttendanceStatus.late),
      _row('a', AttendanceStatus.absent),
    ])).getOrThrow();
    expect(saved.rows.map((r) => r.studentId), ['a', 'b']);
    expect(saved.rows.first.id, isNotEmpty);
    expect((await repo.sheet(_key)).getOrThrow().rows, hasLength(2));
    // O registo por aula é independente do registo do dia.
    expect((await repo.sheet(_lesson)).getOrThrow().rows, isEmpty);
  });

  test('regravar actualiza o mesmo registo e limpa a justificação', () async {
    final repo = _repo();
    await repo.save(_key, [_row('a', AttendanceStatus.absent, why: 'Doença')]);
    final id = (await repo.sheet(_key)).getOrThrow().rows.single.id;
    final again = (await repo.save(_key, [
      _row('a', AttendanceStatus.present),
    ])).getOrThrow();
    expect(again.rows.single.id, id);
    expect(again.rows.single.justification, isNull);
  });

  test('rejeita dias futuros e datas inválidas (422)', () async {
    final repo = _repo();
    // "Agora" do teste é 2026-10-01 (UTC): 2 dias à frente é futuro de certeza.
    final future = await repo.save(
      const AttendanceSheetKey(classroomId: 'c1', date: '2026-10-03'),
      [_row('a', AttendanceStatus.present)],
    );
    expect(future.failureOrNull, _code('VALIDATION_ERROR'));
    // Cliente em UTC+1 já está no dia seguinte à data UTC do servidor: aceita.
    final tomorrowUtc = await repo.save(
      const AttendanceSheetKey(classroomId: 'c1', date: '2026-10-02'),
      [_row('a', AttendanceStatus.present)],
    );
    expect(tomorrowUtc.failureOrNull, isNull);
    final bad = await repo.sheet(
      const AttendanceSheetKey(classroomId: 'c1', date: 'x'),
    );
    expect(bad.failureOrNull, _code('VALIDATION_ERROR'));
  });

  test('só turmas atribuídas ao professor (403)', () async {
    final repo = _repo(
      access: (classroomId, {required daily}) => classroomId == 'c1' && !daily,
    );
    expect((await repo.sheet(_lesson)).isOk, isTrue);
    expect((await repo.sheet(_key)).failureOrNull, _code('FORBIDDEN'));
    final other = await repo.save(
      const AttendanceSheetKey(
        classroomId: 'c2',
        date: '2026-10-01',
        lessonSlotId: 's',
      ),
      [],
    );
    expect(other.failureOrNull, _code('FORBIDDEN'));
    // A coordenação ignora a restrição.
    final all = _repo(
      permissions: ['attendance.record.all'],
      access: (_, {required daily}) => false,
    );
    expect((await all.sheet(_key)).isOk, isTrue);
  });

  test('sem permissão de presenças não lê nem escreve (403)', () async {
    final repo = _repo(permissions: ['grades.entry.write']);
    expect((await repo.sheet(_key)).failureOrNull, _code('FORBIDDEN'));
    expect((await repo.settings()).failureOrNull, _code('FORBIDDEN'));
  });

  test('justificação: só coordenação, só faltas, motivo obrigatório', () async {
    final teacher = _repo();
    await teacher.save(_key, [
      _row('a', AttendanceStatus.absent),
      _row('b', AttendanceStatus.present),
    ]);
    final rows = (await teacher.sheet(_key)).getOrThrow().rows;
    final absent = rows.firstWhere((r) => r.studentId == 'a');
    expect(
      (await teacher.justify(absent.id, 'Doença')).failureOrNull,
      _code('FORBIDDEN'),
    );
    // Novo repository partilha o estado? Não: usa-se o mesmo registry.
    final admin = _repo(permissions: ['attendance.record.all']);
    expect(
      (await admin.justify('nada', 'x')).failureOrNull,
      _code('NOT_FOUND'),
    );
  });

  test('justificar uma falta tira-a da contagem do alerta', () async {
    final repo = _repo(permissions: ['attendance.record.all']);
    await repo.updateSettings(const AttendanceSettingsModel(absenceLimit: 2));
    for (final day in ['2026-09-28', '2026-09-29']) {
      await repo.save(AttendanceSheetKey(classroomId: 'c1', date: day), [
        AttendanceRecordModel(
          classroomId: 'c1',
          studentId: 'a',
          date: day,
          status: AttendanceStatus.absent,
        ),
      ]);
    }
    final alerts = (await repo.alerts(classroomId: 'c1')).getOrThrow();
    expect(alerts.single.unjustified, 2);
    expect(alerts.single.limit, 2);

    final absences = (await repo.records(
      status: AttendanceStatus.absent,
    )).getOrThrow().items;
    final done = (await repo.justify(absences.first.id, 'Luto')).getOrThrow();
    expect(isJustified(done), isTrue);
    expect((await repo.alerts()).getOrThrow(), isEmpty);

    final present = await repo.save(_key, [
      _row('z', AttendanceStatus.present),
    ]);
    final id = present.getOrThrow().rows.single.id;
    expect((await repo.justify(id, 'x')).failureOrNull, _code('CONFLICT'));
    expect(
      (await repo.justify(absences.last.id, ' ')).failureOrNull,
      _code('VALIDATION_ERROR'),
    );
  });

  test('limite configurável: validação e permissão', () async {
    final repo = _repo(permissions: ['attendance.record.all']);
    expect((await repo.settings()).getOrThrow().absenceLimit, 10);
    expect(
      (await repo.updateSettings(
        const AttendanceSettingsModel(absenceLimit: 0),
      )).failureOrNull,
      _code('VALIDATION_ERROR'),
    );
    final saved = (await repo.updateSettings(
      const AttendanceSettingsModel(absenceLimit: 7),
    )).getOrThrow();
    expect(saved.absenceLimit, 7);
    final teacher = _repo();
    expect(
      (await teacher.updateSettings(
        const AttendanceSettingsModel(absenceLimit: 3),
      )).failureOrNull,
      _code('FORBIDDEN'),
    );
  });

  test(
    'seed coerente: tem alertas ao limite do seed e é determinístico',
    () async {
      final repo = _repo(
        permissions: ['attendance.record.all'],
        withSeed: true,
      );
      final first = (await repo.alerts()).getOrThrow();
      expect(first, isNotEmpty);
      expect(first.every((a) => a.unjustified >= a.limit), isTrue);
      final second = (await _repo(
        permissions: ['attendance.record.all'],
        withSeed: true,
      ).alerts()).getOrThrow();
      expect(
        second.map((a) => (a.studentId, a.unjustified)),
        first.map((a) => (a.studentId, a.unjustified)),
      );
    },
  );

  group('regras', () {
    test('faltas por aula do mesmo dia contam como uma', () {
      final records = [
        for (final slot in ['1', '2', '3'])
          AttendanceRecordModel(
            classroomId: 'c',
            studentId: 'a',
            date: '2026-10-01',
            lessonSlotId: slot,
            status: AttendanceStatus.absent,
          ),
        const AttendanceRecordModel(
          classroomId: 'c',
          studentId: 'a',
          date: '2026-10-02',
          status: AttendanceStatus.late,
        ),
      ];
      expect(unjustifiedByStudent(records), {'a': 1});
      expect(buildAlerts(records, 1), hasLength(1));
      expect(buildAlerts(records, 2), isEmpty);
    });
  });
}
