import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../settings/presentation/providers/pdf_letterhead_provider.dart';
import '../../data/models/enrollment_model.dart';
import '../../data/models/student_enums.dart';
import '../../data/models/student_model.dart';
import '../pdf/student_pdf_templates.dart';
import 'student_file_providers.dart';

/// Permissão para emitir os documentos de matrícula.
const studentsPdfPermission = 'students.record.read';

final pdfTemplateEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);

final studentPdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

/// Gera e guarda os PDFs da ficha de matrícula, comprovativo e contrato.
class StudentPdfService {
  StudentPdfService(this._ref);

  final Ref _ref;

  /// Matrícula mais recente que não esteja anulada/rejeitada.
  static EnrollmentModel? pickEnrollment(List<EnrollmentModel> all) {
    for (final e in all) {
      if (e.status != EnrollmentStatus.cancelled &&
          e.status != EnrollmentStatus.rejected) {
        return e;
      }
    }
    return null;
  }

  /// Gera os bytes do PDF; `null` (com aviso) se faltarem dados.
  Future<(StudentPdfData, Uint8List, PdfDocumentTemplate)?> generate(
    StudentModel student,
    StudentPdfKind kind,
  ) async {
    final toast = _ref.read(toastProvider.notifier);
    final enrollments = await _ref.read(
      studentEnrollmentsProvider(student.id).future,
    );
    final enrollment = pickEnrollment(enrollments);
    if (enrollment == null) {
      toast.error('O aluno não tem matrícula para emitir o documento.');
      return null;
    }
    if (!kind.isAvailableFor(enrollment)) {
      toast.error('O comprovativo só é emitido com a taxa de matrícula paga.');
      return null;
    }
    final guardians = await _ref.read(
      studentGuardiansProvider(student.id).future,
    );
    final institution = await _ref
        .read(institutionPdfLetterheadProvider)
        .load();
    final data = StudentPdfData(
      student: student,
      enrollment: enrollment,
      guardians: guardians,
      institutionName: institution.institutionName,
    );
    final template = kind.template(data);
    final bytes = await _ref
        .read(pdfTemplateEngineProvider)
        .render(
          letterhead: institution,
          template: template,
          generatedAt: DateTime.now(),
        );
    return (data, bytes, template);
  }

  Future<void> export(StudentModel student, StudentPdfKind kind) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final out = await generate(student, kind);
      if (out == null) return;
      final saved = await _ref
          .read(studentPdfSaverProvider)
          .save(fileName: out.$3.fileName, bytes: out.$2);
      if (saved) toast.success('${kind.label} guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final studentPdfServiceProvider = Provider<StudentPdfService>(
  StudentPdfService.new,
);
