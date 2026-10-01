import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../students/data/models/student_model.dart';
import '../../data/models/grade_sheet_models.dart';
import '../../domain/assessment_engine.dart';
import '../../domain/grade_entry_repository.dart';
import '../providers/grades_providers.dart';

/// Converte o texto de uma célula. Vazio = sem nota; vírgula decimal aceite.
({double? value, String? error}) parseGradeInput(String text, int scaleMax) {
  final raw = text.trim().replaceAll(',', '.');
  if (raw.isEmpty) return (value: null, error: null);
  final v = double.tryParse(raw);
  if (v == null || v.isNaN || v < 0 || v > scaleMax) {
    return (value: null, error: 'Nota entre 0 e $scaleMax');
  }
  return (value: v, error: null);
}

String formatGrade(double v) => v == v.roundToDouble()
    ? v.toInt().toString()
    : v.toString().replaceAll('.', ',');

/// Grelha editável turma × disciplina × trimestre: validação de intervalo,
/// `MT` calculada pelo motor de médias, bloqueio por prazo/fecho e edição
/// bloqueada só com `approve` + justificação (auditada).
class GradeGrid extends ConsumerStatefulWidget {
  const GradeGrid({super.key, required this.sheetKey});

  final GradeSheetKey sheetKey;

  @override
  ConsumerState<GradeGrid> createState() => _GradeGridState();
}

class _GradeGridState extends ConsumerState<GradeGrid> {
  /// `aluno → componente → texto` apenas das células tocadas.
  final Map<String, Map<String, String>> _edits = {};
  Map<String, String> _serverErrors = {};
  bool _saving = false;

  GradeSheetKey get _key => widget.sheetKey;

  String _text(GradeSheetModel sheet, String studentId, String code) {
    final edited = _edits[studentId]?[code];
    if (edited != null) return edited;
    final v = sheet.rows
        .where((r) => r.studentId == studentId)
        .firstOrNull
        ?.scores[code];
    return v == null ? '' : formatGrade(v);
  }

  String? _error(GradeSheetModel sheet, String studentId, String code) =>
      parseGradeInput(
        _text(sheet, studentId, code),
        sheet.scheme.scaleMax,
      ).error ??
      _serverErrors['$studentId.$code'];

  List<GradeRowModel> _changedRows(GradeSheetModel sheet) => [
    for (final e in _edits.entries)
      GradeRowModel(
        studentId: e.key,
        scores: {
          for (final c in sheet.scheme.components)
            c.code: ?parseGradeInput(
              _text(sheet, e.key, c.code),
              sheet.scheme.scaleMax,
            ).value,
        },
      ),
  ];

  bool _hasLocalErrors(GradeSheetModel sheet) => _edits.entries.any(
    (e) => sheet.scheme.components.any(
      (c) =>
          parseGradeInput(
            _text(sheet, e.key, c.code),
            sheet.scheme.scaleMax,
          ).error !=
          null,
    ),
  );

  Future<String?> _askJustification() => showDialog<String>(
    context: context,
    builder: (context) => const _JustificationDialog(),
  );

  Future<void> _save(GradeSheetModel sheet) async {
    String? justification;
    if (sheet.locked) {
      justification = await _askJustification();
      if (justification == null || !mounted) return;
    }
    setState(() {
      _saving = true;
      _serverErrors = {};
    });
    final result = await ref
        .read(gradeEntryActionsProvider)
        .save(_key, sheet, _changedRows(sheet), justification: justification);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        setState(_edits.clear);
        ref.read(toastProvider.notifier).success('Notas guardadas.');
      case Err(:final failure):
        if (failure is ValidationFailure) {
          setState(() => _serverErrors = failure.fields);
        }
        ref.read(toastProvider.notifier).error(failure.message);
    }
  }

  Future<void> _showHistory(Map<String, StudentModel> students) =>
      showAppDialog<void>(
        context: context,
        title: 'Histórico de alterações',
        content: SizedBox(
          width: 560,
          child: _History(sheetKey: _key, students: students),
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Fechar'),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final sheetAsync = ref.watch(gradeSheetProvider(_key));
    final rosterAsync = ref.watch(classroomRosterProvider(_key.classroomId));
    final failed = [
      sheetAsync,
      rosterAsync,
    ].where((a) => a.hasError).firstOrNull;
    if (failed != null) {
      return ErrorState(
        failure: failed.failure ?? UnknownFailure(cause: failed.error),
        onRetry: () {
          ref
            ..invalidate(gradeSheetProvider(_key))
            ..invalidate(classroomRosterProvider(_key.classroomId));
        },
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

    final permissions = ref.watch(permissionServiceProvider);
    final approver = permissions.canAny(gradeEntryApprovePermission);
    final editable = sheet.locked
        ? approver
        : (permissions.canAny(gradeEntryWritePermission) || approver);
    final engine = AssessmentEngine(sheet.scheme);
    final theme = Theme.of(context);
    final canSave =
        editable && !_saving && _edits.isNotEmpty && !_hasLocalErrors(sheet);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              if (sheet.termClosed)
                const StatusBadge(
                  label: 'Trimestre fechado',
                  status: BadgeStatus.danger,
                )
              else if (sheet.deadlinePassed)
                const StatusBadge(
                  label: 'Prazo de lançamento terminado',
                  status: BadgeStatus.danger,
                )
              else
                const StatusBadge(label: 'Aberto', status: BadgeStatus.success),
              if (sheet.deadline != null)
                Text(
                  'Prazo: ${PtAoFormatters.date(DateTime.parse(sheet.deadline!))}',
                  style: theme.textTheme.bodySmall,
                ),
              if (sheet.locked)
                Text(
                  editable
                      ? 'Alterações exigem justificação e ficam em auditoria.'
                      : 'Só leitura: peça a aprovação da coordenação.',
                  key: const Key('grade_lock_hint'),
                  style: theme.textTheme.bodySmall,
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                label: 'Histórico',
                icon: Icons.history,
                variant: AppButtonVariant.secondary,
                onPressed: () =>
                    _showHistory({for (final s in roster) s.id: s}),
              ),
              if (editable)
                AppButton(
                  label: 'Guardar notas',
                  icon: Icons.save_outlined,
                  loading: _saving,
                  onPressed: canSave ? () => _save(sheet) : null,
                ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  const DataColumn(label: Text('N.º')),
                  const DataColumn(label: Text('Aluno')),
                  for (final c in sheet.scheme.components)
                    DataColumn(label: Text('${c.code} (${c.weight}%)')),
                  const DataColumn(label: Text('MT')),
                ],
                rows: [
                  for (final (i, s) in roster.indexed)
                    DataRow(
                      cells: [
                        DataCell(Text('${i + 1}')),
                        DataCell(Text(s.fullName)),
                        for (final c in sheet.scheme.components)
                          DataCell(
                            SizedBox(
                              width: 88,
                              child: TextFormField(
                                key: Key('grade_${s.id}_${c.code}'),
                                // O texto muda com a folha/edições; recria o campo.
                                initialValue: _text(sheet, s.id, c.code),
                                enabled: editable && !_saving,
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                decoration: InputDecoration(
                                  isDense: true,
                                  errorText: _error(sheet, s.id, c.code),
                                  errorMaxLines: 2,
                                ),
                                onChanged: (v) => setState(() {
                                  (_edits[s.id] ??= {})[c.code] = v;
                                  _serverErrors.remove('${s.id}.${c.code}');
                                }),
                              ),
                            ),
                          ),
                        DataCell(
                          Text(
                            _termAverage(engine, sheet, s.id),
                            key: Key('mt_${s.id}'),
                            style: theme.textTheme.titleSmall,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// `MT` ao vivo; "—" enquanto faltar algum componente ou houver erro.
  String _termAverage(
    AssessmentEngine engine,
    GradeSheetModel sheet,
    String studentId,
  ) {
    final grades = <String, double?>{};
    for (final c in sheet.scheme.components) {
      final parsed = parseGradeInput(
        _text(sheet, studentId, c.code),
        sheet.scheme.scaleMax,
      );
      if (parsed.error != null) return '—';
      grades[c.code] = parsed.value;
    }
    final mt = engine.termAverage(grades);
    return mt == null ? '—' : formatGrade(mt);
  }
}

class _History extends ConsumerWidget {
  const _History({required this.sheetKey, required this.students});

  final GradeSheetKey sheetKey;
  final Map<String, StudentModel> students;

  @override
  Widget build(BuildContext context, WidgetRef ref) => AsyncValueView(
    value: ref.watch(gradeChangesProvider(sheetKey)),
    isEmpty: (rows) => rows.isEmpty,
    loading: const SizedBox(height: 160, child: SkeletonList(itemCount: 3)),
    empty: const SizedBox(
      height: 160,
      child: EmptyState(title: 'Sem alterações registadas'),
    ),
    onRetry: () => ref.invalidate(gradeChangesProvider(sheetKey)),
    data: (rows) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in rows)
          ListTile(
            dense: true,
            title: Text(
              '${students[c.studentId]?.fullName ?? c.studentId} · ${c.componentCode}: '
              '${c.before == null ? '—' : formatGrade(c.before!)} → '
              '${c.after == null ? '—' : formatGrade(c.after!)}',
            ),
            subtitle: Text(
              [
                PtAoFormatters.dateTime(c.changedAt.toLocal()),
                if (c.afterLock) 'Folha bloqueada',
                if (c.justification != null) c.justification!,
              ].join(' · '),
            ),
          ),
      ],
    ),
  );
}

/// Pede a justificação (obrigatória) de uma alteração com a folha bloqueada.
class _JustificationDialog extends StatefulWidget {
  const _JustificationDialog();

  @override
  State<_JustificationDialog> createState() => _JustificationDialogState();
}

class _JustificationDialogState extends State<_JustificationDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Alterar notas com a folha bloqueada'),
    content: SizedBox(
      width: 420,
      child: TextField(
        key: const Key('justification_field'),
        controller: _controller,
        autofocus: true,
        maxLines: 3,
        decoration: const InputDecoration(
          labelText: 'Justificação',
          helperText: 'Obrigatória; fica registada na auditoria.',
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        key: const Key('justification_confirm'),
        onPressed: () {
          final text = _controller.text.trim();
          if (text.isNotEmpty) Navigator.of(context).pop(text);
        },
        child: const Text('Confirmar'),
      ),
    ],
  );
}
