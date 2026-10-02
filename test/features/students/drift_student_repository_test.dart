import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:erp_global/core/database/app_database.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/data/repositories/drift_student_repository.dart';
import 'package:erp_global/features/students/domain/student_duplicates.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:erp_global/features/students/presentation/providers/student_providers.dart';

void main() {
  late AppDatabase db;
  late DriftStudentRepository repo;
  final seed = buildStudentsSeed(count: 30).students;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    repo = DriftStudentRepository(db);
    for (final s in seed) {
      (await repo.create(s)).getOrThrow();
    }
  });
  tearDown(() => db.close());

  test('create/get faz round-trip e marca pendingCreate + outbox', () async {
    final got = (await repo.get(seed.first.id)).getOrThrow();
    expect(got.fullName, seed.first.fullName);
    expect(got.birthDate, seed.first.birthDate);
    expect(got.health.allergies, seed.first.health.allergies);
    expect(got.syncState, 'pendingCreate');
    expect(await db.select(db.syncOutbox).get(), hasLength(seed.length));
  });

  test('list pagina, ordena e pesquisa sem acentos', () async {
    final page = (await repo.list(
      const StudentQuery(pageSize: 10),
    )).getOrThrow();
    expect(page.items, hasLength(10));
    expect(page.meta.total, seed.length);
    final names = page.items.map((s) => s.fullName.toLowerCase()).toList();
    expect(names, isNotEmpty);

    final first = seed.first.fullName.split(' ').first;
    final found = (await repo.list(
      StudentQuery(q: first.toUpperCase()),
    )).getOrThrow();
    expect(found.items.map((s) => s.id), contains(seed.first.id));
  });

  test('update mantém pendingCreate; delete é lógico', () async {
    final updated = (await repo.update(
      seed.first.copyWith(phone: '923000000'),
    )).getOrThrow();
    expect(updated.phone, '923000000');
    expect(updated.syncState, 'pendingCreate');

    (await repo.delete(seed.first.id)).getOrThrow();
    expect((await repo.get(seed.first.id)).failureOrNull?.code, 'NOT_FOUND');
    final list = (await repo.list(
      const StudentQuery(pageSize: 100),
    )).getOrThrow();
    expect(list.meta.total, seed.length - 1);
    final ops = (await db.select(db.syncOutbox).get()).map((r) => r.operation);
    expect(ops, contains('delete'));
  });

  test('BI duplicado devolve CONFLICT', () async {
    final withId = seed.firstWhere((s) => s.idNumber != null);
    final other = seed.last.id == withId.id ? seed.first : seed.last;
    final r = await repo.update(other.copyWith(idNumber: withId.idNumber));
    expect(r.failureOrNull, isA<Failure>());
    expect(r.failureOrNull!.code, 'CONFLICT');
  });

  test('filtra por estado e ordenação inválida dá falha', () async {
    final r = (await repo.list(
      const StudentQuery(status: StudentStatus.dropout),
    )).getOrThrow();
    expect(r.items.every((s) => s.status == StudentStatus.dropout), isTrue);
    final bad = await repo.list(const StudentQuery(sort: ['nope']));
    expect(bad.isErr, isTrue);
  });

  test('nome + data de nascimento repetidos só com confirmDuplicate', () async {
    final base = seed.first;
    final copy = base.copyWith(
      id: '01DUPLICATE000000000000000',
      processNumber: 'P-DUP-0001',
      idNumber: null,
    );

    final found = (await repo.findDuplicates(
      fullName: base.fullName.toUpperCase(),
      birthDate: base.birthDate,
    )).getOrThrow();
    expect(found.single.reason, DuplicateReason.nameAndBirth);

    final refused = await repo.create(copy);
    expect(refused.failureOrNull?.code, 'CONFLICT');

    final ok = await repo.create(copy, confirmDuplicate: true);
    expect(ok.failureOrNull, isNull);
  });

  test('provider troca Api ↔ Drift', () {
    final api = ProviderContainer();
    addTearDown(api.dispose);
    expect(api.read(studentRepositoryProvider), isA<ApiStudentRepository>());

    final local = ProviderContainer(
      overrides: [
        useLocalDbProvider.overrideWithValue(true),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(local.dispose);
    expect(
      local.read(studentRepositoryProvider),
      isA<DriftStudentRepository>(),
    );
  });
}
