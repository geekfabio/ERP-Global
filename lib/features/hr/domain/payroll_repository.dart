import '../../../core/errors/result.dart';
import '../../academic/domain/academic_repositories.dart';
import '../data/models/payroll_models.dart';

typedef AttendanceRepository = AcademicCrudRepository<AttendanceRecord>;
typedef LeaveRepository = AcademicCrudRepository<LeaveModel>;
typedef PayslipRepository = AcademicCrudRepository<Payslip>;

/// Regras da folha e processamento mensal.
abstract interface class PayrollRepository {
  Future<Result<PayrollSettings>> settings();

  Future<Result<PayrollSettings>> updateSettings(PayrollSettings value);

  /// Processa (ou reprocessa) a folha do mês `AAAA-MM`.
  Future<Result<PayrollRunSummary>> run(String month);
}
