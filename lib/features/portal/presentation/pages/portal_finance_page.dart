import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../data/models/portal_finance_models.dart';
import '../../domain/portal_finance_metrics.dart';
import '../providers/portal_finance_providers.dart';
import '../widgets/portal_pupil_scope.dart';

/// Conta corrente do educando no portal: dívidas, referência de pagamento
/// (mock) e recibos. Só leitura.
class PortalFinancePage extends StatelessWidget {
  const PortalFinancePage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilScope(
    title: 'Pagamentos e dívidas',
    builder: (context, pupil) => _FinanceBody(studentId: pupil.student.id),
  );
}

class _FinanceBody extends ConsumerWidget {
  const _FinanceBody({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(portalFinanceProvider(studentId));
    return AsyncValueView<PortalFinance>(
      value: finance,
      loading: const SkeletonCard(),
      onRetry: () => ref.invalidate(portalFinanceProvider(studentId)),
      isEmpty: (f) => f.charges.isEmpty && f.receipts.isEmpty,
      empty: const EmptyState(
        icon: Icons.payments_outlined,
        title: 'Sem movimentos',
        message: 'Ainda não existem cobranças para este educando.',
      ),
      data: (f) {
        final payable = payableCharges(f.charges);
        final text = Theme.of(context).textTheme;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total em dívida', style: text.labelLarge),
                    Text(
                      PtAoFormatters.currency(totalOutstandingMinor(payable)),
                      style: text.headlineMedium,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    FilledButton.icon(
                      onPressed: payable.isEmpty
                          ? null
                          : () => _showReference(context, ref),
                      icon: const Icon(Icons.pin_outlined),
                      label: const Text('Referência de pagamento'),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Cobranças', style: text.titleMedium),
            for (final c in f.charges.reversed) _ChargeTile(charge: c),
            const SizedBox(height: AppSpacing.lg),
            Text('Recibos', style: text.titleMedium),
            if (f.receipts.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text('Sem recibos emitidos.'),
              ),
            for (final r in f.receipts) _ReceiptTile(receipt: r),
          ],
        );
      },
    );
  }

  Future<void> _showReference(BuildContext context, WidgetRef ref) async {
    final result = await ref
        .read(portalFinanceRepositoryProvider)
        .paymentReference(studentId);
    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (_) => result.when(
        ok: (r) => _ReferenceDialog(reference: r),
        err: (f) => AlertDialog(
          title: const Text('Referência de pagamento'),
          content: Text(f.message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ],
        ),
      ),
    );
  }
}

String chargeStatusLabel(StudentChargeStatus s) => switch (s) {
  StudentChargeStatus.open => 'Em aberto',
  StudentChargeStatus.partial => 'Parcial',
  StudentChargeStatus.paid => 'Pago',
  StudentChargeStatus.overdue => 'Em atraso',
};

BadgeStatus chargeBadge(StudentChargeStatus s) => switch (s) {
  StudentChargeStatus.open => BadgeStatus.info,
  StudentChargeStatus.partial => BadgeStatus.warning,
  StudentChargeStatus.paid => BadgeStatus.success,
  StudentChargeStatus.overdue => BadgeStatus.danger,
};

class _ChargeTile extends StatelessWidget {
  const _ChargeTile({required this.charge});

  final StudentChargeLine charge;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(charge.description),
    subtitle: Text(
      'Vence em ${PtAoFormatters.date(charge.dueOn)} · '
      '${PtAoFormatters.currency(charge.amountMinor)}',
    ),
    trailing: StatusBadge(
      label: chargeStatusLabel(charge.status),
      status: chargeBadge(charge.status),
    ),
  );
}

class _ReceiptTile extends StatelessWidget {
  const _ReceiptTile({required this.receipt});

  final PortalReceipt receipt;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: const Icon(Icons.receipt_long_outlined),
    title: Text('${receipt.number} · ${receipt.description}'),
    subtitle: Text(PtAoFormatters.date(receipt.issuedAt)),
    trailing: Text(PtAoFormatters.currency(receipt.amountMinor)),
  );
}

class _ReferenceDialog extends StatelessWidget {
  const _ReferenceDialog({required this.reference});

  final PortalPaymentReference reference;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Referência de pagamento'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Entidade: ${reference.entity}'),
        Text('Referência: ${reference.reference}'),
        Text('Valor: ${PtAoFormatters.currency(reference.amountMinor)}'),
        Text('Válida até ${PtAoFormatters.date(reference.validUntil)}'),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Referência simulada. Após o pagamento, o recibo aparece nesta página.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Fechar'),
      ),
    ],
  );
}
