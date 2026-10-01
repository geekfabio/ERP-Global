import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';
import '../../data/models/menu.dart';

const allergenLabels = <Allergen, String>{
  Allergen.gluten: 'Glúten',
  Allergen.lactose: 'Lactose',
  Allergen.eggs: 'Ovos',
  Allergen.fish: 'Peixe',
  Allergen.shellfish: 'Crustáceos',
  Allergen.peanuts: 'Amendoim',
  Allergen.nuts: 'Frutos de casca rija',
  Allergen.soy: 'Soja',
  Allergen.celery: 'Aipo',
  Allergen.sesame: 'Sésamo',
};

String allergensText(List<Allergen> list) => list.isEmpty
    ? 'Sem alergénios'
    : list.map((a) => allergenLabels[a]).join(', ');

String? _req(String? v) =>
    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;

String? _time(String? v) =>
    _req(v) ??
    (RegExp(r'^([01]\d|2[0-3]):[0-5]\d$').hasMatch(v!.trim())
        ? null
        : 'Use HH:mm');

String moneyText(int minor) =>
    '${minor ~/ 100},${(minor % 100).toString().padLeft(2, '0')}';

List<Widget> _spaced(List<Widget> children) => [
  for (var i = 0; i < children.length; i++) ...[
    if (i > 0) const SizedBox(height: AppSpacing.md),
    children[i],
  ],
];

Widget _dialog({
  required BuildContext context,
  required String title,
  required GlobalKey<FormState>? formKey,
  required List<Widget> children,
  required VoidCallback onSave,
}) => AlertDialog(
  title: Text(title),
  content: SizedBox(
    width: 440,
    child: Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: _spaced(children),
        ),
      ),
    ),
  ),
  actions: [
    TextButton(
      onPressed: () => Navigator.of(context).pop(),
      child: const Text('Cancelar'),
    ),
    FilledButton(onPressed: onSave, child: const Text('Guardar')),
  ],
);

// --- Tipo de refeição --------------------------------------------------------

Future<MealType?> showMealTypeDialog(BuildContext context, [MealType? type]) =>
    showDialog<MealType>(
      context: context,
      builder: (_) => _MealTypeDialog(type),
    );

class _MealTypeDialog extends StatefulWidget {
  const _MealTypeDialog(this.type);
  final MealType? type;

  @override
  State<_MealTypeDialog> createState() => _MealTypeDialogState();
}

class _MealTypeDialogState extends State<_MealTypeDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.type?.name);
  late final _start = TextEditingController(text: widget.type?.startTime);
  late final _end = TextEditingController(text: widget.type?.endTime);
  late final _price = TextEditingController(
    text: moneyText(widget.type?.priceMinor ?? 0),
  );
  late bool _active = widget.type?.isActive ?? true;

  @override
  void dispose() {
    _name.dispose();
    _start.dispose();
    _end.dispose();
    _price.dispose();
    super.dispose();
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop(
      MealType(
        id: widget.type?.id ?? '',
        name: _name.text.trim(),
        startTime: _start.text.trim(),
        endTime: _end.text.trim(),
        priceMinor: parseMinorUnits(_price.text) ?? 0,
        isActive: _active,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _dialog(
    context: context,
    title: widget.type == null
        ? 'Novo tipo de refeição'
        : 'Editar tipo de refeição',
    formKey: _key,
    onSave: _save,
    children: [
      AppTextField(label: 'Designação', controller: _name, validator: _req),
      AppTextField(
        label: 'Início (HH:mm)',
        controller: _start,
        validator: _time,
      ),
      AppTextField(
        label: 'Fim (HH:mm)',
        controller: _end,
        validator: (v) =>
            _time(v) ??
            (v!.trim().compareTo(_start.text.trim()) > 0
                ? null
                : 'O fim deve ser depois do início'),
      ),
      AppMoneyField(label: 'Preço', controller: _price, required: true),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Activo'),
        value: _active,
        onChanged: (v) => setState(() => _active = v),
      ),
    ],
  );
}

// --- Prato ---------------------------------------------------------------------

Future<MealItem?> showMealItemDialog(
  BuildContext context,
  List<MealType> types, [
  MealItem? item,
]) => showDialog<MealItem>(
  context: context,
  builder: (_) => _MealItemDialog(types, item),
);

class _MealItemDialog extends StatefulWidget {
  const _MealItemDialog(this.types, this.item);
  final List<MealType> types;
  final MealItem? item;

  @override
  State<_MealItemDialog> createState() => _MealItemDialogState();
}

class _MealItemDialogState extends State<_MealItemDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.item?.name);
  late final _price = TextEditingController(
    text: moneyText(widget.item?.priceMinor ?? 0),
  );
  late String? _typeId = widget.item?.mealTypeId;
  late final Set<Allergen> _allergens = {...?widget.item?.allergens};
  late bool _active = widget.item?.isActive ?? true;

  @override
  void dispose() {
    _name.dispose();
    _price.dispose();
    super.dispose();
  }

  void _save() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop(
      MealItem(
        id: widget.item?.id ?? '',
        name: _name.text.trim(),
        mealTypeId: _typeId!,
        priceMinor: parseMinorUnits(_price.text) ?? 0,
        allergens: Allergen.values.where(_allergens.contains).toList(),
        isActive: _active,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _dialog(
    context: context,
    title: widget.item == null ? 'Novo prato' : 'Editar prato',
    formKey: _key,
    onSave: _save,
    children: [
      AppTextField(label: 'Designação', controller: _name, validator: _req),
      DropdownButtonFormField<String>(
        initialValue: _typeId,
        decoration: const InputDecoration(labelText: 'Tipo de refeição'),
        items: [
          for (final t in widget.types)
            DropdownMenuItem(value: t.id, child: Text(t.name)),
        ],
        validator: (v) => v == null ? 'Campo obrigatório' : null,
        onChanged: (v) => setState(() => _typeId = v),
      ),
      AppMoneyField(label: 'Preço', controller: _price, required: true),
      Text('Alergénios', style: Theme.of(context).textTheme.labelLarge),
      Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: [
          for (final a in Allergen.values)
            FilterChip(
              label: Text(allergenLabels[a]!),
              selected: _allergens.contains(a),
              onSelected: (on) =>
                  setState(() => on ? _allergens.add(a) : _allergens.remove(a)),
            ),
        ],
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Activo'),
        value: _active,
        onChanged: (v) => setState(() => _active = v),
      ),
    ],
  );
}

// --- Menu de um dia -----------------------------------------------------------

/// Escolhe os pratos de [type] para [date]; devolve os ids (vazio = limpar).
Future<List<String>?> showMenuDialog(
  BuildContext context, {
  required DateTime date,
  required MealType type,
  required List<MealItem> options,
  required List<String> selected,
}) => showDialog<List<String>>(
  context: context,
  builder: (_) => _MenuDialog(date, type, options, selected),
);

class _MenuDialog extends StatefulWidget {
  const _MenuDialog(this.date, this.type, this.options, this.selected);
  final DateTime date;
  final MealType type;
  final List<MealItem> options;
  final List<String> selected;

  @override
  State<_MenuDialog> createState() => _MenuDialogState();
}

class _MenuDialogState extends State<_MenuDialog> {
  late final Set<String> _ids = {...widget.selected};

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('${widget.type.name} — ${PtAoFormatters.date(widget.date)}'),
    content: SizedBox(
      width: 440,
      child: widget.options.isEmpty
          ? const Text('Sem pratos activos para este tipo de refeição.')
          : SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (final i in widget.options)
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _ids.contains(i.id),
                      title: Text(i.name),
                      subtitle: Text(allergensText(i.allergens)),
                      onChanged: (on) => setState(
                        () => on == true ? _ids.add(i.id) : _ids.remove(i.id),
                      ),
                    ),
                ],
              ),
            ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(
          widget.options
              .where((i) => _ids.contains(i.id))
              .map((i) => i.id)
              .toList(),
        ),
        child: const Text('Guardar'),
      ),
    ],
  );
}
