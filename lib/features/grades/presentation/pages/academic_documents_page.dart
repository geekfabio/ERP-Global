import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/academic_document_models.dart';
import '../../domain/academic_document.dart';
import '../providers/academic_document_providers.dart';
import '../widgets/document_request_dialog.dart';
import '../widgets/document_templates_dialog.dart';

/// Certificados e declarações: pedido, emissão numerada com QR de
/// verificação, anulação, modelos editáveis e verificação por número.
class AcademicDocumentsPage extends ConsumerStatefulWidget {
  const AcademicDocumentsPage({super.key});

  @override
  ConsumerState<AcademicDocumentsPage> createState() =>
      _AcademicDocumentsPageState();
}

class _AcademicDocumentsPageState extends ConsumerState<AcademicDocumentsPage> {
  DocumentKind? _kind;
  DocumentStatus? _status;
  final _verify = TextEditingController();
  String? _verifyMessage;
  bool _busy = false;

  DocumentFilter get _filter => (kind: _kind, status: _status);

  @override
  void dispose() {
    _verify.dispose();
    super.dispose();
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

  Future<void> _check() async {
    final result = await ref
        .read(academicDocumentActionsProvider)
        .verify(_verify.text);
    if (!mounted) return;
    setState(() {
      _verifyMessage = switch (result) {
        Ok(:final value) =>
          '${value.kind.label} ${value.number} - ${value.studentName} '
              '(${value.status.label}'
              '${value.issuedAt == null ? '' : ', ${PtAoFormatters.date(value.issuedAt!.toLocal())}'})',
        Err(:final failure) =>
          failure.code == 'NOT_FOUND'
              ? 'Documento não encontrado.'
              : failure.message,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final permissions = ref.watch(permissionServiceProvider);
    final canRequest =
        permissions.canAny(documentRequestPermission) ||
        permissions.canAny(documentIssuePermission);
    final canTemplates = permissions.canAny(documentTemplatePermission);
    final docs = ref.watch(academicDocumentsProvider(_filter));

    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Certificados e declarações',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  if (canTemplates)
                    IconButton(
                      key: const Key('documents_templates'),
                      tooltip: 'Modelos',
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => const DocumentTemplatesDialog(),
                      ),
                      icon: const Icon(Icons.edit_note),
                    ),
                  if (canRequest)
                    IconButton.filled(
                      key: const Key('documents_new'),
                      tooltip: 'Novo pedido',
                      onPressed: () => showDialog<void>(
                        context: context,
                        builder: (_) => const DocumentRequestDialog(),
                      ),
                      icon: const Icon(Icons.add),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Wrap(
                spacing: AppSpacing.md,
                runSpacing: AppSpacing.md,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 260,
                    child: DropdownButtonFormField<DocumentKind?>(
                      key: const Key('documents_kind_filter'),
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Tipo'),
                      initialValue: _kind,
                      items: [
                        const DropdownMenuItem(child: Text('Todos')),
                        for (final k in DocumentKind.values)
                          DropdownMenuItem(value: k, child: Text(k.label)),
                      ],
                      onChanged: (v) => setState(() => _kind = v),
                    ),
                  ),
                  SizedBox(
                    width: 180,
                    child: DropdownButtonFormField<DocumentStatus?>(
                      key: const Key('documents_status_filter'),
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Estado'),
                      initialValue: _status,
                      items: [
                        const DropdownMenuItem(child: Text('Todos')),
                        for (final s in DocumentStatus.values)
                          DropdownMenuItem(value: s, child: Text(s.label)),
                      ],
                      onChanged: (v) => setState(() => _status = v),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      key: const Key('documents_verify_field'),
                      controller: _verify,
                      decoration: InputDecoration(
                        labelText: 'Verificar n.º',
                        suffixIcon: IconButton(
                          key: const Key('documents_verify'),
                          tooltip: 'Verificar',
                          onPressed: _check,
                          icon: const Icon(Icons.verified_outlined),
                        ),
                      ),
                      onSubmitted: (_) => _check(),
                    ),
                  ),
                ],
              ),
              if (_verifyMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    _verifyMessage!,
                    key: const Key('documents_verify_result'),
                  ),
                ),
              const SizedBox(height: AppSpacing.lg),
              docs.when(
                skipLoadingOnReload: true,
                loading: () => const SizedBox(
                  height: 160,
                  child: SkeletonList(itemCount: 3),
                ),
                error: (e, _) => ErrorState(
                  failure: docs.failure ?? UnknownFailure(cause: e),
                  onRetry: () =>
                      ref.invalidate(academicDocumentsProvider(_filter)),
                ),
                data: (list) => list.isEmpty
                    ? const EmptyState(title: 'Sem pedidos de documentos')
                    : Column(
                        children: [
                          for (final d in list)
                            _DocumentCard(
                              doc: d,
                              busy: _busy,
                              canIssue: permissions.canAny(
                                documentIssuePermission,
                              ),
                              onRun: _run,
                            ),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentCard extends ConsumerWidget {
  const _DocumentCard({
    required this.doc,
    required this.busy,
    required this.canIssue,
    required this.onRun,
  });

  final AcademicDocumentModel doc;
  final bool busy;
  final bool canIssue;
  final Future<void> Function(Future<Result<Object?>> Function(), String) onRun;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(academicDocumentActionsProvider);
    final scheme = Theme.of(context).colorScheme;
    final when = doc.issuedAt ?? doc.requestedAt;
    return Card(
      key: Key('document_${doc.id}'),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${doc.kind.label}'
                    '${doc.number == null ? '' : ' · ${doc.number}'}',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '${doc.studentName} · ${doc.processNumber}',
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '${doc.status.label} em '
                    '${PtAoFormatters.dateTime(when.toLocal())}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: scheme.outline),
                  ),
                ],
              ),
            ),
            if (doc.status == DocumentStatus.requested && canIssue)
              IconButton(
                key: Key('document_issue_${doc.id}'),
                tooltip: 'Emitir',
                onPressed: busy
                    ? null
                    : () =>
                          onRun(() => actions.issue(doc), 'Documento emitido.'),
                icon: const Icon(Icons.verified_outlined),
              ),
            if (doc.status == DocumentStatus.issued)
              IconButton(
                key: Key('document_pdf_${doc.id}'),
                tooltip: 'Exportar PDF',
                onPressed: busy
                    ? null
                    : () => onRun(() async {
                        await actions.exportPdf(doc);
                        return const Ok<Object?>(null);
                      }, 'Concluído.'),
                icon: const Icon(Icons.picture_as_pdf_outlined),
              ),
            if (doc.status != DocumentStatus.cancelled && canIssue)
              IconButton(
                key: Key('document_cancel_${doc.id}'),
                tooltip: 'Anular',
                onPressed: busy
                    ? null
                    : () => onRun(
                        () => actions.cancel(doc),
                        'Documento anulado.',
                      ),
                icon: const Icon(Icons.block),
              ),
          ],
        ),
      ),
    );
  }
}
