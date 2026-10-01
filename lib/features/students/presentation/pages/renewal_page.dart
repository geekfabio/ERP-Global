import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../domain/renewal_rules.dart';
import '../providers/enrollment_flow_providers.dart';
import '../providers/renewal_providers.dart';
import '../widgets/student_file/student_labels.dart';
import 'enrollment_flow_page.dart' show enrollmentUpdatePermission;

/// Renovação de matrícula em massa, por turma: pré-visualização com o
/// resultado final de cada aluno, decisão editável (classe seguinte / repete /
/// não renovar) e confirmação antes de aplicar.
class RenewalPage extends ConsumerStatefulWidget {
  const RenewalPage({super.key});

  @override
  ConsumerState<RenewalPage> createState() => _RenewalPageState();
}

class _RenewalPageState extends ConsumerState<RenewalPage> {
  String? _sourceYear;
  String? _targetYear;
  int _gradeIndex = 1;
  int _letterIndex = 0;
  bool _loading = false;
  bool _applying = false;
  Failure? _error;
  RenewalPreview? _preview;
  List<RenewalRow> _rows = const [];

  String get _classroomId => MockRef.classroomId(_gradeIndex, _letterIndex);

  Future<void> _load() async {
    final source = _sourceYear;
    final target = _targetYear;
    if (source == null || target == null) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(renewalRepositoryProvider)
        .preview(
          sourceYearId: source,
          targetYearId: target,
          classroomId: _classroomId,
        );
    if (!mounted) return;
    setState(() {
      _loading = false;
      result.when(
        ok: (p) {
          _preview = p;
          _rows = p.rows;
        },
        err: (f) {
          _preview = null;
          _rows = const [];
          _error = f;
        },
      );
    });
  }

  void _setAction(int i, RenewalAction action) {
    final order = _preview?.gradeOrder ?? const <String>[];
    setState(() {
      _rows = [
        for (var k = 0; k < _rows.length; k++)
          if (k == i) _rows[k].withAction(action, order) else _rows[k],
      ];
    });
  }

  Future<void> _apply() async {
    final source = _sourceYear;
    final target = _targetYear;
    if (source == null || target == null) return;
    final summary = RenewalSummary.of(_rows);
    final ok = await showConfirmDialog(
      context: context,
      title: 'Aplicar renovação',
      message:
          '${summary.promote} aluno(s) passam à classe seguinte e '
          '${summary.repeat} repetem a classe. '
          '${summary.skipped} ficam de fora. '
          'As matrículas de origem serão concluídas. Confirmar?',
      confirmLabel: 'Aplicar',
    );
    if (!ok || !mounted) return;
    final items = [
      for (final r in _rows)
        if (r.willRenew)
          RenewalItem(
            enrollmentId: r.enrollment.id,
            action: r.action,
            gradeId: r.targetGradeId!,
          ),
    ];
    final toast = ref.read(toastProvider.notifier);
    final audit = ref.read(auditServiceProvider);
    final container = ref.container;
    setState(() => _applying = true);
    final result = await ref
        .read(renewalRepositoryProvider)
        .apply(sourceYearId: source, targetYearId: target, items: items);
    if (!mounted) return;
    setState(() => _applying = false);
    await result.when(
      ok: (outcome) async {
        toast.success(
          '${outcome.created.length} matrícula(s) renovada(s)'
          '${outcome.skipped.isEmpty ? '' : ', ${outcome.skipped.length} ignorada(s)'}',
        );
        unawaited(
          audit.record(
            entity: 'enrollment_renewal',
            action: AuditAction.create,
            entityId: _classroomId,
            after: {
              'sourceYearId': source,
              'targetYearId': target,
              'classroomId': _classroomId,
              'created': outcome.created.length,
              'promoted': summary.promote,
              'repeated': summary.repeat,
              'skipped': outcome.skipped.length,
            },
          ),
        );
        container.invalidate(enrollmentQueueProvider);
        await _load();
      },
      err: (f) async => toast.error(f.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final years = ref.watch(renewalYearsProvider);
    years.whenData((list) {
      if (_sourceYear == null && list.isNotEmpty) {
        final active = list.where((y) => y.status == 'active').firstOrNull;
        final planned = list.where((y) => y.status == 'planned').firstOrNull;
        _sourceYear = (active ?? list.first).id;
        _targetYear = (planned ?? list.last).id;
      }
    });
    final text = Theme.of(context).textTheme;
    final summary = RenewalSummary.of(_rows);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Renovação em massa', style: text.headlineSmall),
            const SizedBox(height: AppSpacing.md),
            years.when(
              skipLoadingOnReload: true,
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Row(
                children: [
                  const Flexible(
                    child: Text('Não foi possível carregar os anos lectivos.'),
                  ),
                  TextButton(
                    onPressed: () => ref.invalidate(renewalYearsProvider),
                    child: const Text('Tentar de novo'),
                  ),
                ],
              ),
              data: _filters,
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(child: _body(summary)),
          ],
        ),
      ),
    );
  }

  Widget _filters(List<RenewalYear> years) => Wrap(
    spacing: AppSpacing.md,
    runSpacing: AppSpacing.md,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      _drop<String>(
        key: 'renewal_source',
        label: 'Ano de origem',
        value: _sourceYear,
        items: {for (final y in years) y.id: y.code},
        onChanged: (v) => setState(() => _sourceYear = v),
      ),
      _drop<String>(
        key: 'renewal_target',
        label: 'Ano de destino',
        value: _targetYear,
        items: {for (final y in years) y.id: y.code},
        onChanged: (v) => setState(() => _targetYear = v),
      ),
      _drop<int>(
        key: 'renewal_grade',
        label: 'Classe',
        value: _gradeIndex,
        items: {
          for (var i = 0; i < MockRef.gradeCount; i++) i: MockRef.gradeLabel(i),
        },
        onChanged: (v) => setState(() => _gradeIndex = v ?? _gradeIndex),
      ),
      _drop<int>(
        key: 'renewal_room',
        label: 'Turma',
        value: _letterIndex,
        items: {
          for (var l = 0; l < MockRef.classroomLetters.length; l++)
            l: 'Turma ${MockRef.classroomLetters[l]}',
        },
        onChanged: (v) => setState(() => _letterIndex = v ?? _letterIndex),
      ),
      AppButton(
        key: const Key('renewal_preview'),
        label: 'Pré-visualizar',
        icon: Icons.visibility_outlined,
        loading: _loading,
        onPressed: _loading ? null : _load,
      ),
    ],
  );

  Widget _drop<T>({
    required String key,
    required String label,
    required T? value,
    required Map<T, String> items,
    required ValueChanged<T?> onChanged,
  }) => SizedBox(
    width: 180,
    child: DropdownButtonFormField<T>(
      key: Key(key),
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (final e in items.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: onChanged,
    ),
  );

  Widget _body(RenewalSummary summary) {
    if (_error != null) {
      return ErrorState(failure: _error!, onRetry: _load);
    }
    if (_preview == null) {
      return const EmptyState(
        icon: Icons.upgrade_outlined,
        title: 'Escolha a turma',
        message: 'Seleccione os anos e a turma e pré-visualize a renovação.',
      );
    }
    if (_rows.isEmpty) {
      return const EmptyState(
        icon: Icons.groups_outlined,
        title: 'Sem alunos',
        message: 'A turma não tem matrículas confirmadas neste ano.',
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            StatusBadge(
              key: const Key('renewal_sum_promote'),
              label: 'Classe seguinte: ${summary.promote}',
              status: BadgeStatus.success,
            ),
            StatusBadge(
              key: const Key('renewal_sum_repeat'),
              label: 'Repetem: ${summary.repeat}',
              status: BadgeStatus.warning,
            ),
            StatusBadge(
              key: const Key('renewal_sum_skip'),
              label: 'De fora: ${summary.skipped}',
              status: BadgeStatus.neutral,
            ),
            Can(
              permission: enrollmentUpdatePermission,
              child: AppButton(
                key: const Key('renewal_apply'),
                label: 'Aplicar',
                icon: Icons.check,
                loading: _applying,
                onPressed: _applying || summary.total == 0 ? null : _apply,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: ListView.separated(
            itemCount: _rows.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (_, i) => _row(i, _rows[i]),
          ),
        ),
      ],
    );
  }

  Widget _row(int i, RenewalRow r) {
    final text = Theme.of(context).textTheme;
    final target = r.targetGradeId;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.sm,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SizedBox(
              width: 260,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.studentName, style: text.titleSmall),
                  Text(
                    'Processo ${r.processNumber} · '
                    '${gradeLabelFor(r.enrollment.gradeId)}',
                  ),
                ],
              ),
            ),
            StatusBadge(
              label: renewalResultLabel(r.result),
              status: switch (r.result) {
                'approved' || 'transitsWithDeficiency' => BadgeStatus.success,
                'failed' => BadgeStatus.danger,
                'recourse' => BadgeStatus.warning,
                _ => BadgeStatus.neutral,
              },
            ),
            if (r.alreadyRenewed)
              const StatusBadge(label: 'Já renovado', status: BadgeStatus.info)
            else
              SizedBox(
                width: 200,
                child: DropdownButton<RenewalAction>(
                  key: Key('renewal_action_$i'),
                  isExpanded: true,
                  value: r.action,
                  items: [
                    for (final a in RenewalAction.values)
                      DropdownMenuItem(
                        value: a,
                        child: Text(renewalActionLabel(a)),
                      ),
                  ],
                  onChanged: (a) {
                    if (a != null) _setAction(i, a);
                  },
                ),
              ),
            if (!r.alreadyRenewed &&
                r.action == RenewalAction.promote &&
                target == null)
              const Text('Sem classe seguinte'),
            if (target != null) Text('Destino: ${gradeLabelFor(target)}'),
          ],
        ),
      ),
    );
  }
}
