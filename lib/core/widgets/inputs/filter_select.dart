import 'package:flutter/material.dart';

/// Selector de filtro com a opção "Todos" (`null`) e ícone. Desactivado,
/// pode explicar porquê numa tooltip ([disabledHint]) sem desalinhar a linha.
class FilterSelect<T> extends StatelessWidget {
  const FilterSelect({
    super.key,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
    this.icon,
    this.width,
    this.enabled = true,
    this.disabledHint,
    this.allLabel = 'Todos',
    this.fieldKey,
  });

  final String label;
  final T? value;

  /// Opções `valor → texto`, pela ordem a mostrar.
  final Map<T, String> options;
  final ValueChanged<T?> onChanged;
  final IconData? icon;

  /// Largura fixa; `null` = toda a largura disponível.
  final double? width;
  final bool enabled;
  final String? disabledHint;
  final String allLabel;

  /// Chave do campo em si (para testes e foco).
  final Key? fieldKey;

  @override
  Widget build(BuildContext context) {
    final field = SizedBox(
      width: width ?? double.infinity,
      child: DropdownButtonFormField<T?>(
        key: fieldKey,
        initialValue: value,
        isExpanded: true,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
        ),
        items: [
          DropdownMenuItem<T?>(value: null, child: Text(allLabel)),
          for (final e in options.entries)
            DropdownMenuItem<T?>(value: e.key, child: Text(e.value)),
        ],
        onChanged: enabled ? onChanged : null,
      ),
    );
    final hint = disabledHint;
    return enabled || hint == null
        ? field
        : Tooltip(message: hint, child: field);
  }
}
