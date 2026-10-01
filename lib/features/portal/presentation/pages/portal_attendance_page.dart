import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../domain/portal_academic_logic.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_pupil_page.dart';

/// Presenças e faltas do educando, com atalho para justificar faltas.
class PortalAttendancePage extends StatelessWidget {
  const PortalAttendancePage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilPage(
    title: 'Faltas e presenças',
    moduleCode: 'attendance',
    builder: (context, pupil) => _Attendance(studentId: pupil.student.id),
  );
}

(String, BadgeStatus) _kindLabel(AttendanceKind k) => switch (k) {
  AttendanceKind.present => ('Presente', BadgeStatus.success),
  AttendanceKind.late => ('Atraso', BadgeStatus.warning),
  AttendanceKind.justified => ('Falta justificada', BadgeStatus.info),
  AttendanceKind.unjustified => ('Falta injustificada', BadgeStatus.danger),
};

class _Attendance extends ConsumerWidget {
  const _Attendance({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attendance = ref.watch(portalAttendanceProvider(studentId));
    return AsyncValueView<StudentAttendanceSummary>(
      value: attendance,
      onRetry: () => ref.invalidate(portalAttendanceProvider(studentId)),
      loading: const SkeletonCard(),
      isEmpty: (a) => a.records.isEmpty,
      empty: const EmptyState(
        icon: Icons.fact_check_outlined,
        title: 'Sem registos de assiduidade',
      ),
      data: (a) {
        final counts = countByKind(a);
        final events = a.records
            .where((r) => r.kind != AttendanceKind.present)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                for (final k in AttendanceKind.values)
                  Chip(label: Text('${_kindLabel(k).$1}: ${counts[k]}')),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            if ((counts[AttendanceKind.unjustified] ?? 0) > 0)
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.icon(
                  onPressed: () => context.go('/portal/justifications'),
                  icon: const Icon(Icons.edit_note),
                  label: const Text('Justificar falta'),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            Card(
              child: Column(
                children: [
                  for (final r in events)
                    ListTile(
                      title: Text(PtAoFormatters.date(r.date)),
                      trailing: StatusBadge(
                        label: _kindLabel(r.kind).$1,
                        status: _kindLabel(r.kind).$2,
                      ),
                    ),
                  if (events.isEmpty)
                    const ListTile(title: Text('Sem faltas nem atrasos')),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
