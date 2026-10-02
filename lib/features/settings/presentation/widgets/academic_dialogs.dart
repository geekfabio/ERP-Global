import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/json_converters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../data/models/academic_year_model.dart';
import '../../data/models/term_model.dart';
import '../../domain/academic_rules.dart';
import '../academic_strings.dart';
import '../providers/academic_providers.dart';
import '../providers/settings_providers.dart';

const _date = DateOnlyConverter();

/// Diálogo de criação de um ano lectivo (os períodos são repartidos pelas datas).
Future<void> showYearDialog(BuildContext context) =>
    showDialog<void>(context: context, builder: (_) => const _YearDialog());

/// Diálogo de edição das datas e do prazo de notas de um período.
Future<void> showTermDialog(
  BuildContext context,
  TermModel term,
  AcademicYearModel year,
) => showDialog<void>(
  context: context,
  builder: (_) => _TermDialog(term: term, year: year),
);

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: AppSpacing.md),
    child: Semantics(
      liveRegion: true,
      child: Text(
        message,
        style: TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    ),
  );
}

class _YearDialog extends ConsumerStatefulWidget {
  const _YearDialog();

  @override
  ConsumerState<_YearDialog> createState() => _YearDialogState();
}

class _YearDialogState extends ConsumerState<_YearDialog> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  String? _campusId;
  DateTime? _start;
  DateTime? _end;
  int _count = 3;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref.read(academicActionsProvider).createYear({
      'campusId': _campusId,
      'code': _code.text.trim(),
      'startDate': _date.toJson(_start!),
      'endDate': _date.toJson(_end!),
      'termCount': _count,
    });
    if (!mounted) return;
    result.when(
      ok: (_) {
        Navigator.pop(context);
        ref.read(toastProvider.notifier).success(AcademicStrings.yearCreated);
      },
      err: (f) => setState(() {
        _busy = false;
        _error = f.message;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campuses = ref.watch(campusesProvider).value ?? const [];
    _campusId ??= campuses.isEmpty ? null : campuses.first.id;
    return AlertDialog(
      title: const Text(AcademicStrings.newYear),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  key: const Key('year_campus'),
                  initialValue: _campusId,
                  decoration: const InputDecoration(
                    labelText: AcademicStrings.campus,
                  ),
                  items: [
                    for (final c in campuses)
                      DropdownMenuItem(value: c.id, child: Text(c.name)),
                  ],
                  onChanged: _busy ? null : (v) => _campusId = v,
                  validator: (v) => v == null ? 'Campo obrigatório' : null,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  label: AcademicStrings.code,
                  controller: _code,
                  enabled: !_busy,
                  validator: (v) => isValidAcademicYearCode((v ?? '').trim())
                      ? null
                      : 'Use o formato 2026/2027',
                ),
                const SizedBox(height: AppSpacing.lg),
                AppDateField(
                  label: AcademicStrings.startDate,
                  value: _start,
                  required: true,
                  enabled: !_busy,
                  onChanged: (d) => setState(() => _start = d),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppDateField(
                  label: AcademicStrings.endDate,
                  value: _end,
                  required: true,
                  enabled: !_busy,
                  onChanged: (d) => setState(() => _end = d),
                ),
                const SizedBox(height: AppSpacing.lg),
                DropdownButtonFormField<int>(
                  key: const Key('year_term_count'),
                  initialValue: _count,
                  decoration: const InputDecoration(
                    labelText: AcademicStrings.termCount,
                  ),
                  items: [
                    for (var n = minTermCount; n <= maxTermCount; n++)
                      DropdownMenuItem(
                        value: n,
                        child: Text(AcademicStrings.termsOf(n)),
                      ),
                  ],
                  onChanged: _busy ? null : (v) => _count = v ?? 3,
                ),
                if (_error != null) _ErrorText(_error!),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: const Text(AcademicStrings.cancel),
        ),
        FilledButton(
          key: const Key('year_save'),
          onPressed: _busy ? null : _save,
          child: const Text(AcademicStrings.create),
        ),
      ],
    );
  }
}

class _TermDialog extends ConsumerStatefulWidget {
  const _TermDialog({required this.term, required this.year});

  final TermModel term;
  final AcademicYearModel year;

  @override
  ConsumerState<_TermDialog> createState() => _TermDialogState();
}

class _TermDialogState extends ConsumerState<_TermDialog> {
  late DateTime _start = widget.term.startDate;
  late DateTime _end = widget.term.endDate;
  late DateTime _deadline = widget.term.gradesDeadline;
  bool _busy = false;
  String? _error;

  Future<void> _save() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final result = await ref
        .read(academicActionsProvider)
        .updateTerm(widget.term, {
          'startDate': _date.toJson(_start),
          'endDate': _date.toJson(_end),
          'gradesDeadline': _date.toJson(_deadline),
        });
    if (!mounted) return;
    result.when(
      ok: (_) {
        Navigator.pop(context);
        ref.read(toastProvider.notifier).success(AcademicStrings.saved);
      },
      err: (f) => setState(() {
        _busy = false;
        _error = f.message;
      }),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.term.name),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppDateField(
              label: AcademicStrings.startDate,
              value: _start,
              enabled: !_busy,
              firstDate: widget.year.startDate,
              lastDate: widget.year.endDate,
              onChanged: (d) => setState(() => _start = d),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDateField(
              label: AcademicStrings.endDate,
              value: _end,
              enabled: !_busy,
              firstDate: widget.year.startDate,
              lastDate: widget.year.endDate,
              onChanged: (d) => setState(() => _end = d),
            ),
            const SizedBox(height: AppSpacing.lg),
            AppDateField(
              label: AcademicStrings.gradesDeadline,
              value: _deadline,
              enabled: !_busy,
              firstDate: widget.year.startDate,
              lastDate: widget.year.endDate.add(const Duration(days: 366)),
              onChanged: (d) => setState(() => _deadline = d),
            ),
            if (_error != null) _ErrorText(_error!),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _busy ? null : () => Navigator.pop(context),
        child: const Text(AcademicStrings.cancel),
      ),
      FilledButton(
        key: const Key('term_save'),
        onPressed: _busy ? null : _save,
        child: const Text(AcademicStrings.save),
      ),
    ],
  );
}
