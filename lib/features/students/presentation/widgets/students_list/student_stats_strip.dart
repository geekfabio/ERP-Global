import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../app/theme/app_colors.dart';
import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/cards/app_cards.dart';
import '../../../../../core/widgets/layout/responsive_grid.dart';
import '../../../../../core/widgets/states/app_states.dart';
import '../../providers/student_list_providers.dart';

/// Resumo por cima da tabela: total, divisão por género e activos, sempre
/// com os filtros em vigor. Uma falha aqui não bloqueia a listagem (esconde-se).
class StudentStatsStrip extends ConsumerWidget {
  const StudentStatsStrip({super.key});

  /// "162 (54%)": valor e percentagem do total, arredondada.
  static String withShare(int value, int total) {
    final count = PtAoFormatters.number(value);
    if (total <= 0) return count;
    return '$count (${(value * 100 / total).round()}%)';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.appColors;
    return ref
        .watch(studentListStatsProvider)
        .when(
          skipLoadingOnReload: true,
          loading: () => const ResponsiveGrid(
            minItemWidth: 160,
            children: [
              SkeletonCard(),
              SkeletonCard(),
              SkeletonCard(),
              SkeletonCard(),
            ],
          ),
          error: (_, _) => const SizedBox.shrink(),
          data: (s) {
            final byGender = s.male + s.female;
            // Até 2 colunas mesmo em telemóvel: o resumo não empurra a lista.
            return ResponsiveGrid(
              minItemWidth: 160,
              children: [
                KpiCard(
                  key: const ValueKey('stats_total'),
                  label: 'Total de alunos',
                  icon: Icons.groups_outlined,
                  accent: colors.academic,
                  value: s.total,
                  format: PtAoFormatters.number,
                ),
                KpiCard(
                  key: const ValueKey('stats_male'),
                  label: 'Masculino',
                  icon: Icons.male,
                  accent: colors.info,
                  value: s.male,
                  format: (v) => withShare(v, byGender),
                  progress: byGender == 0 ? 0 : s.male / byGender,
                ),
                KpiCard(
                  key: const ValueKey('stats_female'),
                  label: 'Feminino',
                  icon: Icons.female,
                  accent: colors.access,
                  value: s.female,
                  format: (v) => withShare(v, byGender),
                  progress: byGender == 0 ? 0 : s.female / byGender,
                ),
                KpiCard(
                  key: const ValueKey('stats_active'),
                  label: 'Activos',
                  icon: Icons.verified_outlined,
                  accent: colors.success,
                  value: s.active,
                  format: (v) => withShare(v, s.total),
                  progress: s.total == 0 ? 0 : s.active / s.total,
                ),
              ],
            );
          },
        );
  }
}
