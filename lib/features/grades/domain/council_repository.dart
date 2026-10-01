import '../../../core/errors/result.dart';
import '../data/models/council_models.dart';

/// Exportação da pauta (PDF/Excel) pelo serviço de exportação.
const pautaExportPermission = 'grades.pauta.export';

/// Decidir e aprovar exigem `grades.entry.approve`; a leitura aceita
/// `read`/`write`/`approve`. Erros: 422 (`justification`, `results`),
/// 409 (pauta já aprovada), 403.
abstract interface class CouncilRepository {
  Future<Result<CouncilModel>> council(String classroomId, String yearId);

  Future<Result<CouncilModel>> decide(
    String classroomId,
    String yearId, {
    required String studentId,
    required FinalResult result,
    required String justification,
  });

  /// Aprova a pauta com os [results] finais (nenhum pode estar pendente).
  Future<Result<CouncilModel>> approve(
    String classroomId,
    String yearId,
    Map<String, FinalResult> results,
  );
}
