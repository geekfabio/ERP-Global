import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
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
import '../../data/models/discount.dart';
import '../../domain/discounts.dart';
import '../../domain/invoicing.dart';
import '../providers/discount_providers.dart';
import '../widgets/discount_dialogs.dart';
import '../widgets/payment_dialogs.dart' show shortId;

BadgeStatus _badge(DiscountStatus s) => switch (s) {
  DiscountStatus.pending => BadgeStatus.warning,
  DiscountStatus.approved => BadgeStatus.success,
  DiscountStatus.rejected => BadgeStatus.danger,
  DiscountStatus.revoked => BadgeStatus.neutral,
};

String _validity(Discount d) {
  final from = PtAoFormatters.date(d.validFrom);
  final until = d.validUntil;
  return until == null
      ? 'desde $from'
      : '$from a ${PtAoFormatters.date(until)}';
}

/// Descontos e bolsas: pedido (percentagem ou valor, irmãos, mérito, bolsa,
/// com validade) e aprovação. Só os aprovados se reflectem na cobrança.
class DiscountsPage extends ConsumerStatefulWidget {
  const DiscountsPage({super.key});

  @override
  ConsumerState<DiscountsPage> createState() => _DiscountsPageState();
}

class _DiscountsPageState extends ConsumerState<DiscountsPage> {
  void _audit(AuditAction action, Discount after, {Discount? before}) =>
      unawaited(
        ref
            .read(auditServiceProvider)
            .record(
              entity: 'discount',
              action: action,
              entityId: after.id,
              before: before?.toJson(),
              after: after.toJson(),
            ),
      );

  void _report(
    Result<Discount> result,
    String done,
    AuditAction action, {
    Discount? before,
  }) {
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (d) {
        toast.success(done);
        _audit(action, d, before: before);
      },
      err: (f) => toast.error(f.message),
    );
    ref.invalidate(discountListProvider);
  }

  Future<void> _request() async {
    final draft = await showDiscountRequestDialog(context);
    if (draft == null) return;
    final result = await ref
        .read(discountRepositoryProvider)
        .request(
          studentId: draft.studentId,
          kind: draft.kind,
          reason: draft.reason,
          value: draft.value,
          feeType: draft.feeType,
          validFrom: draft.validFrom,
          validUntil: draft.validUntil,
          note: draft.note,
        );
    _report(result, 'Desconto pedido', AuditAction.create);
  }

  Future<void> _approve(Discount d) async => _report(
    await ref.read(discountRepositoryProvider).approve(d.id),
    'Desconto aprovado',
    AuditAction.approve,
    before: d,
  );

  Future<void> _reject(Discount d) async => _report(
    await ref.read(discountRepositoryProvider).reject(d.id),
    'Desconto rejeitado',
    AuditAction.cancel,
    before: d,
  );

  Future<void> _revoke(Discount d) async => _report(
    await ref.read(discountRepositoryProvider).revoke(d.id),
    'Desconto revogado',
    AuditAction.cancel,
    before: d,
  );

  @override
  Widget build(BuildContext context) {
    final discounts = ref.watch(discountListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
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
                      'Descontos e bolsas',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Can(
                    permission: discountRequestPermission,
                    child: AppButton(
                      label: 'Pedir desconto',
                      icon: Icons.add,
                      onPressed: _request,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<Discount>>(
                  value: discounts,
                  onRetry: () => ref.invalidate(discountListProvider),
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.sell_outlined,
                    title: 'Sem descontos ou bolsas',
                  ),
                  data: (d) => _DiscountTable(
                    discounts: d,
                    canApprove: can(discountApprovePermission),
                    onApprove: _approve,
                    onReject: _reject,
                    onRevoke: _revoke,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscountTable extends StatefulWidget {
  const _DiscountTable({
    required this.discounts,
    required this.canApprove,
    required this.onApprove,
    required this.onReject,
    required this.onRevoke,
  });

  final List<Discount> discounts;
  final bool canApprove;
  final void Function(Discount) onApprove;
  final void Function(Discount) onReject;
  final void Function(Discount) onRevoke;

  @override
  State<_DiscountTable> createState() => _DiscountTableState();
}

class _DiscountTableState extends State<_DiscountTable> {
  late final TableController<Discount> _table = TableController(
    rows: widget.discounts,
    rowId: (d) => d.id,
    columns: [
      AppColumn(label: 'Aluno', text: (d) => shortId(d.studentId)),
      AppColumn(
        label: 'Motivo',
        text: (d) => discountReasonLabels[d.reason]!,
        sortValue: (d) => discountReasonLabels[d.reason]!,
      ),
      AppColumn(
        label: 'Desconto',
        text: (d) => discountValueLabel(d.kind, d.value),
        numeric: true,
      ),
      AppColumn(
        label: 'Aplica-se a',
        text: (d) => d.feeType == null ? 'Todas' : feeTypeLabelsPt[d.feeType]!,
      ),
      AppColumn(label: 'Validade', text: _validity),
      AppColumn(
        label: 'Estado',
        text: (d) => discountStatusLabels[d.status]!,
        sortValue: (d) => discountStatusLabels[d.status]!,
        cell: (d) => StatusBadge(
          label: discountStatusLabels[d.status]!,
          status: _badge(d.status),
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(_DiscountTable old) {
    super.didUpdateWidget(old);
    if (old.discounts != widget.discounts) _table.setRows(widget.discounts);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<Discount>(
    controller: _table,
    selectable: false,
    emptyText: 'Sem descontos ou bolsas',
    rowActions: [
      if (widget.canApprove) ...[
        RowAction(
          label: 'Aprovar',
          icon: Icons.check_circle_outline,
          onTap: widget.onApprove,
        ),
        RowAction(
          label: 'Rejeitar',
          icon: Icons.cancel_outlined,
          onTap: widget.onReject,
        ),
        RowAction(label: 'Revogar', icon: Icons.block, onTap: widget.onRevoke),
      ],
    ],
  );
}
