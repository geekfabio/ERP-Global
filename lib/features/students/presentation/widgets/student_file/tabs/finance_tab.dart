import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/student_model.dart';
import '../../../../data/models/student_summaries_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';
import '../editable_section.dart';

String chargeStatusLabel(StudentChargeStatus s) => switch (s) {
  StudentChargeStatus.open => 'Em aberto',
  StudentChargeStatus.partial => 'Parcial',
  StudentChargeStatus.paid => 'Paga',
  StudentChargeStatus.overdue => 'Em atraso',
};

BadgeStatus chargeBadge(StudentChargeStatus s) => switch (s) {
  StudentChargeStatus.open => BadgeStatus.neutral,
  StudentChargeStatus.partial => BadgeStatus.warning,
  StudentChargeStatus.paid => BadgeStatus.success,
  StudentChargeStatus.overdue => BadgeStatus.danger,
};

/// Separador 8 — Financeiro (módulo `billing`): conta corrente, propinas,
/// dívidas e bolsas/descontos. Dinheiro sempre em menor unidade (`int`).
class FinanceTab extends ConsumerWidget {
  const FinanceTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AsyncValueView<StudentFinanceSummary>(
      value: ref.watch(studentFinanceProvider(student.id)),
      onRetry: () => ref.invalidate(studentFinanceProvider(student.id)),
      isEmpty: (d) => d.charges.isEmpty,
      loading: const SkeletonCard(),
      empty: const EmptyState(
        icon: Icons.payments_outlined,
        title: 'Sem movimentos',
        message: 'A conta corrente deste aluno ainda não tem cobranças.',
      ),
      data: (f) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  FieldRow(
                    label: 'Total em dívida',
                    value: PtAoFormatters.currency(outstandingMinor(f.charges)),
                  ),
                  FieldRow(
                    label: 'Em atraso',
                    value: PtAoFormatters.currency(overdueMinor(f.charges)),
                  ),
                  FieldRow(
                    label: 'Bolsa / desconto',
                    value: f.discountPercent == 0
                        ? 'Sem desconto'
                        : '${f.discountPercent} %',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          for (final c in f.charges)
            Card(
              child: ListTile(
                key: Key('charge_${c.id}'),
                title: Text(c.description),
                subtitle: Text(
                  'Vence em ${PtAoFormatters.date(c.dueOn)} · '
                  '${PtAoFormatters.currency(c.amountMinor)}',
                ),
                trailing: StatusBadge(
                  label: chargeStatusLabel(c.status),
                  status: chargeBadge(c.status),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
