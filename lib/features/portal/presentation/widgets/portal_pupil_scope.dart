import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/portal_models.dart';
import '../providers/portal_providers.dart';
import 'pupil_selector.dart';

/// Moldura das páginas do portal por educando: título, selector de educando
/// (multi-educando) e o conteúdo do educando activo.
class PortalPupilScope extends ConsumerWidget {
  const PortalPupilScope({
    super.key,
    required this.title,
    required this.builder,
  });

  final String title;
  final Widget Function(BuildContext context, PortalPupil pupil) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pupils = ref.watch(portalPupilsProvider);
    return AsyncValueView<List<PortalPupil>>(
      value: pupils,
      onRetry: () => ref.invalidate(portalPupilsProvider),
      isEmpty: (list) => list.isEmpty,
      empty: const EmptyState(
        icon: Icons.family_restroom_outlined,
        title: 'Sem educandos vinculados',
        message:
            'Esta conta ainda não tem educandos associados. '
            'Contacte a secretaria da escola.',
      ),
      data: (list) {
        final active = activePupil(list, ref.watch(selectedPupilIdProvider))!;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            PupilSelector(
              pupils: list,
              selectedId: active.student.id,
              onSelected: ref.read(selectedPupilIdProvider.notifier).select,
            ),
            if (list.length > 1) const SizedBox(height: AppSpacing.lg),
            builder(context, active),
          ],
        );
      },
    );
  }
}
