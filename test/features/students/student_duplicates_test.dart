import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/features/students/data/mock_api/students_mock_handlers.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/data/models/student_model.dart';
import 'package:erp_global/features/students/data/repositories/api_student_repositories.dart';
import 'package:erp_global/features/students/domain/student_duplicates.dart';
import 'package:erp_global/features/students/domain/student_repositories.dart';
import 'package:erp_global/features/students/presentation/widgets/student_wizard/student_wizard_data.dart';
import 'package:flutter_test/flutter_test.dart';

StudentModel _student({
  String id = '01JEXISTING0000000000000001',
  String name = 'João Manuel da Silva',
  String? bi = '004567890LA041',
  DateTime? birth,
}) {
  final now = DateTime.utc(2026, 1, 1);
  return StudentModel(
    id: id,
    institutionId: MockRef.institutionId,
    createdAt: now,
    updatedAt: now,
    processNumber: '2026/0001',
    fullName: name,
    birthDate: birth ?? DateTime.utc(2012, 5, 9),
    gender: Gender.male,
    idNumber: bi,
  );
}

void main() {
  group('findStudentDuplicates', () {
    final existing = [_student()];

    test('mesmo BI (ignora espaços e maiúsculas) bloqueia', () {
      final r = findStudentDuplicates(
        existing,
        fullName: 'Outro Nome',
        birthDate: DateTime.utc(2010, 1, 1),
        idNumber: '004567890 la041',
      );
      expect(r, hasLength(1));
      expect(r.single.reason, DuplicateReason.idNumber);
      expect(r.single.blocking, isTrue);
    });

    test('mesmo nome (sem acentos) e data de nascimento só alerta', () {
      final r = findStudentDuplicates(
        existing,
        fullName: '  joao manuel  da silva ',
        birthDate: DateTime.utc(2012, 5, 9),
      );
      expect(r.single.reason, DuplicateReason.nameAndBirth);
      expect(r.single.blocking, isFalse);
    });

    test('nome igual com outra data, ou data igual com outro nome: não', () {
      expect(
        findStudentDuplicates(
          existing,
          fullName: 'João Manuel da Silva',
          birthDate: DateTime.utc(2012, 5, 10),
        ),
        isEmpty,
      );
      expect(
        findStudentDuplicates(
          existing,
          fullName: 'Maria Silva',
          birthDate: DateTime.utc(2012, 5, 9),
        ),
        isEmpty,
      );
    });

    test('ignora removidos e o próprio aluno', () {
      final removed = _student(id: 'A').copyWith(deletedAt: DateTime.utc(2026));
      expect(
        findStudentDuplicates(
          [removed],
          fullName: removed.fullName,
          birthDate: removed.birthDate,
          idNumber: removed.idNumber,
        ),
        isEmpty,
      );
      expect(
        findStudentDuplicates(
          existing,
          fullName: existing.first.fullName,
          birthDate: existing.first.birthDate,
          idNumber: existing.first.idNumber,
          exceptId: existing.first.id,
        ),
        isEmpty,
      );
    });
  });

  group('Mock API: duplicados no cadastro', () {
    late StudentsMockHandlersEnv env;
    setUp(() => env = StudentsMockHandlersEnv());

    Future<StudentModel> seeded() async => (await env.repo.list(
      const StudentQuery(),
    )).getOrThrow().items.firstWhere((s) => s.idNumber != null);

    StudentModel fresh(StudentModel like, {String? bi, String? name}) =>
        _student(
          id: '01JNEWSTUDENT00000000000001',
          name: name ?? like.fullName,
          bi: bi,
          birth: like.birthDate,
        );

    test('BI repetido → 409 CONFLICT, mesmo com confirmDuplicate', () async {
      final like = await seeded();
      for (final confirm in [false, true]) {
        final r = await env.repo.create(
          fresh(like, bi: like.idNumber, name: 'Nome Diferente Qualquer'),
          confirmDuplicate: confirm,
        );
        expect(r.isOk, isFalse);
        expect(r.when(ok: (_) => '', err: (f) => f.code), 'CONFLICT');
      }
    });

    test('nome + nascimento repetidos → 409; com confirmação cria', () async {
      final like = await seeded();
      final blocked = await env.repo.create(fresh(like, bi: null));
      expect(blocked.when(ok: (_) => '', err: (f) => f.code), 'CONFLICT');

      final ok = await env.repo.create(
        fresh(like, bi: null),
        confirmDuplicate: true,
      );
      expect(ok.isOk, isTrue);
    });

    test('findDuplicates devolve o motivo', () async {
      final like = await seeded();
      final byBi = (await env.repo.findDuplicates(
        fullName: 'Ninguém Conhecido',
        birthDate: DateTime.utc(2000, 1, 1),
        idNumber: like.idNumber,
      )).getOrThrow();
      expect(byBi.single.reason, DuplicateReason.idNumber);
      expect(byBi.single.student.id, like.id);

      final byName = (await env.repo.findDuplicates(
        fullName: like.fullName.toUpperCase(),
        birthDate: like.birthDate,
      )).getOrThrow();
      expect(
        byName.map((d) => d.reason),
        contains(DuplicateReason.nameAndBirth),
      );

      final none = (await env.repo.findDuplicates(
        fullName: 'Ninguém Conhecido',
        birthDate: DateTime.utc(2000, 1, 1),
      )).getOrThrow();
      expect(none, isEmpty);
    });
  });

  group('dados do wizard', () {
    final values = <String, Object?>{
      WizardKeys.fullName: '  Ana Maria Pedro ',
      WizardKeys.birthDate: '2014-03-02',
      WizardKeys.gender: 'female',
      WizardKeys.idNumber: '',
      WizardKeys.allergies: 'pólen; amendoim, ',
      WizardKeys.bloodType: 'oPositive',
      WizardKeys.hasSpecialNeeds: false,
      WizardKeys.specialNeedsNotes: 'ignorado sem NEE',
      WizardKeys.guardians: [
        const WizardGuardian(
          fullName: 'Rosa Pedro',
          phone: '923456789',
          relationship: GuardianRelationship.mother,
          isFinancialResponsible: true,
        ).toMap(),
      ],
      WizardKeys.documents: ['idCard', 'vaccination'],
    };

    test('monta o aluno com campos limpos e saúde', () {
      final s = wizardStudent(
        values,
        id: '01JNEW',
        now: DateTime.utc(2026, 2, 1),
      );
      expect(s.fullName, 'Ana Maria Pedro');
      expect(s.birthDate, DateTime.utc(2014, 3, 2));
      expect(s.gender, Gender.female);
      expect(s.idNumber, isNull);
      expect(s.nationality, 'Angolana');
      expect(s.health.allergies, ['pólen', 'amendoim']);
      expect(s.health.bloodType, BloodType.oPositive);
      expect(s.health.specialNeedsNotes, isNull);
      expect(s.processNumber, isEmpty);
    });

    test('encarregados e documentos sobrevivem ao rascunho (JSON simples)', () {
      final g = wizardGuardians(values).single;
      expect(g.fullName, 'Rosa Pedro');
      expect(g.relationship, GuardianRelationship.mother);
      expect(g.isFinancialResponsible, isTrue);
      expect(wizardDocuments(values), [
        StudentDocumentType.idCard,
        StudentDocumentType.vaccination,
      ]);
    });

    test('datas: formato yyyy-MM-dd e valores inválidos', () {
      expect(formatWizardDate(DateTime.utc(2014, 3, 2)), '2014-03-02');
      expect(parseWizardDate('2014-3-2'), isNull);
      expect(parseWizardDate(null), isNull);
    });
  });
}

/// Repository sobre o adaptador mock (instantâneo), com 20 alunos no seed.
class StudentsMockHandlersEnv {
  StudentsMockHandlersEnv() {
    registry.addModule(StudentsMockHandlers(count: 20));
    repo = ApiStudentRepository(
      ApiClient.create(
        baseUrl: 'https://api.test',
        useMockApi: true,
        registry: registry,
        mockConfig: const MockApiConfig.instant(),
        logging: false,
      ),
    );
  }

  final registry = MockApiRegistry();
  late final ApiStudentRepository repo;
}
