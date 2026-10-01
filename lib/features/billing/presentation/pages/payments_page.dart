import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/payment.dart';
import '../../domain/payments.dart';
import '../providers/payment_providers.dart';
import '../widgets/payment_dialogs.dart';

/// Pagamentos: registo (parcial, total ou adiantado), recibo em PDF e conta
/// corrente do aluno. Os pagamentos registados são imutáveis.
class PaymentsPage extends ConsumerStatefulWidget {
  const PaymentsPage({super.key});

  @override
  ConsumerState<PaymentsPage> createState() => _PaymentsPageState();
}

class _PaymentsPageState extends ConsumerState<PaymentsPage> {
  void _refresh() {
    ref
      ..invalidate(paymentListProvider)
      ..invalidate(openChargesProvider)
      ..invalidate(studentAccountProvider);
  }

  Future<void> _register() async {
    final req = await showRegisterPaymentDialog(context);
    if (req == null) return;
    final result = await ref
        .read(paymentRepositoryProvider)
        .create(
          studentId: req.studentId,
          method: req.method,
          amountMinor: req.amountMinor,
        );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (r) => toast.success(
        r.receipt == null
            ? 'Pagamento registado'
            : 'Pagamento registado · recibo ${r.receipt!.number}',
      ),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final payments = ref.watch(paymentListProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Pagamentos',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Can(
                    permission: paymentCreatePermission,
                    child: AppButton(
                      label: 'Registar pagamento',
                      icon: Icons.add,
                      onPressed: _register,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<Payment>>(
                  value: payments,
                  onRetry: _refresh,
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.payments_outlined,
                    title: 'Sem pagamentos registados',
                  ),
                  data: (d) => _PaymentTable(payments: d),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PaymentTable extends ConsumerStatefulWidget {
  const _PaymentTable({required this.payments});

  final List<Payment> payments;

  @override
  ConsumerState<_PaymentTable> createState() => _PaymentTableState();
}

class _PaymentTableState extends ConsumerState<_PaymentTable> {
  late final TableController<Payment> _table = TableController(
    rows: widget.payments,
    rowId: (p) => p.id,
    columns: [
      AppColumn(
        label: 'Data',
        text: (p) => PtAoFormatters.date(p.paidAt),
        sortValue: (p) => p.paidAt,
      ),
      AppColumn(label: 'Aluno', text: (p) => shortId(p.studentId)),
      AppColumn(label: 'Método', text: (p) => paymentMethodLabelsPt[p.method]!),
      AppColumn(
        label: 'Valor',
        text: (p) => PtAoFormatters.currency(p.amountMinor),
        sortValue: (p) => p.amountMinor,
        numeric: true,
      ),
      AppColumn(
        label: 'Alocado',
        text: (p) => PtAoFormatters.currency(
          p.allocations.fold<int>(0, (a, x) => a + x.amountMinor),
        ),
        numeric: true,
      ),
    ],
  );

  @override
  void didUpdateWidget(_PaymentTable old) {
    super.didUpdateWidget(old);
    if (old.payments != widget.payments) _table.setRows(widget.payments);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<Payment>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem pagamentos registados',
      rowActions: [
        if (can(paymentReadPermission))
          RowAction(
            label: 'Recibo em PDF',
            icon: Icons.picture_as_pdf_outlined,
            onTap: (p) {
              if (p.method != PaymentMethod.prepaidBalance) {
                ref.read(receiptPdfServiceProvider).exportReceipt(p);
              }
            },
          ),
        if (can(paymentReadPermission))
          RowAction(
            label: 'Conta corrente',
            icon: Icons.account_balance_wallet_outlined,
            onTap: (p) => showStudentAccountDialog(context, p.studentId),
          ),
      ],
    );
  }
}
