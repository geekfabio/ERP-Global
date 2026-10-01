import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';

enum FieldKind { text, code, integer, choice, multi, toggle }

/// Campo de um formulário simples em diálogo.
class AcademicField {
  const AcademicField(
    this.key,
    this.label, {
    this.kind = FieldKind.text,
    this.initial,
    this.options = const {},
    this.required = true,
  });

  final String key;
  final String label;
  final FieldKind kind;

  /// `text`/`code`/`integer`/`choice`: texto; `multi`: ids (`List<String>`);
  /// `toggle`: `bool`.
  final Object? initial;

  /// Para `choice`/`multi`: valor → rótulo.
  final Map<String, String> options;

  /// Se `false`, o campo (texto/escolha) pode ficar vazio.
  final bool required;
}

/// Mostra [fields] num diálogo e devolve os valores (`String`, `int`,
/// `List<String>` ou `bool` conforme o tipo); `null` se cancelado.
Future<Map<String, Object?>?> showAcademicForm(
  BuildContext context, {
  required String title,
  required List<AcademicField> fields,
  String? subtitle,
}) => showDialog<Map<String, Object?>>(
  context: context,
  builder: (_) => _FormDialog(title: title, fields: fields, subtitle: subtitle),
);

class _FormDialog extends StatefulWidget {
  const _FormDialog({required this.title, required this.fields, this.subtitle});

  final String title;
  final List<AcademicField> fields;
  final String? subtitle;

  @override
  State<_FormDialog> createState() => _FormDialogState();
}

class _FormDialogState extends State<_FormDialog> {
  final _key = GlobalKey<FormState>();
  late final Map<String, TextEditingController> _controllers = {
    for (final f in widget.fields)
      if (f.kind != FieldKind.multi && f.kind != FieldKind.toggle)
        f.key: TextEditingController(text: f.initial as String?),
  };
  late final Map<String, Object?> _state = {
    for (final f in widget.fields)
      if (f.kind == FieldKind.multi)
        f.key: <String>{...?(f.initial as List<String>?)}
      else if (f.kind == FieldKind.toggle)
        f.key: (f.initial as bool?) ?? true,
  };
  bool _multiEmpty = false;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final formOk = _key.currentState!.validate();
    final multiOk = widget.fields
        .where((f) => f.kind == FieldKind.multi)
        .every((f) => (_state[f.key]! as Set<String>).isNotEmpty);
    setState(() => _multiEmpty = !multiOk);
    if (!formOk || !multiOk) return;
    Navigator.of(context).pop({
      for (final f in widget.fields)
        f.key: switch (f.kind) {
          FieldKind.integer => int.tryParse(_controllers[f.key]!.text.trim()),
          FieldKind.multi => (_state[f.key]! as Set<String>).toList(),
          FieldKind.toggle => _state[f.key],
          _ => _controllers[f.key]!.text.trim(),
        },
    });
  }

  String? Function(String?) _required(AcademicField f) =>
      (v) => f.required && (v == null || v.trim().isEmpty)
      ? 'Campo obrigatório'
      : null;

  Widget _field(AcademicField f) => switch (f.kind) {
    FieldKind.text || FieldKind.code => AppTextField(
      key: Key('field_${f.key}'),
      label: f.label,
      controller: _controllers[f.key],
      validator: _required(f),
    ),
    FieldKind.integer => AppTextField(
      key: Key('field_${f.key}'),
      label: f.label,
      controller: _controllers[f.key],
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: _required(f),
    ),
    FieldKind.choice => DropdownButtonFormField<String>(
      key: Key('field_${f.key}'),
      decoration: InputDecoration(labelText: f.label),
      isExpanded: true,
      initialValue: _controllers[f.key]!.text.isEmpty
          ? null
          : _controllers[f.key]!.text,
      items: [
        for (final e in f.options.entries)
          DropdownMenuItem(value: e.key, child: Text(e.value)),
      ],
      onChanged: (v) => _controllers[f.key]!.text = v ?? '',
      validator: _required(f),
    ),
    FieldKind.multi => Column(
      key: Key('field_${f.key}'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(f.label, style: Theme.of(context).textTheme.labelLarge),
        for (final e in f.options.entries)
          CheckboxListTile(
            key: Key('option_${e.key}'),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(e.value),
            value: (_state[f.key]! as Set<String>).contains(e.key),
            onChanged: (on) => setState(() {
              final set = _state[f.key]! as Set<String>;
              on! ? set.add(e.key) : set.remove(e.key);
            }),
          ),
        if (_multiEmpty)
          Text(
            'Seleccione pelo menos um',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
      ],
    ),
    FieldKind.toggle => SwitchListTile(
      key: Key('field_${f.key}'),
      contentPadding: EdgeInsets.zero,
      title: Text(f.label),
      value: _state[f.key]! as bool,
      onChanged: (v) => setState(() => _state[f.key] = v),
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
