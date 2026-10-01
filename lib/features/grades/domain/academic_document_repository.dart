import '../../../core/errors/result.dart';
import '../../../core/network/api_envelope.dart';
import '../data/models/academic_document_models.dart';

/// Leitura com `grades.document.read`/`request`/`issue`; pedido com
/// `request` (ou `issue`); emitir/anular com `issue`; modelos com
/// `template`. Erros: 422 (`studentId`, `body`...), 409 (estado inválido,
/// modelo em falta), 404, 403. A verificação por número é pública.
abstract interface class AcademicDocumentRepository {
  Future<Result<List<DocumentTemplateModel>>> templates();

  Future<Result<DocumentTemplateModel>> updateTemplate(String id, String body);

  Future<Result<PagedList<AcademicDocumentModel>>> list({
    int page = 1,
    int pageSize = 100,
    DocumentKind? kind,
    DocumentStatus? status,
    String? studentId,
  });

  Future<Result<AcademicDocumentModel>> request({
    required DocumentKind kind,
    required String studentId,
    required String studentName,
    required String processNumber,
    required String purpose,
    required Map<String, String> variables,
  });

  /// Atribui o número sequencial e fixa o texto final.
  Future<Result<AcademicDocumentModel>> issue(String id);

  Future<Result<AcademicDocumentModel>> cancel(String id);

  Future<Result<DocumentVerificationModel>> verify(String number);
}
