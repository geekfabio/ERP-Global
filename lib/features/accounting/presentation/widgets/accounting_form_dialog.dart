import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';

enum FieldKind { text, date, choice }

/// Campo de um formulário simples em diálogo.
class FormFieldSpec {
  const FormFieldSpec(
    this.key,
    this.label, {
    this.kind = FieldKind.text,
    this.initial,
    this.options = const {},
    this.enabled = true,
  });

  final String key;
  final String label;
  final FieldKind kind;
  final String? initial;

  /// Para [FieldKind.choice]: valor → rótulo.
  final Map<String, String> options;
  final bool enabled;
}

/// Mostra [fields] num diálogo e devolve os valores (`text`/`choice` →
/// `String`, `date` → `DateTime` UTC); `null` se cancelado.
Future<Map<String, Object?>?> showAccountingForm(
  BuildContext context, {
  required String title,
  required List<FormFieldSpec> fields,
  String? subtitle,
}) => showDialog<Map<String, Object?>>(
  context: context,
  builder: (_) => _FormDialog(title: title, fields: fields, subtitle: subtitle),
);

class _FormDialog extends StatefulWidget {
  const _FormDialog({required this.title, required this.fields, this.subtitle});

  final String title;
  final List<FormFieldSpec> fields;
  final String? subtitle;

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  final _key = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      f.key: TextEditingController(text: f.initial),
  };
  final Map<String, DateTime> _dates = {};

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
        f.key: f.kind == FieldKind.date
            ? _dates[f.key]
            : _controllers[f.key]!.text.trim(),
    });
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;

  Widget _field(FormFieldSpec f) => switch (f.kind) {
    FieldKind.text => AppTextField(
      key: Key('field_${f.key}'),
      label: f.label,
      controller: _controllers[f.key],
      enabled: f.enabled,
      validator: _required,
    ),
    FieldKind.date => AppDateField(
      key: Key('field_${f.key}'),
      label: f.label,
      value: _dates[f.key],
      required: true,
      onChanged: (d) => setState(() => _dates[f.key] = d),
    ),
    FieldKind.choice => DropdownButtonFormField<String>(
      key: Key('field_${f.key}'),
      decoration: InputDecoration(labelText: f.label),
      initialValue: _controllers[f.key]!.text.isEmpty
          ? null
          : _controllers[f.key]!.text,
      items: [
        for (final e in f.options.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: f.enabled ? (v) => _controllers[f.key]!.text = v ?? '' : null,
      validator: _required,
    ),
  };

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
                  child: _field(f),
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
      FilledButton(onPressed: _submit, child: const Text('Guardar')),
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
