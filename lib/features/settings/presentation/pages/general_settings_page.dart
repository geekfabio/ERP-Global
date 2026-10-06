import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/cards/app_cards.dart';

class GeneralSettingsPage extends StatelessWidget {
  const GeneralSettingsPage({super.key});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 900),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text('Geral', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: AppSpacing.xs),
          const Text('Parâmetros que orientam o funcionamento da instituição.'),
          const SizedBox(height: AppSpacing.xl),
          EntityCard(
            title: 'Ano lectivo e períodos',
            subtitle: 'Abrir, fechar e definir os trimestres.',
            leading: const Icon(Icons.calendar_month_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/academic-year'),
          ),
          const SizedBox(height: AppSpacing.md),
          EntityCard(
            title: 'Regras académicas e financeiras',
            subtitle: 'Critérios de matrícula, avaliação e cobrança.',
            leading: const Icon(Icons.rule_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/rules'),
          ),
          const SizedBox(height: AppSpacing.md),
          EntityCard(
            title: 'Sincronização',
            subtitle: 'Estado, modo de funcionamento e última sincronização.',
            leading: const Icon(Icons.sync_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/sync'),
          ),
          const SizedBox(height: AppSpacing.md),
          EntityCard(
            title: 'Auditoria',
            subtitle: 'Histórico das alterações sensíveis.',
            leading: const Icon(Icons.history_outlined),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/settings/audit'),
          ),
        ],
      ),
    ),
  );
}
