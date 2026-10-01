import 'package:erp_global/core/errors/failure.dart';
import 'package:erp_global/core/network/api_client.dart';
import 'package:erp_global/core/network/mock/mock_api_config.dart';
import 'package:erp_global/core/network/mock/mock_api_registry.dart';
import 'package:erp_global/core/network/mock/mock_reference_data.dart';
import 'package:erp_global/core/pdf/pdf_template.dart';
import 'package:erp_global/core/utils/pt_ao_formatters.dart';
import 'package:erp_global/core/pdf/pdf_template_engine.dart';
import 'package:erp_global/core/events/domain_event.dart';
import 'package:erp_global/features/billing/data/mock_api/billing_mock_handlers.dart';
import 'package:erp_global/features/billing/data/mock_api/invoice_mock_handlers.dart';
import 'package:erp_global/features/billing/data/models/billing_enums.dart';
import 'package:erp_global/features/billing/data/models/charge.dart';
import 'package:erp_global/features/billing/data/repositories/api_billing_repositories.dart';
import 'package:erp_global/features/billing/data/repositories/api_invoice_repository.dart';
import 'package:erp_global/features/billing/domain/invoicing.dart';
import 'package:erp_global/features/billing/presentation/pdf/invoice_pdf_templates.dart';
import 'package:flutter_test/flutter_test.dart';

Future<({ApiInvoiceRepository repo, List<Charge> charges})> _env() async {
  final billing = BillingMockHandlers();
  final registry = MockApiRegistry()
    ..addModule(billing)
    ..addModule(
      InvoiceMockHandlers(
        chargeById: billing.chargeById,
        feeItemById: billing.feeItemById,
      ),
    );
  final client = ApiClient.create(
    baseUrl: 'https://api.test',
    useMockApi: true,
    registry: registry,
    mockConfig: const MockApiConfig.instant(),
    logging: false,
  );
  final plan = ApiBillingPlanRepository(client);
  final charges = (await plan.generateForEnrollment(
    EnrollmentConfirmed(
      enrollmentId: 'enr-1',
      studentId: 'stu-1',
      academicYearId: MockRef.academicYearId,
      gradeId: MockRef.gradeId(3),
      classroomId: MockRef.classroomId(3, 0),
      type: 'new_enrollment',
      feeMinor: 1700000,
      occurredAt: DateTime.utc(2025, 9, 1),
    ),
  )).getOrThrow();
  return (repo: ApiInvoiceRepository(client), charges: charges);
}

void main() {
  setUpAll(PtAoFormatters.initialize);
  group('cálculo', () {
    test('IVA em inteiros com arredondamento ao cêntimo', () {
      expect(computeTax(1000000, 1400), 140000);
      expect(computeTax(1005, 1400), 141); // 140,7
      expect(computeTax(1000000, 0), 0);
    });

    test('totais, numeração e rótulos', () {
      final lines = [
        buildInvoiceLine(
          chargeId: 'a',
          description: 'x',
          netMinor: 1000,
          rateBp: 1400,
        ),
        buildInvoiceLine(
          chargeId: 'b',
          description: 'y',
          netMinor: 500,
          rateBp: 1400,
        ),
      ];
      final t = invoiceTotals(lines);
      expect((t.net, t.tax, t.total), (1500, 210, 1710));
      expect(formatDocumentNumber('FT 2026', 12), 'FT 2026/000012');
      expect(vatRateLabel(1400), '14 %');
      expect(vatRateLabel(0), 'Isento');
    });
  });

  group('API mock de facturas', () {
    test('emite com série, número sequencial e IVA', () async {
      final e = await _env();
      final a = (await e.repo.issue(
        studentId: 'stu-1',
        chargeIds: [e.charges[0].id],
        taxRateBp: 1400,
      )).getOrThrow();
      final b = (await e.repo.issue(
        studentId: 'stu-1',
        chargeIds: [e.charges[1].id, e.charges[2].id],
        taxRateBp: 1400,
      )).getOrThrow();
      expect(a.status, InvoiceStatus.issued);
      expect(a.number, endsWith('/000001'));
      expect(b.number, endsWith('/000002'));
      expect(a.series, startsWith('FT '));
      expect(a.totalMinor, e.charges[0].amountMinor + a.taxMinor);
      expect(b.lines, hasLength(2));
      final page = (await e.repo.list()).getOrThrow();
      expect(page.meta.total, 2);
    });

    test(
      'valida: sem cobranças, isenção sem motivo, cobrança repetida',
      () async {
        final e = await _env();
        final empty = await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [],
          taxRateBp: 1400,
        );
        expect(empty.failureOrNull, isA<ValidationFailure>());
        final exempt = await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [e.charges[0].id],
          taxRateBp: 0,
        );
        expect(exempt.failureOrNull, isA<ValidationFailure>());
        final ok = await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [e.charges[0].id],
          taxRateBp: 0,
          exemptionReason: 'Isento (art. 12.º)',
        );
        expect(ok.getOrThrow().taxMinor, 0);
        final dup = await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [e.charges[0].id],
          taxRateBp: 1400,
        );
        expect(
          dup.failureOrNull,
          isA<UnknownFailure>().having((f) => f.code, 'code', 'CONFLICT'),
        );
        final other = await e.repo.issue(
          studentId: 'stu-2',
          chargeIds: [e.charges[1].id],
          taxRateBp: 1400,
        );
        expect(other.failureOrNull, isA<ValidationFailure>());
      },
    );

    test(
      'anula com motivo, emite nota de crédito e liberta a cobrança',
      () async {
        final e = await _env();
        final inv = (await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [e.charges[0].id],
          taxRateBp: 1400,
        )).getOrThrow();
        expect(
          (await e.repo.cancel(inv.id, reason: ' ')).failureOrNull,
          isA<ValidationFailure>(),
        );
        final r = (await e.repo.cancel(
          inv.id,
          reason: 'Erro de valor',
        )).getOrThrow();
        expect(r.invoice.status, InvoiceStatus.cancelled);
        expect(r.invoice.creditNoteId, r.creditNote.id);
        expect(r.creditNote.totalMinor, inv.totalMinor);
        expect(r.creditNote.number, contains('NC '));
        expect(
          (await e.repo.cancel(inv.id, reason: 'outra')).failureOrNull,
          isA<UnknownFailure>().having((f) => f.code, 'code', 'CONFLICT'),
        );
        final notes = (await e.repo.creditNotes(
          invoiceId: inv.id,
        )).getOrThrow();
        expect(notes.items, hasLength(1));
        // A cobrança anulada pode ser facturada de novo.
        final again = await e.repo.issue(
          studentId: 'stu-1',
          chargeIds: [e.charges[0].id],
          taxRateBp: 1400,
        );
        expect(again.isOk, isTrue);
      },
    );
  });

  test('PDFs de factura e nota de crédito são gerados', () async {
    final e = await _env();
    final inv = (await e.repo.issue(
      studentId: 'stu-1',
      chargeIds: [e.charges[0].id],
      taxRateBp: 1400,
    )).getOrThrow();
    final r = (await e.repo.cancel(
      inv.id,
      reason: 'Erro de valor',
    )).getOrThrow();
    const engine = PdfTemplateEngine();
    const head = PdfLetterhead(institutionName: 'Escola Teste');
    for (final t in <PdfDocumentTemplate>[
      InvoicePdfTemplate(r.invoice, creditNoteNumber: r.creditNote.number),
      CreditNotePdfTemplate(r.creditNote, invoiceNumber: r.invoice.number),
    ]) {
      final bytes = await engine.render(
        letterhead: head,
        template: t,
        generatedAt: DateTime.utc(2026, 1, 1),
      );
      expect(String.fromCharCodes(bytes.take(4)), '%PDF');
      expect(t.fileName, isNot(contains('/')));
    }
  });

  test('documento emitido é imutável (PATCH/PUT/DELETE recusados)', () async {
    final e = await _env();
    final inv = (await e.repo.issue(
      studentId: 'stu-1',
      chargeIds: [e.charges[0].id],
      taxRateBp: 1400,
    )).getOrThrow();
    final client = ApiClient.create(
      baseUrl: 'https://api.test',
      useMockApi: true,
      registry: MockApiRegistry()
        ..addModule(
          InvoiceMockHandlers(
            chargeById: (_) => null,
            feeItemById: (_) => null,
          ),
        ),
      mockConfig: const MockApiConfig.instant(),
      logging: false,
    );
    for (final call in [
      () => client.dio.patch<dynamic>('/v1/invoices/${inv.id}', data: {}),
      () => client.dio.delete<dynamic>('/v1/invoices/${inv.id}'),
    ]) {
      await expectLater(call(), throwsA(anything));
    }
  });
}
