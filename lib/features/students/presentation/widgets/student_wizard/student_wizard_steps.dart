import 'package:flutter/material.dart';

import '../../../../../app/theme/app_tokens.dart';
import '../../../../../core/utils/pt_ao_formatters.dart';
import '../../../../../core/widgets/app_button.dart';
import '../../../../../core/widgets/forms/stepper_form.dart';
import '../../../../../core/widgets/inputs/app_inputs.dart';
import '../../../data/models/student_enums.dart';
import '../student_file/editable_section.dart';
import '../student_file/tabs/guardians_tab.dart' show relationshipLabel;
import '../student_file/tabs/health_tab.dart' show bloodTypeLabel;
import 'student_wizard_data.dart';

String? _required(String? v, [String message = 'Campo obrigatório']) =>
    (v ?? '').trim().isEmpty ? message : null;

String? _email(String? v) {
  final t = v?.trim() ?? '';
  if (t.isEmpty) return null;
  return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)
      ? null
      : 'E-mail inválido';
}

/// Passos do cadastro (a seguir vem o resumo do `StepperForm`):
/// identificação → encarregados → saúde → documentos.
List<FormStepDef> studentWizardSteps() => [
  FormStepDef(title: 'Identificação', builder: _identification),
  FormStepDef(title: 'Encarregados', builder: _guardians),
  FormStepDef(title: 'Saúde', builder: _health),
  FormStepDef(title: 'Documentos', builder: _documents),
];

Widget _identification(BuildContext context, StepperFormController form) {
  String? s(String k) => form.get<String>(k);
  return FormGrid(
    children: [
      AppTextField(
        label: 'Nome completo',
        initialValue: s(WizardKeys.fullName),
        validator: (v) =>
            (v ?? '').trim().length < 3 ? 'Indique o nome completo' : null,
        onChanged: (v) => form.set(WizardKeys.fullName, v),
      ),
      AppDateField(
        label: 'Data de nascimento',
        value: parseWizardDate(s(WizardKeys.birthDate)),
        required: true,
        lastDate: DateTime.now(),
        onChanged: (d) => form.set(WizardKeys.birthDate, formatWizardDate(d)),
      ),
      DropdownButtonFormField<String>(
        initialValue: s(WizardKeys.gender),
        decoration: const InputDecoration(labelText: 'Sexo'),
        validator: _required,
        items: const [
          DropdownMenuItem(value: 'male', child: Text('Masculino')),
          DropdownMenuItem(value: 'female', child: Text('Feminino')),
        ],
        onChanged: (v) => form.set(WizardKeys.gender, v),
      ),
      AppTextField(
        label: 'Local de nascimento',
        initialValue: s(WizardKeys.birthPlace),
        onChanged: (v) => form.set(WizardKeys.birthPlace, v),
      ),
      AppTextField(
        label: 'Nacionalidade',
        initialValue: s(WizardKeys.nationality) ?? 'Angolana',
        validator: _required,
        onChanged: (v) => form.set(WizardKeys.nationality, v),
      ),
      AppTextField(
        label: 'BI / cédula / passaporte',
        initialValue: s(WizardKeys.idNumber),
        helperText: 'Usado para detectar alunos já registados',
        onChanged: (v) => form.set(WizardKeys.idNumber, v),
      ),
      AppTextField(
        label: 'NIF',
        initialValue: s(WizardKeys.nif),
        onChanged: (v) => form.set(WizardKeys.nif, v),
      ),
      AppTextField(
        label: 'Morada',
        initialValue: s(WizardKeys.address),
        onChanged: (v) => form.set(WizardKeys.address, v),
      ),
      AppPhoneField(
        initialValue: s(WizardKeys.phone),
        onChanged: (v) => form.set(WizardKeys.phone, v),
      ),
      AppTextField(
        label: 'E-mail',
        initialValue: s(WizardKeys.email),
        keyboardType: TextInputType.emailAddress,
        validator: _email,
        onChanged: (v) => form.set(WizardKeys.email, v),
      ),
      AppTextField(
        label: 'Escola de origem',
        initialValue: s(WizardKeys.originSchool),
        onChanged: (v) => form.set(WizardKeys.originSchool, v),
      ),
    ],
  );
}

Widget _guardians(BuildContext context, StepperFormController form) {
  final items = wizardGuardians(form.values);
  void save(List<WizardGuardian> list) =>
      form.set(WizardKeys.guardians, [for (final g in list) g.toMap()]);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      if (items.isEmpty)
        const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Text('Ainda sem encarregados. Pode associá-los depois.'),
        ),
      for (final (i, g) in items.indexed)
        Card(
          child: ListTile(
            title: Text(g.fullName),
            subtitle: Text(
              [
                relationshipLabel(g.relationship),
                g.phone,
                if (g.isFinancialResponsible) 'Resp. financeiro',
                if (g.isEmergency) 'Emergência',
                if (g.canPickup) 'Pode levantar',
              ].join(' · '),
            ),
            trailing: AppIconButton(
              icon: Icons.delete_outline,
              tooltip: 'Remover ${g.fullName}',
              onPressed: () => save([...items]..removeAt(i)),
            ),
          ),
        ),
      AppButton(
        label: 'Adicionar encarregado',
        icon: Icons.person_add_alt_outlined,
        variant: AppButtonVariant.secondary,
        onPressed: () async {
          final g = await showDialog<WizardGuardian>(
            context: context,
            builder: (_) => const _GuardianDialog(),
          );
          if (g != null) save([...items, g]);
        },
      ),
    ],
  );
}

class _GuardianDialog extends StatefulWidget {
  const _GuardianDialog();

  @override
  State<_GuardianDialog> createState() => _GuardianDialogState();
}

class _GuardianDialogState extends State<_GuardianDialog> {
  final _key = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  GuardianRelationship _relationship = GuardianRelationship.father;
  bool _financial = false;
  bool _emergency = false;
  bool _pickup = false;

  void _submit() {
    if (!_key.currentState!.validate()) return;
    Navigator.of(context).pop(
      WizardGuardian(
        fullName: _name.trim(),
        phone: _phone.trim(),
        relationship: _relationship,
        isFinancialResponsible: _financial,
        isEmergency: _emergency,
        canPickup: _pickup,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Adicionar encarregado'),
    content: SizedBox(
      width: 420,
      child: SingleChildScrollView(
        child: Form(
          key: _key,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTextField(
                label: 'Nome completo',
                validator: (v) => (v ?? '').trim().length < 3
                    ? 'Indique o nome completo'
                    : null,
                onChanged: (v) => _name = v,
              ),
              const SizedBox(height: AppSpacing.md),
              AppPhoneField(required: true, onChanged: (v) => _phone = v),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<GuardianRelationship>(
                initialValue: _relationship,
                decoration: const InputDecoration(labelText: 'Parentesco'),
                items: [
                  for (final r in GuardianRelationship.values)
                    DropdownMenuItem(
                      value: r,
                      child: Text(relationshipLabel(r)),
                    ),
                ],
                onChanged: (v) => setState(() => _relationship = v!),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Responsável financeiro'),
                value: _financial,
                onChanged: (v) => setState(() => _financial = v ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Contacto de emergência'),
                value: _emergency,
                onChanged: (v) => setState(() => _emergency = v ?? false),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Pode levantar o aluno'),
                value: _pickup,
                onChanged: (v) => setState(() => _pickup = v ?? false),
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
      FilledButton(onPressed: _submit, child: const Text('Adicionar')),
    ],
  );
}

Widget _health(BuildContext context, StepperFormController form) {
  String? s(String k) => form.get<String>(k);
  final special = form.get<bool>(WizardKeys.hasSpecialNeeds) ?? false;
  return FormGrid(
    children: [
      DropdownButtonFormField<String?>(
        initialValue: s(WizardKeys.bloodType),
        decoration: const InputDecoration(labelText: 'Grupo sanguíneo'),
        items: [
          const DropdownMenuItem(value: null, child: Text('Não indicado')),
          for (final t in BloodType.values)
            DropdownMenuItem(value: t.name, child: Text(bloodTypeLabel(t))),
        ],
        onChanged: (v) => form.set(WizardKeys.bloodType, v),
      ),
      AppTextField(
        label: 'Alergias',
        helperText: 'Separe por vírgulas',
        initialValue: s(WizardKeys.allergies),
        onChanged: (v) => form.set(WizardKeys.allergies, v),
      ),
      AppTextField(
        label: 'Medicação',
        initialValue: s(WizardKeys.medication),
        onChanged: (v) => form.set(WizardKeys.medication, v),
      ),
      AppTextField(
        label: 'Condições',
        initialValue: s(WizardKeys.conditions),
        onChanged: (v) => form.set(WizardKeys.conditions, v),
      ),
      AppTextField(
        label: 'Seguro de saúde',
        initialValue: s(WizardKeys.insurance),
        onChanged: (v) => form.set(WizardKeys.insurance, v),
      ),
      AppTextField(
        label: 'Contacto médico',
        initialValue: s(WizardKeys.medicalContact),
        onChanged: (v) => form.set(WizardKeys.medicalContact, v),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: const Text('Necessidades educativas especiais'),
        value: special,
        onChanged: (v) => form.set(WizardKeys.hasSpecialNeeds, v),
      ),
      if (special)
        AppTextField(
          label: 'Notas sobre NEE',
          maxLines: 3,
          initialValue: s(WizardKeys.specialNeedsNotes),
          onChanged: (v) => form.set(WizardKeys.specialNeedsNotes, v),
        ),
    ],
  );
}

Widget _documents(BuildContext context, StepperFormController form) {
  final chosen = {for (final t in wizardDocuments(form.values)) t};
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text('Marque os documentos entregues.'),
      for (final t in StudentDocumentType.values)
        CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(documentTypeLabel(t)),
          value: chosen.contains(t),
          onChanged: (v) => form.set(WizardKeys.documents, [
            for (final x in StudentDocumentType.values)
              if (x == t ? (v ?? false) : chosen.contains(x)) x.name,
          ]),
        ),
    ],
  );
}

/// Resumo final: tudo o que vai ser guardado.
Widget studentWizardSummary(BuildContext context, Map<String, Object?> values) {
  String? s(String k) => values[k] as String?;
  final birth = parseWizardDate(s(WizardKeys.birthDate));
  final guardians = wizardGuardians(values);
  final documents = wizardDocuments(values);
  final title = Theme.of(context).textTheme.titleSmall;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Identificação', style: title),
      FieldRow(label: 'Nome completo', value: s(WizardKeys.fullName)),
      FieldRow(
        label: 'Data de nascimento',
        value: birth == null ? null : PtAoFormatters.date(birth),
      ),
      FieldRow(
        label: 'Sexo',
        value: switch (s(WizardKeys.gender)) {
          'male' => 'Masculino',
          'female' => 'Feminino',
          _ => null,
        },
      ),
      FieldRow(
        label: 'BI / cédula / passaporte',
        value: s(WizardKeys.idNumber),
      ),
      FieldRow(label: 'Telefone', value: s(WizardKeys.phone)),
      const SizedBox(height: AppSpacing.md),
      Text('Encarregados', style: title),
      FieldRow(
        label: 'Indicados',
        value: guardians.isEmpty
            ? null
            : guardians
                  .map(
                    (g) =>
                        '${g.fullName} (${relationshipLabel(g.relationship)})',
                  )
                  .join(', '),
      ),
      const SizedBox(height: AppSpacing.md),
      Text('Saúde', style: title),
      FieldRow(label: 'Alergias', value: s(WizardKeys.allergies)),
      FieldRow(label: 'Medicação', value: s(WizardKeys.medication)),
      FieldRow(
        label: 'NEE',
        value: values[WizardKeys.hasSpecialNeeds] == true ? 'Sim' : 'Não',
      ),
      const SizedBox(height: AppSpacing.md),
      Text('Documentos', style: title),
      FieldRow(
        label: 'Entregues',
        value: documents.isEmpty
            ? null
            : documents.map(documentTypeLabel).join(', '),
      ),
    ],
  );
}
