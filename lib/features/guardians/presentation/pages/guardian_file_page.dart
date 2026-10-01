import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../students/data/models/guardian_model.dart';
import '../../../students/domain/student_repositories.dart';
import '../../../students/data/models/student_model.dart';
import '../../../students/presentation/providers/student_providers.dart';
import '../../domain/link_validity.dart';
import '../providers/guardian_providers.dart';
import '../widgets/pupil_link_dialog.dart';

/// Ficha do encarregado: contactos e educandos vinculados (parentesco,
/// responsabilidades e validade de cada vínculo).
class GuardianFilePage extends ConsumerWidget {
  const GuardianFilePage({super.key, required this.guardianId});

  final String guardianId;

  Future<void> _run(
    WidgetRef ref,
    Future<String?> Function() action,
    String ok,
  ) async {
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final error = await action();
    if (error != null) {
      toast.error(error);
      return;
    }
    toast.success(ok);
    container
      ..invalidate(guardianProvider(guardianId))
      ..invalidate(guardianPupilsProvider(guardianId));
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    GuardianModel g,
  ) async {
    final edited = await showDialog<GuardianModel>(
      context: context,
      builder: (_) => GuardianEditDialog(guardian: g),
    );
    if (edited == null) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.update(edited)).failureOrNull?.message,
      'Encarregado actualizado',
    );
  }

  Future<void> _editLink(
    BuildContext context,
    WidgetRef ref,
    GuardianModel g,
    GuardianPupil p,
  ) async {
    final edited = await showDialog<GuardianLinkModel>(
      context: context,
      builder: (_) => PupilLinkDialog(
        title: 'Vínculo com ${p.student.fullName}',
        guardian: g,
        initial: p.link,
      ),
    );
    if (edited == null) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.updateLink(edited)).failureOrNull?.message,
      'Vínculo actualizado',
    );
  }

  Future<void> _unlink(
    BuildContext context,
    WidgetRef ref,
    GuardianPupil p,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Remover vínculo',
      message: 'Remover o vínculo com "${p.student.fullName}"?',
      confirmLabel: 'Remover',
      destructive: true,
    );
    if (!ok) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.unlink(p.link.id)).failureOrNull?.message,
      'Vínculo removido',
    );
  }

  Future<void> _addPupil(
    BuildContext context,
    WidgetRef ref,
    GuardianModel g,
    List<GuardianPupil> current,
  ) async {
    final students = await ref
        .read(studentRepositoryProvider)
        .list(const StudentQuery(pageSize: 100));
    final linked = {for (final p in current) p.student.id};
    final candidates = [
      for (final s in students.valueOrNull?.items ?? const <StudentModel>[])
        if (!linked.contains(s.id)) s,
    ];
    if (!context.mounted) return;
    final link = await showDialog<GuardianLinkModel>(
      context: context,
      builder: (_) => PupilLinkDialog(
        title: 'Associar educando',
        guardian: g,
        candidates: candidates,
      ),
    );
    if (link == null) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.link(link)).failureOrNull?.message,
      'Educando associado',
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guardian = ref.watch(guardianProvider(guardianId));
    final pupils = ref.watch(guardianPupilsProvider(guardianId));
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => context.go('/guardians'),
                icon: const Icon(Icons.arrow_back),
                label: const Text('Encarregados'),
              ),
            ),
            AsyncValueView<GuardianModel>(
              value: guardian,
              onRetry: () => ref.invalidate(guardianProvider(guardianId)),
              loading: const SkeletonCard(),
              data: (g) =>
                  _Contact(guardian: g, onEdit: () => _edit(context, ref, g)),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Educandos',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                if (guardian.value case final g?)
                  Can(
                    permission: 'students.record.update',
                    child: AppButton(
                      label: 'Associar educando',
                      icon: Icons.person_add_alt_outlined,
                      onPressed: () =>
                          _addPupil(context, ref, g, pupils.value ?? const []),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AsyncValueView<List<GuardianPupil>>(
              value: pupils,
              onRetry: () => ref.invalidate(guardianPupilsProvider(guardianId)),
              isEmpty: (d) => d.isEmpty,
              loading: const SkeletonCard(),
              empty: const EmptyState(
                icon: Icons.school_outlined,
                title: 'Sem educandos',
                message: 'Este encarregado ainda não tem educandos vinculados.',
              ),
              data: (items) => Column(
                children: [
                  for (final p in items)
                    _PupilCard(
                      pupil: p,
                      onEdit: guardian.value == null
                          ? null
                          : () => _editLink(context, ref, guardian.value!, p),
                      onRemove: () => _unlink(context, ref, p),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Contact extends StatelessWidget {
  const _Contact({required this.guardian, required this.onEdit});

  final GuardianModel guardian;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final g = guardian;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(g.fullName, style: text.headlineSmall),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Telefone: ${g.phone}'),
                  if (g.email != null) Text('E-mail: ${g.email}'),
                  if (g.idNumber != null) Text('BI: ${g.idNumber}'),
                  if (g.nif != null) Text('NIF: ${g.nif}'),
                  if (g.address != null) Text('Morada: ${g.address}'),
                  if (g.profession != null) Text('Profissão: ${g.profession}'),
                ],
              ),
            ),
            Can(
              permission: 'students.record.update',
              child: AppIconButton(
                icon: Icons.edit_outlined,
                tooltip: 'Editar encarregado',
                onPressed: onEdit,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PupilCard extends StatelessWidget {
  const _PupilCard({
    required this.pupil,
    required this.onEdit,
    required this.onRemove,
  });

  final GuardianPupil pupil;
  final VoidCallback? onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final s = pupil.student;
    final l = pupil.link;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => context.go('/students/${s.id}'),
                    child: Text(
                      s.fullName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    '${guardianRelationshipLabel(l.relationship)} · '
                    'Processo ${s.processNumber}',
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      if (l.isFinancialResponsible)
                        const StatusBadge(
                          label: 'Responsável financeiro',
                          status: BadgeStatus.info,
                        ),
                      if (l.isEmergency)
                        const StatusBadge(
                          label: 'Emergência',
                          status: BadgeStatus.warning,
                        ),
                      if (l.canPickup)
                        const StatusBadge(
                          label: 'Pode recolher',
                          status: BadgeStatus.success,
                        ),
                      _ValidityBadge(
                        link: l,
                        validity: linkValidity(l, DateTime.now()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Can(
              permission: 'students.record.update',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppIconButton(
                    icon: Icons.edit_outlined,
                    tooltip: 'Editar vínculo',
                    onPressed: onEdit,
                  ),
                  AppIconButton(
                    icon: Icons.link_off_outlined,
                    tooltip: 'Remover vínculo',
                    onPressed: onRemove,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValidityBadge extends StatelessWidget {
  const _ValidityBadge({required this.link, required this.validity});

  final GuardianLinkModel link;
  final LinkValidity validity;

  @override
  Widget build(BuildContext context) {
    final until = link.validUntil;
    if (until == null) {
      return const StatusBadge(
        label: 'Sem fim de validade',
        status: BadgeStatus.neutral,
      );
    }
    final date = PtAoFormatters.date(until);
    return switch (validity) {
      LinkValidity.active => StatusBadge(
        label: 'Válido até $date',
        status: BadgeStatus.success,
      ),
      LinkValidity.expiring => StatusBadge(
        label: 'Termina em $date',
        status: BadgeStatus.warning,
      ),
      LinkValidity.expired => StatusBadge(
        label: 'Expirado em $date',
        status: BadgeStatus.danger,
      ),
    };
  }
}
