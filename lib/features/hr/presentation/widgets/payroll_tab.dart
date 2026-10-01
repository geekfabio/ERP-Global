import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../../academic/presentation/widgets/academic_form_dialog.dart';
import '../../../academic/presentation/widgets/academic_table.dart';
import '../../data/models/payroll_models.dart';
import '../../domain/payroll_rules.dart';
import '../pdf/payslip_pdf_template.dart';
import '../providers/hr_providers.dart';
import '../providers/payroll_providers.dart';

/// Número máximo de escalões de IRT editáveis no formulário.
const _maxBrackets = 6;

String _currentMonth() {
  final n = DateTime.now();
  return '${n.year}-${n.month.toString().padLeft(2, '0')}';
}

/// Folha salarial: regras (INSS/IRT), processamento mensal e recibos em PDF.
class PayrollTab extends ConsumerStatefulWidget {
  const PayrollTab({super.key});

  @override
  ConsumerState<PayrollTab> createState() => _PayrollTabState();
}

class _PayrollTabState extends ConsumerState<PayrollTab> {
  final _month = TextEditingController(text: _currentMonth());
  String _active = _currentMonth();
  bool _running = false;

  @override
  void dispose() {
    _month.dispose();
    super.dispose();
  }

  void _toast(String message, {bool error = false}) {
    final toast = ref.read(toastProvider.notifier);
    error ? toast.error(message) : toast.success(message);
  }

  void _select() {
    final m = _month.text.trim();
    if (monthStart(m) == null) {
      _toast('Mês inválido (AAAA-MM).', error: true);
      return;
    }
    setState(() => _active = m);
  }

  Future<void> _run() async {
    _select();
    if (monthStart(_active) == null || _running) return;
    setState(() => _running = true);
    final result = await ref.read(payrollRepositoryProvider).run(_active);
    if (!mounted) return;
    setState(() => _running = false);
    result.when(
      ok: (s) {
        ref.invalidate(payslipListProvider(_active));
        _toast(
          'Folha de ${monthLabel(s.month)} processada: ${s.count} recibos, '
          'líquido ${PtAoFormatters.currency(s.totalNet)}.',
        );
      },
      err: (f) => _toast(f.message, error: true),
    );
  }

  Future<void> _editSettings() async {
    final current = (await ref.read(payrollSettingsProvider.future));
    if (!mounted) return;
    final b = current.irtBrackets;
    final values = await showAcademicForm(
      context,
      title: 'Regras da folha',
      subtitle: 'Taxas em pontos base (300 = 3%). Valores em Kz.',
      fields: [
        AcademicField(
          'inssEmployeeBp',
          'INSS trabalhador (pontos base)',
          kind: FieldKind.integer,
          initial: '${current.inssEmployeeBp}',
        ),
        AcademicField(
          'inssEmployerBp',
          'INSS entidade patronal (pontos base)',
          kind: FieldKind.integer,
          initial: '${current.inssEmployerBp}',
        ),
        AcademicField(
          'vacationDaysPerYear',
          'Dias de férias por ano (úteis)',
          kind: FieldKind.integer,
          initial: '${current.vacationDaysPerYear}',
        ),
        AcademicField(
          'workingDaysPerMonth',
          'Dias úteis por mês (desconto de faltas)',
          kind: FieldKind.integer,
          initial: '${current.workingDaysPerMonth}',
        ),
        for (var i = 0; i < _maxBrackets; i++) ...[
          AcademicField(
            'irtFrom$i',
            'IRT escalão ${i + 1}: acima de (Kz)',
            kind: FieldKind.integer,
            initial: i < b.length ? '${b[i].from ~/ 100}' : null,
            required: false,
          ),
          AcademicField(
            'irtRate$i',
            'IRT escalão ${i + 1}: taxa (pontos base)',
            kind: FieldKind.integer,
            initial: i < b.length ? '${b[i].rateBp}' : null,
            required: false,
          ),
          AcademicField(
            'irtFixed$i',
            'IRT escalão ${i + 1}: parcela fixa (Kz)',
            kind: FieldKind.integer,
            initial: i < b.length ? '${b[i].fixedAmount ~/ 100}' : null,
            required: false,
          ),
        ],
      ],
    );
    if (values == null || !mounted) return;
    int n(String k) => (values[k] as int?) ?? 0;
    final settings = PayrollSettings(
      inssEmployeeBp: n('inssEmployeeBp'),
      inssEmployerBp: n('inssEmployerBp'),
      vacationDaysPerYear: n('vacationDaysPerYear'),
      workingDaysPerMonth: n('workingDaysPerMonth'),
      irtBrackets: [
        for (var i = 0; i < _maxBrackets; i++)
          if (values['irtFrom$i'] != null)
            IrtBracket(
              from: n('irtFrom$i') * 100,
              rateBp: n('irtRate$i'),
              fixedAmount: n('irtFixed$i') * 100,
            ),
      ],
    );
    final result = await ref
        .read(payrollRepositoryProvider)
        .updateSettings(settings);
    if (!mounted) return;
    result.when(
      ok: (_) {
        ref.invalidate(payrollSettingsProvider);
        _toast('Regras da folha actualizadas.');
      },
      err: (f) => _toast(f.message, error: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    final employees = <String, String>{
      for (final e in ref.watch(employeeListProvider).value ?? const [])
        e.id: '${e.employeeNumber} · ${e.fullName}',
    };
    final payslips = ref.watch(payslipListProvider(_active));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 180,
                child: AppTextField(
                  key: const Key('payroll_month'),
                  label: 'Mês (AAAA-MM)',
                  controller: _month,
                  onChanged: (_) {},
                ),
              ),
              AppButton(
                label: 'Ver',
                variant: AppButtonVariant.secondary,
                onPressed: _select,
              ),
              Can(
                permission: 'hr.payroll.create',
                child: AppButton(
                  key: const Key('payroll_run'),
                  label: 'Processar folha',
                  icon: Icons.calculate_outlined,
                  loading: _running,
                  onPressed: _run,
                ),
              ),
              Can(
                permission: 'hr.payroll.update',
                child: AppButton(
                  key: const Key('payroll_settings'),
                  label: 'Regras (INSS/IRT)',
                  icon: Icons.tune,
                  variant: AppButtonVariant.secondary,
                  onPressed: _editSettings,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AsyncValueView<List<Payslip>>(
            value: payslips,
            onRetry: () => ref.invalidate(payslipListProvider(_active)),
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Folha ainda não processada neste mês',
            ),
            data: (items) => AcademicTable<Payslip>(
              items: items,
              rowId: (p) => p.id,
              emptyText: 'Sem resultados',
              columns: [
                AppColumn(
                  label: 'Funcionário',
                  text: (p) => employees[p.employeeId] ?? '—',
                  sortValue: (p) => employees[p.employeeId] ?? '',
                ),
                AppColumn(
                  label: 'Salário base',
                  text: (p) => PtAoFormatters.currency(p.baseSalary),
                  sortValue: (p) => p.baseSalary,
                  numeric: true,
                ),
                AppColumn(
                  label: 'Faltas',
                  text: (p) => '${p.absenceDays}',
                  sortValue: (p) => p.absenceDays,
                  numeric: true,
                ),
                AppColumn(
                  label: 'INSS',
                  text: (p) => PtAoFormatters.currency(p.inssEmployee),
                  sortValue: (p) => p.inssEmployee,
                  numeric: true,
                ),
                AppColumn(
                  label: 'IRT',
                  text: (p) => PtAoFormatters.currency(p.irt),
                  sortValue: (p) => p.irt,
                  numeric: true,
                ),
                AppColumn(
                  label: 'Líquido',
                  text: (p) => PtAoFormatters.currency(p.netPay),
                  sortValue: (p) => p.netPay,
                  numeric: true,
                ),
              ],
              rowActions: [
                RowAction(
                  label: 'Recibo PDF',
                  icon: Icons.picture_as_pdf_outlined,
                  onTap: (p) => ref.read(payslipPdfServiceProvider).export(p),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
