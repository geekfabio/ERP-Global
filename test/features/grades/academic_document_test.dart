import 'dart:convert';

import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/audit/audit_log_model.dart';
import 'package:erp_global/core/audit/audit_providers.dart';
import 'package:erp_global/core/audit/audit_repository.dart';
import 'package:erp_global/core/audit/audit_service.dart';
import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/errors/result.dart';
import 'package:erp_global/core/network/api_envelope.dart';
import 'package:erp_global/core/security/permission_providers.dart';
import 'package:erp_global/features/grades/domain/academic_document_repository.dart';
import 'package:erp_global/features/grades/presentation/pages/academic_documents_page.dart';
import 'package:erp_global/features/grades/presentation/providers/academic_document_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/core/security/permission_service.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/features/grades/data/mock_api/grades_mock_handlers.dart';
import 'package:erp_global/features/grades/data/models/academic_document_models.dart';
import 'package:erp_global/features/grades/data/repositories/api_academic_document_repository.dart';
import 'package:erp_global/features/grades/domain/academic_document.dart';
import 'package:erp_global/features/grades/presentation/pdf/academic_document_pdf_template.dart';
import 'package:flutter_test/flutter_test.dart';

const _all = [
  'grades.document.read',
  'grades.document.request',
  'grades.document.issue',
  'grades.document.template',
];

ApiAcademicDocumentRepository _repo(
  List<String> permissions, {
  DateTime? now,
}) => ApiAcademicDocumentRepository(
  ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: MockApiRegistry()
      ..addModule(
        GradesMockHandlers(
          permissions: () => PermissionService.fromCodes(permissions),
          now: () => now ?? DateTime.utc(2026, 11, 1),
        ),
      ),
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  ),
);

Future<AcademicDocumentModel> _request(
  ApiAcademicDocumentRepository repo, {
  DocumentKind kind = DocumentKind.certificate,
  String student = 'a1',
}) async => (await repo.request(
  kind: kind,
  studentId: student,
  studentName: 'Ana Silva',
  processNumber: '2026/001',
  purpose: 'Transferência',
  variables: {
    'classroom': '7.ª Classe · A',
    'academicYear': '2026/2027',
    'institutionName': 'Colégio Teste',
  },
)).getOrThrow();

Future<void> _settle(WidgetTester tester) => tester.pumpAndSettle();

void main() {
  setUpAll(PtAoFormatters.initialize);

  group('motor de modelos', () {
    test('substitui marcadores e deixa - quando falta o valor', () {
      expect(
        renderDocumentBody('{{studentName}} / {{ classroom }} / {{number}}', {
          'studentName': 'Ana',
          'classroom': '',
        }),
        'Ana / - / -',
      );
    });

    test('valida corpo vazio, longo e marcadores desconhecidos', () {
      expect(validateTemplateBody(' '), contains('body'));
      expect(validateTemplateBody('x' * 2001), contains('body'));
      expect(validateTemplateBody('Olá {{nope}}')['body'], contains('nope'));
      expect(validateTemplateBody('Olá {{studentName}}'), isEmpty);
    });

    test('numeração e código de verificação', () {
      expect(
        formatDocumentNumber(DocumentKind.certificate, 2026, 7),
        'CERT-2026/0007',
      );
      final code = documentVerificationCode('DM-2026/0001');
      expect(documentNumberFromCode(code), 'DM-2026/0001');
      expect(documentNumberFromCode(' DM-2026/0001 '), 'DM-2026/0001');
    });
  });

  group('/v1/academic-documents', () {
    test('pedido nasce sem número; emissão numera por tipo e ano', () async {
      final repo = _repo(_all);
      final c1 = await _request(repo);
      expect(c1.status, DocumentStatus.requested);
      expect(c1.number, isNull);
      final c2 = await _request(repo);
      final d1 = await _request(repo, kind: DocumentKind.enrollmentDeclaration);

      final i1 = (await repo.issue(c1.id)).getOrThrow();
      final i2 = (await repo.issue(c2.id)).getOrThrow();
      final j1 = (await repo.issue(d1.id)).getOrThrow();
      expect(i1.number, 'CERT-2026/0001');
      expect(i2.number, 'CERT-2026/0002');
      expect(j1.number, 'DM-2026/0001');
      expect(i1.status, DocumentStatus.issued);
      expect(i1.content, contains('Ana Silva'));
      expect(i1.content, contains('CERT-2026/0001'));
      expect(i1.content, contains('01/11/2026'));
      expect(i1.content, isNot(contains('{{')));
    });

    test('não reemite nem reutiliza o número de um anulado', () async {
      final repo = _repo(_all);
      final a = await _request(repo);
      final issued = (await repo.issue(a.id)).getOrThrow();
      final again = await repo.issue(a.id);
      expect(again.failureOrNull?.code, 'CONFLICT');
      await repo.cancel(a.id);
      expect((await repo.cancel(a.id)).failureOrNull?.code, 'CONFLICT');
      final b = await _request(repo);
      expect(
        (await repo.issue(b.id)).getOrThrow().number,
        isNot(issued.number),
      );
    });

    test('lista filtra por estado e tipo', () async {
      final repo = _repo(_all);
      final a = await _request(repo);
      await _request(repo, kind: DocumentKind.attendanceDeclaration);
      await repo.issue(a.id);
      final issued = (await repo.list(
        status: DocumentStatus.issued,
      )).getOrThrow();
      expect(issued.items.map((d) => d.id), [a.id]);
      final byKind = (await repo.list(
        kind: DocumentKind.attendanceDeclaration,
      )).getOrThrow();
      expect(byKind.items, hasLength(1));
    });

    test('validação 422 no pedido', () async {
      final result = await _repo(_all).request(
        kind: DocumentKind.certificate,
        studentId: '',
        studentName: 'x',
        processNumber: 'p',
        purpose: '',
        variables: const {},
      );
      final failure = result.failureOrNull! as ValidationFailure;
      expect(failure.fields.keys, ['studentId']);
    });

    test(
      'permissões: pedir não emite; leitor não pede; sem acesso 403',
      () async {
        final requester = _repo(['grades.document.request']);
        final doc = await _request(requester);
        expect(
          (await requester.issue(doc.id)).failureOrNull?.code,
          'FORBIDDEN',
        );
        expect((await requester.templates()).isOk, isTrue);

        final reader = _repo(['grades.document.read']);
        expect((await reader.list()).isOk, isTrue);
        expect(
          (await reader.request(
            kind: DocumentKind.certificate,
            studentId: 'a',
            studentName: 'A',
            processNumber: 'p',
            purpose: '',
            variables: const {},
          )).failureOrNull?.code,
          'FORBIDDEN',
        );
        final none = _repo(['students.record.read']);
        expect((await none.list()).failureOrNull?.code, 'FORBIDDEN');
      },
    );

    test('verificação por número ou código QR, sem dados sensíveis', () async {
      final repo = _repo(_all);
      final doc = await _request(repo);
      final issued = (await repo.issue(doc.id)).getOrThrow();
      final byCode = (await repo.verify(
        documentVerificationCode(issued.number!),
      )).getOrThrow();
      expect(byCode.number, issued.number);
      expect(byCode.status, DocumentStatus.issued);
      await repo.cancel(doc.id);
      expect(
        (await repo.verify(issued.number!)).getOrThrow().status,
        DocumentStatus.cancelled,
      );
      expect(
        (await repo.verify('CERT-2026/9999')).failureOrNull?.code,
        'NOT_FOUND',
      );
    });
  });

  group('/v1/document-templates', () {
    test('edição altera a emissão seguinte; valida marcadores', () async {
      final repo = _repo(_all);
      final templates = (await repo.templates()).getOrThrow();
      final cert = templates.firstWhere(
        (t) => t.kind == DocumentKind.certificate,
      );
      final bad = await repo.updateTemplate(cert.id, 'Olá {{x}}');
      expect(bad.failureOrNull, isA<ValidationFailure>());
      await repo.updateTemplate(
        cert.id,
        'Certifico {{studentName}} ({{number}}).',
      );
      final doc = await _request(repo);
      final issued = (await repo.issue(doc.id)).getOrThrow();
      expect(issued.content, 'Certifico Ana Silva (CERT-2026/0001).');
    });

    test('só quem tem permissão de modelos edita', () async {
      final repo = _repo(['grades.document.issue']);
      final cert = (await repo.templates()).getOrThrow().first;
      expect(
        (await repo.updateTemplate(cert.id, 'x')).failureOrNull?.code,
        'FORBIDDEN',
      );
    });
  });

  test('PDF do documento emitido com número e QR', () async {
    final repo = _repo(_all);
    final doc = await _request(repo);
    final issued = (await repo.issue(doc.id)).getOrThrow();
    final template = AcademicDocumentTemplate(issued);
    expect(template.fileName, 'cert-2026-0001');
    expect(template.verificationCode, 'ERP-GLOBAL/DOC/CERT-2026/0001');
    final bytes = await const PdfTemplateEngine().render(
      letterhead: const PdfLetterhead(institutionName: 'Colégio Teste'),
      template: template,
      generatedAt: DateTime(2026, 11, 1),
    );
    expect(latin1.decode(bytes.sublist(0, 5)), '%PDF-');
    expect(bytes.length, greaterThan(1000));
  });

  testWidgets('tela emite um pedido, regista auditoria e verifica o número', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final repo = _repo(_all);
    final audit = _RecordingAudit();
    await tester.runAsync(() => _request(repo));
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          academicDocumentRepositoryProvider.overrideWithValue(repo),
          permissionServiceProvider.overrideWithValue(
            PermissionService.fromCodes(_all),
          ),
          auditRepositoryProvider.overrideWithValue(audit),
          auditActorProvider.overrideWithValue(
            const AuditActor(id: 'u1', name: 'Admin', institutionId: 'i1'),
          ),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          home: const Scaffold(body: AcademicDocumentsPage()),
        ),
      ),
    );
    await _settle(tester);
    expect(find.text('Certificado de habilitações'), findsOneWidget);

    final issue = find.byWidgetPredicate(
      (w) => w.key.toString().contains('document_issue_'),
    );
    await tester.tap(issue);
    await _settle(tester);
    await _settle(tester);
    expect(find.textContaining('CERT-2026/0001'), findsWidgets);
    expect(audit.entries.single.entity, 'academic_document');
    expect(audit.entries.single.action, AuditAction.approve);
    expect(audit.entries.single.after?['number'], 'CERT-2026/0001');

    await tester.enterText(
      find.byKey(const Key('documents_verify_field')),
      'ERP-GLOBAL/DOC/CERT-2026/0001',
    );
    await tester.tap(find.byKey(const Key('documents_verify')));
    await _settle(tester);
    expect(find.byKey(const Key('documents_verify_result')), findsOneWidget);
    expect(find.textContaining('Emitido'), findsWidgets);
  });
}

class _RecordingAudit implements AuditRepository {
  final entries = <AuditLogModel>[];

  @override
  Future<Result<PagedList<AuditLogModel>>> list(AuditQuery query) =>
      throw UnimplementedError();

  @override
  Future<Result<AuditLogModel>> record(AuditLogModel entry) async {
    entries.add(entry);
    return Ok(entry);
  }
}
