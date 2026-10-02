import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/invoice.dart';
import '../providers/invoice_providers.dart';
import '../widgets/issue_invoice_dialog.dart';

String _tail(String id) => id.length <= 8 ? id : id.substring(id.length - 8);

/// Facturas emitidas: emissão com série e IVA, anulação com nota de crédito
/// e PDF. Documentos emitidos são imutáveis.
class InvoicesPage extends ConsumerStatefulWidget {
  const InvoicesPage({super.key});

  @override
  ConsumerState<InvoicesPage> createState() => _InvoicesPageState();
}

class _InvoicesPageState extends ConsumerState<InvoicesPage> {
  void _refresh() {
    ref
      ..invalidate(invoiceListProvider)
      ..invalidate(invoiceableChargesProvider);
  }

  Future<void> _issue() async {
    final req = await showIssueInvoiceDialog(context);
    if (req == null) return;
    final result = await ref
        .read(invoiceRepositoryProvider)
        .issue(
          studentId: req.studentId,
          chargeIds: req.chargeIds,
          taxRateBp: req.taxRateBp,
          exemptionReason: req.exemptionReason,
        );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (i) => toast.success('Factura ${i.number} emitida'),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) _refresh();
  }

  Future<void> _cancel(Invoice invoice) async {
    final reason = await showCancelInvoiceDialog(context, invoice.number ?? '');
    if (reason == null) return;
    final result = await ref
        .read(invoiceRepositoryProvider)
        .cancel(invoice.id, reason: reason);
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (c) =>
          toast.success('Anulada com a nota de crédito ${c.creditNote.number}'),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final invoices = ref.watch(invoiceListProvider);
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
                      'Facturas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Can(
                    permission: invoiceCreatePermission,
                    child: AppButton(
                      label: 'Emitir factura',
                      icon: Icons.add,
                      onPressed: _issue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<Invoice>>(
                  value: invoices,
                  onRetry: _refresh,
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'Sem facturas emitidas',
                  ),
                  data: (d) => _InvoiceTable(invoices: d, onCancel: _cancel),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceTable extends ConsumerStatefulWidget {
  const _InvoiceTable({required this.invoices, required this.onCancel});

  final List<Invoice> invoices;
  final void Function(Invoice) onCancel;

  @override
  ConsumerState<_InvoiceTable> createState() => _InvoiceTableState();
}

class _InvoiceTableState extends ConsumerState<_InvoiceTable> {
  late final TableController<Invoice> _table = TableController(
    rows: widget.invoices,
    rowId: (i) => i.id,
    columns: [
      AppColumn(
        label: 'Número',
        text: (i) => i.number ?? '-',
        sortValue: (i) => i.number ?? '',
      ),
      AppColumn(label: 'Aluno', text: (i) => _tail(i.studentId)),
      AppColumn(
        label: 'Emissão',
        text: (i) =>
            i.issuedAt == null ? '-' : PtAoFormatters.date(i.issuedAt!),
        sortValue: (i) => i.issuedAt ?? i.createdAt,
      ),
      AppColumn(
        label: 'IVA',
        text: (i) => PtAoFormatters.currency(i.taxMinor),
        sortValue: (i) => i.taxMinor,
        numeric: true,
      ),
      AppColumn(
        label: 'Total',
        text: (i) => PtAoFormatters.currency(i.totalMinor),
        sortValue: (i) => i.totalMinor,
        numeric: true,
      ),
      AppColumn(
        label: 'Estado',
        text: (i) => _statusLabel(i.status),
        cell: (i) => StatusBadge(
          label: _statusLabel(i.status),
          status: switch (i.status) {
            InvoiceStatus.issued => BadgeStatus.success,
            InvoiceStatus.cancelled => BadgeStatus.danger,
            InvoiceStatus.draft => BadgeStatus.neutral,
          },
        ),
      ),
    ],
  );

  static String _statusLabel(InvoiceStatus s) => switch (s) {
    InvoiceStatus.draft => 'Rascunho',
    InvoiceStatus.issued => 'Emitida',
    InvoiceStatus.cancelled => 'Anulada',
  };

  @override
  void didUpdateWidget(_InvoiceTable old) {
    super.didUpdateWidget(old);
    if (old.invoices != widget.invoices) _table.setRows(widget.invoices);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = ref.watch(permissionServiceProvider).canAny;
    final pdf = ref.read(invoicePdfServiceProvider);
    return AppDataTable<Invoice>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem facturas emitidas',
      rowActions: [
        if (can(invoiceReadPermission))
          RowAction(
            label: 'Factura em PDF',
            icon: Icons.picture_as_pdf_outlined,
            onTap: pdf.exportInvoice,
          ),
        if (can(invoiceReadPermission))
          RowAction(
            label: 'Nota de crédito em PDF',
            icon: Icons.description_outlined,
            onTap: (i) {
              if (i.status == InvoiceStatus.cancelled) pdf.exportCreditNote(i);
            },
          ),
        if (can(invoiceVoidPermission))
          RowAction(
            label: 'Anular',
            icon: Icons.block,
            onTap: (i) {
              if (i.status == InvoiceStatus.issued) widget.onCancel(i);
            },
          ),
      ],
    );
  }
}
