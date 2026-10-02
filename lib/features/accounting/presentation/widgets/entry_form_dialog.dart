import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../data/models/accounting_models.dart';
import '../../data/models/journal_models.dart';
import '../../domain/journal_rules.dart';

/// Diálogo de novo lançamento: só deixa guardar com débito = crédito.
Future<JournalEntryModel?> showEntryForm(
  BuildContext context, {
  required List<AccountModel> accounts,
}) => showDialog<JournalEntryModel>(
  context: context,
  builder: (_) => _EntryDialog(
    accounts: [
      for (final a in accounts)
        if (a.postable && a.isActive) a,
    ],
  ),
);

class _LineDraft {
  String? accountId;
  final debit = TextEditingController();
  final credit = TextEditingController();

  JournalLineModel toModel() => JournalLineModel(
    accountId: accountId ?? '',
    debitMinor: JournalRules.parseMinor(debit.text) ?? 0,
    creditMinor: JournalRules.parseMinor(credit.text) ?? 0,
  );
}

class _EntryDialog extends StatefulWidget {
  const _EntryDialog({required this.accounts});

  final List<AccountModel> accounts;

  @override
  State<_EntryDialog> createState() => _EntryDialogState();
}

class _EntryDialogState extends State<_EntryDialog> {
  final _description = TextEditingController();
  final _lines = [_LineDraft(), _LineDraft()];
  DateTime? _date;

  @override
  void dispose() {
    _description.dispose();
    for (final l in _lines) {
      l.debit.dispose();
      l.credit.dispose();
    }
    super.dispose();
  }

  List<JournalLineModel> get _models => [for (final l in _lines) l.toModel()];

  bool get _valid =>
      _date != null &&
      _description.text.trim().isNotEmpty &&
      _models.every((l) => l.accountId.isNotEmpty) &&
      JournalRules.validate(_models).isEmpty;

  void _submit() => Navigator.of(context).pop(
    JournalEntryModel(
      id: '',
      date: _date!,
      description: _description.text.trim(),
      lines: _models,
    ),
  );

  Widget _amount(String key, TextEditingController c, String label) => SizedBox(
    width: 130,
    child: TextField(
      key: Key(key),
      controller: c,
      decoration: InputDecoration(labelText: label),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (_) => setState(() {}),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final models = _models;
    final debit = JournalRules.totalDebit(models);
    final credit = JournalRules.totalCredit(models);
    return AlertDialog(
      title: const Text('Novo lançamento'),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppDateField(
                key: const Key('field_date'),
                label: 'Data',
                value: _date,
                onChanged: (d) => setState(() => _date = d),
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                key: const Key('field_description'),
                controller: _description,
                decoration: const InputDecoration(labelText: 'Descrição'),
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: AppSpacing.md),
              for (var i = 0; i < _lines.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          key: Key('line_${i}_account'),
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Conta'),
                          initialValue: _lines[i].accountId,
                          items: [
                            for (final a in widget.accounts)
                              DropdownMenuItem(
                                value: a.id,
                                child: Text('${a.code} · ${a.name}'),
                              ),
                          ],
                          onChanged: (v) =>
                              setState(() => _lines[i].accountId = v),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      _amount('line_${i}_debit', _lines[i].debit, 'Débito'),
                      const SizedBox(width: AppSpacing.sm),
                      _amount('line_${i}_credit', _lines[i].credit, 'Crédito'),
                      IconButton(
                        tooltip: 'Remover linha',
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _lines.length > 2
                            ? () => setState(() => _lines.removeAt(i))
                            : null,
                      ),
                    ],
                  ),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() => _lines.add(_LineDraft())),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar linha'),
                ),
              ),
              Text(
                key: const Key('entry_total'),
                'Débito ${PtAoFormatters.currency(debit)} · '
                'Crédito ${PtAoFormatters.currency(credit)}'
                '${debit == credit ? '' : ' · Diferença ${PtAoFormatters.currency((debit - credit).abs())}'}',
                style: Theme.of(context).textTheme.titleSmall,
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
          key: const Key('entry_save'),
          onPressed: _valid ? _submit : null,
          child: const Text('Lançar'),
        ),
      ],
    );
  }
}
