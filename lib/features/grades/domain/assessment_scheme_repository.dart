import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/assessment_scheme_model.dart';

const schemeReadPermission = 'grades.scheme.read';
const schemeUpdatePermission = 'grades.scheme.update';

/// Leitura com `grades.scheme.read`; escrita com `grades.scheme.update`.
/// Erros: 422 por campo (pesos ≠ 100, escala…), 409 em esquema duplicado
/// para a mesma classe/curso.
abstract interface class AssessmentSchemeRepository {
  Future<Result<PagedList<AssessmentSchemeModel>>> list({
    int page = 1,
    int pageSize = 100,
    String? gradeId,
    String? courseId,
  });

  Future<Result<AssessmentSchemeModel>> create(AssessmentSchemeModel value);

  Future<Result<AssessmentSchemeModel>> update(
    String id,
    AssessmentSchemeModel value,
  );

  Future<Result<void>> delete(String id);
}
