import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../settings/data/models/setting_model.dart';
import '../../../settings/presentation/providers/rules_providers.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../../students/presentation/providers/student_pdf_providers.dart';
import '../../data/models/assessment_scheme_model.dart';
import '../../data/models/council_models.dart';
import '../../data/models/grade_sheet_models.dart';
import '../../data/repositories/api_council_repository.dart';
import '../../domain/council_repository.dart';
import '../../domain/grade_entry_repository.dart';
import '../../domain/pauta.dart';
import '../../domain/report_card.dart';
import '../pdf/pauta_pdf_template.dart';
import 'grades_providers.dart';
import 'report_card_providers.dart';

/// Turma e ano lectivo de um conselho de turma.
typedef CouncilKey = ({String classroomId, String yearId});

final councilRepositoryProvider = Provider<CouncilRepository>(
  (ref) => ApiCouncilRepository(ref.watch(apiClientProvider)),
);

final councilProvider = FutureProvider.autoDispose
    .family<CouncilModel, CouncilKey>(
      (ref, key) async =>
          (await ref
                  .watch(councilRepositoryProvider)
                  .council(key.classroomId, key.yearId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Limites do resultado final, lidos das regras académicas (com valores
/// por omissão se a regra não existir).
final pautaRulesProvider = FutureProvider.autoDispose<PautaRules>((ref) async {
  final settings = await ref.watch(
    rulesProvider(SettingModule.academic).future,
  );
  int read(String key, int fallback) {
    final v = settings.where((s) => s.key == key).firstOrNull?.value;
    return v is int ? v : fallback;
  }

  return PautaRules(
    maxFailsDeficiency: read('maxFailsDeficiency', 1),
    maxFailsRecourse: read('maxFailsRecourse', 3),
  );
});

/// Pauta da turma: notas de todos os trimestres por disciplina, `MF`,
/// resultado final pelas regras e decisões do conselho de turma.
final pautaDataProvider = FutureProvider.autoDispose.family<PautaData, String>((
  ref,
  classroomId,
) async {
  final classrooms = await ref.watch(classroomListProvider.future);
  final classroom = classrooms.firstWhere((c) => c.id == classroomId);
  final years = await ref.watch(academicYearsProvider.future);
  final yearName =
      years.where((y) => y.id == classroom.academicYearId).firstOrNull?.code ??
      '';
  final terms = await ref.watch(termsProvider(classroom.academicYearId).future);
  final grades = await ref.watch(gradeListProvider.future);
  final subjects = await ref.watch(subjectListProvider.future);
  final curriculum = await ref.watch(curriculumAllProvider.future);
  final roster = await ref.watch(classroomRosterProvider(classroomId).future);
  final rules = await ref.watch(pautaRulesProvider.future);
  final council = await ref.watch(
    councilProvider((
      classroomId: classroomId,
      yearId: classroom.academicYearId,
    )).future,
  );

  final names = {for (final s in subjects) s.id: s.name};
  final ids = {
    for (final i in curriculum)
      if (i.courseId == classroom.courseId && i.gradeId == classroom.gradeId)
        i.subjectId,
  }.toList()..sort((a, b) => (names[a] ?? a).compareTo(names[b] ?? b));

  final repository = ref.watch(gradeEntryRepositoryProvider);
  final studentRows = <List<List<ReportCardSubject?>>>[
    for (final _ in roster) <List<ReportCardSubject?>>[],
  ];
  final schemes = <AssessmentSchemeModel>[];
  for (final id in ids) {
    final perTerm = <GradeSheetModel>[];
    for (final t in terms) {
      perTerm.add(
        (await repository.sheet(
          GradeSheetKey(
            classroomId: classroom.id,
            subjectId: id,
            termId: t.id,
            gradeId: classroom.gradeId,
            courseId: classroom.courseId,
          ),
        )).getOrThrow(),
      );
    }
    schemes.add(perTerm.first.scheme);
    for (var s = 0; s < roster.length; s++) {
      studentRows[s].add([
        for (final sheet in perTerm)
          ReportCardSubject.fromSheet(names[id] ?? id, sheet, roster[s].id),
      ]);
    }
  }

  final gradeName =
      grades.where((g) => g.id == classroom.gradeId).firstOrNull?.name ?? '';
  return PautaData(
    classroomLabel: '$gradeName · ${classroom.name}',
    yearName: yearName,
    termNames: [for (final t in terms) t.name],
    subjectNames: [for (final id in ids) names[id] ?? id],
    minPassing: schemes.isEmpty ? 10 : schemes.first.minPassing.toDouble(),
    approved: council.approved,
    rows: [
      for (var s = 0; s < roster.length; s++)
        buildPautaRow(
          student: PautaStudent(
            id: roster[s].id,
            name: roster[s].fullName,
            processNumber: roster[s].processNumber,
          ),
          termCount: terms.length,
          sheetsBySubject: studentRows[s],
          schemes: [...schemes],
          rules: rules,
          decision: council.decisionFor(roster[s].id),
          frozen: council.results[roster[s].id],
        ),
    ],
  );
}, retry: (_, _) => null);

/// Decisões, aprovação e PDF da pauta.
class PautaActions {
  PautaActions(this._ref);

  final Ref _ref;

  Future<Result<CouncilModel>> decide(
    CouncilKey key, {
    required String studentId,
    required FinalResult result,
    required String justification,
  }) async {
    final out = await _ref
        .read(councilRepositoryProvider)
        .decide(
          key.classroomId,
          key.yearId,
          studentId: studentId,
          result: result,
          justification: justification,
        );
    if (out is Ok) _refresh(key);
    return out;
  }

  Future<Result<CouncilModel>> approve(
    CouncilKey key,
    Map<String, FinalResult> results,
  ) async {
    final out = await _ref
        .read(councilRepositoryProvider)
        .approve(key.classroomId, key.yearId, results);
    if (out is Ok) _refresh(key);
    return out;
  }

  void _refresh(CouncilKey key) {
    _ref
      ..invalidate(councilProvider(key))
      ..invalidate(pautaDataProvider(key.classroomId));
  }

  Future<void> exportPdf(PautaData data, int? termIndex) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final template = PautaTemplate(
        data,
        termIndex: termIndex,
        verificationCode: 'ERP-GLOBAL/PAUTA/${data.classroomLabel}',
      );
      final Uint8List bytes = await _ref
          .read(pdfTemplateEngineProvider)
          .render(
            letterhead: await _ref.read(reportCardActionsProvider).letterhead(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(studentPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Pauta guardada em PDF.');
    } on Object {
      toast.error('Não foi possível gerar a pauta.');
    }
  }
}

final pautaActionsProvider = Provider<PautaActions>(PautaActions.new);
