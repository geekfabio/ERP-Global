import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/portal_academic_models.dart';
import '../../domain/portal_academic_logic.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_pupil_page.dart';

/// Horário semanal da turma do educando (só leitura).
class PortalSchedulePage extends StatelessWidget {
  const PortalSchedulePage({super.key});

  @override
  Widget build(BuildContext context) => PortalPupilPage(
    title: 'Horário',
    moduleCode: 'academic',
    builder: (context, pupil) => _Schedule(studentId: pupil.student.id),
  );
}

class _Schedule extends ConsumerWidget {
  const _Schedule({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slots = ref.watch(portalScheduleProvider(studentId));
    final text = Theme.of(context).textTheme;
    return AsyncValueView<List<PortalScheduleSlot>>(
      value: slots,
      onRetry: () => ref.invalidate(portalScheduleProvider(studentId)),
      loading: const SkeletonCard(),
      isEmpty: (l) => l.isEmpty,
      empty: const EmptyState(
        icon: Icons.calendar_month_outlined,
        title: 'Sem horário disponível',
        message: 'O educando ainda não tem turma ou horário definido.',
      ),
      data: (l) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in groupByWeekday(l).entries) ...[
            Text(weekdayName(entry.key), style: text.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Column(
                children: [
                  for (final s in entry.value)
                    ListTile(
                      title: Text(s.subject),
                      subtitle: s.teacher == null ? null : Text(s.teacher!),
                      trailing: Text('${s.startTime}–${s.endTime}'),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ],
      ),
    );
  }
}
