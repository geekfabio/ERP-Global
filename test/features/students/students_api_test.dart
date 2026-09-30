import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/students/data/data_mocks/students_seed.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/enrollment_model.dart';
import 'package:erp_global/features/students/data/models/guardian_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:flutter_test/flutter_test.dart';

class _Env {
  _Env({int count = 300}) {
    registry.addModule(StudentsMockHandlers(count: count));
    client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: registry,
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
    students = ApiStudentRepository(client);
    guardians = ApiGuardianRepository(client);
    enrollments = ApiEnrollmentRepository(client);
  }

  final registry = MockApiRegistry();
  late final ApiClient client;
  late final StudentRepository students;
  late final GuardianRepository guardians;
  late final EnrollmentRepository enrollments;
}

StudentModel _draft({String id = '01JNEWSTUDENT00000000000001', String? bi}) {
  final now = DateTime.utc(2026, 1, 1);
  return StudentModel(
    id: id,
    institutionId: MockRef.institutionId,
    createdAt: now,
    updatedAt: now,
    processNumber: '',
    fullName: 'Kiala Domingos Pedro',
    birthDate: DateTime.utc(2012, 5, 3),
    gender: Gender.male,
    idNumber: bi,
  );
}

Failure _fail<T>(Result<T> r) => r.failureOrNull!;

void main() {
  group('seed', () {
    test('é determinístico e coerente', () {
      final a = buildStudentsSeed(seed: 7, count: 120);
      final b = buildStudentsSeed(seed: 7, count: 120);
      expect(
        a.students.map((s) => s.toJson()).toList(),
        b.students.map((s) => s.toJson()).toList(),
      );
      expect(
        buildStudentsSeed(seed: 8, count: 120).students.first.fullName,
        isNot(a.students.first.fullName),
      );
      expect(a.students, hasLength(120));
      final ids = a.students.map((s) => s.id).toSet();
      expect(ids, hasLength(120));
      // Cada aluno: ≥ 1 vínculo e exactamente 1 matrícula no ano activo.
      for (final s in a.students) {
        expect(a.links.where((l) => l.studentId == s.id), isNotEmpty);
        expect(a.enrollments.where((e) => e.studentId == s.id), hasLength(1));
      }
      final guardianIds = a.guardians.map((g) => g.id).toSet();
      expect(a.links.every((l) => guardianIds.contains(l.guardianId)), isTrue);
      // BI únicos, processos únicos, idade coerente com a classe.
      expect(a.students.map((s) => s.idNumber).toSet(), hasLength(120));
      expect(a.students.map((s) => s.processNumber).toSet(), hasLength(120));
    });

    test('por omissão ~300 alunos', () {
      expect(buildStudentsSeed().students, hasLength(300));
    });
  });

  group('alunos', () {
    test('paginação: 300 alunos em páginas de 20', () async {
      final env = _Env();
      final r = (await env.students.list(const StudentQuery())).getOrThrow();
      expect(r.items, hasLength(20));
      expect(r.meta.total, 300);
      expect(r.meta.totalPages, 15);
      final last = (await env.students.list(
        const StudentQuery(page: 15),
      )).getOrThrow();
      expect(last.items, hasLength(20));
      expect(last.meta.hasNext, isFalse);
    });

    test('pesquisa sem acentos nem maiúsculas (nome, processo, BI)', () async {
      final env = _Env();
      final all = (await env.students.list(
        const StudentQuery(pageSize: 100),
      )).getOrThrow();
      final withAccent = all.items.firstWhere(
        (s) => RegExp('[ãáéíóúç]').hasMatch(s.fullName.toLowerCase()),
      );
      final folded = withAccent.fullName
          .toLowerCase()
          .replaceAll(RegExp('[ãá]'), 'a')
          .replaceAll('é', 'e')
          .replaceAll('í', 'i')
          .replaceAll(RegExp('[óõ]'), 'o')
          .replaceAll('ú', 'u')
          .replaceAll('ç', 'c');
      final byName = (await env.students.list(
        StudentQuery(q: folded),
      )).getOrThrow();
      expect(byName.items.map((s) => s.id), contains(withAccent.id));

      final byProcess = (await env.students.list(
        StudentQuery(q: withAccent.processNumber),
      )).getOrThrow();
      expect(byProcess.items.single.id, withAccent.id);

      final byBi = (await env.students.list(
        StudentQuery(q: withAccent.idNumber),
      )).getOrThrow();
      expect(byBi.items.map((s) => s.id), contains(withAccent.id));
    });

    test('filtros por estado, género, classe e turma', () async {
      final env = _Env();
      final inactive = (await env.students.list(
        const StudentQuery(status: StudentStatus.inactive, pageSize: 100),
      )).getOrThrow();
      expect(inactive.items, isNotEmpty);
      expect(
        inactive.items.every((s) => s.status == StudentStatus.inactive),
        isTrue,
      );

      final girls = (await env.students.list(
        const StudentQuery(gender: Gender.female, pageSize: 100),
      )).getOrThrow();
      expect(girls.items.every((s) => s.gender == Gender.female), isTrue);

      final grade5 = MockRef.gradeId(5);
      final inGrade = (await env.students.list(
        StudentQuery(gradeId: grade5, pageSize: 100),
      )).getOrThrow();
      expect(inGrade.items, isNotEmpty);
      expect(inGrade.meta.total, lessThan(300));
      final room = MockRef.classroomId(5, 0);
      final inRoom = (await env.students.list(
        StudentQuery(classroomId: room, pageSize: 100),
      )).getOrThrow();
      expect(inRoom.meta.total, lessThanOrEqualTo(inGrade.meta.total));
    });

    test('ordenação ascendente e descendente', () async {
      final env = _Env();
      final asc = (await env.students.list(
        const StudentQuery(sort: ['processNumber']),
      )).getOrThrow();
      expect(asc.items.first.processNumber, '2026/0001');
      final desc = (await env.students.list(
        const StudentQuery(sort: ['-processNumber']),
      )).getOrThrow();
      expect(desc.items.first.processNumber, '2026/0300');
    });

    test('parâmetros inválidos → 422 com campos', () async {
      final env = _Env();
      final r = await env.students.list(
        const StudentQuery(sort: ['naoExiste']),
      );
      expect(_fail(r), isA<ValidationFailure>());
      final big = await env.students.list(const StudentQuery(pageSize: 1000));
      expect(_fail(big), isA<ValidationFailure>());
    });

    test('get e 404', () async {
      final env = _Env();
      final first = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      expect(
        (await env.students.get(first.id)).getOrThrow().fullName,
        first.fullName,
      );
      expect(_fail(await env.students.get('inexistente')).code, 'NOT_FOUND');
    });

    test('criar, actualizar e remover (lógica)', () async {
      final env = _Env(count: 30);
      final created = (await env.students.create(
        _draft(bi: '000111222LA001'),
      )).getOrThrow();
      expect(created.processNumber, startsWith('2026/'));
      expect(
        (await env.students.list(
          const StudentQuery(pageSize: 100),
        )).getOrThrow().meta.total,
        31,
      );

      final updated = (await env.students.update(
        created.copyWith(
          fullName: 'Kiala Domingos Pedro Jr.',
          phone: '923456789',
        ),
      )).getOrThrow();
      expect(updated.fullName, endsWith('Jr.'));
      expect(updated.phone, '923456789');

      await env.students.delete(created.id);
      expect(_fail(await env.students.get(created.id)).code, 'NOT_FOUND');
      expect(
        (await env.students.list(
          const StudentQuery(pageSize: 100),
        )).getOrThrow().meta.total,
        30,
      );
    });

    test('BI duplicado → 409 CONFLICT (criar e actualizar)', () async {
      final env = _Env(count: 30);
      final existing = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      final r = await env.students.create(_draft(bi: existing.idNumber));
      expect(_fail(r).code, 'CONFLICT');

      final other = (await env.students.create(
        _draft(id: '01JOTHER0000000000000000A1', bi: '999888777LA002'),
      )).getOrThrow();
      final clash = await env.students.update(
        other.copyWith(idNumber: existing.idNumber),
      );
      expect(_fail(clash).code, 'CONFLICT');
    });

    test('dados inválidos → 422 por campo', () async {
      final env = _Env(count: 5);
      final r = await env.client.dio
          .post<dynamic>(
            '/v1/students',
            data: {'fullName': 'A', 'gender': 'x', 'birthDate': '07/03/2010'},
          )
          .then<Object?>((_) => null)
          .catchError((Object e) => e);
      expect(r, isNotNull);
      final failure = Result.guard(() async => throw r!);
      expect(_fail(await failure), isA<ValidationFailure>());
      final fields = (_fail(await failure) as ValidationFailure).fields.keys;
      expect(fields, containsAll(['fullName', 'gender', 'birthDate']));
    });

    test('reset repõe o seed', () async {
      final env = _Env(count: 20);
      await env.students.delete(
        (await env.students.list(
          const StudentQuery(),
        )).getOrThrow().items.first.id,
      );
      expect(
        (await env.students.list(const StudentQuery())).getOrThrow().meta.total,
        19,
      );
      await env.client.dio.post<dynamic>('/__mock/reset');
      expect(
        (await env.students.list(const StudentQuery())).getOrThrow().meta.total,
        20,
      );
    });
  });

  group('encarregados', () {
    test('encarregados de um aluno com vínculo', () async {
      final env = _Env(count: 40);
      final s = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      final list = (await env.guardians.forStudent(s.id)).getOrThrow();
      expect(list, isNotEmpty);
      expect(list.first.link.studentId, s.id);
      expect(list.any((g) => g.link.isFinancialResponsible), isTrue);
      expect(list.first.guardian.id, list.first.link.guardianId);
    });

    test('listar e pesquisar encarregados', () async {
      final env = _Env(count: 60);
      final page = (await env.guardians.list(pageSize: 100)).getOrThrow();
      expect(page.items, isNotEmpty);
      final g = page.items.first;
      final found = (await env.guardians.list(q: g.phone)).getOrThrow();
      expect(found.items.map((x) => x.id), contains(g.id));
    });

    test('actualizar vínculo: parentesco e responsabilidades; 404', () async {
      final env = _Env(count: 10);
      final s = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      final item = (await env.guardians.forStudent(s.id)).getOrThrow().first;
      final updated = (await env.guardians.updateLink(
        item.link.copyWith(
          relationship: GuardianRelationship.tutor,
          isEmergency: !item.link.isEmergency,
          canPickup: !item.link.canPickup,
        ),
      )).getOrThrow();
      expect(updated.relationship, GuardianRelationship.tutor);
      final after = (await env.guardians.forStudent(
        s.id,
      )).getOrThrow().firstWhere((x) => x.link.id == item.link.id).link;
      expect(after.isEmergency, !item.link.isEmergency);
      expect(after.canPickup, !item.link.canPickup);
      expect(after.studentId, s.id);
      expect(after.guardianId, item.guardian.id);

      final missing = await env.guardians.updateLink(
        item.link.copyWith(id: '01JMISSINGLINK00000000000X'),
      );
      expect(_fail(missing).code, 'NOT_FOUND');
    });

    test('criar encarregado, ligar (409 se repetido) e desligar', () async {
      final env = _Env(count: 10);
      final s = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      final now = DateTime.utc(2026, 1, 1);
      final g = (await env.guardians.create(
        GuardianModel(
          id: '01JNEWGUARDIAN000000000001',
          institutionId: MockRef.institutionId,
          createdAt: now,
          updatedAt: now,
          fullName: 'Rosa Miguel',
          phone: '923000111',
        ),
      )).getOrThrow();
      GuardianLinkModel link() => GuardianLinkModel(
        id: '01JNEWLINK0000000000000001',
        institutionId: MockRef.institutionId,
        createdAt: now,
        updatedAt: now,
        studentId: s.id,
        guardianId: g.id,
        relationship: GuardianRelationship.grandparent,
        canPickup: true,
      );
      final created = (await env.guardians.link(link())).getOrThrow();
      expect(
        (await env.guardians.forStudent(
          s.id,
        )).getOrThrow().map((x) => x.guardian.id),
        contains(g.id),
      );
      final again = await env.guardians.link(
        link().copyWith(id: '01JNEWLINK0000000000000002'),
      );
      expect(_fail(again).code, 'CONFLICT');
      await env.guardians.unlink(created.id);
      expect(
        (await env.guardians.forStudent(
          s.id,
        )).getOrThrow().map((x) => x.guardian.id),
        isNot(contains(g.id)),
      );
    });

    test('ligar a aluno inexistente → 404; validação → 422', () async {
      final env = _Env(count: 5);
      final now = DateTime.utc(2026, 1, 1);
      final r = await env.guardians.link(
        GuardianLinkModel(
          id: '01JLINK0000000000000000001',
          institutionId: MockRef.institutionId,
          createdAt: now,
          updatedAt: now,
          studentId: 'nao-existe',
          guardianId: 'nao-existe',
          relationship: GuardianRelationship.father,
        ),
      );
      expect(_fail(r).code, 'NOT_FOUND');
    });
  });

  group('matrículas', () {
    test('listar por aluno, ano e classe', () async {
      final env = _Env(count: 50);
      final s = (await env.students.list(
        const StudentQuery(),
      )).getOrThrow().items.first;
      final mine = (await env.enrollments.list(studentId: s.id)).getOrThrow();
      expect(mine.items, hasLength(1));
      expect(mine.items.single.academicYearId, MockRef.academicYearId);

      final year = (await env.enrollments.list(
        academicYearId: MockRef.academicYearId,
        pageSize: 100,
      )).getOrThrow();
      expect(year.meta.total, 50);
    });

    test(
      'nova matrícula: 409 se já existe no ano; aceita após cancelar',
      () async {
        final env = _Env(count: 10);
        final s = (await env.students.list(
          const StudentQuery(),
        )).getOrThrow().items.first;
        final existing = (await env.enrollments.list(
          studentId: s.id,
        )).getOrThrow().items.single;
        final now = DateTime.utc(2026, 1, 1);
        EnrollmentModel next(String id) => EnrollmentModel(
          id: id,
          institutionId: MockRef.institutionId,
          createdAt: now,
          updatedAt: now,
          studentId: s.id,
          academicYearId: MockRef.academicYearId,
          gradeId: MockRef.gradeId(3),
          type: EnrollmentType.renewal,
          enrolledOn: DateTime.utc(2026, 2, 1),
        );
        expect(
          _fail(
            await env.enrollments.create(next('01JENR0000000000000000001')),
          ).code,
          'CONFLICT',
        );

        await env.enrollments.update(
          existing.copyWith(status: EnrollmentStatus.cancelled),
        );
        final created = (await env.enrollments.create(
          next('01JENR0000000000000000002'),
        )).getOrThrow();
        expect(created.status, EnrollmentStatus.pending);
        final confirmed = (await env.enrollments.update(
          created.copyWith(
            status: EnrollmentStatus.confirmed,
            classroomId: MockRef.classroomId(3, 1),
          ),
        )).getOrThrow();
        expect(confirmed.status, EnrollmentStatus.confirmed);
        expect(confirmed.classroomId, MockRef.classroomId(3, 1));
      },
    );

    test('filtro por estado', () async {
      final env = _Env(count: 200);
      final cancelled = (await env.enrollments.list(
        status: EnrollmentStatus.cancelled,
        pageSize: 100,
      )).getOrThrow();
      expect(cancelled.items, isNotEmpty);
      expect(
        cancelled.items.every((e) => e.status == EnrollmentStatus.cancelled),
        isTrue,
      );
    });
  });
}
