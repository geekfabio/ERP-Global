import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';

enum FieldKind { text, money, date, integer }

/// Campo de um formulário simples em diálogo.
class FormFieldSpec {
  const FormFieldSpec(
    this.key,
    this.label, {
    this.kind = FieldKind.text,
    this.initial,
    this.required = true,
    this.maxLines = 1,
  });

  final String key;
  final String label;
  final FieldKind kind;
  final String? initial;
  final bool required;
  final int maxLines;
}

/// Mostra [fields] num diálogo e devolve os valores (`text` → `String`,
/// `money` → cêntimos `int`, `integer` → `int`, `date` → `DateTime` UTC);
/// `null` se cancelado.
Future<Map<String, Object?>?> showInventoryForm(
  BuildContext context, {
  required String title,
  required List<FormFieldSpec> fields,
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
  final List<FormFieldSpec> fields;
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
        f.key: switch (f.kind) {
          FieldKind.text => _controllers[f.key]!.text.trim(),
          FieldKind.money => parseMinorUnits(_controllers[f.key]!.text) ?? 0,
          FieldKind.integer => int.tryParse(_controllers[f.key]!.text.trim()),
          FieldKind.date => _dates[f.key],
        },
    });
  }

  Widget _field(FormFieldSpec f) {
    String? required(String? v) => f.required && (v == null || v.trim().isEmpty)
        ? 'Campo obrigatório'
        : null;
    return switch (f.kind) {
      FieldKind.text => AppTextField(
        key: Key('field_${f.key}'),
        label: f.label,
        controller: _controllers[f.key],
        maxLines: f.maxLines,
        validator: required,
      ),
      FieldKind.money => AppMoneyField(
        key: Key('field_${f.key}'),
        label: f.label,
        controller: _controllers[f.key],
        required: f.required,
      ),
      FieldKind.integer => AppTextField(
        key: Key('field_${f.key}'),
        label: f.label,
        controller: _controllers[f.key],
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'-?\d*'))],
        validator: (v) =>
            required(v) ??
            (v != null && v.isNotEmpty && int.tryParse(v.trim()) == null
                ? 'Número inválido'
                : null),
      ),
      FieldKind.date => AppDateField(
        key: Key('field_${f.key}'),
        label: f.label,
        value: _dates[f.key],
        required: f.required,
        onChanged: (d) => setState(() => _dates[f.key] = d),
      ),
    };
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
      FilledButton(onPressed: _submit, child: Text(widget.submitLabel)),
    ],
  );
}
