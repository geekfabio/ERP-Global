import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../data/models/student_enums.dart';
import '../../../../data/models/student_model.dart';
import '../editable_section.dart';
import '../student_file_save.dart';

/// Separador 1 — Identificação (docs/03-funcionalidades.md).
class IdentificationTab extends ConsumerStatefulWidget {
  const IdentificationTab({super.key, required this.student});

  final StudentModel student;

  @override
  ConsumerState<IdentificationTab> createState() => _IdentificationTabState();
}

class _IdentificationTabState extends ConsumerState<IdentificationTab> {
  late StudentModel _draft = widget.student;

  @override
  void didUpdateWidget(IdentificationTab old) {
    super.didUpdateWidget(old);
    if (old.student != widget.student) _draft = widget.student;
  }

  static String? _nullIfEmpty(String? v) {
    final t = v?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  static String? _email(String? v) {
    final t = v?.trim() ?? '';
    if (t.isEmpty) return null;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
        ? null
        : 'E-mail inválido';
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.student;
    return EditableSection(
      title: 'Dados de identificação',
      editPermission: 'students.record.update',
      onCancel: () => _draft = widget.student,
      onSave: () => saveStudent(ref, _draft),
      view: (_) => Column(
        children: [
          FieldRow(label: 'Nome completo', value: s.fullName),
          FieldRow(label: 'N.º de processo', value: s.processNumber),
          FieldRow(
            label: 'Data de nascimento',
            value: PtAoFormatters.date(s.birthDate),
          ),
          FieldRow(label: 'Local de nascimento', value: s.birthPlace),
          FieldRow(
            label: 'Sexo',
            value: s.gender == Gender.male ? 'Masculino' : 'Feminino',
          ),
          FieldRow(label: 'Nacionalidade', value: s.nationality),
          FieldRow(label: 'BI / cédula / passaporte', value: s.idNumber),
          FieldRow(label: 'NIF', value: s.nif),
          FieldRow(label: 'Morada', value: s.address),
          FieldRow(label: 'Telefone', value: s.phone),
          FieldRow(label: 'E-mail', value: s.email),
          FieldRow(label: 'Escola de origem', value: s.originSchool),
        ],
      ),
      form: (_) => FormGrid(
        children: [
          AppTextField(
            label: 'Nome completo',
            initialValue: s.fullName,
            validator: (v) =>
                (v ?? '').trim().length < 3 ? 'Indique o nome completo' : null,
            onSaved: (v) => _draft = _draft.copyWith(fullName: v!.trim()),
          ),
          AppDateField(
            label: 'Data de nascimento',
            value: _draft.birthDate,
            required: true,
            lastDate: DateTime.now(),
            onChanged: (d) => setState(() {
              _draft = _draft.copyWith(birthDate: d);
            }),
          ),
          AppTextField(
            label: 'Local de nascimento',
            initialValue: s.birthPlace,
            onSaved: (v) =>
                _draft = _draft.copyWith(birthPlace: _nullIfEmpty(v)),
          ),
          DropdownButtonFormField<Gender>(
            initialValue: s.gender,
            decoration: const InputDecoration(labelText: 'Sexo'),
            items: const [
              DropdownMenuItem(value: Gender.male, child: Text('Masculino')),
              DropdownMenuItem(value: Gender.female, child: Text('Feminino')),
            ],
            onChanged: (_) {},
            onSaved: (v) => _draft = _draft.copyWith(gender: v ?? s.gender),
          ),
          AppTextField(
            label: 'Nacionalidade',
            initialValue: s.nationality,
            validator: (v) =>
                (v ?? '').trim().isEmpty ? 'Campo obrigatório' : null,
            onSaved: (v) => _draft = _draft.copyWith(nationality: v!.trim()),
          ),
          AppTextField(
            label: 'BI / cédula / passaporte',
            initialValue: s.idNumber,
            onSaved: (v) => _draft = _draft.copyWith(idNumber: _nullIfEmpty(v)),
          ),
          AppTextField(
            label: 'NIF',
            initialValue: s.nif,
            onSaved: (v) => _draft = _draft.copyWith(nif: _nullIfEmpty(v)),
          ),
          AppTextField(
            label: 'Morada',
            initialValue: s.address,
            onSaved: (v) => _draft = _draft.copyWith(address: _nullIfEmpty(v)),
          ),
          AppPhoneField(
            initialValue: s.phone,
            onSaved: (v) => _draft = _draft.copyWith(phone: _nullIfEmpty(v)),
          ),
          AppTextField(
            label: 'E-mail',
            initialValue: s.email,
            keyboardType: TextInputType.emailAddress,
            validator: _email,
            onSaved: (v) => _draft = _draft.copyWith(email: _nullIfEmpty(v)),
          ),
          AppTextField(
            label: 'Escola de origem',
            initialValue: s.originSchool,
            onSaved: (v) =>
                _draft = _draft.copyWith(originSchool: _nullIfEmpty(v)),
          ),
        ],
      ),
    );
  }
}
