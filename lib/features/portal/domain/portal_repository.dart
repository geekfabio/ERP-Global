import '../../../core/errors/result.dart';
import '../data/models/portal_models.dart';

/// Códigos dos módulos que alimentam a Home do portal.
const portalSummaryModules = ['grades', 'attendance', 'billing', 'cards'];

/// Portal do encarregado/aluno. O servidor só devolve educandos vinculados à
/// conta autenticada; qualquer outro `studentId` dá `403 FORBIDDEN`.
abstract interface class PortalRepository {
  Future<Result<List<PortalPupil>>> pupils();

  /// Resumo do educando, só com as secções dos [modules] pedidos
  /// (subconjunto de [portalSummaryModules], os licenciados).
  Future<Result<PortalSummary>> summary(
    String studentId, {
    required Set<String> modules,
  });
}
