import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../../academic/presentation/widgets/academic_form_dialog.dart';
import '../../../academic/presentation/widgets/crud_tab.dart';
import '../../data/models/hr_models.dart';
import '../providers/hr_providers.dart';

/// Contratos: tipo, período e salário base (guardado em cêntimos).
class ContractsTab extends ConsumerWidget {
  const ContractsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = <String, String>{
      for (final e in ref.watch(employeeListProvider).value ?? const [])
        e.id: '${e.employeeNumber} · ${e.fullName}',
    };
    return CrudTab<ContractModel>(
      value: ref.watch(contractListProvider),
      onChanged: () {
        ref
          ..invalidate(contractListProvider)
          ..invalidate(employeeListProvider);
      },
      repository: ref.watch(contractRepositoryProvider),
      permission: 'hr.contract',
      noun: 'contrato',
      feminine: false,
      icon: Icons.description_outlined,
      rowId: (c) => c.id,
      describe: (c) => 'o contrato de ${employees[c.employeeId] ?? '—'}',
      columns: [
        AppColumn(
          label: 'Funcionário',
          text: (c) => employees[c.employeeId] ?? '—',
          sortValue: (c) => employees[c.employeeId] ?? '',
        ),
        AppColumn(
          label: 'Tipo',
          text: (c) => c.type.label,
          sortValue: (c) => c.type.label,
        ),
        AppColumn(
          label: 'Início',
          text: (c) => c.startDate,
          sortValue: (c) => c.startDate,
        ),
        AppColumn(
          label: 'Fim',
          text: (c) => c.endDate ?? '—',
          sortValue: (c) => c.endDate ?? '9999-12-31',
        ),
        AppColumn(
          label: 'Salário base',
          text: (c) => PtAoFormatters.currency(c.baseSalary),
          sortValue: (c) => c.baseSalary,
          numeric: true,
        ),
      ],
      fieldsFor: (c) => [
        AcademicField(
          'employeeId',
          'Funcionário',
          kind: FieldKind.choice,
          initial: c?.employeeId,
          options: employees,
        ),
        AcademicField(
          'type',
          'Tipo',
          kind: FieldKind.choice,
          initial: c?.type.code,
          options: {for (final t in ContractType.values) t.code: t.label},
        ),
        AcademicField(
          'startDate',
          'Início (AAAA-MM-DD)',
          initial: c?.startDate,
        ),
        AcademicField(
          'endDate',
          'Fim (AAAA-MM-DD)',
          initial: c?.endDate,
          required: false,
        ),
        AcademicField(
          'baseSalary',
          'Salário base mensal (Kz)',
          kind: FieldKind.integer,
          initial: c == null ? null : '${c.baseSalary ~/ 100}',
        ),
      ],
      fromValues: (c, v) => ContractModel(
        id: c?.id ?? '',
        employeeId: v['employeeId']! as String,
        type: ContractType.values.firstWhere((t) => t.code == v['type']),
        startDate: v['startDate']! as String,
        endDate: (v['endDate'] as String?)?.isEmpty ?? true
            ? null
            : v['endDate']! as String,
        baseSalary: ((v['baseSalary'] as int?) ?? 0) * 100,
      ),
    );
  }
}

/// Cargos.
class PositionsTab extends ConsumerWidget {
  const PositionsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => CrudTab<PositionModel>(
    value: ref.watch(positionListProvider),
    onChanged: () => ref.invalidate(positionListProvider),
    repository: ref.watch(positionRepositoryProvider),
    permission: 'hr.position',
    noun: 'cargo',
    feminine: false,
    icon: Icons.work_outline,
    rowId: (p) => p.id,
    describe: (p) => p.name,
    columns: [
      AppColumn(label: 'Nome', text: (p) => p.name, sortValue: (p) => p.name),
      AppColumn(
        label: 'Categoria',
        text: (p) => p.category.label,
        sortValue: (p) => p.category.label,
      ),
    ],
    fieldsFor: (p) => [
      AcademicField('name', 'Nome', initial: p?.name),
      AcademicField(
        'category',
        'Categoria',
        kind: FieldKind.choice,
        initial: p?.category.name,
        options: {for (final c in PositionCategory.values) c.name: c.label},
      ),
    ],
    fromValues: (p, v) => PositionModel(
      id: p?.id ?? '',
      name: v['name']! as String,
      category: PositionCategory.values.firstWhere(
        (c) => c.name == v['category'],
      ),
    ),
  );
}
