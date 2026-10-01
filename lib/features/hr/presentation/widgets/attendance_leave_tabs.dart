import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../../academic/presentation/widgets/academic_form_dialog.dart';
import '../../../academic/presentation/widgets/crud_tab.dart';
import '../../data/models/payroll_models.dart';
import '../providers/hr_providers.dart';
import '../providers/payroll_providers.dart';

Map<String, String> _employeeNames(WidgetRef ref) => {
  for (final e in ref.watch(employeeListProvider).value ?? const [])
    e.id: '${e.employeeNumber} · ${e.fullName}',
};

/// Assiduidade diária (presença, atrasos e faltas).
class AttendanceTab extends ConsumerWidget {
  const AttendanceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = _employeeNames(ref);
    return CrudTab<AttendanceRecord>(
      value: ref.watch(attendanceListProvider),
      onChanged: () => ref.invalidate(attendanceListProvider),
      repository: ref.watch(attendanceRepositoryProvider),
      permission: 'hr.attendance',
      noun: 'registo de assiduidade',
      feminine: false,
      icon: Icons.event_available_outlined,
      rowId: (a) => a.id,
      describe: (a) => 'o registo de ${employees[a.employeeId] ?? '—'}',
      columns: [
        AppColumn(
          label: 'Funcionário',
          text: (a) => employees[a.employeeId] ?? '—',
          sortValue: (a) => employees[a.employeeId] ?? '',
        ),
        AppColumn(label: 'Data', text: (a) => a.date, sortValue: (a) => a.date),
        AppColumn(
          label: 'Estado',
          text: (a) => a.status.label,
          sortValue: (a) => a.status.label,
          cell: (a) => StatusBadge(
            label: a.status.label,
            status: switch (a.status) {
              AttendanceStatus.present => BadgeStatus.success,
              AttendanceStatus.late ||
              AttendanceStatus.justified => BadgeStatus.warning,
              AttendanceStatus.absent => BadgeStatus.danger,
            },
          ),
        ),
      ],
      fieldsFor: (a) => [
        AcademicField(
          'employeeId',
          'Funcionário',
          kind: FieldKind.choice,
          initial: a?.employeeId,
          options: employees,
        ),
        AcademicField('date', 'Data (AAAA-MM-DD)', initial: a?.date),
        AcademicField(
          'status',
          'Estado',
          kind: FieldKind.choice,
          initial: a?.status.code,
          options: {for (final s in AttendanceStatus.values) s.code: s.label},
        ),
      ],
      fromValues: (a, v) => AttendanceRecord(
        id: a?.id ?? '',
        employeeId: v['employeeId']! as String,
        date: v['date']! as String,
        status: AttendanceStatus.values.firstWhere(
          (s) => s.code == v['status'],
        ),
      ),
    );
  }
}

/// Férias e licenças, com o saldo anual validado pelo servidor.
class LeavesTab extends ConsumerWidget {
  const LeavesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final employees = _employeeNames(ref);
    return CrudTab<LeaveModel>(
      value: ref.watch(leaveListProvider),
      onChanged: () => ref.invalidate(leaveListProvider),
      repository: ref.watch(leaveRepositoryProvider),
      permission: 'hr.leave',
      noun: 'férias ou licença',
      feminine: true,
      icon: Icons.beach_access_outlined,
      rowId: (l) => l.id,
      describe: (l) => 'as férias/licença de ${employees[l.employeeId] ?? '—'}',
      columns: [
        AppColumn(
          label: 'Funcionário',
          text: (l) => employees[l.employeeId] ?? '—',
          sortValue: (l) => employees[l.employeeId] ?? '',
        ),
        AppColumn(
          label: 'Tipo',
          text: (l) => l.kind.label,
          sortValue: (l) => l.kind.label,
        ),
        AppColumn(
          label: 'Início',
          text: (l) => l.startDate,
          sortValue: (l) => l.startDate,
        ),
        AppColumn(
          label: 'Fim',
          text: (l) => l.endDate,
          sortValue: (l) => l.endDate,
        ),
        AppColumn(
          label: 'Dias úteis',
          text: (l) => '${l.days}',
          sortValue: (l) => l.days,
          numeric: true,
        ),
      ],
      fieldsFor: (l) => [
        AcademicField(
          'employeeId',
          'Funcionário',
          kind: FieldKind.choice,
          initial: l?.employeeId,
          options: employees,
        ),
        AcademicField(
          'kind',
          'Tipo',
          kind: FieldKind.choice,
          initial: l?.kind.code,
          options: {for (final k in LeaveKind.values) k.code: k.label},
        ),
        AcademicField(
          'startDate',
          'Início (AAAA-MM-DD)',
          initial: l?.startDate,
        ),
        AcademicField('endDate', 'Fim (AAAA-MM-DD)', initial: l?.endDate),
      ],
      fromValues: (l, v) => LeaveModel(
        id: l?.id ?? '',
        employeeId: v['employeeId']! as String,
        kind: LeaveKind.values.firstWhere((k) => k.code == v['kind']),
        startDate: v['startDate']! as String,
        endDate: v['endDate']! as String,
      ),
    );
  }
}
