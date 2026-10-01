import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/modules/license_gate.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/portal_models.dart';
import '../providers/portal_providers.dart';
import 'pupil_selector.dart';

/// Moldura das páginas do portal por educando: voltar, título, selector de
/// educando e o corpo para o educando activo. Se [moduleCode] não estiver
/// licenciado, mostra o aviso em vez de pedir dados.
class PortalPupilPage extends ConsumerWidget {
  const PortalPupilPage({
    super.key,
    required this.title,
    required this.builder,
    this.moduleCode,
  });

  final String title;
  final String? moduleCode;
  final Widget Function(BuildContext context, PortalPupil pupil) builder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final enabled = ref.watch(enabledModulesProvider);
    final pupils = ref.watch(portalPupilsProvider);
    final text = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        Row(
          children: [
            IconButton(
              tooltip: 'Voltar',
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/portal'),
            ),
            Expanded(child: Text(title, style: text.titleLarge)),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        if (moduleCode != null && !enabled.contains(moduleCode))
          const EmptyState(
            icon: Icons.lock_outline,
            title: 'Secção indisponível',
            message: 'A escola ainda não disponibiliza esta secção no portal.',
          )
        else
          AsyncValueView<List<PortalPupil>>(
            value: pupils,
            onRetry: () => ref.invalidate(portalPupilsProvider),
            isEmpty: (list) => list.isEmpty,
            empty: const EmptyState(
              icon: Icons.family_restroom_outlined,
              title: 'Sem educandos vinculados',
            ),
            loading: const SkeletonCard(),
            data: (list) {
              final active = activePupil(
                list,
                ref.watch(selectedPupilIdProvider),
              )!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PupilSelector(
                    pupils: list,
                    selectedId: active.student.id,
                    onSelected: ref
                        .read(selectedPupilIdProvider.notifier)
                        .select,
                  ),
                  if (list.length > 1) const SizedBox(height: AppSpacing.lg),
                  Text(active.student.fullName, style: text.titleMedium),
                  const SizedBox(height: AppSpacing.md),
                  builder(context, active),
                ],
              );
            },
          ),
      ],
    );
  }
}
