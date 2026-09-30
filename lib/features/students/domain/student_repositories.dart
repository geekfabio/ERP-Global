import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/enrollment_model.dart';
import '../data/models/guardian_model.dart';
import '../data/models/student_enums.dart';
import '../data/models/student_model.dart';

/// Pesquisa de alunos (feita no servidor/handler: paginação, filtros, ordenação).
class StudentQuery {
  const StudentQuery({
    this.page = 1,
    this.pageSize = 20,
    this.q,
    this.status,
    this.gender,
    this.gradeId,
    this.classroomId,
    this.sort = const ['fullName'],
  });

  final int page;
  final int pageSize;

  /// Texto livre: nome, n.º de processo, BI (sem acentos, sem maiúsculas).
  final String? q;
  final StudentStatus? status;
  final Gender? gender;

  /// Classe/turma da matrícula actual.
  final String? gradeId;
  final String? classroomId;

  /// Campos ordenáveis; prefixo `-` = descendente (`-processNumber`).
  final List<String> sort;

  StudentQuery copyWith({int? page, int? pageSize, String? q}) => StudentQuery(
    page: page ?? this.page,
    pageSize: pageSize ?? this.pageSize,
    q: q ?? this.q,
    status: status,
    gender: gender,
    gradeId: gradeId,
    classroomId: classroomId,
    sort: sort,
  );
}

/// Alunos. Erros chegam como `Failure` (`CONFLICT` BI duplicado, `VALIDATION_ERROR`…).
abstract interface class StudentRepository {
  Future<Result<PagedList<StudentModel>>> list(StudentQuery query);
  Future<Result<StudentModel>> get(String id);

  /// O `id` (ULID) é gerado no cliente (offline first).
  Future<Result<StudentModel>> create(StudentModel student);
  Future<Result<StudentModel>> update(StudentModel student);

  /// Remoção lógica (`deletedAt`); o aluno deixa de aparecer nas listagens.
  Future<Result<void>> delete(String id);
}

/// Encarregado com o seu vínculo a um aluno.
class StudentGuardian {
  const StudentGuardian({required this.guardian, required this.link});

  final GuardianModel guardian;
  final GuardianLinkModel link;
}

abstract interface class GuardianRepository {
  Future<Result<PagedList<GuardianModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
  });

  Future<Result<GuardianModel>> create(GuardianModel guardian);

  /// Encarregados de um aluno, com parentesco e responsabilidades.
  Future<Result<List<StudentGuardian>>> forStudent(String studentId);

  Future<Result<GuardianLinkModel>> link(GuardianLinkModel link);
  Future<Result<void>> unlink(String linkId);
}

abstract interface class EnrollmentRepository {
  Future<Result<PagedList<EnrollmentModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? studentId,
    String? academicYearId,
    String? gradeId,
    EnrollmentStatus? status,
  });

  Future<Result<EnrollmentModel>> create(EnrollmentModel enrollment);
  Future<Result<EnrollmentModel>> update(EnrollmentModel enrollment);
}
