import 'package:erp_global/app/theme/app_colors.dart';
import 'package:erp_global/app/theme/app_theme.dart';
import 'package:erp_global/core/widgets/status_badge.dart';
import 'package:erp_global/features/reports/data/models/dashboard_metric.dart';
import 'package:erp_global/features/reports/domain/dashboard_widget.dart';
import 'package:erp_global/features/reports/presentation/widgets/dashboard/dashboard_header.dart';
import 'package:erp_global/features/reports/presentation/widgets/dashboard/dashboard_kpi_sections.dart';
import 'package:erp_global/features/reports/presentation/widgets/dashboard/students_by_grade_chart_card.dart';
import 'package:erp_global/features/students/data/models/student_enums.dart';
import 'package:erp_global/features/students/presentation/widgets/student_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) => MaterialApp(
  theme: AppTheme.light(),
  home: MediaQuery(
    data: const MediaQueryData(disableAnimations: true),
    child: Scaffold(body: SingleChildScrollView(child: child)),
  ),
);

DashboardWidgetSpec _spec(String id) =>
    dashboardWidgetSpecs.firstWhere((w) => w.id == id);

void main() {
  group('alunos', () {
    test('cada estado tem rótulo e cor semântica', () {
      for (final s in StudentStatus.values) {
        expect(studentStatusLabel(s), isNotEmpty);
      }
      expect(studentStatusBadge(StudentStatus.active), BadgeStatus.success);
      expect(studentStatusBadge(StudentStatus.dropout), BadgeStatus.danger);
      expect(genderLabel(Gender.female), 'Feminino');
    });

    testWidgets('StudentStatusBadge e StudentGenderLabel', (tester) async {
      await tester.pumpWidget(
        _wrap(
          const Column(
            children: [
              StudentStatusBadge(StudentStatus.transferred),
              StudentGenderLabel(Gender.male),
            ],
          ),
        ),
      );
      expect(find.text('Transferido'), findsOneWidget);
      expect(find.text('Masculino'), findsOneWidget);
      expect(find.byIcon(Icons.male), findsOneWidget);
    });
  });

  group('painel', () {
    test('saudação pela hora', () {
      expect(greetingFor(DateTime(2026, 10, 2, 8)), 'Bom dia');
      expect(greetingFor(DateTime(2026, 10, 2, 14)), 'Boa tarde');
      expect(greetingFor(DateTime(2026, 10, 2, 21)), 'Boa noite');
    });

    test('áreas e rótulos curtos do eixo', () {
      expect(dashboardAreaOf('attendance'), 'Académico');
      expect(dashboardAreaOf('billing'), 'Financeiro');
      expect(dashboardAreaOf('library'), 'Operações');
      expect(StudentsByGradeChartCard.shortLabel('Iniciação'), 'Inic.');
      expect(StudentsByGradeChartCard.shortLabel('10.ª classe'), '10.ª');
    });

    testWidgets('DashboardKpi: receita com barra face à prevista', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DashboardKpi(
            spec: _spec('billing.revenue'),
            metric: const DashboardMetric(
              widgetId: 'billing.revenue',
              value: 6000,
            ),
            expected: 10000,
          ),
        ),
      );
      final bar = tester.widget<LinearProgressIndicator>(
        find.byType(LinearProgressIndicator),
      );
      expect(bar.value, closeTo(0.6, 1e-9));
    });

    testWidgets('DashboardKpi: dívida a subir aparece a vermelho', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DashboardKpi(
            spec: _spec('billing.debt'),
            metric: const DashboardMetric(
              widgetId: 'billing.debt',
              value: 120,
              previous: 100,
            ),
            caption: 'vs. trimestre anterior',
          ),
        ),
      );
      final delta = tester.widget<Text>(find.text('+20,0%'));
      expect(delta.style?.color, AppColors.light.danger);
      expect(find.textContaining('vs. trimestre anterior:'), findsOneWidget);
    });

    testWidgets('DashboardKpiSections agrupa por área com títulos', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrap(
          DashboardKpiSections(
            widgets: [_spec('students.enrolled'), _spec('billing.debt')],
            metrics: const {
              'students.enrolled': DashboardMetric(
                widgetId: 'students.enrolled',
                value: 300,
              ),
              'billing.debt': DashboardMetric(
                widgetId: 'billing.debt',
                value: 100,
              ),
            },
          ),
        ),
      );
      expect(find.text('Académico'), findsOneWidget);
      expect(find.text('Financeiro'), findsOneWidget);
      expect(find.text('Operações'), findsNothing);
    });
  });
}
