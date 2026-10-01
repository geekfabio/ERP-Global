import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/enrollment_model.dart';
import '../data/models/guardian_model.dart';
import '../data/models/student_document_model.dart';
import '../data/models/student_enums.dart';
import '../data/models/student_model.dart';
import '../data/models/student_occurrence_model.dart';
import '../data/models/student_summaries_model.dart';
import 'student_duplicates.dart';

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

  /// O `id` (ULID) é gerado no cliente (offline first). Duplicados → 409
  /// `CONFLICT`: BI repetido é sempre recusado; nome + data de nascimento
  /// repetidos só com [confirmDuplicate] (o utilizador já foi avisado).
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  });

  /// Possíveis duplicados (BI, ou nome + data de nascimento) — para avisar
  /// antes de guardar.
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  });
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

/// Educando com o seu vínculo a um encarregado (vista do encarregado).
class GuardianPupil {
  const GuardianPupil({required this.student, required this.link});

  final StudentModel student;
  final GuardianLinkModel link;
}

abstract interface class GuardianRepository {
  Future<Result<PagedList<GuardianModel>>> list({
    int page = 1,
    int pageSize = 20,
    String? q,
  });

  Future<Result<GuardianModel>> create(GuardianModel guardian);
  Future<Result<GuardianModel>> get(String id);
  Future<Result<GuardianModel>> update(GuardianModel guardian);

  /// Educandos de um encarregado, com o vínculo de cada um.
  Future<Result<List<GuardianPupil>>> pupilsOf(String guardianId);

  /// Encarregados de um aluno, com parentesco e responsabilidades.
  Future<Result<List<StudentGuardian>>> forStudent(String studentId);

  Future<Result<GuardianLinkModel>> link(GuardianLinkModel link);

  /// Altera parentesco e responsabilidades de um vínculo existente.
  Future<Result<GuardianLinkModel>> updateLink(GuardianLinkModel link);
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

/// Documentos entregues no cadastro do aluno.
abstract interface class StudentDocumentRepository {
  Future<Result<List<StudentDocumentModel>>> forStudent(String studentId);
  Future<Result<StudentDocumentModel>> create(StudentDocumentModel document);

  /// Altera validade e verificação (`verified`, `verifiedBy`, `verifiedAt`).
  Future<Result<StudentDocumentModel>> update(StudentDocumentModel document);
  Future<Result<void>> delete(String id);
}

/// Ocorrências disciplinares (mais recentes primeiro).
abstract interface class OccurrenceRepository {
  Future<Result<List<StudentOccurrenceModel>>> forStudent(String studentId);
  Future<Result<StudentOccurrenceModel>> create(
    StudentOccurrenceModel occurrence,
  );
  Future<Result<void>> delete(String id);
}

/// Vistas de leitura de outros módulos para a ficha do aluno. Só se pedem
/// quando o módulo respectivo está licenciado (o separador fica oculto).
abstract interface class StudentSummaryRepository {
  Future<Result<StudentGradesSummary>> grades(String studentId);
  Future<Result<StudentAttendanceSummary>> attendance(String studentId);
  Future<Result<StudentFinanceSummary>> finance(String studentId);
  Future<Result<StudentCardSummary>> card(String studentId);
}
