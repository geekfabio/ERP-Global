import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../academic/data/models/schedule_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../academic/presentation/providers/assignment_providers.dart';
import '../../../academic/presentation/providers/schedule_providers.dart';
import '../../data/models/attendance_models.dart';
import '../../domain/attendance_repository.dart';
import '../../domain/attendance_rules.dart';
import '../pages/attendance_page.dart';
import '../providers/attendance_providers.dart';

/// Registo de presenças da turma: por dia (director de turma) ou por aula do
/// horário. Quem ainda não tem registo aparece como presente.
class AttendanceSheetTab extends ConsumerStatefulWidget {
  const AttendanceSheetTab({super.key, required this.option});

  final AttendanceOption option;

  @override
  ConsumerState<AttendanceSheetTab> createState() => _AttendanceSheetTabState();
}

class _AttendanceSheetTabState extends ConsumerState<AttendanceSheetTab> {
  late bool _daily = widget.option.canDaily && !widget.option.canLesson;
  late DateTime _date = _today();
  String? _slotId;
  final Map<String, AttendanceStatus> _edits = {};
  bool _saving = false;
  Map<String, String> _serverErrors = {};

  static DateTime _today() {
    final n = DateTime.now();
    return DateTime(n.year, n.month, n.day);
  }

  String get _classroomId => widget.option.classroom.id;

  void _reset() {
    _edits.clear();
    _serverErrors = {};
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(_date.year - 1),
      lastDate: _today(),
    );
    if (picked == null) return;
    setState(() {
      _date = picked;
      _slotId = null;
      _reset();
    });
  }

  Future<void> _save(
    AttendanceSheetKey key,
    AttendanceSheetModel sheet,
    List<String> studentIds,
  ) async {
    final existing = {for (final r in sheet.rows) r.studentId: r};
    final rows = [
      for (final id in studentIds)
        AttendanceRecordModel(
          classroomId: _classroomId,
          studentId: id,
          date: key.date,
          lessonSlotId: key.lessonSlotId,
          status:
              _edits[id] ?? existing[id]?.status ?? AttendanceStatus.present,
          justification: existing[id]?.justification,
        ),
    ];
    setState(() => _saving = true);
    final result = await ref.read(attendanceActionsProvider).save(key, rows);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        setState(_reset);
        ref.read(toastProvider.notifier).success('Presenças guardadas.');
      case Err(:final failure):
        if (failure is ValidationFailure) {
          setState(() => _serverErrors = failure.fields);
        }
        ref.read(toastProvider.notifier).error(failure.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final option = widget.option;
    final all = ref
        .watch(permissionServiceProvider)
        .canAny(attendanceRecordAllPermission);
    final subjects = {
      for (final s in ref.watch(subjectListProvider).value ?? const [])
        s.id: s.name,
    };
    final myTeacherId = ref.watch(myTeacherProvider).value?.id;
    final slots = [
      for (final s in ref.watch(scheduleListProvider).value ?? const [])
        if (s.classroomId == _classroomId &&
            s.weekday == _date.weekday &&
            (all || s.teacherId == myTeacherId))
          s,
    ]..sort((a, b) => a.startTime.compareTo(b.startTime));
    final slotId = slots.any((s) => s.id == _slotId) ? _slotId : null;
    final allowed = _daily ? option.canDaily : option.canLesson;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SegmentedButton<bool>(
              key: const Key('attendance_mode'),
              segments: const [
                ButtonSegment(value: false, label: Text('Por aula')),
                ButtonSegment(value: true, label: Text('Por dia')),
              ],
              selected: {_daily},
              onSelectionChanged: (v) => setState(() {
                _daily = v.first;
                _slotId = null;
                _reset();
              }),
            ),
            OutlinedButton.icon(
              key: const Key('attendance_date'),
              onPressed: _pickDate,
              icon: const Icon(Icons.calendar_today_outlined),
              label: Text(PtAoFormatters.date(_date)),
            ),
            if (!_daily)
              SizedBox(
                width: 280,
                child: DropdownButtonFormField<String>(
                  key: const Key('attendance_slot'),
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Aula'),
                  initialValue: slotId,
                  items: [
                    for (final ScheduleSlotModel s in slots)
                      DropdownMenuItem(
                        value: s.id,
                        child: Text(
                          '${s.startTime}–${s.endTime} · '
                          '${subjects[s.subjectId] ?? s.subjectId}',
                        ),
                      ),
                  ],
                  onChanged: (v) => setState(() {
                    _slotId = v;
                    _reset();
                  }),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: !allowed
              ? EmptyState(
                  title: _daily
                      ? 'Só o director de turma regista o dia'
                      : 'Sem aulas atribuídas nesta turma',
                )
              : !_daily && slotId == null
              ? EmptyState(
                  title: slots.isEmpty
                      ? 'Sem aulas neste dia'
                      : 'Escolha a aula',
                )
              : _grid(
                  AttendanceSheetKey(
                    classroomId: _classroomId,
                    date: attendanceDate(_date),
                    lessonSlotId: _daily ? null : slotId,
                  ),
                ),
        ),
      ],
    );
  }

  Widget _grid(AttendanceSheetKey key) {
    final sheetAsync = ref.watch(attendanceSheetProvider(key));
    final rosterAsync = ref.watch(attendanceRosterProvider(_classroomId));
    final failed = [
      sheetAsync,
      rosterAsync,
    ].where((a) => a.hasError).firstOrNull;
    if (failed != null) {
      return ErrorState(
        failure: failed.failure ?? UnknownFailure(cause: failed.error),
        onRetry: () => ref
          ..invalidate(attendanceSheetProvider(key))
          ..invalidate(attendanceRosterProvider(_classroomId)),
      );
    }
    if (!sheetAsync.hasValue || !rosterAsync.hasValue) {
      return const SkeletonList();
    }
    final sheet = sheetAsync.requireValue;
    final roster = rosterAsync.requireValue;
    if (roster.isEmpty) {
      return const EmptyState(title: 'Esta turma ainda não tem alunos');
    }
    final existing = {for (final r in sheet.rows) r.studentId: r};
    final flagged = {
      for (final a
          in ref.watch(attendanceAlertsProvider(_classroomId)).value ??
              const <AttendanceAlertModel>[])
        a.studentId,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Wrap(
            spacing: AppSpacing.md,
            children: [
              AppButton(
                label: 'Todos presentes',
                icon: Icons.done_all,
                variant: AppButtonVariant.secondary,
                onPressed: _saving
                    ? null
                    : () => setState(() {
                        for (final s in roster) {
                          _edits[s.id] = AttendanceStatus.present;
                        }
                      }),
              ),
              AppButton(
                label: 'Guardar presenças',
                icon: Icons.save_outlined,
                loading: _saving,
                onPressed: _saving
                    ? null
                    : () => _save(key, sheet, [for (final s in roster) s.id]),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Expanded(
          child: ListView.separated(
            itemCount: roster.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final s = roster[i];
              final record = existing[s.id];
              final status =
                  _edits[s.id] ?? record?.status ?? AttendanceStatus.present;
              final justified =
                  record != null && _edits[s.id] == null && isJustified(record);
              return ListTile(
                key: Key('attendance_row_${s.id}'),
                title: Text('${i + 1}. ${s.fullName}'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      SegmentedButton<AttendanceStatus>(
                        key: Key('attendance_status_${s.id}'),
                        showSelectedIcon: false,
                        segments: const [
                          ButtonSegment(
                            value: AttendanceStatus.present,
                            label: Text('Presente'),
                          ),
                          ButtonSegment(
                            value: AttendanceStatus.late,
                            label: Text('Atraso'),
                          ),
                          ButtonSegment(
                            value: AttendanceStatus.absent,
                            label: Text('Falta'),
                          ),
                        ],
                        selected: {status},
                        onSelectionChanged: _saving
                            ? null
                            : (v) => setState(() {
                                _edits[s.id] = v.first;
                                _serverErrors.remove(s.id);
                              }),
                      ),
                      if (justified)
                        const StatusBadge(
                          label: 'Justificada',
                          status: BadgeStatus.info,
                        ),
                      if (flagged.contains(s.id))
                        const StatusBadge(
                          label: 'Limite de faltas',
                          status: BadgeStatus.danger,
                        ),
                      if (_serverErrors[s.id] != null)
                        Text(
                          _serverErrors[s.id]!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
