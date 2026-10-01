import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';

/// Campo de um formulário simples em diálogo.
class LibraryField {
  const LibraryField(
    this.key,
    this.label, {
    this.integer = false,
    this.required = true,
    this.initial,
  });

  final String key;
  final String label;

  /// Aceita só números inteiros (o valor devolvido é `int`).
  final bool integer;
  final bool required;
  final String? initial;
}

/// Mostra [fields] num diálogo e devolve os valores (`String`, ou `int` nos
/// campos inteiros); `null` se cancelado.
Future<Map<String, Object?>?> showLibraryForm(
  BuildContext context, {
  required String title,
  required List<LibraryField> fields,
  String? subtitle,
  String submitLabel = 'Guardar',
}) => showDialog<Map<String, Object?>>(
  context: context,
  builder: (_) => _FormDialog(
    title: title,
    fields: fields,
    subtitle: subtitle,
    submitLabel: submitLabel,
  ),
);

class _FormDialog extends StatefulWidget {
  const _FormDialog({
    required this.title,
    required this.fields,
    required this.submitLabel,
    this.subtitle,
  });

  final String title;
  final List<LibraryField> fields;
  final String? subtitle;
  final String submitLabel;

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  final _key = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      f.key: TextEditingController(text: f.initial),
  };

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop({
      for (final f in widget.fields)
        f.key: f.integer
            ? int.tryParse(_controllers[f.key]!.text.trim())
            : _controllers[f.key]!.text.trim(),
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: Text(widget.subtitle!),
                ),
              for (final f in widget.fields)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppTextField(
                    key: Key('field_${f.key}'),
                    label: f.label,
                    controller: _controllers[f.key],
                    keyboardType: f.integer ? TextInputType.number : null,
                    inputFormatters: f.integer
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                    validator: (v) => f.required && (v ?? '').trim().isEmpty
                        ? 'Campo obrigatório'
                        : null,
                  ),
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
      FilledButton(onPressed: _submit, child: Text(widget.submitLabel)),
    ],
  );
}

/// Toast de sucesso ([done]) ou do erro do [Failure]; devolve `true` se correu bem.
bool reportResult<T>(WidgetRef ref, Result<T> result, {required String done}) {
  final toast = ref.read(toastProvider.notifier);
  return result.when(
    ok: (_) {
      toast.success(done);
      return true;
    },
    err: (f) {
      toast.error(f.message);
      return false;
    },
  );
}
