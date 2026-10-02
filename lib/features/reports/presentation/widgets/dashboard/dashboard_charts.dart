import 'package:flutter/material.dart';

import '../../../../../app/theme/app_tokens.dart';
import 'revenue_chart_card.dart';
import 'students_by_grade_chart_card.dart';

/// Gráficos do painel, só para os indicadores que o perfil já vê: receita
/// mensal (com `billing.revenue`) e alunos por classe (com `students.enrolled`).
/// Lado a lado em espaço largo; empilhados em espaço estreito.
class DashboardCharts extends StatelessWidget {
  const DashboardCharts({super.key, required this.widgetIds});

  final Set<String> widgetIds;

  @override
  Widget build(BuildContext context) {
    final cards = [
      if (widgetIds.contains('billing.revenue')) const RevenueChartCard(),
      if (widgetIds.contains('students.enrolled'))
        const StudentsByGradeChartCard(),
    ];
    if (cards.isEmpty) return const SizedBox.shrink();
    return LayoutBuilder(
      builder: (context, constraints) {
        if (cards.length == 2 &&
            constraints.maxWidth >= AppBreakpoints.expanded) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: cards[0]),
              const SizedBox(width: AppSpacing.lg),
              Expanded(flex: 2, child: cards[1]),
            ],
          );
        }
        return Column(
          children: [
            for (final (i, c) in cards.indexed) ...[
              if (i > 0) const SizedBox(height: AppSpacing.lg),
              c,
            ],
          ],
        );
      },
    );
  }
}
