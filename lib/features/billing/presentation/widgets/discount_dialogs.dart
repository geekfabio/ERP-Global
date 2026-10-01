import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/charge.dart';
import '../../domain/discounts.dart';
import '../../domain/invoicing.dart';
import '../providers/payment_providers.dart';
import 'payment_dialogs.dart' show shortId;

/// Dados recolhidos para pedir um desconto.
class DiscountRequest {
  const DiscountRequest({
    required this.studentId,
    required this.kind,
    required this.reason,
    required this.value,
    required this.validFrom,
    this.feeType,
    this.validUntil,
    this.note,
  });

  final String studentId;
  final DiscountKind kind;
  final DiscountReason reason;

  /// Pontos base (percentagem) ou menor unidade (valor fixo).
  final int value;
  final FeeType? feeType;
  final DateTime validFrom;
  final DateTime? validUntil;
  final String? note;
}

/// Converte o texto de uma percentagem (`12,5`) em pontos base; `null` se
/// inválido ou fora de 0,01..100.
int? parsePercentBp(String text) {
  final t = text.trim().replaceAll(',', '.');
  final v = double.tryParse(t);
  if (v == null) return null;
  final bp = (v * 100).round();
  return bp < 1 || bp > 10000 ? null : bp;
}

Future<DiscountRequest?> showDiscountRequestDialog(BuildContext context) =>
    showDialog<DiscountRequest>(
      context: context,
      builder: (_) => const _DiscountRequestDialog(),
    );

class _DiscountRequestDialog extends ConsumerStatefulWidget {
  const _DiscountRequestDialog();

  @override
  ConsumerState<_DiscountRequestDialog> createState() =>
      _DiscountRequestDialogState();
}

class _DiscountRequestDialogState
    extends ConsumerState<_DiscountRequestDialog> {
  String? _studentId;
  DiscountKind _kind = DiscountKind.percentage;
  DiscountReason _reason = DiscountReason.sibling;
  FeeType? _feeType = FeeType.tuition;
  DateTime _from = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime? _until;
  int? _fixedMinor;
  final _percent = TextEditingController();
  final _note = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _percent.dispose();
    _note.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _kind == DiscountKind.percentage
        ? parsePercentBp(_percent.text)
        : _fixedMinor;
    String? error;
    if (_studentId == null) {
      error = 'Escolha o aluno';
    } else if (value == null || value <= 0) {
      error = _kind == DiscountKind.percentage
          ? 'Indique uma percentagem entre 0,01 e 100'
          : 'Indique um valor válido';
    } else if (_until != null && _until!.isBefore(_from)) {
      error = 'A validade termina antes de começar';
    }
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(
      DiscountRequest(
        studentId: _studentId!,
        kind: _kind,
        reason: _reason,
        value: value!,
        feeType: _feeType,
        validFrom: _from,
        validUntil: _until,
        note: _note.text.trim().isEmpty ? null : _note.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charges = ref.watch(openChargesProvider);
    return AlertDialog(
      title: const Text('Pedir desconto ou bolsa'),
      content: SizedBox(
        width: 460,
        child: AsyncValueView<List<Charge>>(
          value: charges,
          onRetry: () => ref.invalidate(openChargesProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.sell_outlined,
            title: 'Sem alunos com cobranças',
          ),
          data: (list) {
            final students = {for (final c in list) c.studentId}.toList()
              ..sort();
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    key: const Key('field_student'),
                    initialValue: _studentId,
                    decoration: const InputDecoration(labelText: 'Aluno'),
                    items: [
                      for (final s in students)
                        DropdownMenuItem(
                          value: s,
                          child: Text('Aluno ${shortId(s)}'),
                        ),
                    ],
                    onChanged: (v) => setState(() {
                      _studentId = v;
                      _error = null;
                    }),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<DiscountReason>(
                    key: const Key('field_reason'),
                    initialValue: _reason,
                    decoration: const InputDecoration(labelText: 'Motivo'),
                    items: [
                      for (final r in DiscountReason.values)
                        DropdownMenuItem(
                          value: r,
                          child: Text(discountReasonLabels[r]!),
                        ),
                    ],
                    onChanged: (v) => setState(() => _reason = v!),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<DiscountKind>(
                    key: const Key('field_kind'),
                    initialValue: _kind,
                    decoration: const InputDecoration(labelText: 'Desconto'),
                    items: const [
                      DropdownMenuItem(
                        value: DiscountKind.percentage,
                        child: Text('Percentagem'),
                      ),
                      DropdownMenuItem(
                        value: DiscountKind.fixed,
                        child: Text('Valor fixo por cobrança'),
                      ),
                    ],
                    onChanged: (v) => setState(() => _kind = v!),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  if (_kind == DiscountKind.percentage)
                    AppTextField(
                      key: const Key('field_percent'),
                      label: 'Percentagem',
                      controller: _percent,
                      hintText: '10',
                      helperText: 'Em %',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                    )
                  else
                    AppMoneyField(
                      key: const Key('field_amount'),
                      required: true,
                      onChanged: (v) => _fixedMinor = v,
                    ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<FeeType?>(
                    key: const Key('field_fee_type'),
                    initialValue: _feeType,
                    decoration: const InputDecoration(labelText: 'Aplica-se a'),
                    items: [
                      const DropdownMenuItem<FeeType?>(
                        child: Text('Todas as cobranças'),
                      ),
                      for (final t in FeeType.values)
                        DropdownMenuItem<FeeType?>(
                          value: t,
                          child: Text(feeTypeLabelsPt[t]!),
                        ),
                    ],
                    onChanged: (v) => setState(() => _feeType = v),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppDateField(
                    label: 'Válido desde',
                    value: _from,
                    onChanged: (d) => setState(() => _from = d),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppDateField(
                    label: 'Válido até (opcional)',
                    value: _until,
                    firstDate: _from,
                    onChanged: (d) => setState(() => _until = d),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppTextField(
                    key: const Key('field_note'),
                    label: 'Nota (opcional)',
                    controller: _note,
                    maxLines: 2,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _error!,
                      key: const Key('discount_error'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Pedir')),
      ],
    );
  }
}

/// Texto do valor do desconto (`10 %` ou `5 000,00 Kz`).
String discountValueLabel(DiscountKind kind, int value) =>
    kind == DiscountKind.percentage
    ? '${(value / 100).toString().replaceAll('.', ',').replaceAll(RegExp(r',0$'), '')} %'
    : PtAoFormatters.currency(value);
