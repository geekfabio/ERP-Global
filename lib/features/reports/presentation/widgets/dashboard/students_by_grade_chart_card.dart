import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/widgets/charts/app_charts.dart';
import '../../../../../core/widgets/charts/chart_card.dart';
import '../../../../../core/widgets/states/app_states.dart';
import '../../../data/models/academic_overview.dart';
import '../../providers/academic_overview_providers.dart';
import 'revenue_chart_card.dart' show dashboardChartHeight;

/// Alunos matriculados por classe (barras: há demasiadas classes para um
/// donut legível). Dados de `GET /v1/reports/academic-overview`.
class StudentsByGradeChartCard extends ConsumerWidget {
  const StudentsByGradeChartCard({super.key});

  /// Rótulo curto para o eixo ("1.ª classe" → "1.ª"; "Iniciação" → "Inic.").
  static String shortLabel(String label) {
    final first = label.split(' ').first;
    return first.length > 5 ? '${first.substring(0, 4)}.' : first;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => ChartCard(
    title: 'Alunos por classe',
    subtitle: 'Matriculados no período',
    child: AsyncValueView<AcademicOverview?>(
      value: ref.watch(academicOverviewProvider),
      loading: const SkeletonCard(height: dashboardChartHeight),
      onRetry: () => ref.invalidate(academicOverviewProvider),
      isEmpty: (o) => o == null || o.rows.isEmpty,
      empty: const EmptyState(
        icon: Icons.bar_chart,
        title: 'Sem alunos matriculados',
      ),
      data: (o) => AppBarChart(
        height: dashboardChartHeight,
        semanticLabel:
            'Alunos por classe: '
            '${o!.rows.map((r) => '${r.label} ${r.enrolled}').join(', ')}',
        labels: [for (final r in o.rows) shortLabel(r.label)],
        values: [for (final r in o.rows) r.enrolled.toDouble()],
      ),
    ),
  );
}
