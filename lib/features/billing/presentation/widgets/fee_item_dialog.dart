import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/inputs/money_parser.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/fee_item.dart';
import '../pages/billing_page.dart';

/// Diálogo de novo preço; devolve o rascunho (`id` vazio) ou `null`.
Future<FeeItem?> showFeeItemDialog(BuildContext context) =>
    showDialog<FeeItem>(context: context, builder: (_) => const _Dialog());

class _Dialog extends StatefulWidget {
  const _Dialog();

  @override
  State<_Dialog> createState() => _DialogState();
}

class _DialogState extends State<_Dialog> {
  final _key = GlobalKey<FormState>();
  final _amount = TextEditingController();
  String _grade = MockRef.gradeId(1);
  FeeType _type = FeeType.tuition;
  bool _allCampuses = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_key.currentState!.validate()) return;
    final now = DateTime.now().toUtc();
    Navigator.of(context).pop(
      FeeItem(
        id: '',
        institutionId: MockRef.institutionId,
        campusId: _allCampuses ? null : MockRef.campusId,
        createdAt: now,
        updatedAt: now,
        academicYearId: MockRef.academicYearId,
        gradeId: _grade,
        type: _type,
        amountMinor: parseMinorUnits(_amount.text) ?? 0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Novo preço'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                key: const Key('field_grade'),
                initialValue: _grade,
                decoration: const InputDecoration(labelText: 'Classe'),
                items: [
                  for (var i = 0; i < MockRef.gradeCount; i++)
                    DropdownMenuItem(
                      value: MockRef.gradeId(i),
                      child: Text(MockRef.gradeLabel(i)),
                    ),
                ],
                onChanged: (v) => setState(() => _grade = v!),
              ),
              const SizedBox(height: AppSpacing.md),
              DropdownButtonFormField<FeeType>(
                key: const Key('field_type'),
                initialValue: _type,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final t in FeeType.values)
                    DropdownMenuItem(value: t, child: Text(feeTypeLabels[t]!)),
                ],
                onChanged: (v) => setState(() => _type = v!),
              ),
              const SizedBox(height: AppSpacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Aplicar a todos os campus'),
                value: _allCampuses,
                onChanged: (v) => setState(() => _allCampuses = v),
              ),
              AppMoneyField(
                key: const Key('field_amount'),
                controller: _amount,
                required: true,
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
