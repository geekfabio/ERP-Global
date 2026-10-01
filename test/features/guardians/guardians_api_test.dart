import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/guardian_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

GuardianRepository _repo() {
  final registry = MockApiRegistry()
    ..addModule(StudentsMockHandlers(count: 20));
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  return ApiGuardianRepository(client);
}

GuardianLinkModel _newLink(
  String studentId,
  String guardianId, {
  DateTime? until,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return GuardianLinkModel(
    id: '01JTESTLINK0000000000$studentId'.substring(0, 26),
    institutionId: 'mock',
    createdAt: now,
    updatedAt: now,
    studentId: studentId,
    guardianId: guardianId,
    relationship: GuardianRelationship.uncleAunt,
    validUntil: until,
  );
}

void main() {
  test('ficha, ediÃ§Ã£o e educandos do encarregado', () async {
    final repo = _repo();
    final list = (await repo.list(pageSize: 5)).getOrThrow();
    final g = list.items.first;

    expect((await repo.get(g.id)).getOrThrow().fullName, g.fullName);
    final pupils = (await repo.pupilsOf(g.id)).getOrThrow();
    expect(pupils, isNotEmpty);
    expect(pupils.every((p) => p.link.guardianId == g.id), isTrue);

    final updated = (await repo.update(
      g.copyWith(phone: '923000111'),
    )).getOrThrow();
    expect(updated.phone, '923000111');
    expect((await repo.get(g.id)).getOrThrow().phone, '923000111');
  });

  test('encarregado inexistente â†’ 404', () async {
    final r = await _repo().get('nao-existe');
    expect(r.failureOrNull?.code, 'NOT_FOUND');
  });

  test('um aluno com vÃ¡rios encarregados', () async {
    final repo = _repo();
    final guardians = (await repo.list(pageSize: 50)).getOrThrow().items;
    final first = guardians.first;
    final pupil = (await repo.pupilsOf(first.id)).getOrThrow().first.student;
    final before = (await repo.forStudent(pupil.id)).getOrThrow();
    final other = guardians.firstWhere(
      (g) => before.every((b) => b.guardian.id != g.id),
    );

    (await repo.link(_newLink(pupil.id, other.id))).getOrThrow();

    final after = (await repo.forStudent(pupil.id)).getOrThrow();
    expect(after.length, before.length + 1);
    expect(after.map((e) => e.guardian.id), contains(other.id));
    // Duplicar o mesmo vÃ­nculo Ã© recusado.
    final dup = await repo.link(
      _newLink(pupil.id, other.id).copyWith(id: '01JTESTLINK00000000000DUP1'),
    );
    expect(dup.failureOrNull?.code, 'CONFLICT');
  });

  test('um encarregado com vÃ¡rios educandos e validade do vÃ­nculo', () async {
    final repo = _repo();
    final guardian = (await repo.list(pageSize: 5)).getOrThrow().items.first;
    final pupils = (await repo.pupilsOf(guardian.id)).getOrThrow();
    final link = pupils.first.link;

    final until = DateTime.utc(2027, 3, 31);
    final edited = (await repo.updateLink(
      link.copyWith(validUntil: until, canPickup: true),
    )).getOrThrow();
    expect(edited.validUntil, until);
    expect(edited.canPickup, isTrue);

    final reloaded = (await repo.pupilsOf(guardian.id)).getOrThrow();
    expect(
      reloaded.firstWhere((p) => p.link.id == link.id).link.validUntil,
      until,
    );
    // Remover o vÃ­nculo retira o educando da ficha.
    (await repo.unlink(link.id)).getOrThrow();
    final left = (await repo.pupilsOf(guardian.id)).getOrThrow();
    expect(left.any((p) => p.link.id == link.id), isFalse);
  });
}
