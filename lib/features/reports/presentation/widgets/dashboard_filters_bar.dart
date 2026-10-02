import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/academic/period_context.dart';
import '../../../../core/security/permission_providers.dart';
import '../../domain/dashboard_widget.dart';
import '../providers/reports_providers.dart';

/// Filtros globais: ano, trimestre (partilhados com o selector da topbar),
/// campus, comparação e, para o super_admin, o perfil a visualizar. Ano e
/// trimestre só aparecem aqui quando a topbar os esconde (ecrã compacto).
class DashboardFiltersBar extends ConsumerWidget {
  const DashboardFiltersBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices =
        ref.watch(periodChoicesProvider).value ?? const PeriodChoices.empty();
    final period = ref.watch(effectivePeriodProvider);
    final filters = ref.watch(dashboardFiltersProvider);
    final campuses = ref.watch(campusOptionsProvider).value ?? const [];
    final profile = ref.watch(dashboardProfileProvider);
    final isSuperAdmin = ref
        .watch(sessionRolesProvider)
        .contains('super_admin');
    final period$ = ref.read(periodProvider.notifier);
    final filters$ = ref.read(dashboardFiltersProvider.notifier);
    final periodInTopbar =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.medium;
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        if (!periodInTopbar) ...[
          DropdownMenu<String>(
            key: ValueKey('year_${period.year?.id}'),
            label: const Text('Ano lectivo'),
            initialSelection: period.year?.id,
            dropdownMenuEntries: [
              for (final y in choices.years)
                DropdownMenuEntry(value: y.id, label: y.label),
            ],
            onSelected: (id) {
              if (id != null) period$.setYear(id);
            },
          ),
          DropdownMenu<String>(
            key: ValueKey('term_${period.year?.id}_${period.term?.id}'),
            label: const Text('Trimestre'),
            initialSelection: period.term?.id,
            dropdownMenuEntries: [
              for (final t in period.year?.terms ?? const <PeriodTerm>[])
                DropdownMenuEntry(value: t.id, label: t.label),
            ],
            onSelected: (id) {
              if (id != null) period$.setTerm(id);
            },
          ),
        ],
        DropdownMenu<String?>(
          key: ValueKey('campus_${filters.campusId}_${campuses.length}'),
          label: const Text('Campus'),
          initialSelection: filters.campusId,
          dropdownMenuEntries: [
            const DropdownMenuEntry(value: null, label: 'Todos os campus'),
            for (final c in campuses)
              DropdownMenuEntry(value: c.id, label: c.name),
          ],
          onSelected: filters$.setCampus,
        ),
        DropdownMenu<CompareMode>(
          key: const ValueKey('compare'),
          label: const Text('Comparar com'),
          initialSelection: filters.compare,
          dropdownMenuEntries: [
            for (final m in CompareMode.values)
              DropdownMenuEntry(value: m, label: m.label),
          ],
          onSelected: (m) {
            if (m != null) filters$.setCompare(m);
          },
        ),
        if (isSuperAdmin)
          DropdownMenu<String>(
            key: const ValueKey('profile'),
            label: const Text('Ver como'),
            initialSelection: profile,
            dropdownMenuEntries: [
              for (final e in dashboardProfiles.entries)
                DropdownMenuEntry(value: e.key, label: e.value),
            ],
            onSelected: (p) {
              if (p != null) filters$.setProfile(p);
            },
          ),
      ],
    );
  }
}
