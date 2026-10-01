import '../../../core/errors/result.dart';
import '../../students/data/models/student_summaries_model.dart';
import '../data/models/portal_academic_models.dart';
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

  /// Notas por trimestre e boletins emitidos (módulo `grades`).
  Future<Result<StudentGradesSummary>> grades(String studentId);

  /// Presenças do ano lectivo, do mais recente para o mais antigo.
  Future<Result<StudentAttendanceSummary>> attendance(String studentId);

  /// Horário semanal da turma do educando (módulo `academic`).
  Future<Result<List<PortalScheduleSlot>>> schedule(String studentId);

  Future<Result<List<AbsenceJustificationRequest>>> justifications(
    String studentId,
  );

  /// Pede a justificação de uma falta. 422 sem motivo, data inválida ou sem
  /// falta injustificada nesse dia; 409 se já existe pedido para esse dia.
  Future<Result<AbsenceJustificationRequest>> requestJustification(
    String studentId, {
    required DateTime date,
    required String reason,
  });

  Future<Result<List<PortalDocumentRequest>>> documentRequests(
    String studentId,
  );

  /// Pede um documento à secretaria. 422 tipo inválido; 409 se já há um
  /// pedido pendente do mesmo tipo.
  Future<Result<PortalDocumentRequest>> requestDocument(
    String studentId, {
    required PortalDocumentKind kind,
    String? notes,
  });
}
