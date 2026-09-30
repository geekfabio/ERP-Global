import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/cards/app_cards.dart';
import 'package:erp_global/core/widgets/charts/app_charts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child, {bool disableAnimations = false}) => MaterialApp(
  theme: AppTheme.light(),
  home: MediaQuery(
    data: MediaQueryData(disableAnimations: disableAnimations),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  testWidgets('KpiCard conta até ao valor final', (tester) async {
    await tester.pumpWidget(_wrap(const KpiCard(label: 'Alunos', value: 312)));
    expect(find.text('312'), findsNothing);
    await tester.pumpAndSettle();
    expect(find.text('312'), findsOneWidget);
  });

  testWidgets('KpiCard respeita disableAnimations', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const KpiCard(label: 'Alunos', value: 312),
        disableAnimations: true,
      ),
    );
    expect(find.text('312'), findsOneWidget);
  });

  testWidgets('KpiCard mostra variação e formato', (tester) async {
    await tester.pumpWidget(
      _wrap(
        KpiCard(
          label: 'Receita',
          value: 1000,
          format: (v) => '$v Kz',
          deltaPercent: -3.5,
        ),
        disableAnimations: true,
      ),
    );
    expect(find.text('1000 Kz'), findsOneWidget);
    expect(find.text('-3,5%'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_downward), findsOneWidget);
  });

  testWidgets('EntityCard reage ao toque e ListCard mostra vazio', (
    tester,
  ) async {
    var taps = 0;
    await tester.pumpWidget(
      _wrap(
        Column(
          children: [
            EntityCard(
              title: 'Ana Neto',
              subtitle: '10.ª A',
              onTap: () => taps++,
            ),
            const ListCard(title: 'Pagamentos', children: []),
          ],
        ),
      ),
    );
    await tester.tap(find.text('Ana Neto'));
    expect(taps, 1);
    expect(find.text('Sem registos'), findsOneWidget);
  });

  testWidgets('gráficos renderizam com rótulo semântico', (tester) async {
    await tester.pumpWidget(
      _wrap(
        SingleChildScrollView(
          child: Column(
            children: [
              const AppLineChart(
                values: [1, 3, 2, 5],
                labels: ['T1', 'T2', 'T3', 'T4'],
                semanticLabel: 'Evolução',
              ),
              const AppBarChart(values: [4, 2, 6], semanticLabel: 'Notas'),
              const AppDonutChart(
                semanticLabel: 'Estado',
                slices: [
                  DonutSlice(label: 'Pago', value: 70, color: Colors.green),
                  DonutSlice(label: 'Em dívida', value: 30, color: Colors.red),
                ],
              ),
              const Sparkline(values: [1, 2, 1, 3]),
            ],
          ),
        ),
        disableAnimations: true,
      ),
    );
    await tester.pump();
    expect(find.byType(LineChart), findsNWidgets(2));
    expect(find.byType(BarChart), findsOneWidget);
    expect(find.byType(PieChart), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == 'Evolução',
      ),
      findsOneWidget,
    );
    expect(find.text('Pago'), findsOneWidget);
  });
}
