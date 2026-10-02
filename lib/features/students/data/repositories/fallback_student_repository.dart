import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_envelope.dart';
import '../../domain/student_duplicates.dart';
import '../../domain/student_repositories.dart';
import '../models/student_model.dart';

/// [StudentRepository] que tenta a API e, sem ligação (`NETWORK_ERROR` /
/// `TIMEOUT`), recorre ao repository local (Drift, que alimenta a outbox).
///
/// Erros de negócio (401/403/404/409/422/5xx) nunca disparam o fallback: são
/// respostas válidas do servidor e a UI deve vê-las tal como chegam.
class FallbackStudentRepository implements StudentRepository {
  FallbackStudentRepository({required this.remote, required this.local});

  final StudentRepository remote;
  final StudentRepository local;

  static bool _isOffline(Failure f) => f is NetworkFailure;

  Future<Result<T>> _run<T>(
    Future<Result<T>> Function(StudentRepository repo) call,
  ) async {
    final result = await call(remote);
    final failure = result.failureOrNull;
    if (failure != null && _isOffline(failure)) return call(local);
    return result;
  }

  @override
  Future<Result<PagedList<StudentModel>>> list(StudentQuery query) =>
      _run((r) => r.list(query));

  @override
  Future<Result<StudentModel>> get(String id) => _run((r) => r.get(id));

  @override
  Future<Result<StudentModel>> create(
    StudentModel student, {
    bool confirmDuplicate = false,
  }) => _run((r) => r.create(student, confirmDuplicate: confirmDuplicate));

  @override
  Future<Result<List<StudentDuplicate>>> findDuplicates({
    required String fullName,
    required DateTime birthDate,
    String? idNumber,
  }) => _run(
    (r) => r.findDuplicates(
      fullName: fullName,
      birthDate: birthDate,
      idNumber: idNumber,
    ),
  );

  @override
  Future<Result<StudentModel>> update(StudentModel student) =>
      _run((r) => r.update(student));

  @override
  Future<Result<void>> delete(String id) => _run((r) => r.delete(id));
}
