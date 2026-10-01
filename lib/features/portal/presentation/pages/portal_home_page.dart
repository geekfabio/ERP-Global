import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../guardians/domain/link_validity.dart';
import '../../../students/data/models/student_summaries_model.dart';
import '../../data/models/portal_models.dart';
import '../../domain/portal_metrics.dart';
import '../providers/portal_providers.dart';
import '../widgets/portal_summary_tile.dart';
import '../widgets/pupil_selector.dart';

/// Home do portal: selector de educando e resumo só dos módulos licenciados.
class PortalHomePage extends ConsumerWidget {
  const PortalHomePage({super.key});

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
        final selectedId = ref.watch(selectedPupilIdProvider);
        final active = activePupil(list, selectedId)!;
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            PupilSelector(
              pupils: list,
              selectedId: active.student.id,
              onSelected: ref.read(selectedPupilIdProvider.notifier).select,
            ),
            if (list.length > 1) const SizedBox(height: AppSpacing.lg),
            _PupilHeader(pupil: active),
            const SizedBox(height: AppSpacing.lg),
            _Summary(studentId: active.student.id),
          ],
        );
      },
    );
  }
}

class _PupilHeader extends StatelessWidget {
  const _PupilHeader({required this.pupil});

  final PortalPupil pupil;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final link = pupil.link;
    final relationship = link == null
        ? ''
        : ' · ${guardianRelationshipLabel(link.relationship)}';
    return Row(
      children: [
        AppAvatar(
          name: pupil.student.fullName,
          imageUrl: pupil.student.photoUrl,
          radius: 28,
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(pupil.student.fullName, style: text.titleLarge),
              Text(
                'Processo n.º ${pupil.student.processNumber}$relationship',
                style: text.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.studentId});

  final String studentId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modules = ref.watch(portalSummaryModulesProvider);
    if (modules.isEmpty) {
      return const EmptyState(
        icon: Icons.lock_outline,
        title: 'Sem informação disponível',
        message: 'A escola ainda não disponibiliza módulos no portal.',
      );
    }
    final summary = ref.watch(portalSummaryProvider(studentId));
    return AsyncValueView<PortalSummary>(
      value: summary,
      onRetry: () => ref.invalidate(portalSummaryProvider(studentId)),
      loading: const SkeletonCard(),
      data: (s) {
        final tiles = <Widget>[
          if (s.grades case final g?) _gradesTile(g),
          if (s.attendance case final a?)
            PortalSummaryTile(
              icon: Icons.fact_check_outlined,
              label: 'Faltas injustificadas',
              value: '${unjustifiedAbsences(a)}',
              caption: '${a.records.length} registos de assiduidade',
            ),
          if (s.finance case final f?)
            PortalSummaryTile(
              icon: Icons.payments_outlined,
              label: 'Em dívida',
              value: PtAoFormatters.currency(outstandingMinor(f)),
              caption: '${overdueCount(f)} cobranças em atraso',
            ),
          if (s.card case final c?)
            PortalSummaryTile(
              icon: Icons.contactless_outlined,
              label: 'Saldo do refeitório',
              value: PtAoFormatters.currency(c.mealBalanceMinor),
              caption: c.cardNumber == null ? null : 'Cartão ${c.cardNumber}',
            ),
        ];
        return Wrap(
          spacing: AppSpacing.lg,
          runSpacing: AppSpacing.lg,
          children: [for (final t in tiles) SizedBox(width: 280, child: t)],
        );
      },
    );
  }

  Widget _gradesTile(StudentGradesSummary g) {
    final avg = latestTermAverage(g);
    return PortalSummaryTile(
      icon: Icons.grading_outlined,
      label: 'Média do último trimestre',
      value: avg == null ? '—' : PtAoFormatters.number(avg, decimalDigits: 1),
      caption: '${g.bulletins.length} boletins emitidos',
    );
  }
}
