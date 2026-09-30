import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/pt_ao_formatters.dart';
import 'money_parser.dart';

/// Campo de texto base: label sempre visível (acessível), erro/foco/desactivado
/// vêm do `InputDecorationTheme` do tema.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.helperText,
    this.hintText,
    this.keyboardType,
    this.inputFormatters,
    this.obscureText = false,
    this.enabled = true,
    this.suffixIcon,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final String? helperText;
  final String? hintText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool obscureText;
  final bool enabled;
  final Widget? suffixIcon;
  final AutovalidateMode autovalidateMode;

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    enabled: enabled,
    obscureText: obscureText,
    keyboardType: keyboardType,
    inputFormatters: inputFormatters,
    validator: validator,
    onChanged: onChanged,
    autovalidateMode: autovalidateMode,
    decoration: InputDecoration(
      labelText: label,
      helperText: helperText,
      hintText: hintText,
      suffixIcon: suffixIcon,
    ),
  );
}

/// Password com botão mostrar/ocultar.
class AppPasswordField extends StatefulWidget {
  const AppPasswordField({
    super.key,
    this.label = 'Palavra-passe',
    this.controller,
    this.validator,
    this.onChanged,
  });

  final String label;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _hidden = true;

  @override
  Widget build(BuildContext context) => AppTextField(
    label: widget.label,
    controller: widget.controller,
    validator: widget.validator,
    onChanged: widget.onChanged,
    obscureText: _hidden,
    suffixIcon: IconButton(
      tooltip: _hidden ? 'Mostrar palavra-passe' : 'Ocultar palavra-passe',
      icon: Icon(
        _hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
      ),
      onPressed: () => setState(() => _hidden = !_hidden),
    ),
  );
}

/// Valor monetário: o utilizador escreve `1 234,56`, o callback recebe cêntimos (`int`).
class AppMoneyField extends StatelessWidget {
  const AppMoneyField({
    super.key,
    this.label = 'Valor',
    this.controller,
    this.onChanged,
    this.required = false,
    this.enabled = true,
  });

  final String label;
  final TextEditingController? controller;

  /// Cêntimos, ou `null` se o texto estiver vazio/inválido.
  final ValueChanged<int?>? onChanged;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) => AppTextField(
    label: label,
    controller: controller,
    enabled: enabled,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    hintText: '0,00',
    helperText: 'Em Kz',
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,\s]'))],
    onChanged: (v) => onChanged?.call(parseMinorUnits(v)),
    validator: (v) {
      if (v == null || v.trim().isEmpty) {
        return required ? 'Campo obrigatório' : null;
      }
      return parseMinorUnits(v) == null ? 'Valor inválido' : null;
    },
  );
}

/// Data: abre o seletor nativo e mostra `dd/MM/yyyy`. Valor devolvido em UTC (só data).
class AppDateField extends StatelessWidget {
  const AppDateField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.firstDate,
    this.lastDate,
    this.required = false,
    this.enabled = true,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final bool required;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final text = value == null ? '' : PtAoFormatters.date(value!);
    return TextFormField(
      key: ValueKey(text),
      initialValue: text,
      readOnly: true,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: 'dd/mm/aaaa',
        suffixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      validator: (_) => required && value == null ? 'Campo obrigatório' : null,
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now,
          firstDate: firstDate ?? DateTime(1900),
          lastDate: lastDate ?? DateTime(now.year + 10),
        );
        if (picked != null) {
          onChanged(DateTime.utc(picked.year, picked.month, picked.day));
        }
      },
    );
  }
}

/// Telefone angolano: `+244` opcional seguido de 9 dígitos começados por 9.
class AppPhoneField extends StatelessWidget {
  const AppPhoneField({
    super.key,
    this.label = 'Telefone',
    this.controller,
    this.onChanged,
    this.required = false,
  });

  final String label;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool required;

  /// Só dígitos do número nacional (sem `+244`); `null` se inválido.
  static String? normalize(String input) {
    var digits = input.replaceAll(RegExp(r'[\s-]'), '');
    if (digits.startsWith('+244')) digits = digits.substring(4);
    if (digits.startsWith('00244')) digits = digits.substring(5);
    return RegExp(r'^9\d{8}$').hasMatch(digits) ? digits : null;
  }

  @override
  Widget build(BuildContext context) => AppTextField(
    label: label,
    controller: controller,
    keyboardType: TextInputType.phone,
    hintText: '+244 9XX XXX XXX',
    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s-]'))],
    onChanged: onChanged,
    validator: (v) {
      if (v == null || v.trim().isEmpty) {
        return required ? 'Campo obrigatório' : null;
      }
      return normalize(v) == null ? 'Número angolano inválido' : null;
    },
  );
}

/// Select com pesquisa (filtra ao escrever).
class AppSearchableSelect<T> extends StatelessWidget {
  const AppSearchableSelect({
    super.key,
    required this.label,
    required this.options,
    required this.onSelected,
    this.value,
    this.errorText,
    this.enabled = true,
  });

  final String label;

  /// Valor → texto apresentado.
  final Map<T, String> options;
  final T? value;
  final ValueChanged<T?> onSelected;
  final String? errorText;
  final bool enabled;

  @override
  Widget build(BuildContext context) => DropdownMenu<T>(
    label: Text(label),
    initialSelection: value,
    enabled: enabled,
    enableFilter: true,
    requestFocusOnTap: true,
    expandedInsets: EdgeInsets.zero,
    errorText: errorText,
    onSelected: onSelected,
    dropdownMenuEntries: [
      for (final e in options.entries)
        DropdownMenuEntry(value: e.key, label: e.value),
    ],
  );
}
