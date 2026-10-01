import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/mock_api/invoice_mock_handlers.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/charge.dart';
import '../../data/models/credit_note.dart';
import '../../data/models/invoice.dart';
import '../../data/repositories/api_invoice_repository.dart';
import '../../domain/invoice_repository.dart';
import '../pdf/invoice_pdf_templates.dart';
import 'billing_providers.dart';

/// Permissões das acções de facturação.
const invoiceReadPermission = 'billing.invoice.read';
const invoiceCreatePermission = 'billing.invoice.create';
const invoiceVoidPermission = 'billing.invoice.void';

final invoiceRepositoryProvider = Provider<InvoiceRepository>(
  (ref) => ApiInvoiceRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock de facturas; partilham as cobranças do módulo billing.
final invoiceMockHandlersProvider = Provider<InvoiceMockHandlers>((ref) {
  final billing = ref.watch(billingMockHandlersProvider);
  return InvoiceMockHandlers(
    chargeById: billing.chargeById,
    feeItemById: billing.feeItemById,
  );
});

final invoicePdfEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);

final invoicePdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

Future<List<T>> _all<T>(
  Future<({List<T> items, bool hasNext})> Function(int page) fetch,
) async {
  final all = <T>[];
  var page = 1;
  while (true) {
    final r = await fetch(page);
    all.addAll(r.items);
    if (!r.hasNext) return all;
    page++;
  }
}

/// Todas as facturas (mais recentes primeiro).
final invoiceListProvider = FutureProvider.autoDispose<List<Invoice>>((
  ref,
) async {
  final repo = ref.watch(invoiceRepositoryProvider);
  return _all((page) async {
    final r = (await repo.list(page: page, pageSize: 100)).getOrThrow();
    return (items: r.items, hasNext: r.meta.hasNext);
  });
}, retry: (_, _) => null);

/// Cobranças ainda sem factura emitida, para a emissão.
final invoiceableChargesProvider = FutureProvider.autoDispose<List<Charge>>((
  ref,
) async {
  final plan = ref.watch(billingPlanRepositoryProvider);
  final invoices = await ref.watch(invoiceListProvider.future);
  final invoiced = {
    for (final i in invoices)
      if (i.status == InvoiceStatus.issued)
        for (final l in i.lines) l.chargeId,
  };
  final charges = await _all((page) async {
    final r = (await plan.charges(page: page, pageSize: 100)).getOrThrow();
    return (items: r.items, hasNext: r.meta.hasNext);
  });
  return [
    for (final c in charges)
      if (c.status != ChargeStatus.cancelled && !invoiced.contains(c.id)) c,
  ];
}, retry: (_, _) => null);

/// Gera e guarda os PDFs de facturas e notas de crédito.
class InvoicePdfService {
  InvoicePdfService(this._ref);

  final Ref _ref;

  Future<PdfLetterhead> _letterhead() async {
    try {
      final i = await _ref.read(institutionProvider.future);
      if (i != null) {
        return PdfLetterhead(
          institutionName: i.name,
          nif: i.nif,
          address: i.address,
          phone: i.phone,
          email: i.email,
          brandColor: i.brandColor,
        );
      }
    } on Object {
      // sem acesso às definições: cabeçalho genérico
    }
    return const PdfLetterhead(institutionName: 'Instituição');
  }

  Future<bool> _save(PdfDocumentTemplate template) async {
    final bytes = await _ref
        .read(invoicePdfEngineProvider)
        .render(
          letterhead: await _letterhead(),
          template: template,
          generatedAt: DateTime.now(),
        );
    return _ref
        .read(invoicePdfSaverProvider)
        .save(fileName: template.fileName, bytes: bytes);
  }

  Future<CreditNote?> _noteOf(Invoice invoice) async {
    if (invoice.creditNoteId == null) return null;
    final page =
        (await _ref
                .read(invoiceRepositoryProvider)
                .creditNotes(invoiceId: invoice.id))
            .getOrThrow();
    return page.items.isEmpty ? null : page.items.first;
  }

  Future<void> exportInvoice(Invoice invoice) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final note = await _noteOf(invoice);
      final saved = await _save(
        InvoicePdfTemplate(invoice, creditNoteNumber: note?.number),
      );
      if (saved) toast.success('Factura guardada em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }

  Future<void> exportCreditNote(Invoice invoice) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final note = await _noteOf(invoice);
      if (note == null) {
        toast.error('A factura não tem nota de crédito.');
        return;
      }
      final saved = await _save(
        CreditNotePdfTemplate(note, invoiceNumber: invoice.number),
      );
      if (saved) toast.success('Nota de crédito guardada em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final invoicePdfServiceProvider = Provider<InvoicePdfService>(
  InvoicePdfService.new,
);
