import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/modules/license_gate.dart';
import '../../../../../core/security/permission_providers.dart';
import '../../../../../core/widgets/layout/page_actions.dart';
import '../../../domain/report_catalog.dart';

/// Atalho do painel para outro módulo; só aparece com o módulo licenciado e
/// a permissão.
class DashboardShortcut {
  const DashboardShortcut({
    required this.label,
    required this.icon,
    required this.path,
    required this.module,
    required this.permission,
  });

  final String label;
  final IconData icon;
  final String path;
  final String module;
  final String permission;
}

/// Acções rápidas do painel, pela ordem de destaque (a 1.ª é a principal).
const dashboardShortcuts = [
  DashboardShortcut(
    label: 'Nova matrícula',
    icon: Icons.person_add_alt_1_outlined,
    path: '/students/enrollments',
    module: 'students',
    permission: 'students.record.update',
  ),
  DashboardShortcut(
    label: 'Nova factura',
    icon: Icons.receipt_long_outlined,
    path: '/billing/invoices',
    module: 'billing',
    permission: 'billing.invoice.create',
  ),
  DashboardShortcut(
    label: 'Registar presença',
    icon: Icons.fact_check_outlined,
    path: '/attendance',
    module: 'attendance',
    permission: 'attendance.record.write',
  ),
];

/// Acções rápidas permitidas + menu "Mais acções" com os dashboards de
/// detalhe e o catálogo de relatórios.
class DashboardActions extends ConsumerWidget {
  const DashboardActions({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(enabledModulesProvider);
    final can = ref.watch(permissionServiceProvider);
    final shortcuts = [
      for (final s in dashboardShortcuts)
        if (enabled.contains(s.module) && can.canAny(s.permission)) s,
    ];
    void go(String path) => context.go(path);
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final (i, s) in shortcuts.indexed)
          PageActionButton(
            PageAction(
              label: s.label,
              icon: s.icon,
              primary: i == 0,
              onPressed: () => go(s.path),
            ),
          ),
        OverflowActionsMenu(
          actions: [
            PageAction(
              key: const ValueKey('open_academic_dashboard'),
              label: 'Direcção e Académico',
              icon: Icons.school_outlined,
              onPressed: () => go('/reports/academic'),
            ),
            if (enabled.contains('billing'))
              PageAction(
                key: const ValueKey('open_finance_dashboard'),
                label: 'Financeiro e Contabilidade',
                icon: Icons.account_balance_outlined,
                onPressed: () => go('/reports/finance'),
              ),
            PageAction(
              key: const ValueKey('open_operations_dashboard'),
              label: 'Operações',
              icon: Icons.dashboard_customize_outlined,
              onPressed: () => go('/reports/operations'),
            ),
            if (can.canAny(reportsCatalogPermission))
              PageAction(
                key: const ValueKey('open_report_catalog'),
                label: 'Catálogo de relatórios',
                icon: Icons.assignment_outlined,
                onPressed: () => go('/reports/catalog'),
              ),
          ],
        ),
      ],
    );
  }
}
