import 'package:drift/native.dart';
import 'package:erp_global/core/database/app_database.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/api_envelope.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/data/repositories/drift_student_repository.dart';
import 'package:erp_global/features/students/data/repositories/fallback_student_repository.dart';
import 'package:erp_global/features/students/domain/student_duplicates.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:erp_global/features/students/presentation/providers/student_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

StudentModel _draft(String id, {String? bi}) {
  final now = DateTime.utc(2026, 1, 1);
  return StudentModel(
    id: id,
    institutionId: MockRef.institutionId,
    createdAt: now,
    updatedAt: now,
    processNumber: '',
    fullName: 'Contrato Teste Silva',
    birthDate: DateTime.utc(2011, 4, 2),
    gender: Gender.female,
    idNumber: bi,
  );
}

/// Suite de contrato sobre a interface: serve a Mock API e, futuramente, o
/// servidor real (basta trocar [make]).
void studentContract(String name, Future<StudentRepository> Function() make) {
  group('contrato de alunos — $name', () {
    late StudentRepository repo;
    setUp(() async => repo = await make());

    test('list devolve envelope paginado coerente', () async {
      final page = (await repo.list(
        const StudentQuery(pageSize: 10),
      )).getOrThrow();
      expect(page.items, hasLength(10));
      expect(page.meta.page, 1);
      expect(page.meta.pageSize, 10);
      expect(page.meta.total, greaterThanOrEqualTo(10));
    });

    test('get de ID inexistente → NOT_FOUND', () async {
      final r = await repo.get('01JNOTFOUND0000000000000000');
      expect(r.failureOrNull?.code, 'NOT_FOUND');
    });

    test('create → get → update → delete', () async {
      final created = (await repo.create(
        _draft('01JCONTRACT00000000000001', bi: '009999999ZZ999'),
      )).getOrThrow();
      expect(created.id, '01JCONTRACT00000000000001');

      final got = (await repo.get(created.id)).getOrThrow();
      expect(got.fullName, 'Contrato Teste Silva');

      final updated = (await repo.update(
        got.copyWith(fullName: 'Contrato Alterado Silva'),
      )).getOrThrow();
      expect(updated.fullName, 'Contrato Alterado Silva');

      (await repo.delete(created.id)).getOrThrow();
      expect((await repo.get(created.id)).failureOrNull?.code, 'NOT_FOUND');
    });

    test('BI repetido → CONFLICT', () async {
      (await repo.create(
        _draft('01JCONTRACT00000000000002', bi: '008888888ZZ888'),
      )).getOrThrow();
      final dup = await repo.create(
        _draft('01JCONTRACT00000000000003', bi: '008888888ZZ888'),
      );
      expect(dup.failureOrNull?.code, 'CONFLICT');
    });

    test('findDuplicates assinala BI repetido', () async {
      (await repo.create(
        _draft('01JCONTRACT00000000000004', bi: '007777777ZZ777'),
      )).getOrThrow();
      final found = (await repo.findDuplicates(
        fullName: 'Outro Nome',
        birthDate: DateTime.utc(2000, 1, 1),
        idNumber: '007777777ZZ777',
      )).getOrThrow();
      expect(found.single.reason, DuplicateReason.idNumber);
    });
  });
}

/// Rede sempre em baixo.
class _OfflineRepository implements StudentRepository {
  int calls = 0;

  Future<Result<T>> _off<T>() async {
    calls++;
    return Err(NetworkFailure());
  }

  @override
  Future<Result<PagedList<StudentModel>>> list(StudentQuery query) => _off();
  @override
  Future<Result<StudentModel>> get(String id) => _off();
  @override
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  }) => _off();
  @override
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) => _off();
  @override
  Future<Result<StudentModel>> update(StudentModel student) => _off();
  @override
  Future<Result<void>> delete(String id) => _off();
}

StudentRepository _mockApi() {
  final registry = MockApiRegistry()
    ..addModule(StudentsMockHandlers(count: 30));
  return ApiStudentRepository(
    ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    ),
  );
}

void main() {
  studentContract('Mock API', () async => _mockApi());

  late AppDatabase db;
  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  studentContract('Fallback local (API online)', () async {
    final local = DriftStudentRepository(db);
    for (final s in buildStudentsSeed(count: 30).students) {
      (await local.create(s)).getOrThrow();
    }
    return FallbackStudentRepository(remote: _mockApi(), local: local);
  });

  group('FallbackStudentRepository', () {
    test('offline recorre ao Drift e regista na outbox', () async {
      final offline = _OfflineRepository();
      final repo = FallbackStudentRepository(
        remote: offline,
        local: DriftStudentRepository(db),
      );
      final created = (await repo.create(
        _draft('01JFALLBACK000000000000001'),
      )).getOrThrow();
      expect(created.syncState, 'pendingCreate');
      expect((await repo.get(created.id)).getOrThrow().id, created.id);
      expect(
        (await repo.list(const StudentQuery())).getOrThrow().items,
        hasLength(1),
      );
      expect(offline.calls, 3);
      expect(await db.select(db.syncOutbox).get(), hasLength(1));
    });

    test('erro do servidor não dispara o fallback', () async {
      final repo = FallbackStudentRepository(
        remote: _mockApi(),
        local: DriftStudentRepository(db),
      );
      final r = await repo.get('01JNOTFOUND0000000000000000');
      expect(r.failureOrNull?.code, 'NOT_FOUND');
    });

    test('provider só usa o fallback com localFallback', () {
      final plain = ProviderContainer();
      addTearDown(plain.dispose);
      expect(
        plain.read(studentRepositoryProvider),
        isA<ApiStudentRepository>(),
      );

      final fb = ProviderContainer(
        overrides: [
          localFallbackProvider.overrideWithValue(true),
          appDatabaseProvider.overrideWithValue(db),
        ],
      );
      addTearDown(fb.dispose);
      expect(
        fb.read(studentRepositoryProvider),
        isA<FallbackStudentRepository>(),
      );
    });
  });
}
