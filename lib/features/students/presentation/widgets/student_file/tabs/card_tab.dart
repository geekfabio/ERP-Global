import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../data/models/student_model.dart';
import '../../../../data/models/student_summaries_model.dart';
import '../../../providers/student_file_providers.dart';
import '../editable_section.dart';

String cardStatusLabel(StudentCardStatus? s) => switch (s) {
  null => 'Sem cartão',
  StudentCardStatus.active => 'Activo',
  StudentCardStatus.blocked => 'Bloqueado',
  StudentCardStatus.lost => 'Perdido',
};

/// Separador 11 — Cartão e acessos (módulo `cards`): cartão associado, saldo do
/// refeitório e últimas entradas/saídas.
class CardTab extends ConsumerWidget {
  const CardTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = Theme.of(context).textTheme;
    return AsyncValueView<StudentCardSummary>(
      value: ref.watch(studentCardProvider(student.id)),
      onRetry: () => ref.invalidate(studentCardProvider(student.id)),
      isEmpty: (d) => d.cardNumber == null,
      loading: const SkeletonCard(),
      empty: const EmptyState(
        icon: Icons.credit_card_outlined,
        title: 'Sem cartão',
        message: 'Este aluno ainda não tem cartão associado.',
      ),
      data: (c) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  FieldRow(label: 'N.º do cartão', value: c.cardNumber),
                  FieldRow(label: 'Estado', value: cardStatusLabel(c.status)),
                  FieldRow(
                    label: 'Saldo do refeitório',
                    value: PtAoFormatters.currency(c.mealBalanceMinor),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('Últimas entradas e saídas', style: text.titleMedium),
          if (c.recentAccess.isEmpty)
            const Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Text('Sem acessos registados.'),
            ),
          for (final e in c.recentAccess)
            ListTile(
              dense: true,
              leading: Icon(
                e.direction == AccessDirection.entry
                    ? Icons.login_outlined
                    : Icons.logout_outlined,
              ),
              title: Text(
                e.direction == AccessDirection.entry ? 'Entrada' : 'Saída',
              ),
              subtitle: Text(
                '${PtAoFormatters.dateTime(e.at)}'
                '${e.gate == null ? '' : ' · ${e.gate}'}',
              ),
            ),
        ],
      ),
    );
  }
}
