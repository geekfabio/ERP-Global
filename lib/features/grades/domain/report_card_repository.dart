import '../../../core/errors/result.dart';
import '../data/models/report_card_models.dart';

/// Leitura com `grades.entry.read`/`write`/`approve`; observações e envio
/// com `write` ou `approve`. Erros: 422 (`remarks`, `guardianIds`), 403.
abstract interface class ReportCardRepository {
  Future<Result<ReportCardStateModel>> state(String studentId, String termId);

  Future<Result<ReportCardStateModel>> saveRemarks(
    String studentId,
    String termId,
    String remarks,
  );

  /// Hook de envio ao encarregado: regista o envio aos [guardianIds].
  Future<Result<ReportCardStateModel>> send(
    String studentId,
    String termId,
    List<String> guardianIds,
  );
}
