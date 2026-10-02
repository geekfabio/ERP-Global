import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/audit/audit_providers.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/utils/seed_generator.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../../../core/widgets/feedback/toasts.dart';
import '../../../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../../../core/widgets/permissions/can.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../../../../data/models/student_occurrence_model.dart';
import '../../../providers/student_file_providers.dart';
import '../../../providers/student_providers.dart';
import '../student_labels.dart';

/// Separador 9 — Disciplina e ocorrências: elogios, advertências e incidentes.
class DisciplineTab extends ConsumerWidget {
  const DisciplineTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(studentOccurrencesProvider(student.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Can(
            permission: 'students.record.update',
            child: AppButton(
              label: 'Registar ocorrência',
              icon: Icons.add,
              onPressed: () => _add(context, ref),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AsyncValueView<List<StudentOccurrenceModel>>(
          value: items,
          onRetry: () => ref.invalidate(studentOccurrencesProvider(student.id)),
          isEmpty: (d) => d.isEmpty,
          loading: const SkeletonCard(),
          empty: const EmptyState(
            icon: Icons.gavel_outlined,
            title: 'Sem ocorrências',
            message: 'Não há elogios, advertências ou incidentes registados.',
          ),
          data: (list) => Column(
            children: [
              for (final o in list)
                _OccurrenceCard(
                  occurrence: o,
                  onRemove: () => _remove(context, ref, o),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final draft = await showDialog<StudentOccurrenceModel>(
      context: context,
      builder: (_) => _OccurrenceDialog(studentId: student.id),
    );
    if (draft == null) return;
    final repo = ref.read(occurrenceRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final actor = ref.read(auditActorProvider);
    final result = await repo.create(draft.copyWith(reportedBy: actor?.id));
    result.when(
      ok: (_) {
        toast.success('Ocorrência registada');
        container.invalidate(studentOccurrencesProvider(student.id));
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    StudentOccurrenceModel o,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Remover ocorrência',
      message: 'Remover "${o.title}" do registo disciplinar?',
      confirmLabel: 'Remover',
      destructive: true,
    );
    if (!ok) return;
    final repo = ref.read(occurrenceRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final result = await repo.delete(o.id);
    result.when(
      ok: (_) {
        toast.success('Ocorrência removida');
        container.invalidate(studentOccurrencesProvider(student.id));
      },
      err: (f) => toast.error(f.message),
    );
  }
}

BadgeStatus occurrenceBadge(OccurrenceType t) => switch (t) {
  OccurrenceType.praise => BadgeStatus.success,
  OccurrenceType.warning => BadgeStatus.warning,
  OccurrenceType.incident => BadgeStatus.danger,
};

class _OccurrenceCard extends StatelessWidget {
  const _OccurrenceCard({required this.occurrence, required this.onRemove});

  final StudentOccurrenceModel occurrence;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final o = occurrence;
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
                  Wrap(
                    spacing: AppSpacing.sm,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusBadge(
                        label: occurrenceTypeLabel(o.type),
                        status: occurrenceBadge(o.type),
                      ),
                      Text(PtAoFormatters.date(o.occurredOn)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(o.title, style: text.titleMedium),
                  if (o.description != null && o.description!.isNotEmpty)
                    Text(o.description!),
                ],
              ),
            ),
            Can(
              permission: 'students.record.update',
              child: AppIconButton(
                icon: Icons.delete_outline,
                tooltip: 'Remover ocorrência',
                onPressed: onRemove,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OccurrenceDialog extends StatefulWidget {
  const _OccurrenceDialog({required this.studentId});

  final String studentId;

  @override
  State<_OccurrenceDialog> createState() => _OccurrenceDialogState();
}

class _OccurrenceDialogState extends State<_OccurrenceDialog> {
  final _formKey = GlobalKey<FormState>();
  OccurrenceType _type = OccurrenceType.warning;
  DateTime _date = DateTime.now().toUtc();
  String _title = '';
  String? _description;

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final now = DateTime.now().toUtc();
    Navigator.of(context).pop(
      StudentOccurrenceModel(
        id: SeedGenerator(now.microsecondsSinceEpoch).ulid(now),
        institutionId: 'mock',
        createdAt: now,
        updatedAt: now,
        studentId: widget.studentId,
        type: _type,
        occurredOn: DateTime.utc(_date.year, _date.month, _date.day),
        title: _title.trim(),
        description: _description?.trim().isEmpty ?? true
            ? null
            : _description!.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Registar ocorrência'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<OccurrenceType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final t in OccurrenceType.values)
                    DropdownMenuItem(
                      value: t,
                      child: Text(occurrenceTypeLabel(t)),
                    ),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: AppSpacing.md),
              AppDateField(
                label: 'Data',
                value: _date,
                required: true,
                lastDate: DateTime.now(),
                onChanged: (d) => setState(() => _date = d),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Campo obrigatório' : null,
                onSaved: (v) => _title = v ?? '',
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Descrição'),
                maxLines: 3,
                onSaved: (v) => _description = v,
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Guardar')),
    ],
  );
}
