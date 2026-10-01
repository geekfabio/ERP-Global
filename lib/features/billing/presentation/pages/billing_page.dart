import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
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
import '../../data/models/fee_item.dart';
import '../../domain/invoicing.dart';
import '../providers/billing_providers.dart';
import '../widgets/fee_item_dialog.dart';

const feeTypeLabels = feeTypeLabelsPt;

String _gradeLabel(String gradeId) {
  for (var i = 0; i < MockRef.gradeCount; i++) {
    if (MockRef.gradeId(i) == gradeId) return MockRef.gradeLabel(i);
  }
  return gradeId;
}

/// Financeiro: tabela de preços (ano × classe × campus) e aplicação de multas
/// e juros por atraso. As cobranças são geradas ao confirmar a matrícula.
class BillingPage extends ConsumerStatefulWidget {
  const BillingPage({super.key});

  @override
  ConsumerState<BillingPage> createState() => _BillingPageState();
}

class _BillingPageState extends ConsumerState<BillingPage> {
  void _refresh() => ref.invalidate(feeItemListProvider);

  void _report<T>(Result<T> result, String done) {
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success(done),
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _create() async {
    final draft = await showFeeItemDialog(context);
    if (draft == null) return;
    final result = await ref.read(feeItemRepositoryProvider).create(draft);
    _report(result, 'Preço registado');
    if (result.isOk) _refresh();
  }

  Future<void> _deactivate(FeeItem item) async {
    final result = await ref
        .read(feeItemRepositoryProvider)
        .update(item.id, status: FeeItemStatus.inactive);
    _report(result, 'Preço desactivado');
    if (result.isOk) _refresh();
  }

  Future<void> _applyLateFees() async {
    final result = await ref
        .read(billingPlanRepositoryProvider)
        .applyLateFees();
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (list) => toast.success(
        list.isEmpty
            ? 'Sem cobranças em atraso'
            : '${list.length} multa(s) aplicada(s)',
      ),
      err: (f) => toast.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(feeItemListProvider);
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
                      'Tabela de preços',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Can(
                    permission: 'billing.invoice.read',
                    child: IconButton(
                      tooltip: 'Facturas',
                      icon: const Icon(Icons.receipt_long_outlined),
                      onPressed: () => context.go('/billing/invoices'),
                    ),
                  ),
                  Can(
                    permission: 'billing.payment.read',
                    child: IconButton(
                      tooltip: 'Pagamentos',
                      icon: const Icon(Icons.payments_outlined),
                      onPressed: () => context.go('/billing/payments'),
                    ),
                  ),
                  Can(
                    permission: 'billing.debtor.read',
                    child: IconButton(
                      tooltip: 'Devedores',
                      icon: const Icon(Icons.money_off_outlined),
                      onPressed: () => context.go('/billing/debtors'),
                    ),
                  ),
                  Can(
                    permission: 'billing.discount.read',
                    child: IconButton(
                      tooltip: 'Descontos',
                      icon: const Icon(Icons.sell_outlined),
                      onPressed: () => context.go('/billing/discounts'),
                    ),
                  ),
                  Can(
                    permission: 'billing.report.read',
                    child: IconButton(
                      tooltip: 'Relatórios',
                      icon: const Icon(Icons.bar_chart_outlined),
                      onPressed: () => context.go('/billing/reports'),
                    ),
                  ),
                  Can(
                    permission: 'billing.cash.read',
                    child: IconButton(
                      tooltip: 'Caixa',
                      icon: const Icon(Icons.point_of_sale_outlined),
                      onPressed: () => context.go('/billing/cash'),
                    ),
                  ),
                  Can(
                    permission: 'billing.invoice.create',
                    child: Wrap(
                      spacing: AppSpacing.sm,
                      children: [
                        AppButton(
                          label: 'Aplicar multas e juros',
                          icon: Icons.gavel_outlined,
                          onPressed: _applyLateFees,
                        ),
                        AppButton(
                          label: 'Novo preço',
                          icon: Icons.add,
                          onPressed: _create,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<FeeItem>>(
                  value: items,
                  onRetry: _refresh,
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.payments_outlined,
                    title: 'Sem preços definidos',
                  ),
                  data: (d) => _PriceTable(items: d, onDeactivate: _deactivate),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceTable extends ConsumerStatefulWidget {
  const _PriceTable({required this.items, required this.onDeactivate});

  final List<FeeItem> items;
  final void Function(FeeItem) onDeactivate;

  @override
  ConsumerState<_PriceTable> createState() => _PriceTableState();
}

class _PriceTableState extends ConsumerState<_PriceTable> {
  late final TableController<FeeItem> _table = TableController(
    rows: widget.items,
    rowId: (i) => i.id,
    columns: [
      AppColumn(
        label: 'Classe',
        text: (i) => _gradeLabel(i.gradeId),
        sortValue: (i) => i.gradeId,
      ),
      AppColumn(
        label: 'Tipo',
        text: (i) => feeTypeLabels[i.type]!,
        sortValue: (i) => feeTypeLabels[i.type]!,
      ),
      AppColumn(
        label: 'Campus',
        text: (i) => i.campusId == null ? 'Todos' : 'Campus',
      ),
      AppColumn(
        label: 'Valor',
        text: (i) => PtAoFormatters.currency(i.amountMinor),
        sortValue: (i) => i.amountMinor,
        numeric: true,
      ),
      AppColumn(
        label: 'Estado',
        text: (i) => i.status == FeeItemStatus.active ? 'Activo' : 'Inactivo',
        cell: (i) => StatusBadge(
          label: i.status == FeeItemStatus.active ? 'Activo' : 'Inactivo',
          status: i.status == FeeItemStatus.active
              ? BadgeStatus.success
              : BadgeStatus.neutral,
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(_PriceTable old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<FeeItem>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem preços definidos',
      rowActions: [
        if (can('billing.invoice.create'))
          RowAction(
            label: 'Desactivar',
            icon: Icons.block,
            onTap: widget.onDeactivate,
          ),
      ],
    );
  }
}
