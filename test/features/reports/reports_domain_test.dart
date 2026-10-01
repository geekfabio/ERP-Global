import 'package:erp_global/core/academic/period_context.dart';
import 'package:erp_global/features/reports/domain/dashboard_widget.dart';
import 'package:erp_global/features/reports/presentation/providers/reports_providers.dart';
import 'package:flutter_test/flutter_test.dart';

const _terms = [
  PeriodTerm(id: 't1', label: '1.º Trimestre'),
  PeriodTerm(id: 't2', label: '2.º Trimestre'),
];
const _choices = PeriodChoices([
  PeriodYear(id: 'y26', label: '2025/2026', isActive: true, terms: _terms),
  PeriodYear(id: 'y25', label: '2024/2025', terms: _terms),
]);

void main() {
  test('o dashboard muda por perfil', () {
    const all = {'students', 'billing', 'cafeteria', 'library'};
    ids(String p) => visibleWidgets(p, all).map((w) => w.id).toSet();
    expect(ids('financeiro'), contains('billing.debt'));
    expect(ids('financeiro'), isNot(contains('students.enrolled')));
    expect(ids('refeitorio'), contains('cafeteria.meals'));
    expect(ids('direcao').length, greaterThan(ids('financeiro').length));
    expect(visibleWidgets('encarregado', all), isEmpty);
    expect(visibleWidgets(null, all), isEmpty);
  });

  test('widgets de módulos não licenciados não aparecem', () {
    final ids = visibleWidgets('direcao', {'students'}).map((w) => w.id);
    expect(ids, everyElement(startsWith('students.')));
  });

  test('perfil da sessão', () {
    expect(dashboardProfileFor(['super_admin']), 'direcao');
    expect(dashboardProfileFor(['aluno', 'rh']), 'rh');
    expect(dashboardProfileFor(['encarregado']), isNull);
  });

  test('variação: % nos valores, pontos nos percentuais', () {
    expect(deltaOf(MetricKind.count, 110, 100), closeTo(10, 1e-9));
    expect(deltaOf(MetricKind.percent, 90, 85), 5);
    expect(deltaOf(MetricKind.money, 5, 0), isNull);
    expect(deltaOf(MetricKind.count, 5, null), isNull);
  });

  test('período de comparação: trimestre e ano anteriores', () {
    final t2 = resolvePeriod(
      _choices,
      const PeriodSelection(yearId: 'y26', termId: 't2'),
    );
    final prevTerm = comparePeriod(_choices, t2, CompareMode.previousTerm);
    expect((prevTerm!.yearId, prevTerm.termId), ('y26', 't1'));
    final prevYear = comparePeriod(_choices, t2, CompareMode.previousYear);
    expect((prevYear!.yearId, prevYear.termId), ('y25', 't2'));
    expect(comparePeriod(_choices, t2, CompareMode.none), isNull);

    final t1 = resolvePeriod(
      _choices,
      const PeriodSelection(yearId: 'y26', termId: 't1'),
    );
    expect(comparePeriod(_choices, t1, CompareMode.previousTerm), isNull);
    final old = resolvePeriod(_choices, const PeriodSelection(yearId: 'y25'));
    expect(comparePeriod(_choices, old, CompareMode.previousYear), isNull);
  });
}
