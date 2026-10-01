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
import '../../../academic/data/models/classroom_models.dart';
import '../../../academic/presentation/providers/academic_structure_providers.dart';
import '../../../settings/data/models/term_model.dart';
import '../../../settings/presentation/providers/academic_providers.dart';
import '../../domain/grade_entry_repository.dart';
import '../providers/grades_providers.dart';
import '../providers/report_card_providers.dart';
import '../widgets/report_card_view.dart';

/// Boletim de notas por aluno e trimestre: ecrã, PDF e envio ao encarregado.
class ReportCardPage extends ConsumerStatefulWidget {
  const ReportCardPage({super.key});

  @override
  ConsumerState<ReportCardPage> createState() => _ReportCardPageState();
}

class _ReportCardPageState extends ConsumerState<ReportCardPage> {
  String? _classroomId;
  String? _termId;
  String? _studentId;

  @override
  Widget build(BuildContext context) {
    final classrooms = ref.watch(classroomListProvider);
    final grades = ref.watch(gradeListProvider).value ?? const [];
    final gradeNames = {for (final g in grades) g.id: g.name};

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            children: [
              Text(
                'Boletim de notas',
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

  Widget _body(
    List<ClassroomModel> classrooms,
    Map<String, String> gradeNames,
  ) {
    final current = classrooms.where((c) => c.id == _classroomId).firstOrNull;
    final terms = current == null
        ? const <TermModel>[]
        : ref.watch(termsProvider(current.academicYearId)).value ??
              const <TermModel>[];
    final termId = terms.any((t) => t.id == _termId) ? _termId : null;
    final roster = current == null
        ? null
        : ref.watch(classroomRosterProvider(current.id));
    final students = roster?.value ?? const [];
    final studentId = students.any((s) => s.id == _studentId)
        ? _studentId
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            SizedBox(
              width: 260,
              child: DropdownButtonFormField<String>(
                key: const Key('report_classroom'),
                decoration: const InputDecoration(labelText: 'Turma'),
                initialValue: current?.id,
                items: [
                  for (final c in classrooms)
                    DropdownMenuItem<String>(
                      value: c.id,
                      child: Text('${gradeNames[c.gradeId] ?? ''} · ${c.name}'),
                    ),
                ],
                onChanged: (v) => setState(() {
                  _classroomId = v;
                  _termId = null;
                  _studentId = null;
                }),
              ),
            ),
            SizedBox(
              width: 220,
              child: DropdownButtonFormField<String>(
                key: const Key('report_term'),
                decoration: const InputDecoration(labelText: 'Trimestre'),
                initialValue: termId,
                items: [
                  for (final t in terms)
                    DropdownMenuItem(value: t.id, child: Text(t.name)),
                ],
                onChanged: current == null
                    ? null
                    : (v) => setState(() => _termId = v),
              ),
            ),
            SizedBox(
              width: 320,
              child: DropdownButtonFormField<String>(
                key: const Key('report_student'),
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Aluno'),
                initialValue: studentId,
                items: [
                  for (final s in students)
                    DropdownMenuItem(
                      value: s.id,
                      child: Text(s.fullName, overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: current == null
                    ? null
                    : (v) => setState(() => _studentId = v),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        if (current == null || termId == null || studentId == null)
          const EmptyState(title: 'Escolha a turma, o trimestre e o aluno')
        else
          _ReportCardBody(
            key: ValueKey('$_classroomId/$termId/$studentId'),
            reportKey: (
              studentId: studentId,
              classroomId: current.id,
              termId: termId,
            ),
          ),
      ],
    );
  }
}

class _ReportCardBody extends ConsumerStatefulWidget {
  const _ReportCardBody({super.key, required this.reportKey});

  final ReportCardKey reportKey;

  @override
  ConsumerState<_ReportCardBody> createState() => _ReportCardBodyState();
}

class _ReportCardBodyState extends ConsumerState<_ReportCardBody> {
  bool _busy = false;

  ReportCardKey get _key => widget.reportKey;

  Future<void> _editRemarks(String current) async {
    final controller = TextEditingController(text: current);
    final text = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Observações do director de turma'),
        content: SizedBox(
          width: 480,
          child: TextField(
            key: const Key('report_remarks_field'),
            controller: controller,
            maxLines: 5,
            maxLength: 500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            key: const Key('report_remarks_save'),
            onPressed: () => Navigator.of(context).pop(controller.text),
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (text == null || !mounted) return;
    await _run(
      () => ref.read(reportCardActionsProvider).saveRemarks(_key, text),
      'Observações guardadas.',
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(reportCardDataProvider(_key));
    final state = ref.watch(reportCardStateProvider(_key)).value;
    final permissions = ref.watch(permissionServiceProvider);
    final canWrite =
        permissions.canAny(gradeEntryWritePermission) ||
        permissions.canAny(gradeEntryApprovePermission);

    return data.when(
      skipLoadingOnReload: true,
      loading: () => const SkeletonCard(),
      error: (e, _) => ErrorState(
        failure: data.failure ?? UnknownFailure(cause: e),
        onRetry: () => ref.invalidate(reportCardDataProvider(_key)),
      ),
      data: (report) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              AppButton(
                key: const Key('report_export'),
                label: 'Exportar PDF',
                icon: Icons.picture_as_pdf_outlined,
                variant: AppButtonVariant.secondary,
                loading: _busy,
                onPressed: () => _run(() async {
                  await ref.read(reportCardActionsProvider).export(_key);
                  return const Ok<Object?>(null);
                }, 'Concluído.'),
              ),
              if (canWrite) ...[
                AppButton(
                  key: const Key('report_edit_remarks'),
                  label: 'Observações',
                  icon: Icons.edit_note,
                  variant: AppButtonVariant.secondary,
                  onPressed: _busy ? null : () => _editRemarks(report.remarks),
                ),
                AppButton(
                  key: const Key('report_send'),
                  label: 'Enviar ao encarregado',
                  icon: Icons.send_outlined,
                  onPressed: _busy
                      ? null
                      : () => _run(
                          () => ref.read(reportCardActionsProvider).send(_key),
                          'Boletim enviado ao encarregado.',
                        ),
                ),
              ],
            ],
          ),
          if (state?.sentAt != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: Text(
                'Enviado em ${PtAoFormatters.dateTime(state!.sentAt!.toLocal())}',
                key: const Key('report_sent_at'),
              ),
            ),
          const SizedBox(height: AppSpacing.md),
          ReportCardView(data: report),
        ],
      ),
    );
  }
}
