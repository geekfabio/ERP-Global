import 'dart:convert';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/features/grades/data/mock_api/grades_mock_handlers.dart';
import 'package:erp_global/features/grades/data/models/assessment_scheme_model.dart';
import 'package:erp_global/features/grades/data/models/council_models.dart';
import 'package:erp_global/features/grades/data/repositories/api_council_repository.dart';
import 'package:erp_global/features/grades/domain/assessment_engine.dart';
import 'package:erp_global/features/grades/domain/pauta.dart';
import 'package:erp_global/features/grades/domain/report_card.dart';
import 'package:erp_global/features/grades/presentation/pdf/pauta_pdf_template.dart';
import 'package:erp_global/features/grades/presentation/widgets/pauta_view.dart';
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

ApiCouncilRepository _repo(List<String> permissions) => ApiCouncilRepository(
  ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(
        GradesMockHandlers(
          permissions: () => PermissionService.fromCodes(permissions),
          now: () => DateTime.utc(2026, 11, 1),
        ),
      ),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  ),
);

PautaData _data() => PautaData(
  classroomLabel: '7.ª Classe · A',
  yearName: '2026/2027',
  termNames: const ['1.º Trimestre', '2.º Trimestre', '3.º Trimestre'],
  subjectNames: const ['Matemática', 'Português'],
  minPassing: 10,
  rows: [
    _row('a1', [
      [12, 14, 16],
      [10, 10, 10],
    ]),
    _row('a2', [
      [5, 6, 7],
      [10, 10, null],
    ]),
  ],
);

void main() {
  group('regras do resultado final', () {
    const rules = PautaRules();
    const ok = GradeOutcome.approved;
    const ko = GradeOutcome.failed;

    test('sem negativas aprova; limites configuráveis', () {
      expect(rules.resultFor([ok, ok]), FinalResult.approved);
      expect(rules.resultFor([ok, ko]), FinalResult.transitsWithDeficiency);
      expect(rules.resultFor([ko, ko]), FinalResult.recourse);
      expect(rules.resultFor([ko, ko, ko]), FinalResult.recourse);
      expect(rules.resultFor([ko, ko, ko, ko]), FinalResult.failed);
      const strict = PautaRules(maxFailsDeficiency: 0, maxFailsRecourse: 1);
      expect(strict.resultFor([ok, ko]), FinalResult.recourse);
      expect(strict.resultFor([ko, ko]), FinalResult.failed);
    });

    test('disciplina pendente deixa o resultado pendente', () {
      expect(rules.resultFor([ok, GradeOutcome.pending]), FinalResult.pending);
      expect(rules.resultFor([]), FinalResult.pending);
    });
  });

  group('pauta', () {
    test('MF pelo motor de médias e resultado calculado', () {
      final a1 = _data().rows[0];
      expect(a1.subjects[0].finalAverage, 14);
      expect(a1.subjects[1].finalAverage, 10);
      expect(a1.computed, FinalResult.approved);
      final a2 = _data().rows[1];
      expect(a2.subjects[0].outcome, GradeOutcome.failed);
      expect(a2.subjects[1].finalAverage, isNull);
      expect(a2.computed, FinalResult.pending);
    });

    test('pesos de trimestres incompatíveis são ignorados', () {
      final row = buildPautaRow(
        student: const PautaStudent(id: 'a', name: 'A', processNumber: '1'),
        termCount: 3,
        sheetsBySubject: [
          [_mt(10), _mt(10), _mt(10)],
        ],
        schemes: [
          _scheme.copyWith(termWeights: const [50, 50]),
        ],
        rules: const PautaRules(),
      );
      expect(row.subjects.single.finalAverage, 10);
    });

    test('decisão do conselho sobrepõe-se; aprovada fica congelada', () {
      final a2 = _data().rows[1];
      final decided = PautaRow(
        student: a2.student,
        subjects: a2.subjects,
        computed: a2.computed,
        decision: CouncilDecisionModel(
          studentId: 'a2',
          result: FinalResult.recourse,
          justification: 'Bom desempenho',
          decidedAt: DateTime.utc(2026, 7),
        ),
      );
      expect(decided.result, FinalResult.recourse);
      final frozen = PautaRow(
        student: a2.student,
        subjects: a2.subjects,
        computed: a2.computed,
        frozen: FinalResult.failed,
        decision: decided.decision,
      );
      expect(frozen.result, FinalResult.failed);
    });

    test('tabela final e trimestral partilham cabeçalhos e linhas', () {
      final d = _data();
      expect(d.tableHeaders(null), [
        'N.º',
        'Aluno',
        'Matemática',
        'Português',
        'Média',
        'Resultado',
      ]);
      expect(d.tableRows(null)[0], [
        'Pa1',
        'Aluno a1',
        '14',
        '10',
        '12',
        'Aprovado',
      ]);
      expect(d.tableRows(null)[1].last, 'Pendente');
      expect(d.tableHeaders(0).last, 'Negativas');
      expect(d.tableRows(0)[1], ['Pa2', 'Aluno a2', '5', '10', '7,5', '1']);
      expect(d.pendingCount, 1);
    });
  });

  group('/v1/class-councils', () {
    test('decisão exige justificação e fica guardada', () async {
      final repo = _repo(['grades.entry.approve']);
      final bad = await repo.decide(
        'c',
        'y',
        studentId: 'a2',
        result: FinalResult.recourse,
        justification: ' ',
      );
      expect(bad.failureOrNull, isA<ValidationFailure>());
      final ok = (await repo.decide(
        'c',
        'y',
        studentId: 'a2',
        result: FinalResult.recourse,
        justification: ' Conselho ',
      )).getOrThrow();
      expect(ok.decisionFor('a2')?.justification, 'Conselho');
      expect(
        (await repo.council('c', 'y')).getOrThrow().decisions,
        hasLength(1),
      );
    });

    test('aprovar congela a pauta e bloqueia novas decisões', () async {
      final repo = _repo(['grades.entry.approve']);
      final approved = (await repo.approve('c', 'y', {
        'a1': FinalResult.approved,
      })).getOrThrow();
      expect(approved.approved, isTrue);
      expect(approved.results['a1'], FinalResult.approved);
      final late = await repo.decide(
        'c',
        'y',
        studentId: 'a1',
        result: FinalResult.failed,
        justification: 'x',
      );
      expect(late.failureOrNull?.code, 'CONFLICT');
      expect(
        (await repo.approve('c', 'y', {
          'a1': FinalResult.approved,
        })).failureOrNull?.code,
        'CONFLICT',
      );
    });

    test('resultado pendente ou pauta vazia dão 422', () async {
      final repo = _repo(['grades.entry.approve']);
      expect(
        (await repo.approve('c', 'y', {
          'a1': FinalResult.pending,
        })).failureOrNull,
        isA<ValidationFailure>(),
      );
      expect(
        (await repo.approve('c', 'y', {})).failureOrNull,
        isA<ValidationFailure>(),
      );
    });

    test('só quem aprova decide; leitores só consultam', () async {
      final writer = _repo(['grades.entry.write']);
      expect((await writer.council('c', 'y')).isOk, isTrue);
      expect(
        (await writer.decide(
          'c',
          'y',
          studentId: 'a',
          result: FinalResult.approved,
          justification: 'x',
        )).failureOrNull?.code,
        'FORBIDDEN',
      );
      expect(
        (await writer.approve('c', 'y', {
          'a': FinalResult.approved,
        })).failureOrNull?.code,
        'FORBIDDEN',
      );
      expect(
        (await _repo([
          'students.record.read',
        ]).council('c', 'y')).failureOrNull?.code,
        'FORBIDDEN',
      );
    });
  });

  group('PDF da pauta', () {
    test('gera PDF válido com nome de ficheiro previsível', () async {
      final template = PautaTemplate(_data(), verificationCode: 'ERP/PAUTA/c');
      expect(template.fileName, 'pauta-7-classe-a-final');
      final bytes = await const PdfTemplateEngine().render(
        letterhead: const PdfLetterhead(institutionName: 'Colégio Teste'),
        template: template,
        generatedAt: DateTime(2026, 12, 20),
      );
      expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
    });
  });

  testWidgets('ecrã mostra a pauta final e abre a decisão por aluno', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final data = _data();
    PautaRow? decided;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: PautaView(
            data: data,
            termIndex: null,
            onDecide: (r) => decided = r,
          ),
        ),
      ),
    );
    for (final h in data.tableHeaders(null)) {
      expect(find.text(h), findsOneWidget);
    }
    expect(find.text('Aluno a1'), findsOneWidget);
    expect(find.text('Aprovado'), findsOneWidget);
    await tester.tap(find.byKey(const Key('pauta_decide_a2')));
    expect(decided?.student.id, 'a2');
  });
}
