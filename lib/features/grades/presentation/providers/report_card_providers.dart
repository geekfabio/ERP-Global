import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../../settings/presentation/providers/pdf_letterhead_provider.dart';
import '../../../students/presentation/providers/student_file_providers.dart';
import '../../../students/presentation/providers/student_pdf_providers.dart';
import '../../data/models/assessment_scheme_model.dart';
import '../../data/models/report_card_models.dart';
import '../../data/repositories/api_report_card_repository.dart';
import '../../domain/grade_entry_repository.dart';
import '../../domain/report_card.dart';
import '../../domain/report_card_repository.dart';
import '../pdf/report_card_pdf_template.dart';
import 'grades_providers.dart';

/// Aluno × turma × trimestre de um boletim.
typedef ReportCardKey = ({String studentId, String classroomId, String termId});

final reportCardRepositoryProvider = Provider<ReportCardRepository>(
  (ref) => ApiReportCardRepository(ref.watch(apiClientProvider)),
);

/// Observações e último envio do boletim.
final reportCardStateProvider = FutureProvider.autoDispose
    .family<ReportCardStateModel, ReportCardKey>(
      (ref, key) async =>
          (await ref
                  .watch(reportCardRepositoryProvider)
                  .state(key.studentId, key.termId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Junta notas (folhas por disciplina, `MT` pelo motor de médias), faltas do
/// trimestre e observações num [ReportCardData].
final reportCardDataProvider = FutureProvider.autoDispose
    .family<ReportCardData, ReportCardKey>((ref, key) async {
      final classrooms = await ref.watch(classroomListProvider.future);
      final classroom = classrooms.firstWhere((c) => c.id == key.classroomId);
      final terms = await ref.watch(
        termsProvider(classroom.academicYearId).future,
      );
      final term = terms.firstWhere((t) => t.id == key.termId);
      final student = await ref.watch(studentProvider(key.studentId).future);
      final grades = await ref.watch(gradeListProvider.future);
      final subjects = await ref.watch(subjectListProvider.future);
      final curriculum = await ref.watch(curriculumAllProvider.future);
      final attendance = await ref.watch(
        studentAttendanceProvider(key.studentId).future,
      );
      final state = await ref.watch(reportCardStateProvider(key).future);

      final subjectNames = {for (final s in subjects) s.id: s.name};
      final ids =
          {
            for (final i in curriculum)
              if (i.courseId == classroom.courseId &&
                  i.gradeId == classroom.gradeId)
                i.subjectId,
          }.toList()..sort(
            (a, b) => (subjectNames[a] ?? a).compareTo(subjectNames[b] ?? b),
          );

      final repository = ref.watch(gradeEntryRepositoryProvider);
      final rows = <ReportCardSubject>[];
      var components = const <AssessmentComponentModel>[];
      for (final id in ids) {
        final sheet = (await repository.sheet(
          GradeSheetKey(
            classroomId: classroom.id,
            subjectId: id,
            termId: term.id,
            gradeId: classroom.gradeId,
            courseId: classroom.courseId,
          ),
        )).getOrThrow();
        if (components.isEmpty) components = sheet.scheme.components;
        rows.add(
          ReportCardSubject.fromSheet(
            subjectNames[id] ?? id,
            sheet,
            student.id,
          ),
        );
      }

      final gradeName =
          grades.where((g) => g.id == classroom.gradeId).firstOrNull?.name ??
          '';
      return ReportCardData(
        studentName: student.fullName,
        processNumber: student.processNumber,
        classroomLabel: '$gradeName · ${classroom.name}',
        termName: term.name,
        components: components,
        subjects: rows,
        absences: countAbsences(
          attendance.records,
          term.startDate,
          term.endDate,
        ),
        remarks: state.remarks,
      );
    }, retry: (_, _) => null);

/// Emite o PDF, guarda as observações e dispara o envio ao encarregado.
class ReportCardActions {
  ReportCardActions(this._ref);

  final Ref _ref;

  Future<Result<ReportCardStateModel>> saveRemarks(
    ReportCardKey key,
    String remarks,
  ) async {
    final result = await _ref
        .read(reportCardRepositoryProvider)
        .saveRemarks(key.studentId, key.termId, remarks);
    if (result is Ok) _ref.invalidate(reportCardStateProvider(key));
    return result;
  }

  /// Envia o boletim a todos os encarregados do aluno (hook de entrega).
  Future<Result<ReportCardStateModel>> send(ReportCardKey key) async {
    final guardians = await _ref.read(
      studentGuardiansProvider(key.studentId).future,
    );
    final result = await _ref.read(reportCardRepositoryProvider).send(
      key.studentId,
      key.termId,
      [for (final g in guardians) g.guardian.id],
    );
    if (result is Ok) _ref.invalidate(reportCardStateProvider(key));
    return result;
  }

  /// Gera os bytes do PDF do boletim com o cabeçalho da instituição.
  Future<(ReportCardTemplate, Uint8List)> render(ReportCardKey key) async {
    final data = await _ref.read(reportCardDataProvider(key).future);
    final template = ReportCardTemplate(
      data,
      verificationCode: 'ERP-GLOBAL/BOLETIM/${key.studentId}/${key.termId}',
    );
    final bytes = await _ref
        .read(pdfTemplateEngineProvider)
        .render(
          letterhead: await letterhead(),
          template: template,
          generatedAt: DateTime.now(),
        );
    return (template, bytes);
  }

  Future<void> export(ReportCardKey key) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final (template, bytes) = await render(key);
      final saved = await _ref
          .read(studentPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Boletim guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o boletim.');
    }
  }

  Future<PdfLetterhead> letterhead() async {
    return _ref.read(institutionPdfLetterheadProvider).load();
  }
}

final reportCardActionsProvider = Provider<ReportCardActions>(
  ReportCardActions.new,
);
