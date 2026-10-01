import '../models/hr_models.dart';
import '../models/payroll_models.dart';

class PayrollSeed {
  const PayrollSeed({required this.attendance, required this.leaves});

  final List<AttendanceRecord> attendance;
  final List<LeaveModel> leaves;
}

String _id(String tag, int n) =>
    '01J$tag${n.toString().padLeft(4, '0')}'.padRight(26, '0');

/// Assiduidade de Setembro/2026 e férias de Agosto/2026 para parte dos
/// funcionários (determinístico, para a folha ter descontos reais).
PayrollSeed buildPayrollSeed(List<EmployeeModel> employees) {
  final attendance = <AttendanceRecord>[];
  final leaves = <LeaveModel>[];
  for (final (i, e) in employees.indexed) {
    if (i % 5 == 0) {
      attendance.add(
        AttendanceRecord(
          id: _id('ATT', attendance.length + 1),
          employeeId: e.id,
          date: '2026-09-10',
          status: AttendanceStatus.absent,
        ),
      );
    }
    if (i % 6 == 0) {
      attendance.add(
        AttendanceRecord(
          id: _id('ATT', attendance.length + 1),
          employeeId: e.id,
          date: '2026-09-11',
          status: AttendanceStatus.late,
        ),
      );
    }
    if (i % 7 == 0) {
      leaves.add(
        LeaveModel(
          id: _id('LEV', leaves.length + 1),
          employeeId: e.id,
          startDate: '2026-08-03',
          endDate: '2026-08-14',
          days: 10,
        ),
      );
    }
  }
  return PayrollSeed(attendance: attendance, leaves: leaves);
}
