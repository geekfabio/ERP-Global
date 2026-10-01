import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/animations/app_animate.dart';
import '../../../../core/animations/reduce_motion.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/menu.dart';
import '../../data/models/wallet.dart';
import '../../domain/pos_sale.dart';
import '../providers/pos_providers.dart';
import '../providers/wallet_providers.dart';
import 'meal_dialogs.dart';

String posBlockLabel(PosBlock b) => switch (b) {
  PosBlock.emptyCart => 'Adicione pelo menos um prato',
  PosBlock.cardBlocked => 'Cartão bloqueado',
  PosBlock.walletBlocked => 'Carteira bloqueada',
  PosBlock.insufficientBalance => 'Saldo insuficiente',
  PosBlock.dailyLimitExceeded => 'Limite diário excedido',
};

String allergenList(Iterable<Allergen> a) =>
    a.map((e) => allergenLabels[e] ?? e.name).join(', ');

/// Simula a leitura do cartão: UID digitado ou titular escolhido.
class PosReaderCard extends ConsumerStatefulWidget {
  const PosReaderCard({super.key});

  @override
  ConsumerState<PosReaderCard> createState() => _PosReaderCardState();
}

class _PosReaderCardState extends ConsumerState<PosReaderCard> {
  final _uid = TextEditingController();

  @override
  void dispose() {
    _uid.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final holderId = await showDialog<String>(
      context: context,
      builder: (_) => const _PickHolderDialog(),
    );
    if (holderId != null) {
      await ref.read(posProvider.notifier).readHolder(holderId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = ref.watch(posProvider.select((s) => s.busy));
    void read() {
      if (_uid.text.trim().isEmpty) return;
      ref.read(posProvider.notifier).readCard(_uid.text);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 280,
              child: AppTextField(
                label: 'UID do cartão',
                controller: _uid,
                hintText: 'RFID-1001',
                onChanged: (_) {},
              ),
            ),
            AppButton(
              label: 'Ler cartão',
              icon: Icons.contactless_outlined,
              loading: busy,
              onPressed: read,
            ),
            AppButton(
              label: 'Simular',
              icon: Icons.touch_app_outlined,
              variant: AppButtonVariant.secondary,
              onPressed: busy ? null : _pick,
            ),
          ],
        ),
      ),
    );
  }
}

class _PickHolderDialog extends ConsumerWidget {
  const _PickHolderDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallets = ref.watch(walletListProvider);
    return AlertDialog(
      title: const Text('Simular leitura'),
      content: SizedBox(
        width: 420,
        height: 420,
        child: AsyncValueView<List<Wallet>>(
          value: wallets,
          onRetry: () => ref.invalidate(walletListProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(title: 'Sem carteiras'),
          data: (items) => ListView(
            children: [
              for (final w in items)
                ListTile(
                  minVerticalPadding: AppSpacing.md,
                  title: Text(w.holderName),
                  subtitle: Text(PtAoFormatters.currency(w.balanceMinor)),
                  trailing: w.blocked
                      ? const StatusBadge(
                          label: 'Bloqueada',
                          status: BadgeStatus.danger,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(w.holderId),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
      ],
    );
  }
}

/// Cliente identificado: saldo, limite, estado e alerta de alergias.
class PosCustomerCard extends StatelessWidget {
  const PosCustomerCard({super.key, required this.state});

  final PosState state;

  @override
  Widget build(BuildContext context) {
    final c = state.customer!;
    final decision = state.decision!;
    final theme = Theme.of(context);
    final colors = context.appColors;
    final alert = decision.hasAllergyAlert;
    final declared = c.allergies.isNotEmpty;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(c.holderName, style: theme.textTheme.titleLarge),
                if (c.cardBlocked)
                  const StatusBadge(
                    label: 'Cartão bloqueado',
                    status: BadgeStatus.danger,
                  ),
                if (c.wallet.blocked)
                  const StatusBadge(
                    label: 'Carteira bloqueada',
                    status: BadgeStatus.danger,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              PtAoFormatters.currency(c.wallet.balanceMinor),
              key: const Key('pos_balance'),
              style: theme.textTheme.headlineMedium,
            ),
            Text(
              c.wallet.dailyLimitMinor == 0
                  ? 'Sem limite diário'
                  : 'Hoje: ${PtAoFormatters.currency(c.spentTodayMinor)} de '
                        '${PtAoFormatters.currency(c.wallet.dailyLimitMinor)}',
              style: theme.textTheme.bodyMedium,
            ),
            if (declared) ...[
              const SizedBox(height: AppSpacing.md),
              DecoratedBox(
                key: const Key('pos_allergy_banner'),
                decoration: BoxDecoration(
                  color: alert ? colors.danger : colors.warning,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: alert ? colors.onDanger : colors.onWarning,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Text(
                          alert
                              ? 'ALERGIA: o pedido contém '
                                    '${allergenList(decision.allergenConflicts)}'
                              : 'Alergias: ${c.allergies.join(', ')}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: alert ? colors.onDanger : colors.onWarning,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Pratos do menu de hoje, por tipo de refeição.
class PosCatalogView extends ConsumerStatefulWidget {
  const PosCatalogView({super.key});

  @override
  ConsumerState<PosCatalogView> createState() => _PosCatalogViewState();
}

class _PosCatalogViewState extends ConsumerState<PosCatalogView> {
  String? _typeId;

  String _initial(PosCatalog c) {
    final now = TimeOfDay.now();
    final minutes = now.hour * 60 + now.minute;
    int parse(String hhmm) {
      final p = hhmm.split(':');
      return int.parse(p[0]) * 60 + int.parse(p[1]);
    }

    final current = c.types.where(
      (t) => minutes >= parse(t.startTime) && minutes <= parse(t.endTime),
    );
    return (current.isNotEmpty ? current.first : c.types.first).id;
  }

  @override
  Widget build(BuildContext context) {
    final catalog = ref.watch(posCatalogProvider);
    return AsyncValueView<PosCatalog>(
      value: catalog,
      onRetry: () => ref.invalidate(posCatalogProvider),
      isEmpty: (c) => c.types.isEmpty,
      empty: const EmptyState(
        icon: Icons.restaurant_menu,
        title: 'Sem tipos de refeição',
      ),
      loading: const SkeletonCard(height: 160),
      data: (c) {
        final selected = c.types.any((t) => t.id == _typeId)
            ? _typeId!
            : _initial(c);
        final items = c.itemsByType[selected] ?? const <MealItem>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final t in c.types)
                  ChoiceChip(
                    label: Text(t.name),
                    selected: t.id == selected,
                    materialTapTargetSize: MaterialTapTargetSize.padded,
                    onSelected: (_) => setState(() => _typeId = t.id),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            if (items.isEmpty)
              const EmptyState(
                icon: Icons.no_meals_outlined,
                title: 'Sem menu para hoje',
                message: 'Não há pratos definidos para esta refeição.',
              )
            else
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                children: [for (final i in items) _ItemTile(item: i)],
              ),
          ],
        );
      },
    );
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item});

  final MealItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final enabled = ref.watch(posProvider.select((s) => s.customer != null));
    return SizedBox(
      width: 220,
      height: 148,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled
              ? () => ref.read(posProvider.notifier).add(item)
              : null,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
                const Spacer(),
                if (item.allergens.isNotEmpty)
                  Text(
                    allergenList(item.allergens),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                Text(
                  PtAoFormatters.currency(item.priceMinor),
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Carrinho, total, motivos de bloqueio e acção de cobrar.
class PosCartCard extends ConsumerWidget {
  const PosCartCard({
    super.key,
    required this.canCharge,
    required this.onCharge,
  });

  final bool canCharge;
  final VoidCallback onCharge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(posProvider);
    final notifier = ref.read(posProvider.notifier);
    final theme = Theme.of(context);
    final decision = state.decision;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Pedido', style: theme.textTheme.titleMedium),
            if (state.lines.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Text(
                  state.customer == null
                      ? 'Leia um cartão para começar.'
                      : 'Toque num prato para o adicionar.',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            for (final l in state.lines)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('${l.quantity}× ${l.item.name}'),
                subtitle: Text(PtAoFormatters.currency(l.totalMinor)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIconButton(
                      icon: Icons.remove_circle_outline,
                      tooltip: 'Retirar ${l.item.name}',
                      onPressed: () => notifier.remove(l.item),
                    ),
                    AppIconButton(
                      icon: Icons.add_circle_outline,
                      tooltip: 'Adicionar ${l.item.name}',
                      onPressed: () => notifier.add(l.item),
                    ),
                  ],
                ),
              ),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text('Total', style: theme.textTheme.titleMedium),
                ),
                Text(
                  PtAoFormatters.currency(state.totalMinor),
                  key: const Key('pos_total'),
                  style: theme.textTheme.headlineSmall,
                ),
              ],
            ),
            if (decision != null && state.lines.isNotEmpty)
              for (final b in decision.blocks)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Row(
                    children: [
                      Icon(
                        Icons.block,
                        size: 18,
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          posBlockLabel(b),
                          style: TextStyle(color: theme.colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  state.error!,
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Cobrar',
              icon: Icons.payments_outlined,
              loading: state.busy,
              onPressed: canCharge && (decision?.approved ?? false)
                  ? onCharge
                  : null,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Limpar',
              variant: AppButtonVariant.secondary,
              onPressed: state.lines.isEmpty ? null : notifier.clearCart,
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirmação animada depois de uma venda registada.
class PosConfirmation extends ConsumerWidget {
  const PosConfirmation({super.key, required this.sale});

  final WalletTransaction sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final color = context.appColors.success;
    return Card(
      key: const Key('pos_confirmation'),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            SuccessCheck(color: color, size: 72),
            const SizedBox(height: AppSpacing.md),
            Text('Venda registada', style: theme.textTheme.titleLarge),
            Text(
              '${PtAoFormatters.currency(sale.amountMinor)} · saldo '
              '${PtAoFormatters.currency(sale.balanceAfterMinor)}',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Novo atendimento',
              icon: Icons.person_add_alt_1_outlined,
              onPressed: ref.read(posProvider.notifier).reset,
            ),
          ],
        ),
      ).appEnter(reduce: shouldReduceMotion(context)),
    );
  }
}

/// Consumos de hoje do cliente, com estorno.
class PosTodayCard extends ConsumerWidget {
  const PosTodayCard({
    super.key,
    required this.canRefund,
    required this.onRefund,
  });

  final bool canRefund;
  final void Function(WalletTransaction) onRefund;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(posTodayProvider);
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Consumos de hoje', style: theme.textTheme.titleMedium),
            AsyncValueView<List<WalletTransaction>>(
              value: today,
              onRetry: () => ref.invalidate(posTodayProvider),
              loading: const SkeletonCard(),
              data: (txs) {
                final refunded = {
                  for (final t in txs)
                    if (t.type == WalletTransactionType.refund) t.refundOfId,
                };
                final purchases = txs
                    .where((t) => t.type == WalletTransactionType.purchase)
                    .toList();
                if (purchases.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md,
                    ),
                    child: Text(
                      'Sem consumos hoje.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }
                return Column(
                  children: [
                    for (final t in purchases)
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(t.description ?? 'Consumo'),
                        subtitle: Text(
                          '${PtAoFormatters.currency(t.amountMinor)} · '
                          '${PtAoFormatters.dateTime(t.occurredAt.toLocal())}',
                        ),
                        trailing: refunded.contains(t.id)
                            ? const StatusBadge(
                                label: 'Estornado',
                                status: BadgeStatus.neutral,
                              )
                            : canRefund
                            ? AppButton(
                                label: 'Estornar',
                                variant: AppButtonVariant.secondary,
                                onPressed: () => onRefund(t),
                              )
                            : null,
                      ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
