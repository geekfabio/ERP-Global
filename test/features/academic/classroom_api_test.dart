import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/academic/data/mock_api/academic_structure_mock_handlers.dart';
import 'package:erp_global/features/academic/data/models/classroom_models.dart';
import 'package:erp_global/features/academic/data/repositories/api_academic_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

ApiClient _client() => ApiClient.create(
  baseUrl: 'https://api.test',
  useMockApi: true,
  registry: MockApiRegistry()..addModule(AcademicStructureMockHandlers()),
  mockConfig: const MockApiConfig.instant(),
  logging: false,
);

void expectCode(Result<Object?> r, String code) =>
    expect(r.failureOrNull?.code, code);

void main() {
  test('seed: salas, turnos e turmas do ano activo', () async {
    final c = _client();
    final rooms = (await apiRoomRepository(c).list()).getOrThrow().items;
    final shifts = (await apiShiftRepository(c).list()).getOrThrow().items;
    final classes = (await apiClassroomRepository(c).list()).getOrThrow().items;
    expect(rooms, isNotEmpty);
    expect(shifts.map((s) => s.name), containsAll(['Manhã', 'Tarde']));
    expect(classes, isNotEmpty);
    expect(classes.every((t) => t.academicYearId.isNotEmpty), isTrue);
    expect(classes.every((t) => t.enrolledCount <= t.capacity), isTrue);
  });

  test('turma exige ano lectivo e valida a capacidade da sala', () async {
    final c = _client();
    final repo = apiClassroomRepository(c);
    final base = (await repo.list()).getOrThrow().items.first;
    final rooms = (await apiRoomRepository(c).list()).getOrThrow().items;
    final free = rooms.firstWhere((r) => r.code == 'S24');
    final candidate = base.copyWith(
      id: '',
      name: 'Z',
      roomId: free.id,
      enrolledCount: 0,
    );

    expectCode(
      await repo.create(candidate.copyWith(academicYearId: '')),
      'VALIDATION_ERROR',
    );
    expectCode(
      await repo.create(candidate.copyWith(capacity: free.capacity + 1)),
      'VALIDATION_ERROR',
    );
    final ok = await repo.create(candidate);
    expect(ok.isOk, isTrue);
  });

  test('sala ocupada no mesmo turno e vagas abaixo dos matriculados', () async {
    final c = _client();
    final repo = apiClassroomRepository(c);
    final base = (await repo.list()).getOrThrow().items.first;
    // Mesma sala e turno de outra turma do mesmo ano -> 409.
    expectCode(await repo.create(base.copyWith(id: '', name: 'Y')), 'CONFLICT');
    // Reduzir as vagas abaixo dos matriculados -> 422.
    expectCode(
      await repo.update(
        base.id,
        base.copyWith(capacity: base.enrolledCount - 1),
      ),
      'VALIDATION_ERROR',
    );
  });

  test('não elimina sala/turno em uso nem turma com alunos', () async {
    final c = _client();
    final base = (await apiClassroomRepository(
      c,
    ).list()).getOrThrow().items.first;
    expectCode(await apiRoomRepository(c).delete(base.roomId), 'CONFLICT');
    expectCode(await apiShiftRepository(c).delete(base.shiftId), 'CONFLICT');
    expectCode(await apiClassroomRepository(c).delete(base.id), 'CONFLICT');
  });

  test('turnos: horas válidas e fim depois do início', () async {
    final c = _client();
    final repo = apiShiftRepository(c);
    const bad = ShiftModel(
      id: '',
      name: 'Extra',
      startTime: '9h',
      endTime: '10:00',
    );
    expectCode(await repo.create(bad), 'VALIDATION_ERROR');
    expectCode(
      await repo.create(bad.copyWith(startTime: '10:00', endTime: '09:00')),
      'VALIDATION_ERROR',
    );
    expect((await repo.create(bad.copyWith(startTime: '08:00'))).isOk, isTrue);
    expectCode(await repo.create(bad.copyWith(startTime: '08:00')), 'CONFLICT');
  });

  test('sala: não reduz a capacidade abaixo das vagas das turmas', () async {
    final c = _client();
    final base = (await apiClassroomRepository(
      c,
    ).list()).getOrThrow().items.first;
    final room = (await apiRoomRepository(
      c,
    ).list()).getOrThrow().items.firstWhere((r) => r.id == base.roomId);
    expectCode(
      await apiRoomRepository(c).update(room.id, room.copyWith(capacity: 10)),
      'CONFLICT',
    );
  });
}
