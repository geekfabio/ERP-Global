import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../editable_section.dart';
import '../student_file_save.dart';

/// Nome apresentado do grupo sanguíneo (`A+`, `O-`…).
String bloodTypeLabel(BloodType t) => switch (t) {
  BloodType.aPositive => 'A+',
  BloodType.aNegative => 'A-',
  BloodType.bPositive => 'B+',
  BloodType.bNegative => 'B-',
  BloodType.abPositive => 'AB+',
  BloodType.abNegative => 'AB-',
  BloodType.oPositive => 'O+',
  BloodType.oNegative => 'O-',
};

/// Alergias escritas numa só linha, separadas por vírgula (ou ponto e vírgula).
List<String> parseAllergies(String? text) => [
  for (final a in (text ?? '').split(RegExp(r'[,;]')))
    if (a.trim().isNotEmpty) a.trim(),
];

/// Separador 3 — Saúde: dados sensíveis, por isso com permissões próprias
/// (`students.health.read` / `students.health.update`).
class HealthTab extends ConsumerStatefulWidget {
  const HealthTab({super.key, required this.student});

  final StudentModel student;

  @override
  ConsumerState<HealthTab> createState() => _HealthTabState();
}

class _HealthTabState extends ConsumerState<HealthTab> {
  late HealthInfo _draft = widget.student.health;

  @override
  void didUpdateWidget(HealthTab old) {
    super.didUpdateWidget(old);
    if (old.student.health != widget.student.health) {
      _draft = widget.student.health;
    }
  }

  static String? _nullIfEmpty(String? v) {
    final t = v?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  @override
  Widget build(BuildContext context) {
    final h = widget.student.health;
    return EditableSection(
      title: 'Ficha de saúde',
      editPermission: 'students.health.update',
      onCancel: () => _draft = widget.student.health,
      onSave: () => saveStudent(ref, widget.student.copyWith(health: _draft)),
      view: (_) => Column(
        children: [
          FieldRow(
            label: 'Grupo sanguíneo',
            value: h.bloodType == null ? null : bloodTypeLabel(h.bloodType!),
          ),
          FieldRow(label: 'Alergias', value: h.allergies.join(', ')),
          FieldRow(label: 'Medicação', value: h.medication),
          FieldRow(label: 'Condições', value: h.conditions),
          FieldRow(label: 'Seguro de saúde', value: h.insurance),
          FieldRow(
            label: 'Necessidades educativas especiais',
            value: h.hasSpecialNeeds ? 'Sim' : 'Não',
          ),
          if (h.hasSpecialNeeds)
            FieldRow(label: 'Notas sobre NEE', value: h.specialNeedsNotes),
          FieldRow(label: 'Contacto médico', value: h.medicalContact),
        ],
      ),
      form: (_) => FormGrid(
        children: [
          DropdownButtonFormField<BloodType?>(
            initialValue: h.bloodType,
            decoration: const InputDecoration(labelText: 'Grupo sanguíneo'),
            items: [
              const DropdownMenuItem(value: null, child: Text('Não indicado')),
              for (final t in BloodType.values)
                DropdownMenuItem(value: t, child: Text(bloodTypeLabel(t))),
            ],
            onChanged: (_) {},
            onSaved: (v) => _draft = _draft.copyWith(bloodType: v),
          ),
          TextFormField(
            initialValue: h.allergies.join(', '),
            decoration: const InputDecoration(
              labelText: 'Alergias',
              helperText: 'Separe por vírgulas',
            ),
            onSaved: (v) =>
                _draft = _draft.copyWith(allergies: parseAllergies(v)),
          ),
          TextFormField(
            initialValue: h.medication,
            decoration: const InputDecoration(labelText: 'Medicação'),
            onSaved: (v) =>
                _draft = _draft.copyWith(medication: _nullIfEmpty(v)),
          ),
          TextFormField(
            initialValue: h.conditions,
            decoration: const InputDecoration(labelText: 'Condições'),
            onSaved: (v) =>
                _draft = _draft.copyWith(conditions: _nullIfEmpty(v)),
          ),
          TextFormField(
            initialValue: h.insurance,
            decoration: const InputDecoration(labelText: 'Seguro de saúde'),
            onSaved: (v) =>
                _draft = _draft.copyWith(insurance: _nullIfEmpty(v)),
          ),
          TextFormField(
            initialValue: h.medicalContact,
            decoration: const InputDecoration(labelText: 'Contacto médico'),
            onSaved: (v) =>
                _draft = _draft.copyWith(medicalContact: _nullIfEmpty(v)),
          ),
          FormField<bool>(
            initialValue: h.hasSpecialNeeds,
            onSaved: (v) =>
                _draft = _draft.copyWith(hasSpecialNeeds: v ?? false),
            builder: (field) => SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Necessidades educativas especiais'),
              value: field.value ?? false,
              onChanged: field.didChange,
            ),
          ),
          TextFormField(
            initialValue: h.specialNeedsNotes,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Notas sobre NEE'),
            onSaved: (v) =>
                _draft = _draft.copyWith(specialNeedsNotes: _nullIfEmpty(v)),
          ),
        ],
      ),
    );
  }
}
