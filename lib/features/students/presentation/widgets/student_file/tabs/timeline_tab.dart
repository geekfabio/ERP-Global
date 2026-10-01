import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/audit/audit_log_model.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../data/models/student_model.dart';
import '../../../providers/student_file_providers.dart';

String auditActionLabel(AuditAction a) => switch (a) {
  AuditAction.create => 'Criado',
  AuditAction.update => 'Alterado',
  AuditAction.delete => 'Removido',
  AuditAction.approve => 'Aprovado',
  AuditAction.reopen => 'Reaberto',
  AuditAction.cancel => 'Anulado',
  AuditAction.other => 'Outra acção',
};

/// Campos que mudaram entre `before` e `after` (só os nomes, nunca os valores,
/// para não expor dados sensíveis na linha temporal).
List<String> changedFields(AuditLogModel l) {
  final before = l.before ?? const <String, dynamic>{};
  final after = l.after ?? const <String, dynamic>{};
  return [
    for (final k in {...before.keys, ...after.keys})
      if (before[k] != after[k]) k,
  ]..sort();
}

/// Separador 12 — Histórico/Auditoria: linha temporal do que mudou na ficha.
class TimelineTab extends ConsumerWidget {
  const TimelineTab({super.key, required this.student});

  final StudentModel student;

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      AsyncValueView<List<AuditLogModel>>(
        value: ref.watch(studentTimelineProvider(student.id)),
        onRetry: () => ref.invalidate(studentTimelineProvider(student.id)),
        isEmpty: (d) => d.isEmpty,
        loading: const SkeletonCard(),
        empty: const EmptyState(
          icon: Icons.history_outlined,
          title: 'Sem histórico',
          message: 'Ainda não há alterações registadas nesta ficha.',
        ),
        data: (logs) => Column(
          children: [
            for (final l in logs)
              Card(
                child: ListTile(
                  key: Key('timeline_${l.id}'),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                  ),
                  leading: const Icon(Icons.history_outlined),
                  title: Text(
                    '${auditActionLabel(l.action)} por ${l.actorName}',
                  ),
                  subtitle: Text(
                    [
                      PtAoFormatters.dateTime(l.createdAt),
                      if (changedFields(l).isNotEmpty)
                        'Campos: ${changedFields(l).join(', ')}',
                    ].join(' · '),
                  ),
                ),
              ),
          ],
        ),
      );
}
