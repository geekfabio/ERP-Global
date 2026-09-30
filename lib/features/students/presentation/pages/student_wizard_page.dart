import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/audit/audit_log_model.dart';
import '../../../../core/audit/audit_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/forms/stepper_form.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../domain/student_duplicates.dart';
import '../providers/student_list_providers.dart';
import '../providers/student_providers.dart';
import '../providers/student_wizard_providers.dart';
import '../widgets/student_wizard/student_wizard_data.dart';
import '../widgets/student_wizard/student_wizard_steps.dart';

/// Cadastro de aluno em passos (identificação → encarregados → saúde →
/// documentos → resumo). Cada alteração guarda o rascunho; antes de gravar
/// avisa de possíveis duplicados (BI, ou nome + data de nascimento).
class StudentWizardPage extends StatelessWidget {
  const StudentWizardPage({super.key});

  @override
  Widget build(BuildContext context) => const Can(
    permission: 'students.record.create',
    fallback: EmptyState(
      icon: Icons.lock_outline,
      title: 'Sem permissão',
      message: 'Não tem permissão para registar alunos.',
    ),
    child: _WizardBody(),
  );
}

class _WizardBody extends ConsumerStatefulWidget {
  const _WizardBody();

  @override
  ConsumerState<_WizardBody> createState() => _WizardBodyState();
}

class _WizardBodyState extends ConsumerState<_WizardBody> {
  late final DraftStore _store = ref.read(studentWizardDraftStoreProvider);
  StepperFormController? _form;
  bool _restored = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final draft = await _store.load();
    if (!mounted) return;
    _start(draft);
  }

  void _start(Map<String, Object?>? draft) {
    final old = _form;
    setState(() {
      _restored = draft != null && draft.isNotEmpty;
      _form = StepperFormController(initial: draft, onChanged: _store.save);
    });
    // Só depois de o `StepperForm` antigo sair da árvore (ainda ouve o controlador).
    if (old != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }
  }

  Future<void> _discard() async {
    await _store.clear();
    if (mounted) _start(null);
  }

  @override
  void dispose() {
    _form?.dispose();
    super.dispose();
  }

  /// Mostra os duplicados. Devolve `true` se o utilizador quer gravar mesmo assim.
  Future<bool> _confirmDuplicates(List<StudentDuplicate> found) async {
    final lines = [
      for (final d in found)
        '• ${d.student.fullName} — processo ${d.student.processNumber}, '
            'nascido em ${PtAoFormatters.date(d.student.birthDate)}'
            '${d.blocking ? ' (mesmo BI)' : ''}',
    ].join('\n');
    if (found.any((d) => d.blocking)) {
      await showAppDialog<void>(
        context: context,
        title: 'Aluno já registado',
        content: Text('Já existe um aluno com este BI:\n$lines'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Fechar'),
          ),
        ],
      );
      return false;
    }
    return showConfirmDialog(
      context: context,
      title: 'Possível duplicado',
      message:
          'Já existe um aluno com o mesmo nome e data de nascimento:\n$lines\n\n'
          'Quer registar mesmo assim?',
      confirmLabel: 'Registar mesmo assim',
    );
  }

  Future<void> _submit(Map<String, Object?> values) async {
    final now = DateTime.now().toUtc();
    final student = wizardStudent(
      values,
      id: SeedGenerator(now.microsecondsSinceEpoch).ulid(now),
      now: now,
    );
    final students = ref.read(studentRepositoryProvider);
    final guardiansRepo = ref.read(guardianRepositoryProvider);
    final documentsRepo = ref.read(studentDocumentRepositoryProvider);
    final audit = ref.read(auditServiceProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final router = GoRouter.of(context);

    // 1. Alerta de duplicados antes de guardar.
    var confirmDuplicate = false;
    final dupes = await students.findDuplicates(
      fullName: student.fullName,
      birthDate: student.birthDate,
      idNumber: student.idNumber,
    );
    if (!mounted) return;
    if (dupes.isOk && dupes.getOrThrow().isNotEmpty) {
      if (!await _confirmDuplicates(dupes.getOrThrow()) || !mounted) return;
      confirmDuplicate = true;
    }

    // 2. Aluno (o servidor volta a validar: 409 em duplicado, 422 em campos).
    final created = await students.create(
      student,
      confirmDuplicate: confirmDuplicate,
    );
    final saved = created.when(ok: (s) => s, err: (f) => null);
    if (saved == null) {
      toast.error(created.when(ok: (_) => '', err: (f) => f.message));
      return;
    }

    // 3. Encarregados e documentos: se algum falhar, o aluno já existe — avisa
    //    e o resto completa-se na ficha.
    var failed = 0;
    for (final g in wizardGuardians(values)) {
      final m = wizardGuardianModels(g, studentId: saved.id, now: now);
      final guardian = await guardiansRepo.create(m.guardian);
      final linked = guardian.isOk ? await guardiansRepo.link(m.link) : null;
      if (linked == null || !linked.isOk) failed++;
    }
    for (final t in wizardDocuments(values)) {
      final doc = await documentsRepo.create(
        wizardDocument(t, studentId: saved.id, now: now),
      );
      if (!doc.isOk) failed++;
    }
    await _store.clear();
    unawaited(
      audit.record(
        entity: 'student',
        action: AuditAction.create,
        entityId: saved.id,
        after: saved.toJson(),
      ),
    );
    container.invalidate(studentListProvider);
    if (failed == 0) {
      toast.success('Aluno registado');
    } else {
      toast.info(
        'Aluno registado, mas $failed item(ns) não foram guardados. '
        'Complete-os na ficha.',
      );
    }
    router.go('/students/${saved.id}');
  }

  @override
  Widget build(BuildContext context) {
    final form = _form;
    final text = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Row(
                  children: [
                    AppIconButton(
                      icon: Icons.arrow_back,
                      tooltip: 'Voltar aos alunos',
                      onPressed: () {
                        if (form != null && form.values.isNotEmpty) {
                          ref
                              .read(toastProvider.notifier)
                              .info('Rascunho guardado');
                        }
                        context.go('/students');
                      },
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text('Novo aluno', style: text.headlineSmall),
                  ],
                ),
              ),
              if (_restored)
                MaterialBanner(
                  content: const Text('Rascunho restaurado.'),
                  actions: [
                    TextButton(
                      onPressed: _discard,
                      child: const Text('Descartar rascunho'),
                    ),
                  ],
                ),
              Expanded(
                child: form == null
                    ? const Center(child: CircularProgressIndicator())
                    : StepperForm(
                        // Novo controlador (descartar) → formulário novo.
                        key: ObjectKey(form),
                        controller: form,
                        steps: studentWizardSteps(),
                        summaryBuilder: studentWizardSummary,
                        submitLabel: 'Registar aluno',
                        onSubmit: _submit,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
