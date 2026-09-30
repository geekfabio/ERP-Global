import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/utils/seed_generator.dart';
import '../models/enrollment_model.dart';
import '../models/guardian_model.dart';
import '../models/student_enums.dart';
import '../models/student_model.dart';

/// Conjunto coerente de alunos, encarregados, vínculos e matrículas.
class StudentsSeed {
  const StudentsSeed({
    required this.students,
    required this.guardians,
    required this.links,
    required this.enrollments,
  });

  final List<StudentModel> students;
  final List<GuardianModel> guardians;
  final List<GuardianLinkModel> links;
  final List<EnrollmentModel> enrollments;
}

/// Gera o seed (mesma [seed] → mesmos dados). Por omissão ~300 alunos; irmãos
/// partilham encarregado; cada aluno tem uma matrícula confirmada no ano activo.
StudentsSeed buildStudentsSeed({int seed = 42, int count = 300}) {
  final gen = SeedGenerator(seed);
  final at = DateTime.utc(2025, 9, 1);
  final students = <StudentModel>[];
  final guardians = <GuardianModel>[];
  final links = <GuardianLinkModel>[];
  final enrollments = <EnrollmentModel>[];

  GuardianModel? previous;
  var previousSurname = '';

  for (var i = 0; i < count; i++) {
    final gender = gen.gender();
    final g = gender == SeedGender.male ? Gender.male : Gender.female;
    final gradeIndex = gen.random.nextInt(MockRef.gradeCount);
    final age = MockRef.gradeAge(gradeIndex);

    // ~25 % dos alunos são irmãos do anterior: mesmo encarregado e apelido.
    final sibling = previous != null && gen.random.chance(0.25);
    final guardian = sibling ? previous : _newGuardian(gen, at);
    if (!sibling) {
      guardians.add(guardian);
      previous = guardian;
      previousSurname = guardian.fullName.split(' ').last;
    }
    final surname = sibling
        ? previousSurname
        : guardian.fullName.split(' ').last;

    final studentId = gen.ulid(at.add(Duration(minutes: i)));
    final name =
        '${gen.firstName(gender)} ${gen.random.pick(SeedGenerator.surnames)} $surname';
    final statusRoll = gen.random.nextInt(100);
    final status = statusRoll < 4
        ? StudentStatus.inactive
        : statusRoll < 7
        ? StudentStatus.transferred
        : StudentStatus.active;
    final hasAllergy = gen.random.chance(0.08);

    students.add(
      StudentModel(
        id: studentId,
        institutionId: MockRef.institutionId,
        campusId: MockRef.campusId,
        createdAt: at,
        updatedAt: at,
        processNumber: '2026/${(i + 1).toString().padLeft(4, '0')}',
        fullName: name,
        birthDate: gen.birthDate(minAge: age, maxAge: age),
        birthPlace: gen.random.pick(const [
          'Luanda',
          'Benguela',
          'Huambo',
          'Lubango',
          'Malanje',
          'Cabinda',
        ]),
        gender: g,
        idNumber: gen.bi(),
        address:
            'Bairro ${gen.random.pick(const ['Maianga', 'Talatona', 'Viana', 'Cazenga', 'Kilamba'])}, Luanda',
        phone: age >= 13 ? gen.phone() : null,
        status: status,
        health: HealthInfo(
          bloodType: gen.random.pick(BloodType.values),
          allergies: hasAllergy
              ? [
                  gen.random.pick(const ['amendoim', 'lactose', 'pólen']),
                ]
              : const [],
        ),
      ),
    );

    // Vínculo principal (responsável financeiro) e, às vezes, um segundo.
    links.add(
      GuardianLinkModel(
        id: gen.ulid(at),
        institutionId: MockRef.institutionId,
        createdAt: at,
        updatedAt: at,
        studentId: studentId,
        guardianId: guardian.id,
        relationship: gen.random.chance(0.5)
            ? GuardianRelationship.mother
            : GuardianRelationship.father,
        isFinancialResponsible: true,
        isEmergency: true,
        canPickup: true,
        verified: true,
      ),
    );
    if (gen.random.chance(0.4)) {
      final other = _newGuardian(gen, at);
      guardians.add(other);
      links.add(
        GuardianLinkModel(
          id: gen.ulid(at),
          institutionId: MockRef.institutionId,
          createdAt: at,
          updatedAt: at,
          studentId: studentId,
          guardianId: other.id,
          relationship: GuardianRelationship.tutor,
          canPickup: true,
        ),
      );
    }

    final letter = gen.random.nextInt(MockRef.classroomLetters.length);
    enrollments.add(
      EnrollmentModel(
        id: gen.ulid(at),
        institutionId: MockRef.institutionId,
        campusId: MockRef.campusId,
        createdAt: at,
        updatedAt: at,
        studentId: studentId,
        academicYearId: MockRef.academicYearId,
        gradeId: MockRef.gradeId(gradeIndex),
        classroomId: MockRef.classroomId(gradeIndex, letter),
        shiftId: letter == 2
            ? MockRef.afternoonShiftId
            : MockRef.morningShiftId,
        rollNumber: gen.random.range(1, 40),
        type: gen.random.chance(0.3)
            ? EnrollmentType.newEnrollment
            : EnrollmentType.renewal,
        status: status == StudentStatus.active
            ? EnrollmentStatus.confirmed
            : EnrollmentStatus.cancelled,
        enrolledOn: DateTime.utc(2025, 9, gen.random.range(1, 20)),
        feeMinor: 1500000,
        feePaid: gen.random.chance(0.9),
      ),
    );
  }

  return StudentsSeed(
    students: students,
    guardians: guardians,
    links: links,
    enrollments: enrollments,
  );
}

GuardianModel _newGuardian(SeedGenerator gen, DateTime at) {
  final name = gen.fullName();
  return GuardianModel(
    id: gen.ulid(at),
    institutionId: MockRef.institutionId,
    createdAt: at,
    updatedAt: at,
    fullName: name,
    idNumber: gen.bi(),
    phone: gen.phone(),
    email: gen.random.chance(0.5) ? gen.email(name) : null,
    profession: gen.random.pick(const [
      'Professor',
      'Comerciante',
      'Enfermeira',
      'Engenheiro',
      'Motorista',
      'Funcionário público',
    ]),
  );
}
