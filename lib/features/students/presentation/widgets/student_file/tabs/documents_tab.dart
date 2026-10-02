import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../app/theme/app_tokens.dart';
import '../../../../../../core/audit/audit_providers.dart';
import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/utils/seed_generator.dart';
import '../../../../../../core/widgets/app_button.dart';
import '../../../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../../../core/widgets/feedback/toasts.dart';
import '../../../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../../../core/widgets/permissions/can.dart';
import '../../../../../../core/widgets/states/app_states.dart';
import '../../../../../../core/widgets/status_badge.dart';
import '../../../../data/models/student_document_model.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../../../../domain/student_file_rules.dart';
import '../../../providers/student_file_providers.dart';
import '../../../providers/student_providers.dart';
import '../student_labels.dart';

/// Escolhe um ficheiro no disco (nome apenas: o upload é simulado). Substituível
/// nos testes.
typedef DocumentPicker = Future<String?> Function();

Future<String?> _defaultPicker() async {
  final files = await FilePicker.pickFiles();
  return files.firstOrNull?.name;
}

/// Separador 10 — Documentos: upload (mock) com validade e verificação.
class DocumentsTab extends ConsumerWidget {
  const DocumentsTab({super.key, required this.student, this.picker});

  final StudentModel student;
  final DocumentPicker? picker;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final docs = ref.watch(studentDocumentsProvider(student.id));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Can(
            permission: 'students.record.update',
            child: AppButton(
              label: 'Carregar documento',
              icon: Icons.upload_file_outlined,
              onPressed: () => _upload(context, ref),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AsyncValueView<List<StudentDocumentModel>>(
          value: docs,
          onRetry: () => ref.invalidate(studentDocumentsProvider(student.id)),
          isEmpty: (d) => d.isEmpty,
          loading: const SkeletonCard(),
          empty: const EmptyState(
            icon: Icons.folder_open_outlined,
            title: 'Sem documentos',
            message: 'Ainda não foram carregados documentos para este aluno.',
          ),
          data: (list) => Column(
            children: [
              for (final d in list)
                _DocumentCard(
                  document: d,
                  onVerify: () => _verify(ref, d),
                  onRemove: () => _remove(context, ref, d),
                ),
            ],
          ),
        ),
      ],
    );
  }

  void _refresh(ProviderContainer container) =>
      container.invalidate(studentDocumentsProvider(student.id));

  Future<void> _upload(BuildContext context, WidgetRef ref) async {
    final draft = await showDialog<StudentDocumentModel>(
      context: context,
      builder: (_) => _UploadDialog(
        studentId: student.id,
        picker: picker ?? _defaultPicker,
      ),
    );
    if (draft == null) return;
    final repo = ref.read(studentDocumentRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    (await repo.create(draft)).when(
      ok: (_) {
        toast.success('Documento carregado');
        _refresh(container);
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _verify(WidgetRef ref, StudentDocumentModel d) async {
    final repo = ref.read(studentDocumentRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    final actor = ref.read(auditActorProvider);
    final result = await repo.update(
      d.copyWith(
        verified: true,
        verifiedBy: actor?.id ?? 'desconhecido',
        verifiedAt: DateTime.now().toUtc(),
      ),
    );
    result.when(
      ok: (_) {
        toast.success('Documento verificado');
        _refresh(container);
      },
      err: (f) => toast.error(f.message),
    );
  }

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    StudentDocumentModel d,
  ) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Remover documento',
      message: 'Remover "${d.fileName}" da ficha?',
      confirmLabel: 'Remover',
      destructive: true,
    );
    if (!ok) return;
    final repo = ref.read(studentDocumentRepositoryProvider);
    final toast = ref.read(toastProvider.notifier);
    final container = ref.container;
    (await repo.delete(d.id)).when(
      ok: (_) {
        toast.success('Documento removido');
        _refresh(container);
      },
      err: (f) => toast.error(f.message),
    );
  }
}

class _DocumentCard extends StatelessWidget {
  const _DocumentCard({
    required this.document,
    required this.onVerify,
    required this.onRemove,
  });

  final StudentDocumentModel document;
  final VoidCallback onVerify;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final d = document;
    final text = Theme.of(context).textTheme;
    final validity = documentValidity(d, DateTime.now());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(documentTypeLabel(d.type), style: text.titleMedium),
                  Text(d.fileName),
                  const SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    children: [
                      d.verified
                          ? const StatusBadge(
                              label: 'Verificado',
                              status: BadgeStatus.success,
                            )
                          : const StatusBadge(
                              label: 'Por verificar',
                              status: BadgeStatus.neutral,
                            ),
                      ?switch (validity) {
                        DocumentValidity.noExpiry => null,
                        DocumentValidity.valid => StatusBadge(
                          label:
                              'Válido até ${PtAoFormatters.date(d.expiresOn!)}',
                          status: BadgeStatus.info,
                        ),
                        DocumentValidity.expiringSoon => StatusBadge(
                          label:
                              'Expira em ${PtAoFormatters.date(d.expiresOn!)}',
                          status: BadgeStatus.warning,
                        ),
                        DocumentValidity.expired => StatusBadge(
                          label:
                              'Expirado em ${PtAoFormatters.date(d.expiresOn!)}',
                          status: BadgeStatus.danger,
                        ),
                      },
                    ],
                  ),
                ],
              ),
            ),
            Can(
              permission: 'students.record.update',
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!d.verified)
                    AppIconButton(
                      icon: Icons.verified_outlined,
                      tooltip: 'Marcar como verificado',
                      onPressed: onVerify,
                    ),
                  AppIconButton(
                    icon: Icons.delete_outline,
                    tooltip: 'Remover documento',
                    onPressed: onRemove,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UploadDialog extends StatefulWidget {
  const _UploadDialog({required this.studentId, required this.picker});

  final String studentId;
  final DocumentPicker picker;

  @override
  State<_UploadDialog> createState() => _UploadDialogState();
}

class _UploadDialogState extends State<_UploadDialog> {
  final _formKey = GlobalKey<FormState>();
  final _fileName = TextEditingController();
  StudentDocumentType _type = StudentDocumentType.idCard;
  DateTime? _expiresOn;

  @override
  void dispose() {
    _fileName.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final name = await widget.picker();
    if (name != null && mounted) setState(() => _fileName.text = name);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    final name = _fileName.text.trim();
    Navigator.of(context).pop(
      StudentDocumentModel(
        id: SeedGenerator(now.microsecondsSinceEpoch).ulid(now),
        institutionId: 'mock',
        createdAt: now,
        updatedAt: now,
        studentId: widget.studentId,
        type: _type,
        fileName: name,
        fileUrl: 'mock://documents/$name',
        expiresOn: _expiresOn,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Carregar documento'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<StudentDocumentType>(
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final t in StudentDocumentType.values)
                    DropdownMenuItem(
                      value: t,
                      child: Text(documentTypeLabel(t)),
                    ),
                ],
                onChanged: (v) => setState(() => _type = v ?? _type),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _fileName,
                decoration: InputDecoration(
                  labelText: 'Ficheiro',
                  suffixIcon: IconButton(
                    tooltip: 'Escolher ficheiro',
                    icon: const Icon(Icons.attach_file),
                    onPressed: _pick,
                  ),
                ),
                validator: (v) =>
                    (v?.trim().isEmpty ?? true) ? 'Escolha um ficheiro' : null,
              ),
              const SizedBox(height: AppSpacing.md),
              AppDateField(
                label: 'Validade (opcional)',
                value: _expiresOn,
                onChanged: (d) => setState(() => _expiresOn = d),
              ),
            ],
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Carregar')),
    ],
  );
}
