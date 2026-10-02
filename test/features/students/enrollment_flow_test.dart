import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/enrollment_model.dart';
import 'package:erp_global/features/students/data/models/enrollment_rules_model.dart';
import 'package:erp_global/features/students/data/models/student_document_model.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/enrollment_flow.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime.utc(2026, 1, 1);

EnrollmentModel _enrollment({
  EnrollmentStatus status = EnrollmentStatus.underReview,
  EnrollmentType type = EnrollmentType.newEnrollment,
  String? classroomId,
}) => EnrollmentModel(
  id: 'e1',
  institutionId: 'i',
  createdAt: _now,
  updatedAt: _now,
  studentId: 's1',
  academicYearId: MockRef.academicYearId,
  gradeId: MockRef.gradeId(1),
  type: type,
  status: status,
  enrolledOn: DateTime.utc(2026, 2, 1),
  classroomId: classroomId,
);

StudentDocumentModel _doc(StudentDocumentType t, {bool verified = true}) =>
    StudentDocumentModel(
      id: t.name,
      institutionId: 'i',
      createdAt: _now,
      updatedAt: _now,
      studentId: 's1',
      type: t,
      fileName: '${t.name}.pdf',
      verified: verified,
    );

const _rules = EnrollmentRulesModel(
  minAgeYears: 5,
  capacityPerClassroom: 2,
  requiredDocuments: {
    'new_enrollment': [StudentDocumentType.birthCertificate],
  },
);

String _room(EnrollmentModel e) => MockRef.classroomId(
  [
    for (var i = 0; i < MockRef.gradeCount; i++) MockRef.gradeId(i),
  ].indexOf(e.gradeId),
  0,
);

void main() {
  group('regras puras', () {
    test('transições só para a frente', () {
      expect(
        canTransitionEnrollment(
          EnrollmentStatus.application,
          EnrollmentStatus.underReview,
        ),
        isTrue,
      );
      expect(
        canTransitionEnrollment(
          EnrollmentStatus.application,
          EnrollmentStatus.confirmed,
        ),
        isFalse,
      );
      expect(nextEnrollmentStatus(EnrollmentStatus.confirmed), isNull);
    });

    test('idade em anos completos', () {
      expect(ageOn(DateTime.utc(2020, 6, 1), DateTime.utc(2026, 5, 31)), 5);
      expect(ageOn(DateTime.utc(2020, 6, 1), DateTime.utc(2026, 6, 1)), 6);
    });

    Map<String, String> approve({
      required DateTime birth,
      required List<StudentDocumentModel> docs,
      EnrollmentType type = EnrollmentType.newEnrollment,
      bool seats = true,
    }) => enrollmentViolations(
      enrollment: _enrollment(type: type),
      to: EnrollmentStatus.approved,
      birthDate: birth,
      documents: docs,
      rules: _rules,
      seatsFree: seats,
    );

    test('aprovação: idade, documentos e vagas', () {
      final ok = approve(
        birth: DateTime.utc(2018, 1, 1),
        docs: [_doc(StudentDocumentType.birthCertificate)],
      );
      expect(ok, isEmpty);
      final bad = approve(
        birth: DateTime.utc(2024, 1, 1),
        docs: [_doc(StudentDocumentType.birthCertificate, verified: false)],
        seats: false,
      );
      expect(bad.keys, containsAll(['age', 'documents', 'classroomId']));
    });

    test('renovação não tem idade mínima', () {
      final v = approve(
        birth: DateTime.utc(2024, 1, 1),
        docs: const [],
        type: EnrollmentType.renewal,
      );
      expect(v, isEmpty);
    });

    test('confirmar exige turma com vaga', () {
      Map<String, String> confirm({String? room, bool seats = true}) =>
          enrollmentViolations(
            enrollment: _enrollment(status: EnrollmentStatus.approved),
            to: EnrollmentStatus.confirmed,
            birthDate: DateTime.utc(2018, 1, 1),
            documents: const [],
            rules: _rules,
            seatsFree: seats,
            classroomId: room,
          );
      expect(confirm().keys, ['classroomId']);
      expect(confirm(room: 'r', seats: false).keys, ['classroomId']);
      expect(confirm(room: 'r'), isEmpty);
    });
  });

  group('API mock', () {
    late ApiEnrollmentRepository repo;
    late ApiEnrollmentRulesRepository rulesRepo;
    late ApiStudentDocumentRepository docs;
    late EnrollmentWorkflow workflow;
    late DomainEventBus bus;
    late EnrollmentModel enrollment;
    late String studentId;

    setUp(() async {
      final registry = MockApiRegistry()
        ..addModule(StudentsMockHandlers(count: 20));
      final client = ApiClient.create(
        baseUrl: 'https://api.test',
        useMockApi: true,
        registry: registry,
        mockConfig: const MockApiConfig.instant(),
        logging: false,
      );
      repo = ApiEnrollmentRepository(client);
      rulesRepo = ApiEnrollmentRulesRepository(client);
      docs = ApiStudentDocumentRepository(client);
      bus = DomainEventBus();
      workflow = EnrollmentWorkflow(repo, bus);
      final all = (await repo.list(pageSize: 100)).getOrThrow().items;
      final seed = all.first;
      studentId = seed.studentId;
      // Aluno com matrícula num ano novo, para não colidir com o seed.
      enrollment = (await repo.create(
        seed.copyWith(
          id: '01JNEWENROLLMENT0000000001',
          academicYearId: 'year-next',
          status: EnrollmentStatus.application,
          type: EnrollmentType.newEnrollment,
          classroomId: null,
          rollNumber: null,
          enrolledOn: DateTime.utc(2026, 9, 1),
        ),
      )).getOrThrow();
    });

    Future<void> deliver(StudentDocumentType t) async {
      await docs.create(
        StudentDocumentModel(
          id: '01JDOC${t.name}'.padRight(26, '0').substring(0, 26),
          institutionId: 'i',
          createdAt: _now,
          updatedAt: _now,
          studentId: studentId,
          type: t,
          fileName: 'x.pdf',
          verified: true,
        ),
      );
    }

    test('fluxo completo publica EnrollmentConfirmed', () async {
      final events = <EnrollmentConfirmed>[];
      bus.on<EnrollmentConfirmed>().listen(events.add);
      await deliver(StudentDocumentType.birthCertificate);
      await deliver(StudentDocumentType.photo);

      final review = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.underReview,
      );
      expect(review.getOrThrow().status, EnrollmentStatus.underReview);
      await workflow.transition(enrollment.id, EnrollmentStatus.approved);

      // Sem turma não confirma.
      final noRoom = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.confirmed,
      );
      expect(
        (noRoom.failureOrNull! as ValidationFailure).fields,
        contains('classroomId'),
      );
      expect(events, isEmpty);

      final room = _room(enrollment);
      final done = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.confirmed,
        classroomId: room,
      );
      expect(done.getOrThrow().classroomId, room);
      expect(done.getOrThrow().rollNumber, isPositive);
      expect(events, hasLength(1));
      expect(events.single.enrollmentId, enrollment.id);
      expect(events.single.type, 'new_enrollment');
    });

    test('aprovar sem documentos → 422 por campo', () async {
      await workflow.transition(enrollment.id, EnrollmentStatus.underReview);
      final r = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.approved,
      );
      final f = r.failureOrNull! as ValidationFailure;
      expect(f.fields.keys, contains('documents'));
    });

    test('transição inválida → 409', () async {
      final r = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.confirmed,
      );
      expect(r.failureOrNull!.code, 'CONFLICT');
    });

    test('regras configuráveis: idade mínima e vagas', () async {
      final current = (await rulesRepo.get()).getOrThrow();
      expect(current.minAgeYears, 5);
      final saved = await rulesRepo.save(
        current.copyWith(minAgeYears: 25, requiredDocuments: const {}),
      );
      expect(saved.getOrThrow().minAgeYears, 25);
      await workflow.transition(enrollment.id, EnrollmentStatus.underReview);
      final r = await workflow.transition(
        enrollment.id,
        EnrollmentStatus.approved,
      );
      expect(
        (r.failureOrNull! as ValidationFailure).fields.keys,
        contains('age'),
      );
      final invalid = await rulesRepo.save(current.copyWith(minAgeYears: -1));
      expect(invalid.failureOrNull, isA<ValidationFailure>());
    });

    test('turma cheia recusa atribuição', () async {
      final current = (await rulesRepo.get()).getOrThrow();
      await rulesRepo.save(
        current.copyWith(capacityPerClassroom: 1, requiredDocuments: const {}),
      );
      await workflow.transition(enrollment.id, EnrollmentStatus.underReview);
      await workflow.transition(enrollment.id, EnrollmentStatus.approved);
      final room = _room(enrollment);
      expect((await repo.assignClassroom(enrollment.id, room)).isOk, isTrue);

      final vacancies = (await repo.vacancies(
        gradeId: enrollment.gradeId,
        academicYearId: enrollment.academicYearId,
      )).getOrThrow();
      expect(vacancies, hasLength(3));
      expect(vacancies.first.hasRoom, isFalse);
    });
  });
}
