import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/academic_year_model.dart';
import '../data/models/term_model.dart';

/// Leitura aberta a qualquer utilizador autenticado (alimenta o selector da
/// topbar); escrita exige [academicUpdatePermission] (ver `academic_rules.dart`).
abstract interface class AcademicRepository {
  Future<Result<PagedList<AcademicYearModel>>> years({
    int page = 1,
    int pageSize = 100,
  });

  /// Cria um ano `planned` com [termCount] períodos repartidos pelas datas.
  Future<Result<AcademicYearModel>> createYear(Map<String, dynamic> values);

  Future<Result<AcademicYearModel>> updateYear(
    String id,
    Map<String, dynamic> values,
  );

  /// Avança o estado do ano; transições inválidas dão 409.
  Future<Result<AcademicYearModel>> transitionYear(
    String id,
    AcademicYearStatus to,
  );

  Future<Result<List<TermModel>>> terms(String yearId);

  /// Datas e prazo de notas (`startDate`, `endDate`, `gradesDeadline`).
  Future<Result<TermModel>> updateTerm(String id, Map<String, dynamic> values);

  /// Abre o período; se já foi fechado é uma reabertura (exige `approve`).
  Future<Result<TermModel>> openTerm(String id);

  Future<Result<TermModel>> closeTerm(String id);
}
