import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/payment_agreement.dart';
import '../../data/models/payment_notice.dart';
import '../../domain/debt.dart';
import '../providers/debt_providers.dart';
import 'payment_dialogs.dart' show shortId;

/// Dados de um novo acordo (abrange toda a dívida em atraso do aluno).
class AgreementDraft {
  const AgreementDraft({required this.installments, required this.firstDue});

  final int installments;
  final DateTime firstDue;
}

Future<AgreementDraft?> showAgreementDialog(
  BuildContext context, {
  required String studentId,
}) => showDialog<AgreementDraft>(
  context: context,
  builder: (_) => _AgreementDialog(studentId: studentId),
);

class _AgreementDialog extends StatefulWidget {
  const _AgreementDialog({required this.studentId});

  final String studentId;

  @override
  State<_AgreementDialog> createState() => _AgreementDialogState();
}

class _AgreementDialogState extends State<_AgreementDialog> {
  int _count = 3;
  DateTime _first = addMonths(dayOf(DateTime.now()), 1);

  @override
  Widget build(BuildContext context) {
    final today = dayOf(DateTime.now());
    return AlertDialog(
      title: Text('Novo acordo · aluno ${shortId(widget.studentId)}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Abrange toda a dívida em atraso do aluno, repartida em '
              'prestações mensais.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<int>(
              key: const Key('field_installments'),
              initialValue: _count,
              decoration: const InputDecoration(labelText: 'Prestações'),
              items: [
                for (var i = 2; i <= 12; i++)
                  DropdownMenuItem(value: i, child: Text('$i prestações')),
              ],
              onChanged: (v) => setState(() => _count = v!),
            ),
            const SizedBox(height: AppSpacing.md),
            AppDateField(
              label: 'Primeira prestação',
              value: _first,
              firstDate: today,
              onChanged: (d) => setState(() => _first = d),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(
            context,
          ).pop(AgreementDraft(installments: _count, firstDue: _first)),
          child: const Text('Criar acordo'),
        ),
      ],
    );
  }
}

BadgeStatus _agreementBadge(AgreementStatus s) => switch (s) {
  AgreementStatus.active => BadgeStatus.info,
  AgreementStatus.completed => BadgeStatus.success,
  AgreementStatus.broken => BadgeStatus.danger,
  AgreementStatus.cancelled => BadgeStatus.neutral,
};

/// Acordos de pagamento: progresso, prestações e cancelamento.
Future<void> showAgreementsDialog(
  BuildContext context, {
  bool canManage = false,
}) => showDialog<void>(
  context: context,
  builder: (_) => _AgreementsDialog(canManage: canManage),
);

class _AgreementsDialog extends ConsumerWidget {
  const _AgreementsDialog({required this.canManage});

  final bool canManage;

  Future<void> _cancel(WidgetRef ref, PaymentAgreement a) async {
    final result = await ref.read(debtRepositoryProvider).cancelAgreement(a.id);
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success('Acordo cancelado'),
      err: (f) => toast.error(f.message),
    );
    ref
      ..invalidate(agreementListProvider)
      ..invalidate(debtorListProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final agreements = ref.watch(agreementListProvider);
    return AlertDialog(
      title: const Text('Acordos de pagamento'),
      content: SizedBox(
        width: 640,
        child: AsyncValueView<List<PaymentAgreement>>(
          value: agreements,
          onRetry: () => ref.invalidate(agreementListProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.handshake_outlined,
            title: 'Sem acordos de pagamento',
          ),
          data: (list) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final a in list)
                  ListTile(
                    key: Key('agreement_${a.id}'),
                    title: Text(
                      'Aluno ${shortId(a.studentId)} · '
                      '${PtAoFormatters.currency(a.totalMinor)}',
                    ),
                    subtitle: Text(
                      'Pago ${PtAoFormatters.currency(a.paidMinor)} · '
                      '${a.installments.where((i) => i.paid).length}/'
                      '${a.installments.length} prestações',
                    ),
                    trailing: Wrap(
                      spacing: AppSpacing.sm,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        StatusBadge(
                          label: agreementStatusLabelsPt[a.status]!,
                          status: _agreementBadge(a.status),
                        ),
                        if (canManage &&
                            (a.status == AgreementStatus.active ||
                                a.status == AgreementStatus.broken))
                          IconButton(
                            tooltip: 'Cancelar acordo',
                            icon: const Icon(Icons.cancel_outlined),
                            onPressed: () => _cancel(ref, a),
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}

/// Avisos pré/pós-vencimento já enviados.
Future<void> showNoticesDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const _NoticesDialog());

class _NoticesDialog extends ConsumerWidget {
  const _NoticesDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notices = ref.watch(noticeListProvider);
    return AlertDialog(
      title: const Text('Avisos enviados'),
      content: SizedBox(
        width: 640,
        child: AsyncValueView<List<PaymentNotice>>(
          value: notices,
          onRetry: () => ref.invalidate(noticeListProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.notifications_none,
            title: 'Sem avisos enviados',
          ),
          data: (list) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final n in list)
                  ListTile(
                    title: Text(n.message),
                    subtitle: Text(
                      'Aluno ${shortId(n.studentId)} · '
                      '${noticeKindLabelsPt[n.kind]!} · '
                      '${PtAoFormatters.date(n.sentAt)}',
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
