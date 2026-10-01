import '../data/models/assessment_scheme_model.dart';
import 'assessment_engine.dart';
import 'pauta.dart';

/// Faixas da distribuição de notas: cada faixa cobre um quarto da escala
/// (0-20 por omissão); a última inclui o máximo.
const gradeBandCount = 4;

/// Estatísticas de uma disciplina no âmbito escolhido.
class SubjectStatistics {
  const SubjectStatistics({
    required this.name,
    required this.average,
    required this.approved,
    required this.failed,
    required this.pending,
  });

  final String name;

  /// Média das notas conhecidas (1 casa decimal); `null` sem notas.
  final double? average;
  final int approved;
  final int failed;

  /// Alunos sem nota (excluídos da taxa de aprovação).
  final int pending;

  int get graded => approved + failed;

  /// Percentagem 0-100 de aprovados entre os avaliados; `null` sem avaliados.
  double? get approvalRate => graded == 0 ? null : approved * 100 / graded;
}

/// Aluno em risco: [negatives] disciplinas abaixo da nota mínima.
class AtRiskStudent {
  const AtRiskStudent({
    required this.studentId,
    required this.name,
    required this.negatives,
    required this.average,
  });

  final String studentId;
  final String name;
  final int negatives;
  final double? average;
}

/// Desempenho de uma turma num trimestre (`termIndex`) ou no ano
/// (`termIndex == null`, médias finais).
class GradeStatistics {
  const GradeStatistics({
    required this.termIndex,
    required this.average,
    required this.approvalRate,
    required this.distribution,
    required this.subjects,
    required this.atRisk,
    required this.minPassing,
    required this.scaleMax,
  });

  /// Calcula a partir da pauta. [riskThreshold] = n.º de negativas a partir
  /// do qual o aluno fica em risco.
  factory GradeStatistics.fromPauta(
    PautaData pauta, {
    int? termIndex,
    int riskThreshold = 2,
    double scaleMax = 20,
  }) {
    double? grade(PautaSubjectGrades s) =>
        termIndex == null ? s.finalAverage : s.termAverages[termIndex];

    final all = <double>[];
    final subjects = <SubjectStatistics>[];
    for (var i = 0; i < pauta.subjectNames.length; i++) {
      final values = <double?>[
        for (final r in pauta.rows) grade(r.subjects[i]),
      ];
      final known = values.nonNulls.toList();
      all.addAll(known);
      subjects.add(
        SubjectStatistics(
          name: pauta.subjectNames[i],
          average: _mean(known),
          approved: known.where((v) => v >= pauta.minPassing).length,
          failed: known.where((v) => v < pauta.minPassing).length,
          pending: values.length - known.length,
        ),
      );
    }

    final distribution = List<int>.filled(gradeBandCount, 0);
    for (final v in all) {
      final band = (v / scaleMax * gradeBandCount).floor().clamp(
        0,
        gradeBandCount - 1,
      );
      distribution[band]++;
    }

    final atRisk = <AtRiskStudent>[];
    for (final r in pauta.rows) {
      final negatives = [
        for (final s in r.subjects) grade(s),
      ].where((v) => v != null && v < pauta.minPassing).length;
      if (negatives >= riskThreshold) {
        atRisk.add(
          AtRiskStudent(
            studentId: r.student.id,
            name: r.student.name,
            negatives: negatives,
            average: termIndex == null
                ? r.finalOverall
                : r.termOverall(termIndex),
          ),
        );
      }
    }
    atRisk.sort((a, b) {
      final byNegatives = b.negatives.compareTo(a.negatives);
      return byNegatives != 0 ? byNegatives : a.name.compareTo(b.name);
    });

    final approved = subjects.fold(0, (a, s) => a + s.approved);
    final graded = subjects.fold(0, (a, s) => a + s.graded);
    return GradeStatistics(
      termIndex: termIndex,
      average: _mean(all),
      approvalRate: graded == 0 ? null : approved * 100 / graded,
      distribution: distribution,
      subjects: subjects,
      atRisk: atRisk,
      minPassing: pauta.minPassing,
      scaleMax: scaleMax,
    );
  }

  final int? termIndex;
  final double? average;

  /// Aprovações entre todas as notas conhecidas (0-100).
  final double? approvalRate;

  /// Notas (aluno × disciplina) por faixa (ver [bandLabels]).
  final List<int> distribution;
  final List<SubjectStatistics> subjects;
  final List<AtRiskStudent> atRisk;
  final double minPassing;
  final double scaleMax;

  /// Rótulos das faixas, ex.: `0-4`, `5-9`, `10-14`, `15-20`.
  List<String> get bandLabels {
    final size = scaleMax / gradeBandCount;
    return [
      for (var i = 0; i < gradeBandCount; i++)
        '${(i * size).round()}-'
            '${i == gradeBandCount - 1 ? scaleMax.round() : ((i + 1) * size).round() - 1}',
    ];
  }

  static double? _mean(List<double> values) => values.isEmpty
      ? null
      : roundGrade(
          values.fold(0.0, (a, v) => a + v) / values.length,
          RoundingMode.nearest,
          1,
        );
}

/// Percentagem em pt-AO (vírgula decimal, 1 casa), ex.: `66,7%`.
String formatPercent(double? v) =>
    v == null ? '-' : '${v.toStringAsFixed(1).replaceAll('.', ',')}%';
