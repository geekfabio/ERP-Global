import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/charge.dart';
import '../../domain/invoicing.dart';
import '../providers/invoice_providers.dart';

/// Dados recolhidos para emitir uma factura.
class IssueInvoiceRequest {
  const IssueInvoiceRequest({
    required this.studentId,
    required this.chargeIds,
    required this.taxRateBp,
    this.exemptionReason,
  });

  final String studentId;
  final List<String> chargeIds;
  final int taxRateBp;
  final String? exemptionReason;
}

Future<IssueInvoiceRequest?> showIssueInvoiceDialog(BuildContext context) =>
    showDialog<IssueInvoiceRequest>(
      context: context,
      builder: (_) => const _Dialog(),
    );

class _Dialog extends ConsumerStatefulWidget {
  const _Dialog();

  @override
  ConsumerState<_Dialog> createState() => _DialogState();
}

class _DialogState extends ConsumerState<_Dialog> {
  final _selected = <String>{};
  final _reason = TextEditingController();
  String? _studentId;
  int _rate = vatRatesBp.first;
  String? _error;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  void _toggle(Charge c, bool on) => setState(() {
    if (on) {
      _selected.add(c.id);
      _studentId = c.studentId;
    } else {
      _selected.remove(c.id);
      if (_selected.isEmpty) _studentId = null;
    }
    _error = null;
  });

  void _submit() {
    if (_selected.isEmpty) {
      setState(() => _error = 'Seleccione pelo menos uma cobrança');
      return;
    }
    if (_rate == 0 && _reason.text.trim().isEmpty) {
      setState(() => _error = 'Indique o motivo da isenção');
      return;
    }
    Navigator.of(context).pop(
      IssueInvoiceRequest(
        studentId: _studentId!,
        chargeIds: _selected.toList(),
        taxRateBp: _rate,
        exemptionReason: _rate == 0 ? _reason.text.trim() : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final charges = ref.watch(invoiceableChargesProvider);
    return AlertDialog(
      title: const Text('Emitir factura'),
      content: SizedBox(
        width: 480,
        child: AsyncValueView<List<Charge>>(
          value: charges,
          onRetry: () => ref.invalidate(invoiceableChargesProvider),
          isEmpty: (d) => d.isEmpty,
          empty: const EmptyState(
            icon: Icons.receipt_long_outlined,
            title: 'Sem cobranças por facturar',
          ),
          data: (list) => SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Cobranças (do mesmo aluno)',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                for (final c in list)
                  CheckboxListTile(
                    key: Key('charge_${c.id}'),
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _selected.contains(c.id),
                    onChanged: _studentId != null && _studentId != c.studentId
                        ? null
                        : (v) => _toggle(c, v ?? false),
                    title: Text(
                      PtAoFormatters.currency(c.amountMinor - c.discountMinor),
                    ),
                    subtitle: Text(
                      'Vence em ${PtAoFormatters.date(c.dueDate)} · aluno '
                      '${c.studentId.substring(c.studentId.length > 8 ? c.studentId.length - 8 : 0)}',
                    ),
                  ),
                const SizedBox(height: AppSpacing.md),
                DropdownButtonFormField<int>(
                  key: const Key('field_vat'),
                  initialValue: _rate,
                  decoration: const InputDecoration(labelText: 'IVA'),
                  items: [
                    for (final r in vatRatesBp)
                      DropdownMenuItem(value: r, child: Text(vatRateLabel(r))),
                  ],
                  onChanged: (v) => setState(() => _rate = v!),
                ),
                if (_rate == 0) ...[
                  const SizedBox(height: AppSpacing.md),
                  TextField(
                    key: const Key('field_exemption'),
                    controller: _reason,
                    decoration: const InputDecoration(
                      labelText: 'Motivo da isenção',
                    ),
                  ),
                ],
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
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
        FilledButton(onPressed: _submit, child: const Text('Emitir')),
      ],
    );
  }
}

/// Pede o motivo da anulação; `null` se cancelado.
Future<String?> showCancelInvoiceDialog(BuildContext context, String number) =>
    showDialog<String>(
      context: context,
      builder: (_) => _CancelDialog(number: number),
    );

class _CancelDialog extends StatefulWidget {
  const _CancelDialog({required this.number});

  final String number;

  @override
  State<_CancelDialog> createState() => _CancelDialogState();
}

class _CancelDialogState extends State<_CancelDialog> {
  final _key = GlobalKey<FormState>();
  final _reason = TextEditingController();

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text('Anular ${widget.number}'),
    content: SizedBox(
      width: 420,
      child: Form(
        key: _key,
        child: TextFormField(
          key: const Key('field_cancel_reason'),
          controller: _reason,
          maxLines: 3,
          decoration: const InputDecoration(
            labelText: 'Motivo da anulação',
            helperText: 'Será emitida uma nota de crédito.',
          ),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Campo obrigatório' : null,
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Voltar'),
      ),
      FilledButton(
        onPressed: () {
          if (_key.currentState!.validate()) {
            Navigator.of(context).pop(_reason.text.trim());
          }
        },
        child: const Text('Anular'),
      ),
    ],
  );
}
