import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/attendance_models.dart';
import '../providers/attendance_providers.dart';

/// Faltas ainda sem justificação (secretaria/coordenação).
class AttendanceJustifyTab extends ConsumerWidget {
  const AttendanceJustifyTab({super.key, required this.classroomId});

  final String classroomId;

  Future<void> _justify(
    BuildContext context,
    WidgetRef ref,
    AttendanceRecordModel record,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => const _ReasonDialog(),
    );
    if (reason == null) return;
    final result = await ref
        .read(attendanceActionsProvider)
        .justify(record, reason);
    final toast = ref.read(toastProvider.notifier);
    switch (result) {
      case Ok():
        toast.success('Falta justificada.');
      case Err(:final failure):
        toast.error(failure.message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final names = {
      for (final s
          in ref.watch(attendanceRosterProvider(classroomId)).value ?? const [])
        s.id: s.fullName,
    };
    return AsyncValueView<List<AttendanceRecordModel>>(
      value: ref.watch(unjustifiedAbsencesProvider(classroomId)),
      onRetry: () => ref.invalidate(unjustifiedAbsencesProvider(classroomId)),
      isEmpty: (d) => d.isEmpty,
      empty: const EmptyState(
        icon: Icons.fact_check_outlined,
        title: 'Sem faltas por justificar',
      ),
      data: (records) => ListView(
        children: [
          for (final r in records)
            ListTile(
              key: Key('attendance_absence_${r.id}'),
              title: Text(names[r.studentId] ?? r.studentId),
              subtitle: Text(
                PtAoFormatters.date(DateTime.parse(r.date)) +
                    (r.lessonSlotId == null ? ' · dia' : ' · aula'),
              ),
              trailing: TextButton(
                key: Key('attendance_justify_${r.id}'),
                onPressed: () => _justify(context, ref, r),
                child: const Text('Justificar'),
              ),
            ),
        ],
      ),
    );
  }
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog();

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Justificar falta'),
    content: SizedBox(
      width: 400,
      child: TextField(
        key: const Key('attendance_reason'),
        controller: _controller,
        autofocus: true,
        maxLines: 2,
        decoration: const InputDecoration(labelText: 'Motivo'),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('attendance_reason_confirm'),
        onPressed: () {
          final text = _controller.text.trim();
          if (text.isNotEmpty) Navigator.of(context).pop(text);
        },
        child: const Text('Confirmar'),
      ),
    ],
  );
}
