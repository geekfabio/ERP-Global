import '../data/models/hr_models.dart';
import '../data/models/payroll_models.dart';
import 'hr_rules.dart';

/// Dias úteis (seg–sex) entre [start] e [end], inclusive.
int countWorkdays(DateTime start, DateTime end) {
  var n = 0;
  for (var d = start; !d.isAfter(end); d = d.add(const Duration(days: 1))) {
    if (d.weekday <= DateTime.friday) n++;
  }
  return n;
}

/// Primeiro dia do mês `AAAA-MM` (UTC), ou `null` se inválido.
DateTime? monthStart(String month) {
  if (!RegExp(r'^\d{4}-(0[1-9]|1[0-2])$').hasMatch(month)) return null;
  return parseIsoDate('$month-01');
}

/// Último dia do mês `AAAA-MM` (UTC), ou `null` se inválido.
DateTime? monthEnd(String month) {
  final start = monthStart(month);
  return start == null ? null : DateTime.utc(start.year, start.month + 1, 0);
}

/// O contrato tem vigência em algum dia do mês.
bool contractCoversMonth(ContractModel c, String month) {
  final from = monthStart(month);
  final to = monthEnd(month);
  final start = parseIsoDate(c.startDate);
  if (from == null || to == null || start == null || start.isAfter(to)) {
    return false;
  }
  final end = parseIsoDate(c.endDate);
  return end == null || !end.isBefore(from);
}

/// Arredondamento de `value × bp / 10000` sem `double`.
int applyBp(int value, int bp) => (value * bp + 5000) ~/ 10000;

/// IRT sobre a matéria colectável: parcela fixa + taxa × excesso do escalão.
int computeIrt(int taxable, List<IrtBracket> brackets) {
  IrtBracket? hit;
  for (final b in brackets) {
    if (taxable >= b.from && (hit == null || b.from >= hit.from)) hit = b;
  }
  if (hit == null) return 0;
  return hit.fixedAmount + applyBp(taxable - hit.from, hit.rateBp);
}

/// Dias de férias por gozar em [year] (`AAAA`).
int vacationBalance(
  PayrollSettings s,
  Iterable<LeaveModel> leaves,
  String employeeId,
  int year, {
  String? excludeLeaveId,
}) =>
    s.vacationDaysPerYear -
    leaves
        .where(
          (l) =>
              l.id != excludeLeaveId &&
              l.employeeId == employeeId &&
              l.kind == LeaveKind.vacation &&
              l.startDate.startsWith('$year'),
        )
        .fold<int>(0, (a, l) => a + l.days);

/// Calcula o recibo: desconta faltas injustificadas, INSS e IRT.
Payslip computePayslip({
  required String id,
  required String employeeId,
  required String month,
  required int baseSalary,
  required int absenceDays,
  required PayrollSettings settings,
}) {
  final daily = baseSalary ~/ settings.workingDaysPerMonth;
  final deduction = (daily * absenceDays).clamp(0, baseSalary);
  final gross = baseSalary - deduction;
  final inss = applyBp(gross, settings.inssEmployeeBp);
  final irt = computeIrt(gross - inss, settings.irtBrackets);
  return Payslip(
    id: id,
    employeeId: employeeId,
    month: month,
    baseSalary: baseSalary,
    absenceDays: absenceDays,
    absenceDeduction: deduction,
    grossPay: gross,
    inssEmployee: inss,
    inssEmployer: applyBp(gross, settings.inssEmployerBp),
    irt: irt,
    netPay: gross - inss - irt,
  );
}
