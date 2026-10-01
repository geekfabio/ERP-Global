import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/attendance_models.dart';
import '../providers/attendance_providers.dart';

/// Alunos da turma que atingiram o limite de faltas injustificadas; quem tem
/// permissão configura o limite.
class AttendanceAlertsTab extends ConsumerStatefulWidget {
  const AttendanceAlertsTab({
    super.key,
    required this.classroomId,
    required this.canConfigure,
  });

  final String classroomId;
  final bool canConfigure;

  @override
  ConsumerState<AttendanceAlertsTab> createState() =>
      _AttendanceAlertsTabState();
}

class _AttendanceAlertsTabState extends ConsumerState<AttendanceAlertsTab> {
  final _limit = TextEditingController();
  String? _limitError;
  bool _saving = false;

  @override
  void dispose() {
    _limit.dispose();
    super.dispose();
  }

  Future<void> _saveLimit() async {
    final value = int.tryParse(_limit.text.trim());
    if (value == null || value < 1 || value > 100) {
      setState(() => _limitError = 'Limite entre 1 e 100');
      return;
    }
    setState(() {
      _limitError = null;
      _saving = true;
    });
    final result = await ref.read(attendanceActionsProvider).updateLimit(value);
    if (!mounted) return;
    setState(() => _saving = false);
    final toast = ref.read(toastProvider.notifier);
    switch (result) {
      case Ok():
        toast.success('Limite actualizado.');
      case Err(:final failure):
        toast.error(failure.message);
    }
  }

  Future<void> _notify(AttendanceAlertModel alert) async {
    final sent = await ref
        .read(attendanceActionsProvider)
        .notifyGuardian(alert);
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    if (sent) {
      toast.success('Encarregado avisado.');
    } else {
      toast.error('Não foi possível avisar (módulo Comunicação inactivo).');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(attendanceSettingsProvider);
    final limit = settings.value?.absenceLimit;
    if (limit != null && _limit.text.isEmpty) _limit.text = '$limit';
    final names = {
      for (final s
          in ref.watch(attendanceRosterProvider(widget.classroomId)).value ??
              const [])
        s.id: s.fullName,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.canConfigure)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Wrap(
              spacing: AppSpacing.md,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                SizedBox(
                  width: 260,
                  child: TextField(
                    key: const Key('attendance_limit'),
                    controller: _limit,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Limite de faltas injustificadas',
                      errorText: _limitError,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: FilledButton(
                    key: const Key('attendance_limit_save'),
                    onPressed: _saving ? null : _saveLimit,
                    child: const Text('Guardar'),
                  ),
                ),
              ],
            ),
          )
        else if (limit != null)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Text('Limite de faltas injustificadas: $limit'),
          ),
        Expanded(
          child: AsyncValueView<List<AttendanceAlertModel>>(
            value: ref.watch(attendanceAlertsProvider(widget.classroomId)),
            onRetry: () =>
                ref.invalidate(attendanceAlertsProvider(widget.classroomId)),
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.verified_outlined,
              title: 'Sem alertas',
              message: 'Nenhum aluno atingiu o limite de faltas.',
            ),
            data: (alerts) => ListView(
              children: [
                for (final a in alerts)
                  ListTile(
                    key: Key('attendance_alert_${a.studentId}'),
                    title: Text(names[a.studentId] ?? a.studentId),
                    subtitle: Text(
                      '${a.unjustified} faltas injustificadas '
                      '(limite ${a.limit})',
                    ),
                    leading: const StatusBadge(
                      label: 'Alerta',
                      status: BadgeStatus.danger,
                    ),
                    trailing: IconButton(
                      key: Key('attendance_notify_${a.studentId}'),
                      tooltip: 'Avisar encarregado',
                      icon: const Icon(Icons.notifications_active_outlined),
                      onPressed: () => _notify(a),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
