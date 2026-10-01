import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/export/export_contract.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/export_button.dart';
import '../../../academic/data/models/classroom_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../data/models/council_models.dart';
import '../../domain/council_repository.dart';
import '../../domain/grade_entry_repository.dart';
import '../../domain/pauta.dart';
import '../providers/pauta_providers.dart';
import '../widgets/pauta_view.dart';

/// Pautas por turma (trimestrais e final) com resultados e conselho de turma.
class PautaPage extends ConsumerStatefulWidget {
  const PautaPage({super.key});

  @override
  ConsumerState<PautaPage> createState() => _PautaPageState();
}

class _PautaPageState extends ConsumerState<PautaPage> {
  String? _classroomId;

  /// `null` = pauta final.
  int? _termIndex;

  @override
  Widget build(BuildContext context) {
    final classrooms = ref.watch(classroomListProvider);
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            children: [
              Text(
                'Pautas e resultado final',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.md),
              classrooms.when(
                skipLoadingOnReload: true,
                loading: () => const SkeletonList(),
                error: (e, _) => ErrorState(
                  failure: classrooms.failure ?? UnknownFailure(cause: e),
                  onRetry: () => ref.invalidate(classroomListProvider),
                ),
                data: (list) => list.isEmpty
                    ? const EmptyState(title: 'Sem turmas')
                    : _body(list, gradeNames),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _body(List<ClassroomModel> classrooms, Map<String, String> names) {
    final current = classrooms.where((c) => c.id == _classroomId).firstOrNull;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 300,
          child: DropdownButtonFormField<String>(
            key: const Key('pauta_classroom'),
            decoration: const InputDecoration(labelText: 'Turma'),
            initialValue: current?.id,
            items: [
              for (final c in classrooms)
                DropdownMenuItem(
                  value: c.id,
                  child: Text('${names[c.gradeId] ?? ''} · ${c.name}'),
                ),
            ],
            onChanged: (v) => setState(() {
              _classroomId = v;
              _termIndex = null;
            }),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        if (current == null)
          const EmptyState(title: 'Escolha a turma')
        else
          _PautaBody(
            key: ValueKey(current.id),
            classroom: current,
            termIndex: _termIndex,
            onScope: (i) => setState(() => _termIndex = i),
          ),
      ],
    );
  }
}

class _PautaBody extends ConsumerStatefulWidget {
  const _PautaBody({
    super.key,
    required this.classroom,
    required this.termIndex,
    required this.onScope,
  });

  final ClassroomModel classroom;
  final int? termIndex;
  final ValueChanged<int?> onScope;

  @override
  ConsumerState<_PautaBody> createState() => _PautaBodyState();
}

class _PautaBodyState extends ConsumerState<_PautaBody> {
  bool _busy = false;

  CouncilKey get _key => (
    classroomId: widget.classroom.id,
    yearId: widget.classroom.academicYearId,
  );

  Future<void> _run(
    Future<Result<Object?>> Function() action,
    String success,
  ) async {
    setState(() => _busy = true);
    final result = await action();
    if (!mounted) return;
    setState(() => _busy = false);
    final toast = ref.read(toastProvider.notifier);
    switch (result) {
      case Ok():
        toast.success(success);
      case Err(:final failure):
        toast.error(
          failure is ValidationFailure && failure.fields.isNotEmpty
              ? failure.fields.values.first
              : failure.message,
        );
    }
  }

  Future<void> _decide(PautaRow row) async {
    final justification = TextEditingController(
      text: row.decision?.justification ?? '',
    );
    var result = row.result == FinalResult.pending
        ? FinalResult.approved
        : row.result;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setLocal) => AlertDialog(
          title: Text('Decisão do conselho · ${row.student.name}'),
          content: SizedBox(
            width: 440,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<FinalResult>(
                  key: const Key('council_result'),
                  decoration: const InputDecoration(labelText: 'Resultado'),
                  initialValue: result,
                  items: [
                    for (final r in FinalResult.values)
                      if (r != FinalResult.pending)
                        DropdownMenuItem(
                          value: r,
                          child: Text(finalResultLabel(r)),
                        ),
                  ],
                  onChanged: (v) => setLocal(() => result = v ?? result),
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  key: const Key('council_justification'),
                  controller: justification,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: 'Justificação'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              key: const Key('council_save'),
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Registar decisão'),
            ),
          ],
        ),
      ),
    );
    final text = justification.text;
    justification.dispose();
    if (ok != true || !mounted) return;
    await _run(
      () => ref
          .read(pautaActionsProvider)
          .decide(
            _key,
            studentId: row.student.id,
            result: result,
            justification: text,
          ),
      'Decisão registada.',
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(pautaDataProvider(widget.classroom.id));
    final permissions = ref.watch(permissionServiceProvider);
    final canApprove = permissions.canAny(gradeEntryApprovePermission);
    return data.when(
      skipLoadingOnReload: true,
      loading: () => const SkeletonCard(),
      error: (e, _) => ErrorState(
        failure: data.failure ?? UnknownFailure(cause: e),
        onRetry: () => ref.invalidate(pautaDataProvider(widget.classroom.id)),
      ),
      data: (pauta) {
        final index = widget.termIndex;
        final open = canApprove && !pauta.approved;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SegmentedButton<int?>(
                  key: const Key('pauta_scope'),
                  showSelectedIcon: false,
                  segments: [
                    for (var i = 0; i < pauta.termNames.length; i++)
                      ButtonSegment(value: i, label: Text(pauta.termNames[i])),
                    const ButtonSegment(value: null, label: Text('Final')),
                  ],
                  selected: {index},
                  onSelectionChanged: (s) => widget.onScope(s.first),
                ),
                AppButton(
                  key: const Key('pauta_export_pdf'),
                  label: 'Exportar PDF',
                  icon: Icons.picture_as_pdf_outlined,
                  variant: AppButtonVariant.secondary,
                  onPressed: () =>
                      ref.read(pautaActionsProvider).exportPdf(pauta, index),
                ),
                ExportButton(
                  key: const Key('pauta_export'),
                  permission: pautaExportPermission,
                  dataset: () => ExportDataset(
                    title: 'Pauta ${pauta.scopeName(index)}',
                    entity: 'pauta',
                    permission: pautaExportPermission,
                    columns: [
                      for (final h in pauta.tableHeaders(index))
                        ExportDatasetColumn(key: h, label: h),
                    ],
                    rows: pauta.tableRows(index),
                  ),
                ),
                if (pauta.approved)
                  const Chip(
                    key: Key('pauta_approved'),
                    avatar: Icon(Icons.verified_outlined, size: 18),
                    label: Text('Aprovada pelo conselho de turma'),
                  )
                else if (index == null && canApprove)
                  AppButton(
                    key: const Key('pauta_approve'),
                    label: 'Aprovar pauta',
                    icon: Icons.verified_outlined,
                    loading: _busy,
                    onPressed: pauta.pendingCount > 0
                        ? null
                        : () => _run(
                            () => ref
                                .read(pautaActionsProvider)
                                .approve(_key, pauta.results),
                            'Pauta aprovada.',
                          ),
                  ),
              ],
            ),
            if (index == null && !pauta.approved && pauta.pendingCount > 0)
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: Text(
                  '${pauta.pendingCount} aluno(s) com resultado pendente: '
                  'faltam notas ou uma decisão do conselho.',
                  key: const Key('pauta_pending'),
                ),
              ),
            const SizedBox(height: AppSpacing.md),
            if (pauta.rows.isEmpty)
              const EmptyState(title: 'A turma não tem alunos')
            else
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: PautaView(
                    data: pauta,
                    termIndex: index,
                    onDecide: open ? _decide : null,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
