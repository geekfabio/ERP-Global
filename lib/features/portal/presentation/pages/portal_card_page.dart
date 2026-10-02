import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../data/models/portal_finance_models.dart';
import '../providers/portal_finance_providers.dart';
import '../widgets/portal_pupil_scope.dart';

/// Cartão do educando no portal: saldo, extracto (carregamentos e consumos)
/// e entradas/saídas. Só leitura.
class PortalCardPage extends StatelessWidget {
  const PortalCardPage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilScope(
    title: 'Cartão e refeitório',
    builder: (context, pupil) => _CardBody(studentId: pupil.student.id),
  );
}

String cardStatusLabel(StudentCardStatus s) => switch (s) {
  StudentCardStatus.active => 'Activo',
  StudentCardStatus.blocked => 'Bloqueado',
  StudentCardStatus.lost => 'Perdido',
};

String cardEntryLabel(PortalCardEntryKind k) => switch (k) {
  PortalCardEntryKind.topup => 'Carregamento',
  PortalCardEntryKind.purchase => 'Consumo',
  PortalCardEntryKind.refund => 'Estorno',
};

class _CardBody extends ConsumerWidget {
  const _CardBody({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final card = ref.watch(portalCardProvider(studentId));
    return AsyncValueView<PortalCard>(
      value: card,
      loading: const SkeletonCard(),
      onRetry: () => ref.invalidate(portalCardProvider(studentId)),
      data: (c) {
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
                    Text('Saldo do refeitório', style: text.labelLarge),
                    Text(
                      PtAoFormatters.currency(c.balanceMinor),
                      style: text.headlineMedium,
                    ),
                    if (c.cardNumber != null)
                      Text(
                        'Cartão ${c.cardNumber}'
                        '${c.status == null ? '' : ' · ${cardStatusLabel(c.status!)}'}',
                        style: text.bodyMedium,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text('Extracto', style: text.titleMedium),
            if (c.entries.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text('Sem movimentos.'),
              ),
            for (final e in c.entries)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  e.signedMinor < 0
                      ? Icons.restaurant_outlined
                      : Icons.add_card_outlined,
                ),
                title: Text(e.description ?? cardEntryLabel(e.kind)),
                subtitle: Text(
                  '${PtAoFormatters.dateTime(e.at)} · saldo '
                  '${PtAoFormatters.currency(e.balanceAfterMinor)}',
                ),
                trailing: Text(
                  '${e.signedMinor < 0 ? '−' : '+'}'
                  '${PtAoFormatters.currency(e.amountMinor)}',
                  style: text.labelLarge,
                ),
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('Entradas e saídas', style: text.titleMedium),
            if (c.access.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text('Sem registos de acesso.'),
              ),
            for (final a in c.access)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Icon(
                  a.direction == AccessDirection.entry
                      ? Icons.login
                      : Icons.logout,
                ),
                title: Text(
                  a.direction == AccessDirection.entry ? 'Entrada' : 'Saída',
                ),
                subtitle: Text(
                  '${PtAoFormatters.dateTime(a.at)}'
                  '${a.gate == null ? '' : ' · ${a.gate}'}',
                ),
              ),
          ],
        );
      },
    );
  }
}
