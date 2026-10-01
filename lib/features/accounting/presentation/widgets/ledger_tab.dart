import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/journal_models.dart';
import '../providers/accounting_providers.dart';
import 'period_bar.dart';

/// Razão: movimentos e saldo acumulado de uma conta (e subcontas).
class LedgerTab extends ConsumerStatefulWidget {
  const LedgerTab({super.key});

  @override
  ConsumerState<LedgerTab> createState() => _LedgerTabState();
}

class _LedgerTabState extends ConsumerState<LedgerTab> {
  String? _accountId;
  ReportPeriod _period = (from: null, to: null);

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountListProvider).value ?? const [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.md,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 360,
                child: DropdownButtonFormField<String>(
                  key: const Key('ledger_account'),
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Conta'),
                  initialValue: _accountId,
                  items: [
                    for (final a in accounts)
                      DropdownMenuItem(
                        value: a.id,
                        child: Text('${a.code} · ${a.name}'),
                      ),
                  ],
                  onChanged: (v) => setState(() => _accountId = v),
                ),
              ),
              PeriodBar(
                period: _period,
                onChanged: (p) => setState(() => _period = p),
              ),
            ],
          ),
        ),
        Expanded(
          child: _accountId == null
              ? const EmptyState(
                  icon: Icons.account_tree_outlined,
                  title: 'Escolha uma conta',
                )
              : AsyncValueView<LedgerModel>(
                  value: ref.watch(
                    ledgerProvider((accountId: _accountId!, period: _period)),
                  ),
                  onRetry: () => ref.invalidate(ledgerProvider),
                  data: _table,
                ),
        ),
      ],
    );
  }

  Widget _table(LedgerModel ledger) => SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Data')),
          DataColumn(label: Text('N.º')),
          DataColumn(label: Text('Descrição')),
          DataColumn(label: Text('Débito'), numeric: true),
          DataColumn(label: Text('Crédito'), numeric: true),
          DataColumn(label: Text('Saldo'), numeric: true),
        ],
        rows: [
          DataRow(
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('Saldo anterior')),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(formatSigned(ledger.openingMinor))),
            ],
          ),
          for (final l in ledger.lines)
            DataRow(
              cells: [
                DataCell(Text(PtAoFormatters.date(l.date))),
                DataCell(Text('${l.number}')),
                DataCell(Text(l.description)),
                DataCell(
                  Text(
                    l.debitMinor == 0
                        ? ''
                        : PtAoFormatters.currency(l.debitMinor),
                  ),
                ),
                DataCell(
                  Text(
                    l.creditMinor == 0
                        ? ''
                        : PtAoFormatters.currency(l.creditMinor),
                  ),
                ),
                DataCell(Text(formatSigned(l.balanceMinor))),
              ],
            ),
          DataRow(
            cells: [
              const DataCell(Text('')),
              const DataCell(Text('')),
              const DataCell(Text('Totais')),
              DataCell(Text(PtAoFormatters.currency(ledger.debitMinor))),
              DataCell(Text(PtAoFormatters.currency(ledger.creditMinor))),
              DataCell(
                Text(
                  key: const Key('ledger_closing'),
                  formatSigned(ledger.closingMinor),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
