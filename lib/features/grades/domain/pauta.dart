import '../data/models/council_models.dart';
import '../data/models/assessment_scheme_model.dart';
import 'assessment_engine.dart';
import 'report_card.dart';

String finalResultLabel(FinalResult r) => switch (r) {
  FinalResult.approved => 'Aprovado',
  FinalResult.failed => 'Reprovado',
  FinalResult.recourse => 'Recurso',
  FinalResult.transitsWithDeficiency => 'Transita com deficiência',
  FinalResult.pending => 'Pendente',
};

/// Regras do resultado final (configuráveis em Regras e parâmetros):
/// 0 negativas aprova; até [maxFailsDeficiency] transita com deficiência;
/// até [maxFailsRecourse] vai a recurso; acima disso reprova.
class PautaRules {
  const PautaRules({this.maxFailsDeficiency = 1, this.maxFailsRecourse = 3});

  final int maxFailsDeficiency;
  final int maxFailsRecourse;

  /// Resultado calculado a partir das situações finais por disciplina.
  /// Qualquer disciplina pendente deixa o resultado pendente.
  FinalResult resultFor(Iterable<GradeOutcome> outcomes) {
    final list = outcomes.toList();
    if (list.isEmpty || list.contains(GradeOutcome.pending)) {
      return FinalResult.pending;
    }
    final failed = list.where((o) => o == GradeOutcome.failed).length;
    if (failed == 0) return FinalResult.approved;
    if (failed <= maxFailsDeficiency) return FinalResult.transitsWithDeficiency;
    if (failed <= maxFailsRecourse) return FinalResult.recourse;
    return FinalResult.failed;
  }
}

/// Aluno da pauta.
class PautaStudent {
  const PautaStudent({
    required this.id,
    required this.name,
    required this.processNumber,
  });

  final String id;
  final String name;
  final String processNumber;
}

/// Médias de um aluno numa disciplina: `MT` por trimestre e `MF`.
class PautaSubjectGrades {
  const PautaSubjectGrades({
    required this.termAverages,
    required this.finalAverage,
    required this.outcome,
  });

  /// `MT` por trimestre (`null` = pendente).
  final List<double?> termAverages;
  final double? finalAverage;

  /// Situação com base na `MF`.
  final GradeOutcome outcome;
}

/// Linha da pauta: um aluno e as suas notas por disciplina.
class PautaRow {
  const PautaRow({
    required this.student,
    required this.subjects,
    required this.computed,
    this.decision,
    this.frozen,
  });

  final PautaStudent student;

  /// Pela ordem de [PautaData.subjectNames].
  final List<PautaSubjectGrades> subjects;

  /// Resultado pelas regras configuradas.
  final FinalResult computed;

  /// Decisão do conselho de turma (sobrepõe-se a [computed]).
  final CouncilDecisionModel? decision;

  /// Resultado congelado na aprovação da pauta.
  final FinalResult? frozen;

  FinalResult get result => frozen ?? decision?.result ?? computed;

  int negativesInTerm(int termIndex, double minPassing) => subjects
      .where(
        (s) =>
            s.termAverages[termIndex] != null &&
            s.termAverages[termIndex]! < minPassing,
      )
      .length;

  /// Média das `MF` conhecidas (1 casa decimal); `null` sem nenhuma.
  double? get finalOverall => _mean([for (final s in subjects) s.finalAverage]);

  double? termOverall(int termIndex) =>
      _mean([for (final s in subjects) s.termAverages[termIndex]]);

  static double? _mean(List<double?> values) {
    final known = values.nonNulls.toList();
    if (known.isEmpty) return null;
    return roundGrade(
      known.fold(0.0, (a, v) => a + v) / known.length,
      RoundingMode.nearest,
      1,
    );
  }
}

/// Todos os dados da pauta; o ecrã, o PDF e a exportação desenham-se a partir
/// dele. [termIndex] `null` = pauta final.
class PautaData {
  const PautaData({
    required this.classroomLabel,
    required this.yearName,
    required this.termNames,
    required this.subjectNames,
    required this.rows,
    required this.minPassing,
    this.approved = false,
  });

  final String classroomLabel;
  final String yearName;
  final List<String> termNames;
  final List<String> subjectNames;
  final List<PautaRow> rows;
  final double minPassing;

  /// Pauta aprovada pelo conselho de turma (congelada).
  final bool approved;

  String scopeName(int? termIndex) =>
      termIndex == null ? 'Final' : termNames[termIndex];

  /// Cabeçalhos (iguais no ecrã, no PDF e no Excel).
  List<String> tableHeaders(int? termIndex) => [
    'N.º',
    'Aluno',
    ...subjectNames,
    'Média',
    if (termIndex == null) 'Resultado' else 'Negativas',
  ];

  /// Linhas (iguais no ecrã, no PDF e no Excel).
  List<List<String>> tableRows(int? termIndex) => [
    for (final r in rows)
      [
        r.student.processNumber,
        r.student.name,
        for (final s in r.subjects)
          formatReportGrade(
            termIndex == null ? s.finalAverage : s.termAverages[termIndex],
          ),
        formatReportGrade(
          termIndex == null ? r.finalOverall : r.termOverall(termIndex),
        ),
        termIndex == null
            ? finalResultLabel(r.result)
            : '${r.negativesInTerm(termIndex, minPassing)}',
      ],
  ];

  /// Resultados finais por aluno (para aprovar a pauta).
  Map<String, FinalResult> get results => {
    for (final r in rows) r.student.id: r.result,
  };

  int get pendingCount =>
      rows.where((r) => r.result == FinalResult.pending).length;
}

/// Calcula uma linha da pauta: `MT` por trimestre (motor de médias do esquema
/// da folha) e `MF` com os pesos dos trimestres do esquema.
PautaRow buildPautaRow({
  required PautaStudent student,
  required int termCount,

  /// Folhas por disciplina (índice igual a `subjectNames`) e trimestre.
  required List<List<ReportCardSubject?>> sheetsBySubject,
  required List<AssessmentSchemeModel> schemes,
  required PautaRules rules,
  CouncilDecisionModel? decision,
  FinalResult? frozen,
}) {
  final subjects = <PautaSubjectGrades>[];
  for (var i = 0; i < sheetsBySubject.length; i++) {
    final terms = [for (final s in sheetsBySubject[i]) s?.termAverage];
    final scheme = schemes[i];
    final engine = AssessmentEngine(
      scheme.termWeights.length == termCount
          ? scheme
          : scheme.copyWith(termWeights: const []),
    );
    final mf = engine.finalAverage(terms);
    subjects.add(
      PautaSubjectGrades(
        termAverages: terms,
        finalAverage: mf,
        outcome: engine.outcome(mf),
      ),
    );
  }
  return PautaRow(
    student: student,
    subjects: subjects,
    computed: rules.resultFor([for (final s in subjects) s.outcome]),
    decision: decision,
    frozen: frozen,
  );
}
