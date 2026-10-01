import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/features/grades/data/models/assessment_scheme_model.dart';
import 'package:erp_global/features/grades/domain/assessment_engine.dart';
import 'package:erp_global/features/grades/domain/grade_statistics.dart';
import 'package:erp_global/features/grades/domain/pauta.dart';
import 'package:erp_global/features/grades/domain/report_card.dart';
import 'package:erp_global/features/grades/presentation/widgets/grade_statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _scheme = AssessmentSchemeModel(
  id: 's',
  name: 'Geral',
  components: [AssessmentComponentModel(code: 'NT', name: 'Nota', weight: 100)],
);

ReportCardSubject _mt(double? v) => ReportCardSubject(
  name: 'x',
  scores: const {},
  termAverage: v,
  outcome: GradeOutcome.pending,
);

PautaRow _row(String id, List<List<double?>> perSubjectTerms) => buildPautaRow(
  student: PautaStudent(id: id, name: 'Aluno $id', processNumber: 'P$id'),
  termCount: 3,
  sheetsBySubject: [
    for (final terms in perSubjectTerms) [for (final t in terms) _mt(t)],
  ],
  schemes: [for (final _ in perSubjectTerms) _scheme],
  rules: const PautaRules(),
);

PautaData _data() => PautaData(
  classroomLabel: '7.ª classe · A',
  yearName: '2026/2027',
  termNames: const ['1.º', '2.º', '3.º'],
  subjectNames: const ['Matemática', 'Português'],
  minPassing: 10,
  rows: [
    _row('a1', [
      [16, 18, 17],
      [12, 14, 13],
    ]),
    _row('a2', [
      [6, 8, 7],
      [4, 9, 8],
    ]),
    _row('a3', [
      [10, null, null],
      [null, null, null],
    ]),
  ],
);

void main() {
  group('GradeStatistics', () {
    test('trimestre: média, aprovação, distribuição e risco', () {
      final s = GradeStatistics.fromPauta(_data(), termIndex: 0);
      // notas: 16, 12, 6, 4, 10 -> média 9,6
      expect(s.average, 9.6);
      // aprovadas: 16, 12, 10 de 5
      expect(s.approvalRate, 60);
      expect(s.distribution, [1, 1, 2, 1]);
      expect(s.bandLabels, ['0-4', '5-9', '10-14', '15-20']);
      expect(s.subjects.first.approved, 2);
      expect(s.subjects.first.failed, 1);
      expect(s.subjects.last.pending, 1);
      expect(s.subjects.last.approvalRate, 50);
      expect([for (final r in s.atRisk) r.studentId], ['a2']);
      expect(s.atRisk.single.negatives, 2);
    });

    test('ano usa as médias finais', () {
      final s = GradeStatistics.fromPauta(_data());
      expect(s.atRisk.map((r) => r.studentId), ['a2']);
      expect(s.subjects.first.average, isNotNull);
    });

    test('sem notas devolve nulos e distribuição vazia', () {
      final empty = PautaData(
        classroomLabel: 'x',
        yearName: 'y',
        termNames: const ['1.º', '2.º', '3.º'],
        subjectNames: const ['Matemática'],
        minPassing: 10,
        rows: [
          _row('a', [
            [null, null, null],
          ]),
        ],
      );
      final s = GradeStatistics.fromPauta(empty, termIndex: 1);
      expect(s.average, isNull);
      expect(s.approvalRate, isNull);
      expect(s.distribution, [0, 0, 0, 0]);
      expect(s.atRisk, isEmpty);
    });

    test('formatPercent usa vírgula decimal', () {
      expect(formatPercent(66.666), '66,7%');
      expect(formatPercent(null), '-');
    });
  });

  testWidgets('ecrã mostra KPIs, gráficos e alunos em risco', (tester) async {
    tester.view.physicalSize = const Size(1600, 1400);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(
            child: GradeStatisticsView(
              stats: GradeStatistics.fromPauta(_data(), termIndex: 0),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('stats_kpi_average'))).data,
      '9,6',
    );
    expect(
      tester.widget<Text>(find.byKey(const Key('stats_kpi_approval'))).data,
      '60,0%',
    );
    expect(find.byKey(const Key('stats_distribution')), findsOneWidget);
    expect(find.byKey(const Key('stats_subject_average')), findsOneWidget);
    expect(find.byKey(const Key('stats_risk_a2')), findsOneWidget);
    expect(find.byKey(const Key('stats_risk_a1')), findsNothing);
  });
}
