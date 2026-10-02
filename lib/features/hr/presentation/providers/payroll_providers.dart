import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/pdf/pdf_file_saver.dart';
import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/pdf/pdf_template_engine.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../../data/mock_api/payroll_mock_handlers.dart';
import '../../data/models/payroll_models.dart';
import '../../data/repositories/api_payroll_repositories.dart';
import '../../domain/payroll_repository.dart';
import '../pdf/payslip_pdf_template.dart';
import 'hr_providers.dart';

final attendanceRepositoryProvider = Provider<AttendanceRepository>(
  (ref) => apiAttendanceRepository(ref.watch(apiClientProvider)),
);
final leaveRepositoryProvider = Provider<LeaveRepository>(
  (ref) => apiLeaveRepository(ref.watch(apiClientProvider)),
);
final payslipRepositoryProvider = Provider<PayslipRepository>(
  (ref) => apiPayslipRepository(ref.watch(apiClientProvider)),
);
final payrollRepositoryProvider = Provider<PayrollRepository>(
  (ref) => ApiPayrollRepository(ref.watch(apiClientProvider)),
);

/// Handlers mock da folha; partilham funcionários e contratos do RH.
final payrollMockHandlersProvider = Provider<PayrollMockHandlers>((ref) {
  final hr = ref.watch(hrMockHandlersProvider);
  return PayrollMockHandlers(
    employeesOf: () => hr.employeesSnapshot,
    contractsOf: () => hr.contractsSnapshot,
  );
});

final payrollPdfEngineProvider = Provider<PdfTemplateEngine>(
  (ref) => const PdfTemplateEngine(),
);
final payrollPdfSaverProvider = Provider<PdfFileSaver>(
  (ref) => const PickerPdfFileSaver(),
);

final attendanceListProvider =
    FutureProvider.autoDispose<List<AttendanceRecord>>(
      (ref) => fetchAllPages(ref.watch(attendanceRepositoryProvider)),
      retry: (_, _) => null,
    );

final leaveListProvider = FutureProvider.autoDispose<List<LeaveModel>>(
  (ref) => fetchAllPages(ref.watch(leaveRepositoryProvider)),
  retry: (_, _) => null,
);

final payrollSettingsProvider = FutureProvider.autoDispose<PayrollSettings>(
  (ref) async =>
      (await ref.watch(payrollRepositoryProvider).settings()).getOrThrow(),
  retry: (_, _) => null,
);

/// Recibos de um mês (`AAAA-MM`).
final payslipListProvider = FutureProvider.autoDispose
    .family<List<Payslip>, String>(
      (ref, month) => fetchAllPages(
        ref.watch(payslipRepositoryProvider),
        filters: {'month': month},
      ),
      retry: (_, _) => null,
    );

/// Gera e guarda o PDF do recibo de vencimento.
class PayslipPdfService {
  PayslipPdfService(this._ref);

  final Ref _ref;

  Future<PdfLetterhead> _letterhead() async {
    try {
      final i = await _ref.read(institutionProvider.future);
      if (i != null) {
        return PdfLetterhead(
          institutionName: i.name,
          nif: i.nif,
          address: i.address,
          phone: i.phone,
          email: i.email,
          brandColor: i.brandColor,
        );
      }
    } on Object {
      // sem acesso às definições: cabeçalho genérico
    }
    return const PdfLetterhead(institutionName: 'Instituição');
  }

  Future<void> export(Payslip payslip) async {
    final toast = _ref.read(toastProvider.notifier);
    try {
      final employees = await _ref.read(employeeListProvider.future);
      final positions = await _ref.read(positionListProvider.future);
      final employee = employees.firstWhere((e) => e.id == payslip.employeeId);
      final position = positions
          .where((p) => p.id == employee.positionId)
          .firstOrNull;
      final template = PayslipPdfTemplate(
        payslip: payslip,
        employee: employee,
        positionName: position?.name ?? '—',
      );
      final bytes = await _ref
          .read(payrollPdfEngineProvider)
          .render(
            letterhead: await _letterhead(),
            template: template,
            generatedAt: DateTime.now(),
          );
      final saved = await _ref
          .read(payrollPdfSaverProvider)
          .save(fileName: template.fileName, bytes: bytes);
      if (saved) toast.success('Recibo de vencimento guardado em PDF.');
    } on Object {
      toast.error('Não foi possível gerar o documento.');
    }
  }
}

final payslipPdfServiceProvider = Provider<PayslipPdfService>(
  PayslipPdfService.new,
);
