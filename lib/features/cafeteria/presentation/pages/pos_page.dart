import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/wallet.dart';
import '../providers/pos_providers.dart';
import '../widgets/pos_widgets.dart';

/// POS do refeitório (tablet): leitura simulada do cartão, alerta de alergias,
/// débito da carteira com validação local, estornos e confirmação animada.
class PosPage extends ConsumerWidget {
  const PosPage({super.key});

  Future<void> _charge(BuildContext context, WidgetRef ref) async {
    final state = ref.read(posProvider);
    final decision = state.decision;
    if (decision == null || !decision.approved) return;
    if (decision.hasAllergyAlert) {
      final ok = await showConfirmDialog(
        context: context,
        title: 'Alerta de alergia',
        message:
            '${state.customer!.holderName} tem alergia a '
            '${allergenList(decision.allergenConflicts)}. '
            'Cobrar mesmo assim?',
        confirmLabel: 'Cobrar mesmo assim',
        destructive: true,
      );
      if (!ok) return;
    }
    final done = await ref.read(posProvider.notifier).charge();
    final sale = ref.read(posProvider).lastSale;
    if (done && sale != null) {
      unawaited(
        ref
            .read(auditServiceProvider)
            .record(
              entity: 'wallet_transaction',
              action: AuditAction.create,
              entityId: sale.id,
              after: sale.toJson(),
            ),
      );
    }
  }

  Future<void> _refund(
    BuildContext context,
    WidgetRef ref,
    WalletTransaction tx,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Estornar consumo',
      message: 'Devolver o valor deste consumo à carteira?',
      confirmLabel: 'Estornar',
      destructive: true,
    );
    if (!ok) return;
    final done = await ref
        .read(posProvider.notifier)
        .refund(tx, reason: 'Estorno no POS');
    final toast = ref.read(toastProvider.notifier);
    if (done) {
      toast.success('Consumo estornado');
      unawaited(
        ref
            .read(auditServiceProvider)
            .record(
              entity: 'wallet_transaction',
              action: AuditAction.cancel,
              entityId: tx.id,
              before: tx.toJson(),
            ),
      );
    } else {
      toast.error(ref.read(posProvider).error ?? 'Não foi possível estornar');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(permissionServiceProvider).canAny;
    if (!p('cafeteria.pos.read')) {
      return const EmptyState(
        icon: Icons.lock_outline,
        title: 'Sem permissão',
        message: 'Não tem acesso ao POS do refeitório.',
      );
    }
    final state = ref.watch(posProvider);
    final sale = state.lastSale;

    final left = <Widget>[
      const PosReaderCard(key: ValueKey('pos_reader')),
      if (state.customer != null)
        PosCustomerCard(key: const ValueKey('pos_customer'), state: state),
      const PosCatalogView(key: ValueKey('pos_catalog')),
    ];
    final right = <Widget>[
      if (sale != null)
        PosConfirmation(key: const ValueKey('pos_done'), sale: sale),
      PosCartCard(
        key: const ValueKey('pos_cart'),
        canCharge: p('cafeteria.pos.create'),
        onCharge: () => _charge(context, ref),
      ),
      if (state.customer != null)
        PosTodayCard(
          key: const ValueKey('pos_today'),
          canRefund: p('cafeteria.pos.refund'),
          onRefund: (tx) => _refund(context, ref, tx),
        ),
    ];

    Widget column(List<Widget> children) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final w in children)
          Padding(
            key: w.key,
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: w,
          ),
      ],
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth >= 900;
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: column(left)),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(flex: 2, child: column(right)),
                  ],
                )
              : column([...left, ...right]),
        );
      },
    );
  }
}
