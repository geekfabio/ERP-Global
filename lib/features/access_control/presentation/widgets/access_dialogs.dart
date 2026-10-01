import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../data/models/access_models.dart';
import '../../domain/access_evaluator.dart';
import 'access_labels.dart';

Widget _gap(Widget child) => Padding(
  padding: const EdgeInsets.only(bottom: AppSpacing.md),
  child: child,
);

String? _required(String? v) =>
    v == null || v.trim().isEmpty ? 'Campo obrigatório' : null;

/// Diálogo base: formulário validado; [onSubmit] devolve o resultado a fechar.
class _FormDialog<T> extends StatelessWidget {
  const _FormDialog({
    required this.title,
    required this.formKey,
    required this.children,
    required this.onSubmit,
  });

  final String title;
  final GlobalKey<FormState> formKey;
  final List<Widget> children;
  final void Function() onSubmit;

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(title),
    content: SizedBox(
      width: 440,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: onSubmit, child: const Text('Guardar')),
    ],
  );
}

/// Zona nova ou existente ([zone]); `null` se cancelado.
Future<ZoneModel?> showZoneDialog(
  BuildContext context, {
  required Map<String, String> campuses,
  ZoneModel? zone,
}) => showDialog<ZoneModel>(
  context: context,
  builder: (_) => _ZoneDialog(campuses: campuses, zone: zone),
);

class _ZoneDialog extends StatefulWidget {
  const _ZoneDialog({required this.campuses, this.zone});

  final Map<String, String> campuses;
  final ZoneModel? zone;

  @override
  State<_ZoneDialog> createState() => _ZoneDialogState();
}

class _ZoneDialogState extends State<_ZoneDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.zone?.name);
  late final _description = TextEditingController(
    text: widget.zone?.description,
  );
  late String? _campusId =
      widget.zone?.campusId ??
      (widget.campuses.length == 1 ? widget.campuses.keys.first : null);
  bool _campusError = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = _key.currentState!.validate();
    setState(() => _campusError = _campusId == null);
    if (!ok || _campusId == null) return;
    final desc = _description.text.trim();
    Navigator.of(context).pop(
      (widget.zone ?? const ZoneModel(id: '', campusId: '', name: '')).copyWith(
        name: _name.text.trim(),
        campusId: _campusId!,
        description: desc.isEmpty ? null : desc,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _FormDialog<ZoneModel>(
    title: widget.zone == null ? 'Nova zona' : 'Editar zona',
    formKey: _key,
    onSubmit: _submit,
    children: [
      _gap(
        AppTextField(
          key: const Key('field_name'),
          label: 'Nome',
          controller: _name,
          validator: _required,
        ),
      ),
      _gap(
        AppSearchableSelect<String>(
          key: const Key('field_campus'),
          label: 'Campus',
          options: widget.campuses,
          value: _campusId,
          errorText: widget.campuses.isEmpty
              ? 'Sem campus disponíveis (verifique as permissões de definições)'
              : _campusError
              ? 'Campo obrigatório'
              : null,
          onSelected: (v) => setState(() {
            _campusId = v;
            _campusError = false;
          }),
        ),
      ),
      _gap(
        AppTextField(
          key: const Key('field_description'),
          label: 'Descrição',
          controller: _description,
        ),
      ),
    ],
  );
}

/// Dispositivo novo ou existente; [zones] = `id → nome`.
Future<AccessDeviceModel?> showDeviceDialog(
  BuildContext context, {
  required Map<String, String> zones,
  AccessDeviceModel? device,
}) => showDialog<AccessDeviceModel>(
  context: context,
  builder: (_) => _DeviceDialog(zones: zones, device: device),
);

class _DeviceDialog extends StatefulWidget {
  const _DeviceDialog({required this.zones, this.device});

  final Map<String, String> zones;
  final AccessDeviceModel? device;

  @override
  State<_DeviceDialog> createState() => _DeviceDialogState();
}

class _DeviceDialogState extends State<_DeviceDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.device?.name);
  late String? _zoneId = widget.device?.zoneId;
  late DeviceKind _kind = widget.device?.kind ?? DeviceKind.reader;
  bool _zoneError = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final ok = _key.currentState!.validate();
    setState(() => _zoneError = _zoneId == null);
    if (!ok || _zoneId == null) return;
    Navigator.of(context).pop(
      (widget.device ?? const AccessDeviceModel(id: '', zoneId: '', name: ''))
          .copyWith(name: _name.text.trim(), zoneId: _zoneId!, kind: _kind),
    );
  }

  @override
  Widget build(BuildContext context) => _FormDialog<AccessDeviceModel>(
    title: widget.device == null ? 'Novo dispositivo' : 'Editar dispositivo',
    formKey: _key,
    onSubmit: _submit,
    children: [
      _gap(
        AppTextField(
          key: const Key('field_name'),
          label: 'Nome',
          controller: _name,
          validator: _required,
        ),
      ),
      _gap(
        AppSearchableSelect<String>(
          key: const Key('field_zone'),
          label: 'Zona',
          options: widget.zones,
          value: _zoneId,
          errorText: _zoneError ? 'Campo obrigatório' : null,
          onSelected: (v) => setState(() {
            _zoneId = v;
            _zoneError = false;
          }),
        ),
      ),
      _gap(
        AppSearchableSelect<DeviceKind>(
          key: const Key('field_kind'),
          label: 'Tipo',
          options: {for (final k in DeviceKind.values) k: deviceKindLabel(k)},
          value: _kind,
          onSelected: (v) => setState(() => _kind = v ?? _kind),
        ),
      ),
    ],
  );
}

/// Regra nova ou existente; [zones] = `id → nome`.
Future<AccessRuleModel?> showRuleDialog(
  BuildContext context, {
  required Map<String, String> zones,
  AccessRuleModel? rule,
}) => showDialog<AccessRuleModel>(
  context: context,
  builder: (_) => _RuleDialog(zones: zones, rule: rule),
);

class _RuleDialog extends StatefulWidget {
  const _RuleDialog({required this.zones, this.rule});

  final Map<String, String> zones;
  final AccessRuleModel? rule;

  @override
  State<_RuleDialog> createState() => _RuleDialogState();
}

class _RuleDialogState extends State<_RuleDialog> {
  final _key = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.rule?.name);
  late String? _zoneId = widget.rule?.zoneId;
  late AccessSubject _subject = widget.rule?.subject ?? AccessSubject.all;
  late final Set<int> _days = {...?widget.rule?.days};
  late int _start = widget.rule?.startMinute ?? 7 * 60;
  late int _end = widget.rule?.endMinute ?? 18 * 60;
  late bool _activeStudent = widget.rule?.requireActiveStudent ?? false;
  late bool _financial = widget.rule?.requireFinancialClear ?? false;
  bool _submitted = false;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  String? get _zoneError =>
      _submitted && _zoneId == null ? 'Campo obrigatório' : null;
  String? get _daysError =>
      _submitted && _days.isEmpty ? 'Escolha pelo menos um dia' : null;
  String? get _timeError =>
      _end <= _start ? 'O fim deve ser depois do início' : null;

  Future<void> _pick(bool start) async {
    final current = start ? _start : _end;
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: (current ~/ 60) % 24, minute: current % 60),
    );
    if (t == null) return;
    final minutes = t.hour * 60 + t.minute;
    setState(() {
      if (start) {
        _start = minutes;
      } else {
        // 00:00 como fim significa meia-noite (24:00).
        _end = minutes == 0 ? 1440 : minutes;
      }
    });
  }

  void _submit() {
    setState(() => _submitted = true);
    if (!_key.currentState!.validate() ||
        _zoneId == null ||
        _days.isEmpty ||
        _timeError != null) {
      return;
    }
    Navigator.of(context).pop(
      (widget.rule ??
              const AccessRuleModel(
                id: '',
                zoneId: '',
                name: '',
                days: [],
                startMinute: 0,
                endMinute: 0,
              ))
          .copyWith(
            name: _name.text.trim(),
            zoneId: _zoneId!,
            subject: _subject,
            days: _days.toList()..sort(),
            startMinute: _start,
            endMinute: _end,
            requireActiveStudent: _activeStudent,
            requireFinancialClear: _financial,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return _FormDialog<AccessRuleModel>(
      title: widget.rule == null ? 'Nova regra' : 'Editar regra',
      formKey: _key,
      onSubmit: _submit,
      children: [
        _gap(
          AppTextField(
            key: const Key('field_name'),
            label: 'Nome',
            controller: _name,
            validator: _required,
          ),
        ),
        _gap(
          AppSearchableSelect<String>(
            key: const Key('field_zone'),
            label: 'Zona',
            options: widget.zones,
            value: _zoneId,
            errorText: _zoneError,
            onSelected: (v) => setState(() => _zoneId = v),
          ),
        ),
        _gap(
          AppSearchableSelect<AccessSubject>(
            key: const Key('field_subject'),
            label: 'Aplica-se a',
            options: {for (final s in AccessSubject.values) s: subjectLabel(s)},
            value: _subject,
            onSelected: (v) => setState(() => _subject = v ?? _subject),
          ),
        ),
        Wrap(
          spacing: AppSpacing.sm,
          children: [
            for (var d = 1; d <= 7; d++)
              FilterChip(
                key: Key('day_$d'),
                label: Text(weekdayShort[d - 1]),
                selected: _days.contains(d),
                onSelected: (on) =>
                    setState(() => on ? _days.add(d) : _days.remove(d)),
              ),
          ],
        ),
        if (_daysError != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(_daysError!, style: TextStyle(color: scheme.error)),
          ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                key: const Key('field_start'),
                onPressed: () => _pick(true),
                child: Text('Início ${formatMinute(_start)}'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: OutlinedButton(
                key: const Key('field_end'),
                onPressed: () => _pick(false),
                child: Text('Fim ${formatMinute(_end)}'),
              ),
            ),
          ],
        ),
        if (_timeError != null)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.xs),
            child: Text(_timeError!, style: TextStyle(color: scheme.error)),
          ),
        SwitchListTile(
          key: const Key('field_activeStudent'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Exigir aluno activo'),
          value: _activeStudent,
          onChanged: (v) => setState(() => _activeStudent = v),
        ),
        SwitchListTile(
          key: const Key('field_financial'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Exigir situação financeira regularizada'),
          value: _financial,
          onChanged: (v) => setState(() => _financial = v),
        ),
      ],
    );
  }
}
