import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/widgets/academic_form_dialog.dart';
import '../../../academic/presentation/widgets/crud_tab.dart';
import '../../data/models/hr_models.dart';
import '../../domain/hr_rules.dart';
import '../providers/hr_providers.dart';

/// Funcionários: lista com aviso de docentes sem contrato, ficha e CRUD.
class EmployeesTab extends ConsumerWidget {
  const EmployeesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final positions = <String, String>{
      for (final p in ref.watch(positionListProvider).value ?? const [])
        p.id: p.name,
    };
    final teachers = <String, String>{
      '': 'Sem ligação ao académico',
      for (final t in ref.watch(teacherListProvider).value ?? const [])
        t.id: '${t.employeeNumber} · ${t.fullName}',
    };
    final employees = ref.watch(employeeListProvider);
    final flagged = (employees.value ?? const <EmployeeModel>[])
        .where(isTeacherWithoutContract)
        .length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (flagged > 0)
          _TeacherWarning(
            key: const Key('teachers_without_contract_banner'),
            count: flagged,
          ),
        Expanded(
          child: CrudTab<EmployeeModel>(
            value: employees,
            onChanged: () {
              ref
                ..invalidate(employeeListProvider)
                ..invalidate(contractListProvider);
            },
            repository: ref.watch(employeeRepositoryProvider),
            permission: 'hr.employee',
            noun: 'funcionário',
            feminine: false,
            icon: Icons.badge_outlined,
            rowId: (e) => e.id,
            describe: (e) => e.fullName,
            extraActions: [
              RowAction(
                label: 'Ficha',
                icon: Icons.badge_outlined,
                onTap: (e) => showDialog<void>(
                  context: context,
                  builder: (_) => EmployeeSheet(
                    employee: e,
                    position: positions[e.positionId] ?? '—',
                  ),
                ),
              ),
            ],
            columns: [
              AppColumn(
                label: 'N.º',
                text: (e) => e.employeeNumber,
                sortValue: (e) => e.employeeNumber,
              ),
              AppColumn(
                label: 'Nome',
                text: (e) => e.fullName,
                sortValue: (e) => e.fullName,
              ),
              AppColumn(
                label: 'Cargo',
                text: (e) => positions[e.positionId] ?? '—',
                sortValue: (e) => positions[e.positionId] ?? '',
              ),
              AppColumn(
                label: 'Contrato',
                text: _contractLabel,
                sortValue: _contractLabel,
                cell: (e) => StatusBadge(
                  label: _contractLabel(e),
                  status: e.hasActiveContract
                      ? BadgeStatus.success
                      : isTeacherWithoutContract(e)
                      ? BadgeStatus.danger
                      : BadgeStatus.neutral,
                ),
              ),
              AppColumn(
                label: 'Estado',
                text: (e) => e.isActive ? 'Activo' : 'Inactivo',
                sortValue: (e) => e.isActive ? 0 : 1,
                cell: (e) => StatusBadge(
                  label: e.isActive ? 'Activo' : 'Inactivo',
                  status: e.isActive
                      ? BadgeStatus.success
                      : BadgeStatus.neutral,
                ),
              ),
            ],
            fieldsFor: (e) => [
              AcademicField('fullName', 'Nome completo', initial: e?.fullName),
              AcademicField('email', 'Email', initial: e?.email),
              AcademicField(
                'phone',
                'Telemóvel',
                initial: e?.phone,
                required: false,
              ),
              AcademicField(
                'positionId',
                'Cargo',
                kind: FieldKind.choice,
                initial: e?.positionId,
                options: positions,
              ),
              AcademicField(
                'hireDate',
                'Data de admissão (AAAA-MM-DD)',
                initial: e?.hireDate,
              ),
              AcademicField(
                'teacherId',
                'Professor (académico)',
                kind: FieldKind.choice,
                initial: e?.teacherId,
                options: teachers,
                required: false,
              ),
              AcademicField(
                'isActive',
                'Activo',
                kind: FieldKind.toggle,
                initial: e?.isActive ?? true,
              ),
            ],
            fromValues: (e, v) => EmployeeModel(
              id: e?.id ?? '',
              employeeNumber: e?.employeeNumber ?? '',
              fullName: v['fullName']! as String,
              email: v['email']! as String,
              phone: v['phone']! as String,
              positionId: v['positionId']! as String,
              hireDate: v['hireDate']! as String,
              teacherId: (v['teacherId'] as String?)?.isEmpty ?? true
                  ? null
                  : v['teacherId']! as String,
              isActive: v['isActive']! as bool,
            ),
          ),
        ),
      ],
    );
  }

  static String _contractLabel(EmployeeModel e) => e.hasActiveContract
      ? 'Em vigor'
      : isTeacherWithoutContract(e)
      ? 'Docente sem contrato'
      : 'Sem contrato';
}

class _TeacherWarning extends StatelessWidget {
  const _TeacherWarning({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      margin: const EdgeInsets.only(top: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_outlined, color: scheme.onErrorContainer),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              count == 1
                  ? '1 docente activo sem contrato em vigor'
                  : '$count docentes activos sem contrato em vigor',
              style: TextStyle(color: scheme.onErrorContainer),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ficha do funcionário: dados, contratos e, nos docentes, atribuições.
class EmployeeSheet extends ConsumerWidget {
  const EmployeeSheet({
    super.key,
    required this.employee,
    required this.position,
  });

  final EmployeeModel employee;
  final String position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    Widget row(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: theme.textTheme.labelLarge),
          ),
          Expanded(child: Text(value.isEmpty ? '—' : value)),
        ],
      ),
    );
    final contracts = ref.watch(employeeContractsProvider(employee.id));
    final teacherId = employee.teacherId;
    return AlertDialog(
      key: const Key('employee_sheet'),
      title: Text(employee.fullName),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              row('N.º funcionário', employee.employeeNumber),
              row('Cargo', position),
              row('Email', employee.email),
              row('Telemóvel', employee.phone),
              row('Admissão', employee.hireDate),
              row('Estado', employee.isActive ? 'Activo' : 'Inactivo'),
              if (teacherId != null)
                Consumer(
                  builder: (context, ref, _) => row(
                    'Atribuições',
                    ref
                        .watch(teacherAssignmentCountProvider(teacherId))
                        .when(
                          data: (n) => n == 0
                              ? 'Sem atribuições'
                              : '$n turma/disciplina',
                          loading: () => 'A carregar…',
                          error: (_, _) => '—',
                        ),
                  ),
                ),
              if (isTeacherWithoutContract(employee))
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Text(
                    'Docente sem contrato em vigor',
                    key: const Key('sheet_teacher_warning'),
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              Text('Contratos', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.xs),
              contracts.when(
                data: (list) => list.isEmpty
                    ? const Text('Sem contratos registados')
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (final c in list)
                            Text(
                              '${c.type.label} · ${c.startDate} → '
                              '${c.endDate ?? 'sem termo'} · '
                              '${PtAoFormatters.currency(c.baseSalary)}',
                            ),
                        ],
                      ),
                loading: () => const Text('A carregar…'),
                error: (_, _) => const Text('Não foi possível carregar'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
