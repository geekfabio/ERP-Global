import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/modules/license_gate.dart';
import '../../core/widgets/states/app_states.dart';
import '../../features/reports/presentation/pages/dashboard_page.dart';

/// Página inicial (`/dashboard`): o dashboard do módulo `reports`. Sem esse
/// módulo licenciado mostra um estado de boas-vindas com o caminho para as
/// definições, em vez de um ecrã vazio.
class DashboardHome extends ConsumerWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasReports = ref.watch(enabledModulesProvider).contains('reports');
    if (hasReports) return const DashboardPage();
    return EmptyState(
      icon: Icons.dashboard_outlined,
      title: 'Bem-vindo ao ERP-Global',
      message:
          'Escolha um módulo no menu. Os indicadores do painel precisam do '
          'módulo Relatórios licenciado.',
      actionLabel: 'Ver licença',
      onAction: () => context.go('/settings/license'),
    );
  }
}
