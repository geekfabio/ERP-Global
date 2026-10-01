import 'package:pdf/widgets.dart' as pw;

import '../../../../core/pdf/pdf_template.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../data/models/hr_models.dart';
import '../../data/models/payroll_models.dart';

const _months = [
  'Janeiro',
  'Fevereiro',
  'Março',
  'Abril',
  'Maio',
  'Junho',
  'Julho',
  'Agosto',
  'Setembro',
  'Outubro',
  'Novembro',
  'Dezembro',
];

/// `2026-09` → `Setembro de 2026`.
String monthLabel(String month) {
  final m = int.tryParse(month.length >= 7 ? month.substring(5, 7) : '');
  if (m == null || m < 1 || m > 12) return month;
  return '${_months[m - 1]} de ${month.substring(0, 4)}';
}

/// Recibo de vencimento: vencimento, descontos (faltas, INSS, IRT) e líquido.
class PayslipPdfTemplate implements PdfDocumentTemplate {
  const PayslipPdfTemplate({
    required this.payslip,
    required this.employee,
    required this.positionName,
  });

  final Payslip payslip;
  final EmployeeModel employee;
  final String positionName;

  @override
  String get title => 'Recibo de vencimento';

  @override
  String get fileName =>
      'recibo-vencimento-${employee.employeeNumber}-${payslip.month}';

  @override
  String get verificationCode =>
      'ERP-RV-${employee.employeeNumber}-${payslip.month}';

  @override
  List<pw.Widget> buildBody(PdfTemplateStyle s) {
    String money(int v) => PtAoFormatters.currency(v);
    return [
      s.section('Funcionário'),
      s.fields([
        ('Nome', employee.fullName),
        ('Nº de funcionário', employee.employeeNumber),
        ('Cargo', positionName),
        ('Período', monthLabel(payslip.month)),
      ]),
      s.section('Vencimento e descontos'),
      s.table(
        const ['Descrição', 'Valor'],
        [
          ['Salário base', money(payslip.baseSalary)],
          [
            'Faltas injustificadas (${payslip.absenceDays} dia(s))',
            '- ${money(payslip.absenceDeduction)}',
          ],
          ['Remuneração ilíquida', money(payslip.grossPay)],
          ['INSS (trabalhador)', '- ${money(payslip.inssEmployee)}'],
          ['IRT', '- ${money(payslip.irt)}'],
        ],
      ),
      pw.SizedBox(height: 10),
      pw.Align(
        alignment: pw.Alignment.centerRight,
        child: pw.Text(
          'Líquido a receber: ${money(payslip.netPay)}',
          style: s.bold,
        ),
      ),
      pw.SizedBox(height: 4),
      pw.Text(
        'INSS a cargo da entidade patronal: ${money(payslip.inssEmployer)}',
        style: s.label,
      ),
      pw.SizedBox(height: 24),
      s.signatures(const ['A entidade patronal', 'O funcionário']),
    ];
  }
}
