import '../../students/data/models/student_summaries_model.dart';
import '../data/models/assessment_scheme_model.dart';
import '../data/models/grade_sheet_models.dart';
import 'assessment_engine.dart';

/// Nota formatada em pt-AO (vírgula decimal); `-` quando não há nota.
String formatReportGrade(double? v) {
  if (v == null) return '-';
  return v == v.roundToDouble()
      ? v.toInt().toString()
      : v.toString().replaceAll('.', ',');
}

String outcomeLabel(GradeOutcome o) => switch (o) {
  GradeOutcome.approved => 'Aprovado',
  GradeOutcome.failed => 'Reprovado',
  GradeOutcome.pending => 'Pendente',
};

/// Resultado de uma disciplina no trimestre: notas por componente e `MT`.
class ReportCardSubject {
  const ReportCardSubject({
    required this.name,
    required this.scores,
    required this.termAverage,
    required this.outcome,
  });

  /// Calcula `MT` e situação com o motor de médias do esquema da folha.
  factory ReportCardSubject.fromSheet(
    String name,
    GradeSheetModel sheet,
    String studentId,
  ) {
    final scores =
        sheet.rows.where((r) => r.studentId == studentId).firstOrNull?.scores ??
        const <String, double>{};
    final engine = AssessmentEngine(sheet.scheme);
    final mt = engine.termAverage({
      for (final c in sheet.scheme.components) c.code: scores[c.code],
    });
    return ReportCardSubject(
      name: name,
      scores: scores,
      termAverage: mt,
      outcome: engine.outcome(mt),
    );
  }

  final String name;
  final Map<String, double> scores;

  /// `null` = pendente (falta algum componente).
  final double? termAverage;
  final GradeOutcome outcome;
}

/// Faltas do aluno no trimestre.
class ReportCardAbsences {
  const ReportCardAbsences({
    this.justified = 0,
    this.unjustified = 0,
    this.late = 0,
  });

  final int justified;
  final int unjustified;
  final int late;

  int get total => justified + unjustified;
}

/// Todos os dados do boletim; o ecrã e o PDF desenham-se a partir dele.
class ReportCardData {
  const ReportCardData({
    required this.studentName,
    required this.processNumber,
    required this.classroomLabel,
    required this.termName,
    required this.components,
    required this.subjects,
    this.absences = const ReportCardAbsences(),
    this.remarks = '',
  });

  final String studentName;
  final String processNumber;
  final String classroomLabel;
  final String termName;

  /// Colunas de avaliação (código/nome), pela ordem do esquema.
  final List<AssessmentComponentModel> components;
  final List<ReportCardSubject> subjects;
  final ReportCardAbsences absences;
  final String remarks;

  /// Média das `MT` já calculadas (1 casa decimal); `null` sem nenhuma.
  double? get overallAverage {
    final mts = [
      for (final s in subjects)
        if (s.termAverage != null) s.termAverage!,
    ];
    if (mts.isEmpty) return null;
    return roundGrade(
      mts.fold(0.0, (a, v) => a + v) / mts.length,
      RoundingMode.nearest,
      1,
    );
  }

  /// Cabeçalhos da tabela de notas (iguais no ecrã e no PDF).
  List<String> get tableHeaders => [
    'Disciplina',
    for (final c in components) c.code,
    'MT',
    'Situação',
  ];

  /// Linhas da tabela de notas (iguais no ecrã e no PDF).
  List<List<String>> get tableRows => [
    for (final s in subjects)
      [
        s.name,
        for (final c in components) formatReportGrade(s.scores[c.code]),
        formatReportGrade(s.termAverage),
        outcomeLabel(s.outcome),
      ],
  ];

  /// Linha de faltas (igual no ecrã e no PDF).
  String get absencesLine =>
      'Faltas justificadas: ${absences.justified}  |  '
      'injustificadas: ${absences.unjustified}  |  '
      'atrasos: ${absences.late}';
}

/// Conta presenças `[start, end]` (só datas, inclusive) por tipo.
ReportCardAbsences countAbsences(
  Iterable<AttendanceRecord> records,
  DateTime start,
  DateTime end,
) {
  DateTime day(DateTime d) => DateTime(d.year, d.month, d.day);
  final from = day(start);
  final to = day(end);
  var justified = 0;
  var unjustified = 0;
  var late = 0;
  for (final r in records) {
    final d = day(r.date);
    if (d.isBefore(from) || d.isAfter(to)) continue;
    switch (r.kind) {
      case AttendanceKind.justified:
        justified++;
      case AttendanceKind.unjustified:
        unjustified++;
      case AttendanceKind.late:
        late++;
      case AttendanceKind.present:
        break;
    }
  }
  return ReportCardAbsences(
    justified: justified,
    unjustified: unjustified,
    late: late,
  );
}
