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
import 'package:erp_global/features/grades/data/models/grade_sheet_models.dart';
import 'package:erp_global/features/grades/data/repositories/api_report_card_repository.dart';
import 'package:erp_global/features/grades/domain/assessment_engine.dart';
import 'package:erp_global/features/grades/domain/report_card.dart';
import 'package:erp_global/features/grades/presentation/pdf/report_card_pdf_template.dart';
import 'package:erp_global/features/grades/presentation/widgets/report_card_view.dart';
import 'package:erp_global/features/students/data/models/student_summaries_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const _scheme = AssessmentSchemeModel(
  id: 's',
  name: 'Geral',
  components: [
    AssessmentComponentModel(code: 'MAC', name: 'Contínua', weight: 30),
    AssessmentComponentModel(
      code: 'NPP',
      name: 'Prova do professor',
      weight: 30,
    ),
    AssessmentComponentModel(code: 'NPT', name: 'Prova trimestral', weight: 40),
  ],
);

GradeSheetModel _sheet(Map<String, double> scores) => GradeSheetModel(
  classroomId: 'c',
  subjectId: 's',
  termId: 't',
  scheme: _scheme,
  rows: [GradeRowModel(studentId: 'a1', scores: scores)],
);

ReportCardData _data({String remarks = 'Bom aluno.'}) => ReportCardData(
  studentName: 'Ana Silva',
  processNumber: '2026/001',
  classroomLabel: '7.ª Classe · A',
  termName: '1.º Trimestre',
  components: _scheme.components,
  subjects: [
    ReportCardSubject.fromSheet(
      'Matemática',
      _sheet({'MAC': 12, 'NPP': 14, 'NPT': 16}),
      'a1',
    ),
    ReportCardSubject.fromSheet('Português', _sheet({'MAC': 8}), 'a1'),
    ReportCardSubject.fromSheet(
      'História',
      _sheet({'MAC': 6, 'NPP': 6, 'NPT': 6}),
      'a1',
    ),
  ],
  absences: const ReportCardAbsences(justified: 2, unjustified: 1, late: 3),
  remarks: remarks,
);

ApiReportCardRepository _repo(List<String> permissions) =>
    ApiReportCardRepository(
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

void main() {
  group('motor do boletim', () {
    test('MT pelo motor de médias; componente em falta fica pendente', () {
      final d = _data();
      final [math, pt, history] = d.subjects;
      expect(math.termAverage, 14);
      expect(math.outcome, GradeOutcome.approved);
      expect(pt.termAverage, isNull);
      expect(pt.outcome, GradeOutcome.pending);
      expect(history.outcome, GradeOutcome.failed);
    });

    test('média do período ignora disciplinas pendentes', () {
      final d = _data();
      final mts = [for (final s in d.subjects) s.termAverage].nonNulls;
      expect(mts, hasLength(2));
      expect(d.overallAverage, 10);
    });

    test('tabela partilha cabeçalhos e linhas (ecrã e PDF)', () {
      final d = _data();
      expect(d.tableHeaders, [
        'Disciplina',
        'MAC',
        'NPP',
        'NPT',
        'MT',
        'Situação',
      ]);
      expect(d.tableRows[1], ['Português', '8', '-', '-', '-', 'Pendente']);
    });

    test('faltas contadas só dentro do período, inclusive', () {
      final records = [
        AttendanceRecord(
          date: DateTime(2026, 9, 1),
          kind: AttendanceKind.justified,
        ),
        AttendanceRecord(
          date: DateTime(2026, 12, 15),
          kind: AttendanceKind.unjustified,
        ),
        AttendanceRecord(
          date: DateTime(2026, 10, 5),
          kind: AttendanceKind.late,
        ),
        AttendanceRecord(
          date: DateTime(2026, 8, 31),
          kind: AttendanceKind.unjustified,
        ),
        AttendanceRecord(
          date: DateTime(2026, 10, 6),
          kind: AttendanceKind.present,
        ),
      ];
      final a = countAbsences(
        records,
        DateTime(2026, 9, 1),
        DateTime(2026, 12, 15),
      );
      expect([a.justified, a.unjustified, a.late, a.total], [1, 1, 1, 2]);
    });
  });

  group('/v1/report-cards', () {
    test('observações e envio ao encarregado ficam guardados', () async {
      final repo = _repo(['grades.entry.write']);
      expect((await repo.state('a1', 't1')).getOrThrow().remarks, '');
      await repo.saveRemarks('a1', 't1', '  Esforçado.  ');
      final sent = (await repo.send('a1', 't1', ['g1'])).getOrThrow();
      expect(sent.remarks, 'Esforçado.');
      expect(sent.sentAt, isNotNull);
      expect(sent.sentToGuardianIds, ['g1']);
      expect((await repo.state('a1', 't1')).getOrThrow().sentAt, isNotNull);
    });

    test('sem encarregado o envio dá 422', () async {
      final failure = (await _repo([
        'grades.entry.write',
      ]).send('a1', 't1', [])).failureOrNull!;
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).fields.keys, ['guardianIds']);
    });

    test('só leitura não escreve; sem permissão recebe 403', () async {
      final reader = _repo(['grades.entry.read']);
      expect((await reader.state('a1', 't1')).isOk, isTrue);
      expect(
        (await reader.saveRemarks('a1', 't1', 'x')).failureOrNull?.code,
        'FORBIDDEN',
      );
      expect(
        (await reader.send('a1', 't1', ['g'])).failureOrNull?.code,
        'FORBIDDEN',
      );
      final none = _repo(['students.record.read']);
      expect((await none.state('a1', 't1')).failureOrNull?.code, 'FORBIDDEN');
    });

    test('observações demasiado longas dão 422', () async {
      final result = await _repo([
        'grades.entry.write',
      ]).saveRemarks('a1', 't1', 'x' * 501);
      expect(result.failureOrNull, isA<ValidationFailure>());
    });
  });

  group('PDF do boletim', () {
    test('gera PDF válido com nome de ficheiro previsível', () async {
      final template = ReportCardTemplate(
        _data(),
        verificationCode: 'ERP/BOLETIM/a1/t1',
      );
      expect(template.fileName, 'boletim-2026-001-1-trimestre');
      final bytes = await const PdfTemplateEngine().render(
        letterhead: const PdfLetterhead(
          institutionName: 'Colégio Teste',
          nif: '500',
        ),
        template: template,
        generatedAt: DateTime(2026, 12, 20),
      );
      expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
      expect(bytes.length, greaterThan(1000));
    });
  });

  testWidgets('ecrã mostra as mesmas linhas, média, faltas e observações', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final data = _data();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: SingleChildScrollView(child: ReportCardView(data: data)),
        ),
      ),
    );
    expect(find.text('Boletim de notas - 1.º Trimestre'), findsOneWidget);
    for (final h in data.tableHeaders) {
      expect(find.text(h), findsWidgets);
    }
    expect(find.text('Matemática'), findsOneWidget);
    expect(find.text('Pendente'), findsOneWidget);
    expect(find.text(data.absencesLine), findsOneWidget);
    expect(find.text('Bom aluno.'), findsOneWidget);
    expect(
      find.text('Média do período: ${formatReportGrade(data.overallAverage)}'),
      findsOneWidget,
    );
  });
}
