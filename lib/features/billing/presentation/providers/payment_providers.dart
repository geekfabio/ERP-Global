import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../settings/presentation/providers/pdf_letterhead_provider.dart';
import '../../data/mock_api/payment_mock_handlers.dart';
import '../../data/models/charge.dart';
import '../../data/models/payment.dart';
import '../../data/models/student_account.dart';
import '../../data/repositories/api_payment_repository.dart';
import '../../domain/payment_repository.dart';
import '../../domain/payments.dart';
import '../pdf/receipt_pdf_template.dart';
import 'billing_providers.dart';
import 'cash_providers.dart';

/// Permissões das acções de pagamentos.
const paymentReadPermission = 'billing.payment.read';
const paymentCreatePermission = 'billing.payment.create';

final paymentRepositoryProvider = Provider<PaymentRepository>(
  (ref) => ApiPaymentRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock de pagamentos; partilham as cobranças do módulo billing.
final paymentMockHandlersProvider = Provider<PaymentMockHandlers>((ref) {
  final billing = ref.watch(billingMockHandlersProvider);
  final cash = ref.watch(cashMockHandlersProvider);
  return PaymentMockHandlers(
    onPayment: cash.recordCashPayment,
    chargesOf: billing.chargesOf,
    setChargeStatus: billing.setChargeStatus,
  );
});

final paymentPdfEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);

final paymentPdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

/// Todos os pagamentos (mais recentes primeiro).
final paymentListProvider = FutureProvider.autoDispose<List<Payment>>((
  ref,
) async {
  final repo = ref.watch(paymentRepositoryProvider);
  final all = <Payment>[];
  var page = 1;
  while (true) {
    final r = (await repo.list(page: page, pageSize: 100)).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) return all;
    page++;
  }
}, retry: (_, _) => null);

/// Cobranças em aberto (por pagar ou parciais) de todos os alunos.
final openChargesProvider = FutureProvider.autoDispose<List<Charge>>((
  ref,
) async {
  final plan = ref.watch(billingPlanRepositoryProvider);
  final all = <Charge>[];
  var page = 1;
  while (true) {
    final r = (await plan.charges(page: page, pageSize: 100)).getOrThrow();
    all.addAll(r.items);
    if (!r.meta.hasNext) break;
    page++;
  }
  return all.where(isChargeOpen).toList();
}, retry: (_, _) => null);

/// Conta corrente de um aluno.
final studentAccountProvider = FutureProvider.autoDispose
    .family<StudentAccount, String>(
      (ref, studentId) async =>
          (await ref.watch(paymentRepositoryProvider).account(studentId))
              .getOrThrow(),
      retry: (_, _) => null,
    );

/// Gera e guarda o PDF do recibo de um pagamento.
class ReceiptPdfService {
  ReceiptPdfService(this._ref);

  final Ref _ref;

  Future<void> exportReceipt(Payment payment) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final page =
          (await _ref
                  .read(paymentRepositoryProvider)
                  .receipts(paymentId: payment.id))
              .getOrThrow();
      if (page.items.isEmpty) {
        toast.error('Este pagamento não tem recibo (saldo pré-pago).');
        return;
      }
      final template = ReceiptPdfTemplate(page.items.first, payment);
      final bytes = await _ref
          .read(paymentPdfEngineProvider)
          .render(
            letterhead: await _ref
                .read(institutionPdfLetterheadProvider)
                .load(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(paymentPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Recibo guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final receiptPdfServiceProvider = Provider<ReceiptPdfService>(
  ReceiptPdfService.new,
);
