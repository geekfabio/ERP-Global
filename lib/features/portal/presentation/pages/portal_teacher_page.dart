import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/portal_teacher_models.dart';
import '../providers/portal_teacher_providers.dart';

/// Home do professor (mobile first): "as minhas turmas" com atalhos para o
/// registo de presenças e o lançamento de notas, só dos módulos licenciados
/// e permitidos ao perfil.
class PortalTeacherPage extends ConsumerWidget {
  const PortalTeacherPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final classes = ref.watch(portalTeacherClassesProvider);
    final enabled = ref.watch(enabledModulesProvider);
    final permissions = ref.watch(permissionServiceProvider);
    final canAttendance =
        enabled.contains('attendance') &&
        permissions.canAny('attendance.record.write');
    final canGrades =
        enabled.contains('grades') && permissions.canAny('grades.entry.write');

    return AsyncValueView<List<TeacherClass>>(
      value: classes,
      onRetry: () => ref.invalidate(portalTeacherClassesProvider),
      isEmpty: (list) => list.isEmpty,
      empty: const EmptyState(
        icon: Icons.school_outlined,
        title: 'Sem turmas atribuídas',
        message:
            'Ainda não tem turmas atribuídas neste ano lectivo. '
            'Contacte a coordenação.',
      ),
      data: (list) => ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: [
          Text(
            'As minhas turmas',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.lg),
          for (final c in list) ...[
            _ClassCard(
              item: c,
              canAttendance: canAttendance,
              canGrades: canGrades,
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _ClassCard extends StatelessWidget {
  const _ClassCard({
    required this.item,
    required this.canAttendance,
    required this.canGrades,
  });

  final TeacherClass item;
  final bool canAttendance;
  final bool canGrades;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final detail = [
      if (item.shiftName.isNotEmpty) item.shiftName,
      '${item.enrolledCount} alunos',
    ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.label, style: text.titleMedium),
            Text(detail, style: text.bodyMedium),
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                if (item.isHomeroom)
                  const Chip(
                    avatar: Icon(Icons.star_outline, size: 18),
                    label: Text('Director de turma'),
                  ),
                for (final s in item.subjects) Chip(label: Text(s.name)),
              ],
            ),
            if (canAttendance || canGrades) ...[
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  if (canAttendance)
                    FilledButton.tonalIcon(
                      style: _touch,
                      onPressed: () => context.go('/attendance'),
                      icon: const Icon(Icons.fact_check_outlined),
                      label: const Text('Presenças'),
                    ),
                  if (canGrades)
                    FilledButton.tonalIcon(
                      style: _touch,
                      onPressed: () => context.go('/grades'),
                      icon: const Icon(Icons.grading_outlined),
                      label: const Text('Notas'),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Alvo de toque confortável em telemóvel.
  static final _touch = FilledButton.styleFrom(
    minimumSize: const Size(120, 48),
  );
}
