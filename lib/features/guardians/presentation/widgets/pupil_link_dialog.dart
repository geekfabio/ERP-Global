import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/seed_generator.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../students/data/models/guardian_model.dart';
import '../../../students/data/models/student_enums.dart';
import '../../../students/data/models/student_model.dart';
import '../../domain/link_validity.dart';

/// Diálogo de vínculo: edita [initial] ou cria um novo para um dos
/// [candidates] (educandos ainda não ligados ao encarregado).
class PupilLinkDialog extends StatefulWidget {
  const PupilLinkDialog({
    super.key,
    required this.title,
    required this.guardian,
    this.initial,
    this.candidates = const [],
  });

  final String title;
  final GuardianModel guardian;
  final GuardianLinkModel? initial;
  final List<StudentModel> candidates;

  @override
  State<PupilLinkDialog> createState() => _PupilLinkDialogState();
}

class _PupilLinkDialogState extends State<PupilLinkDialog> {
  String? _studentId;
  late GuardianRelationship _relationship =
      widget.initial?.relationship ?? GuardianRelationship.father;
  late bool _financial = widget.initial?.isFinancialResponsible ?? false;
  late bool _emergency = widget.initial?.isEmergency ?? false;
  late bool _pickup = widget.initial?.canPickup ?? false;
  late DateTime? _validUntil = widget.initial?.validUntil;

  bool get _creating => widget.initial == null;

  void _submit() {
    final now = DateTime.now().toUtc();
    final base =
        widget.initial ??
        GuardianLinkModel(
          id: SeedGenerator(now.microsecondsSinceEpoch).ulid(now),
          institutionId: widget.guardian.institutionId,
          createdAt: now,
          updatedAt: now,
          studentId: _studentId!,
          guardianId: widget.guardian.id,
          relationship: _relationship,
        );
    Navigator.of(context).pop(
      base.copyWith(
        relationship: _relationship,
        isFinancialResponsible: _financial,
        isEmergency: _emergency,
        canPickup: _pickup,
        validUntil: _validUntil,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.title),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_creating) ...[
              AppSearchableSelect<String>(
                label: 'Educando',
                value: _studentId,
                options: {
                  for (final s in widget.candidates)
                    s.id: '${s.fullName} · ${s.processNumber}',
                },
                onSelected: (v) => setState(() => _studentId = v),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            DropdownButtonFormField<GuardianRelationship>(
              initialValue: _relationship,
              decoration: const InputDecoration(labelText: 'Parentesco'),
              items: [
                for (final r in GuardianRelationship.values)
                  DropdownMenuItem(
                    value: r,
                    child: Text(guardianRelationshipLabel(r)),
                  ),
              ],
              onChanged: (v) =>
                  setState(() => _relationship = v ?? _relationship),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Responsável financeiro'),
              value: _financial,
              onChanged: (v) => setState(() => _financial = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Contacto de emergência'),
              value: _emergency,
              onChanged: (v) => setState(() => _emergency = v),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Autorizado a recolher'),
              value: _pickup,
              onChanged: (v) => setState(() => _pickup = v),
            ),
            Row(
              children: [
                Expanded(
                  child: AppDateField(
                    label: 'Válido até',
                    value: _validUntil,
                    firstDate: DateTime(2020),
                    onChanged: (d) => setState(() => _validUntil = d),
                  ),
                ),
                if (_validUntil != null)
                  IconButton(
                    tooltip: 'Sem fim de validade',
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _validUntil = null),
                  ),
              ],
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
        onPressed: _creating && _studentId == null ? null : _submit,
        child: const Text('Guardar'),
      ),
    ],
  );
}

/// Diálogo de edição dos contactos do encarregado.
class GuardianEditDialog extends StatefulWidget {
  const GuardianEditDialog({super.key, required this.guardian});

  final GuardianModel guardian;

  @override
  State<GuardianEditDialog> createState() => _GuardianEditDialogState();
}

class _GuardianEditDialogState extends State<GuardianEditDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.guardian.fullName);
  late final _phone = TextEditingController(text: widget.guardian.phone);
  late final _email = TextEditingController(text: widget.guardian.email);
  late final _address = TextEditingController(text: widget.guardian.address);
  late final _profession = TextEditingController(
    text: widget.guardian.profession,
  );

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _address, _profession]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _required(String? v, [int min = 1]) =>
      (v ?? '').trim().length < min ? 'Campo obrigatório' : null;

  String? _nullIfEmpty(TextEditingController c) =>
      c.text.trim().isEmpty ? null : c.text.trim();

  void _submit() {
    if (!_form.currentState!.validate()) return;
    Navigator.of(context).pop(
      widget.guardian.copyWith(
        fullName: _name.text.trim(),
        phone: _phone.text.trim(),
        email: _nullIfEmpty(_email),
        address: _nullIfEmpty(_address),
        profession: _nullIfEmpty(_profession),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Editar encarregado'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _form,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('guardian_name'),
                controller: _name,
                decoration: const InputDecoration(labelText: 'Nome completo'),
                validator: (v) => _required(v, 3),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                key: const Key('guardian_phone'),
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Telefone'),
                validator: _required,
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'E-mail'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Morada'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextFormField(
                controller: _profession,
                decoration: const InputDecoration(labelText: 'Profissão'),
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
