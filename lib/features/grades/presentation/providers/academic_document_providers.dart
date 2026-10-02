import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/presentation/providers/student_pdf_providers.dart';
import '../../data/models/academic_document_models.dart';
import '../../data/repositories/api_academic_document_repository.dart';
import '../../domain/academic_document.dart';
import '../../domain/academic_document_repository.dart';
import '../pdf/academic_document_pdf_template.dart';
import 'report_card_providers.dart';

final academicDocumentRepositoryProvider = Provider<AcademicDocumentRepository>(
  (ref) => ApiAcademicDocumentRepository(ref.watch(apiClientProvider)),
);

final documentTemplatesProvider =
    FutureProvider.autoDispose<List<DocumentTemplateModel>>(
      (ref) async =>
          (await ref.watch(academicDocumentRepositoryProvider).templates())
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Filtro da lista de documentos (`null` = todos).
typedef DocumentFilter = ({DocumentKind? kind, DocumentStatus? status});

final academicDocumentsProvider = FutureProvider.autoDispose
    .family<List<AcademicDocumentModel>, DocumentFilter>(
      (ref, filter) async =>
          (await ref
                  .watch(academicDocumentRepositoryProvider)
                  .list(kind: filter.kind, status: filter.status))
              .getOrThrow()
              .items,
      retry: (_, _) => null,
    );

/// Pedido, emissão, anulação e PDF; cada alteração fica em auditoria (a
/// auditoria nunca anula a acção).
class AcademicDocumentActions {
  AcademicDocumentActions(this._ref);

  final Ref _ref;

  AcademicDocumentRepository get _repo =>
      _ref.read(academicDocumentRepositoryProvider);

  void _refresh() => _ref
    ..invalidate(academicDocumentsProvider)
    ..invalidate(documentTemplatesProvider);

  Future<void> _audit(
    AuditAction action,
    String id, {
    Map<String, dynamic>? before,
    Map<String, dynamic>? after,
  }) async {
    await _ref
        .read(auditServiceProvider)
        .record(
          entity: 'academic_document',
          action: action,
          entityId: id,
          before: before,
          after: after,
        );
  }

  Future<Result<AcademicDocumentModel>> request({
    required DocumentKind kind,
    required StudentModel student,
    required String classroomLabel,
    required String yearName,
    String purpose = '',
  }) async {
    final institution =
        (await _ref.read(reportCardActionsProvider).letterhead())
            .institutionName;
    final result = await _repo.request(
      kind: kind,
      studentId: student.id,
      studentName: student.fullName,
      processNumber: student.processNumber,
      purpose: purpose,
      variables: {
        'classroom': classroomLabel,
        'academicYear': yearName,
        'institutionName': institution,
      },
    );
    if (result case Ok(:final value)) {
      await _audit(
        AuditAction.create,
        value.id,
        after: {'kind': kind.name, 'studentId': student.id},
      );
      _refresh();
    }
    return result;
  }

  Future<Result<AcademicDocumentModel>> issue(AcademicDocumentModel doc) async {
    final result = await _repo.issue(doc.id);
    if (result case Ok(:final value)) {
      await _audit(
        AuditAction.approve,
        doc.id,
        before: {'status': doc.status.name},
        after: {
          'status': value.status.name,
          'number': value.number,
          'studentId': value.studentId,
        },
      );
      _refresh();
    }
    return result;
  }

  Future<Result<AcademicDocumentModel>> cancel(
    AcademicDocumentModel doc,
  ) async {
    final result = await _repo.cancel(doc.id);
    if (result case Ok(:final value)) {
      await _audit(
        AuditAction.cancel,
        doc.id,
        before: {'status': doc.status.name, 'number': doc.number},
        after: {'status': value.status.name},
      );
      _refresh();
    }
    return result;
  }

  Future<Result<DocumentTemplateModel>> saveTemplate(
    DocumentTemplateModel template,
    String body,
  ) async {
    final result = await _repo.updateTemplate(template.id, body);
    if (result case Ok(:final value)) {
      await _audit(
        AuditAction.update,
        template.id,
        before: {'body': template.body},
        after: {'body': value.body},
      );
      _refresh();
    }
    return result;
  }

  Future<Result<DocumentVerificationModel>> verify(String input) =>
      _repo.verify(documentNumberFromCode(input));

  Future<void> exportPdf(AcademicDocumentModel doc) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final template = AcademicDocumentTemplate(doc);
      final bytes = await _ref
          .read(pdfTemplateEngineProvider)
          .render(
            letterhead: await _ref.read(reportCardActionsProvider).letterhead(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(studentPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Documento guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final academicDocumentActionsProvider = Provider<AcademicDocumentActions>(
  AcademicDocumentActions.new,
);
