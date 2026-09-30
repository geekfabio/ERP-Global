import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/utils/seed_generator.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../../../core/widgets/feedback/toasts.dart';
import '../../../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../../../core/widgets/permissions/can.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/guardian_model.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../../../../domain/student_repositories.dart';
import '../../../providers/student_file_providers.dart';
import '../../../providers/student_providers.dart';

/// Nome apresentado do parentesco.
String relationshipLabel(GuardianRelationship r) => switch (r) {
  GuardianRelationship.father => 'Pai',
  GuardianRelationship.mother => 'Mãe',
  GuardianRelationship.tutor => 'Tutor',
  GuardianRelationship.grandparent => 'Avô/Avó',
  GuardianRelationship.sibling => 'Irmão/Irmã',
  GuardianRelationship.uncleAunt => 'Tio/Tia',
  GuardianRelationship.other => 'Outro',
};

/// Separador 2 — Encarregados: parentesco, responsável financeiro, contacto de
/// emergência e autorização de recolha. Cada vínculo é editado/removido à parte.
class GuardiansTab extends ConsumerWidget {
  const GuardiansTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guardians = ref.watch(studentGuardiansProvider(student.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Can(
            permission: 'students.record.update',
            child: AppButton(
              label: 'Associar encarregado',
              icon: Icons.person_add_alt_outlined,
              onPressed: () => _associate(context, ref, guardians.value ?? []),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AsyncValueView<List<StudentGuardian>>(
          value: guardians,
          onRetry: () => ref.invalidate(studentGuardiansProvider(student.id)),
          isEmpty: (d) => d.isEmpty,
          loading: const SkeletonCard(),
          empty: const EmptyState(
            icon: Icons.family_restroom_outlined,
            title: 'Sem encarregados',
            message: 'Este aluno ainda não tem encarregados associados.',
          ),
          data: (items) => Column(
            children: [
              for (final g in items)
                _GuardianCard(
                  item: g,
                  onEdit: () => _edit(context, ref, g),
                  onRemove: () => _remove(context, ref, g),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _run(
    WidgetRef ref,
    Future<Object?> Function() action,
    String okMessage,
  ) async {
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final failure = await action();
    if (failure is String) {
      toast.error(failure);
      return;
    }
    toast.success(okMessage);
    container.invalidate(studentGuardiansProvider(student.id));
  }

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    StudentGuardian item,
  ) async {
    final edited = await showDialog<GuardianLinkModel>(
      context: context,
      builder: (_) => _LinkDialog(
        title: 'Editar ${item.guardian.fullName}',
        initial: item.link,
      ),
    );
    if (edited == null) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.updateLink(edited)).failureOrNull?.message,
      'Encarregado actualizado',
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    StudentGuardian item,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Remover encarregado',
      message: 'Remover "${item.guardian.fullName}" desta ficha?',
      confirmLabel: 'Remover',
      destructive: true,
    );
    if (!ok) return;
    final repo = ref.read(guardianRepositoryProvider);
    await _run(
      ref,
      () async => (await repo.unlink(item.link.id)).failureOrNull?.message,
      'Encarregado removido',
    );
  }

  Future<void> _associate(
    BuildContext context,
    WidgetRef ref,
    List<StudentGuardian> current,
  ) async {
    final repo = ref.read(guardianRepositoryProvider);
    final linked = {for (final g in current) g.guardian.id};
    final page = await repo.list(pageSize: 100);
    final candidates = [
      for (final g in page.valueOrNull?.items ?? const <GuardianModel>[])
        if (!linked.contains(g.id)) g,
    ];
    if (!context.mounted) return;
    final link = await showDialog<GuardianLinkModel>(
      context: context,
      builder: (_) => _LinkDialog(
        title: 'Associar encarregado',
        studentId: student.id,
        candidates: candidates,
      ),
    );
    if (link == null) return;
    await _run(
      ref,
      () async => (await repo.link(link)).failureOrNull?.message,
      'Encarregado associado',
    );
  }
}

class _GuardianCard extends StatelessWidget {
  const _GuardianCard({
    required this.item,
    required this.onEdit,
    required this.onRemove,
  });

  final StudentGuardian item;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final g = item.guardian;
    final l = item.link;
    final text = Theme.of(context).textTheme;
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
                  Text(g.fullName, style: text.titleMedium),
                  Text(
                    '${relationshipLabel(l.relationship)} · ${g.phone}'
                    '${g.email == null ? '' : ' · ${g.email}'}',
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
                    tooltip: 'Editar encarregado',
                    onPressed: onEdit,
                  ),
                  AppIconButton(
                    icon: Icons.link_off_outlined,
                    tooltip: 'Remover encarregado',
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

/// Diálogo de vínculo: edita um [initial] ou cria um novo a partir de [candidates].
class _LinkDialog extends StatefulWidget {
  const _LinkDialog({
    required this.title,
    this.initial,
    this.studentId,
    this.candidates = const [],
  });

  final String title;
  final GuardianLinkModel? initial;
  final String? studentId;
  final List<GuardianModel> candidates;

  @override
  State<_LinkDialog> createState() => _LinkDialogState();
}

class _LinkDialogState extends State<_LinkDialog> {
  String? _guardianId;
  late GuardianRelationship _relationship =
      widget.initial?.relationship ?? GuardianRelationship.father;
  late bool _financial = widget.initial?.isFinancialResponsible ?? false;
  late bool _emergency = widget.initial?.isEmergency ?? false;
  late bool _pickup = widget.initial?.canPickup ?? false;

  bool get _creating => widget.initial == null;

  void _submit() {
    final now = DateTime.now().toUtc();
    final base =
        widget.initial ??
        GuardianLinkModel(
          id: SeedGenerator(now.microsecondsSinceEpoch).ulid(now),
          institutionId: 'mock',
          createdAt: now,
          updatedAt: now,
          studentId: widget.studentId!,
          guardianId: _guardianId!,
          relationship: _relationship,
        );
    Navigator.of(context).pop(
      base.copyWith(
        relationship: _relationship,
        isFinancialResponsible: _financial,
        isEmergency: _emergency,
        canPickup: _pickup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_creating) ...[
              AppSearchableSelect<String>(
                label: 'Encarregado',
                value: _guardianId,
                options: {
                  for (final g in widget.candidates)
                    g.id: '${g.fullName} · ${g.phone}',
                },
                onSelected: (v) => setState(() => _guardianId = v),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            DropdownButtonFormField<GuardianRelationship>(
              initialValue: _relationship,
              decoration: const InputDecoration(labelText: 'Parentesco'),
              items: [
                for (final r in GuardianRelationship.values)
                  DropdownMenuItem(value: r, child: Text(relationshipLabel(r))),
              ],
              onChanged: (v) =>
                  setState(() => _relationship = v ?? _relationship),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Responsável financeiro'),
              value: _financial,
              onChanged: (v) => setState(() => _financial = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Contacto de emergência'),
              value: _emergency,
              onChanged: (v) => setState(() => _emergency = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Autorizado a recolher'),
              value: _pickup,
              onChanged: (v) => setState(() => _pickup = v),
            ),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: _creating && _guardianId == null ? null : _submit,
        child: const Text('Guardar'),
      ),
    ],
  );
}
