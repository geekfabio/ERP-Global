import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/modules/license_gate.dart';

/// Secção do portal, mostrada só se o [module] que a alimenta está licenciado.
typedef PortalSection = ({
  String module,
  String path,
  IconData icon,
  String label,
});

const portalSections = <PortalSection>[
  (
    module: 'grades',
    path: '/portal/grades',
    icon: Icons.grading_outlined,
    label: 'Notas e boletins',
  ),
  (
    module: 'attendance',
    path: '/portal/attendance',
    icon: Icons.fact_check_outlined,
    label: 'Faltas e presenças',
  ),
  (
    module: 'attendance',
    path: '/portal/justifications',
    icon: Icons.edit_note,
    label: 'Justificar faltas',
  ),
  (
    module: 'academic',
    path: '/portal/schedule',
    icon: Icons.calendar_month_outlined,
    label: 'Horário',
  ),
  (
    module: 'guardian_portal',
    path: '/portal/documents',
    icon: Icons.request_page_outlined,
    label: 'Pedir documentos',
  ),
];

/// Atalhos para as secções do portal; só as dos módulos licenciados.
class PortalSections extends ConsumerWidget {
  const PortalSections({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(enabledModulesProvider);
    return Card(
      child: Column(
        children: [
          for (final s in portalSections)
            if (enabled.contains(s.module))
              ListTile(
                leading: Icon(s.icon),
                title: Text(s.label),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go(s.path),
              ),
        ],
      ),
    );
  }
}
