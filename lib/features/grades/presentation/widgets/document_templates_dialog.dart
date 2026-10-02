import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/academic_document_models.dart';
import '../../domain/academic_document.dart';
import '../providers/academic_document_providers.dart';

/// Edição dos modelos de certificados e declarações (marcadores `{{...}}`).
class DocumentTemplatesDialog extends ConsumerStatefulWidget {
  const DocumentTemplatesDialog({super.key});

  @override
  ConsumerState<DocumentTemplatesDialog> createState() =>
      _DocumentTemplatesDialogState();
}

class _DocumentTemplatesDialogState
    extends ConsumerState<DocumentTemplatesDialog> {
  final _controller = TextEditingController();
  String? _templateId;
  String? _error;
  bool _saving = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(DocumentTemplateModel? t) => setState(() {
    _templateId = t?.id;
    _controller.text = t?.body ?? '';
    _error = null;
  });

  Future<void> _save(DocumentTemplateModel template) async {
    setState(() {
      _saving = true;
      _error = null;
    });
    final result = await ref
        .read(academicDocumentActionsProvider)
        .saveTemplate(template, _controller.text);
    if (!mounted) return;
    setState(() => _saving = false);
    switch (result) {
      case Ok():
        ref.read(toastProvider.notifier).success('Modelo guardado.');
      case Err(:final failure):
        setState(
          () =>
              _error = failure is ValidationFailure && failure.fields.isNotEmpty
              ? failure.fields.values.first
              : failure.message,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final templates = ref.watch(documentTemplatesProvider);
    return AlertDialog(
      title: const Text('Modelos de documentos'),
      content: SizedBox(
        width: 560,
        child: templates.when(
          loading: () =>
              const SizedBox(height: 160, child: SkeletonList(itemCount: 3)),
          error: (e, _) => ErrorState(
            failure: templates.failure ?? UnknownFailure(cause: e),
            onRetry: () => ref.invalidate(documentTemplatesProvider),
          ),
          data: (list) {
            final current = list.where((t) => t.id == _templateId).firstOrNull;
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    key: const Key('template_select'),
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Modelo'),
                    initialValue: current?.id,
                    items: [
                      for (final t in list)
                        DropdownMenuItem(value: t.id, child: Text(t.name)),
                    ],
                    onChanged: (id) =>
                        _select(list.where((t) => t.id == id).firstOrNull),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    key: const Key('template_body'),
                    controller: _controller,
                    enabled: current != null,
                    minLines: 6,
                    maxLines: 10,
                    maxLength: maxDocumentTemplateLength,
                    decoration: InputDecoration(
                      labelText: 'Texto',
                      errorText: _error,
                    ),
                  ),
                  Text(
                    'Marcadores: ${[for (final k in documentPlaceholders.keys) '{{$k}}'].join(', ')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  if (current != null) ...[
                    const SizedBox(height: AppSpacing.md),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton(
                        key: const Key('template_save'),
                        onPressed: _saving ? null : () => _save(current),
                        child: const Text('Guardar'),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Fechar'),
        ),
      ],
    );
  }
}
