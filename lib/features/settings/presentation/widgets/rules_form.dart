import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../data/models/setting_model.dart';
import '../providers/rules_providers.dart';
import '../rules_strings.dart';

/// Formulário gerado a partir das regras tipadas de um módulo. Sem [editable]
/// os campos ficam só de leitura.
class RulesForm extends ConsumerStatefulWidget {
  const RulesForm({
    super.key,
    required this.module,
    required this.settings,
    required this.editable,
  });

  final SettingModule module;
  final List<SettingModel> settings;
  final bool editable;

  @override
  ConsumerState<RulesForm> createState() => _RulesFormState();
}

class _RulesFormState extends ConsumerState<RulesForm> {
  final _formKey = GlobalKey<FormState>();
  late final Map<String, Object> _values = {
    for (final s in widget.settings) s.key: s.value,
  };
  late final Map<String, TextEditingController> _c = {
    for (final s in widget.settings)
      if (s.type == SettingType.integer || s.type == SettingType.text)
        s.key: TextEditingController(text: '${s.value}'),
  };
  bool _busy = false;

  @override
  void dispose() {
    for (final c in _c.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final values = <String, Object>{
      for (final s in widget.settings)
        s.key: switch (s.type) {
          SettingType.integer => int.parse(_c[s.key]!.text.trim()),
          SettingType.text => _c[s.key]!.text.trim(),
          _ => _values[s.key]!,
        },
    };
    setState(() => _busy = true);
    final result = await ref
        .read(rulesRepositoryProvider)
        .save(widget.module, values);
    if (!mounted) return;
    setState(() => _busy = false);
    final toasts = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) {
        ref.invalidate(rulesProvider(widget.module));
        toasts.success(RulesStrings.saved);
      },
      err: (f) => toasts.error(f.message),
    );
  }

  Widget _field(SettingModel s) {
    final label = RulesStrings.labels[s.key] ?? s.key;
    return switch (s.type) {
      SettingType.boolean => SwitchListTile(
        key: Key('rule_${s.key}'),
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        value: _values[s.key]! as bool,
        onChanged: widget.editable && !_busy
            ? (v) => setState(() => _values[s.key] = v)
            : null,
      ),
      SettingType.choice => DropdownButtonFormField<String>(
        key: Key('rule_${s.key}'),
        initialValue: _values[s.key]! as String,
        decoration: InputDecoration(labelText: label),
        items: [
          for (final o in s.options)
            DropdownMenuItem(
              value: o,
              child: Text(RulesStrings.currencyNames[o] ?? o),
            ),
        ],
        onChanged: widget.editable && !_busy
            ? (v) => setState(() => _values[s.key] = v!)
            : null,
      ),
      SettingType.integer => AppTextField(
        key: Key('rule_${s.key}'),
        label: label,
        controller: _c[s.key],
        enabled: widget.editable && !_busy,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        helperText: s.min == null ? null : '${s.min} – ${s.max}',
        validator: (v) {
          final n = int.tryParse(v?.trim() ?? '');
          if (n == null) return RulesStrings.invalidNumber;
          return n < s.min! || n > s.max! ? '${s.min} – ${s.max}' : null;
        },
      ),
      SettingType.text => AppTextField(
        key: Key('rule_${s.key}'),
        label: label,
        controller: _c[s.key],
        enabled: widget.editable && !_busy,
        validator: (v) =>
            (v ?? '').trim().isEmpty ? RulesStrings.required : null,
      ),
    };
  }

  @override
  Widget build(BuildContext context) => Form(
    key: _formKey,
    child: ListView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      children: [
        for (final s in widget.settings)
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: _field(s),
          ),
        if (widget.editable)
          Align(
            alignment: Alignment.centerLeft,
            child: AppButton(
              label: RulesStrings.save,
              loading: _busy,
              onPressed: _busy ? null : _save,
            ),
          ),
      ],
    ),
  );
}
