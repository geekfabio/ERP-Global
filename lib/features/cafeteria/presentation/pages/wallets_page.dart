import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/events/domain_event.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/wallet.dart';
import '../providers/wallet_providers.dart';
import '../widgets/wallet_dialogs.dart';

/// Carteira pré-paga do refeitório: saldo, carregamentos, limite diário,
/// bloqueio e extracto.
class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({super.key});

  @override
  ConsumerState<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends ConsumerState<WalletsPage> {
  void _audit(Wallet before, Wallet after) => unawaited(
    ref
        .read(auditServiceProvider)
        .record(
          entity: 'wallet',
          action: AuditAction.update,
          entityId: after.id,
          before: before.toJson(),
          after: after.toJson(),
        ),
  );

  void _report<T>(Result<T> result, String done, {void Function(T)? onOk}) {
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (v) {
        onOk?.call(v);
        toast.success(done);
        ref.invalidate(walletListProvider);
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _open() async {
    final v = await showOpenWalletDialog(context);
    if (v == null) return;
    final result = await ref
        .read(walletRepositoryProvider)
        .open(
          holderId: v.holderId,
          holderName: v.holderName,
          dailyLimitMinor: v.dailyLimitMinor,
        );
    _report(result, 'Carteira aberta');
  }

  Future<void> _topUp(Wallet w) async {
    final v = await showTopUpDialog(context, w);
    if (v == null) return;
    final result = await ref
        .read(walletRepositoryProvider)
        .topUp(
          w.id,
          amountMinor: v.amountMinor,
          method: v.method,
          reference: v.reference,
        );
    _report(
      result,
      'Carregamento registado',
      // Contrato com o billing: avisa que houve um carregamento pago.
      onOk: (tx) => ref
          .read(domainEventBusProvider)
          .publish(
            WalletToppedUp(
              walletId: w.id,
              holderId: w.holderId,
              transactionId: tx.id,
              amountMinor: tx.amountMinor,
              method: tx.method ?? v.method,
              reference: tx.reference,
              occurredAt: tx.occurredAt,
            ),
          ),
    );
  }

  Future<void> _limit(Wallet w) async {
    final v = await showDailyLimitDialog(context, w);
    if (v == null) return;
    final result = await ref
        .read(walletRepositoryProvider)
        .setDailyLimit(w.id, v);
    _report(result, 'Limite diário actualizado', onOk: (a) => _audit(w, a));
  }

  Future<void> _toggleBlock(Wallet w) async {
    final block = !w.blocked;
    final ok = await showConfirmDialog(
      context: context,
      title: block ? 'Bloquear carteira' : 'Desbloquear carteira',
      message:
          '${block ? 'Bloquear' : 'Desbloquear'} a carteira de ${w.holderName}?',
      confirmLabel: block ? 'Bloquear' : 'Desbloquear',
      destructive: block,
    );
    if (!ok) return;
    final result = await ref
        .read(walletRepositoryProvider)
        .setBlocked(w.id, blocked: block);
    _report(
      result,
      block ? 'Carteira bloqueada' : 'Carteira desbloqueada',
      onOk: (a) => _audit(w, a),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wallets = ref.watch(walletListProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Carteiras',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Can(
                      permission: 'cafeteria.wallet.create',
                      child: AppButton(
                        label: 'Abrir',
                        icon: Icons.add,
                        onPressed: _open,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AsyncValueView<List<Wallet>>(
                  value: wallets,
                  onRetry: () => ref.invalidate(walletListProvider),
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Sem carteiras',
                    message: 'Ainda não foram abertas carteiras.',
                  ),
                  data: (items) => _WalletsTable(
                    items: items,
                    onTopUp: _topUp,
                    onLimit: _limit,
                    onToggleBlock: _toggleBlock,
                    onStatement: (w) => showStatementDialog(context, w),
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

class _WalletsTable extends ConsumerStatefulWidget {
  const _WalletsTable({
    required this.items,
    required this.onTopUp,
    required this.onLimit,
    required this.onToggleBlock,
    required this.onStatement,
  });

  final List<Wallet> items;
  final void Function(Wallet) onTopUp;
  final void Function(Wallet) onLimit;
  final void Function(Wallet) onToggleBlock;
  final void Function(Wallet) onStatement;

  @override
  ConsumerState<_WalletsTable> createState() => _WalletsTableState();
}

class _WalletsTableState extends ConsumerState<_WalletsTable> {
  late final TableController<Wallet> _table = TableController(
    rows: widget.items,
    rowId: (w) => w.id,
    columns: [
      AppColumn(
        label: 'Titular',
        text: (w) => w.holderName,
        sortValue: (w) => w.holderName,
      ),
      AppColumn(
        label: 'Saldo',
        text: (w) => PtAoFormatters.currency(w.balanceMinor),
        sortValue: (w) => w.balanceMinor,
      ),
      AppColumn(
        label: 'Limite diário',
        text: (w) => w.dailyLimitMinor == 0
            ? 'Sem limite'
            : PtAoFormatters.currency(w.dailyLimitMinor),
        sortValue: (w) => w.dailyLimitMinor,
      ),
      AppColumn(
        label: 'Estado',
        text: (w) => w.blocked ? 'Bloqueada' : 'Activa',
        sortValue: (w) => w.blocked ? 1 : 0,
        cell: (w) => StatusBadge(
          label: w.blocked ? 'Bloqueada' : 'Activa',
          status: w.blocked ? BadgeStatus.danger : BadgeStatus.success,
        ),
      ),
    ],
  );

  @override
  void didUpdateWidget(_WalletsTable old) {
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
    final p = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<Wallet>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem carteiras',
      rowActions: [
        if (p('cafeteria.wallet.topup'))
          RowAction(
            label: 'Carregar',
            icon: Icons.add_card,
            onTap: widget.onTopUp,
          ),
        RowAction(
          label: 'Extracto',
          icon: Icons.receipt_long_outlined,
          onTap: widget.onStatement,
        ),
        if (p('cafeteria.wallet.limit'))
          RowAction(
            label: 'Limite diário',
            icon: Icons.speed,
            onTap: widget.onLimit,
          ),
        if (p('cafeteria.wallet.block'))
          RowAction(
            label: 'Bloqueio',
            icon: Icons.block,
            onTap: widget.onToggleBlock,
          ),
      ],
    );
  }
}
