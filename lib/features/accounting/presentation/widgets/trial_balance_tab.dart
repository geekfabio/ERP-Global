import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/journal_models.dart';
import '../providers/accounting_providers.dart';
import 'period_bar.dart';

/// Balancete: movimentos e saldos por conta, com totais a débito e a crédito.
class TrialBalanceTab extends ConsumerStatefulWidget {
  const TrialBalanceTab({super.key});

  @override
  ConsumerState<TrialBalanceTab> createState() => _TrialBalanceTabState();
}

class _TrialBalanceTabState extends ConsumerState<TrialBalanceTab> {
  ReportPeriod _period = (from: null, to: null);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Align(
          alignment: Alignment.centerLeft,
          child: PeriodBar(
            period: _period,
            onChanged: (p) => setState(() => _period = p),
          ),
        ),
      ),
      Expanded(
        child: AsyncValueView<TrialBalanceModel>(
          value: ref.watch(trialBalanceProvider(_period)),
          onRetry: () => ref.invalidate(trialBalanceProvider),
          isEmpty: (d) => d.rows.isEmpty,
          empty: const EmptyState(
            icon: Icons.balance_outlined,
            title: 'Sem movimentos no período',
          ),
          data: _table,
        ),
      ),
    ],
  );

  Widget _table(TrialBalanceModel tb) => SingleChildScrollView(
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('Conta')),
          DataColumn(label: Text('Saldo anterior'), numeric: true),
          DataColumn(label: Text('Débito'), numeric: true),
          DataColumn(label: Text('Crédito'), numeric: true),
          DataColumn(label: Text('Saldo final'), numeric: true),
        ],
        rows: [
          for (final r in tb.rows)
            DataRow(
              cells: [
                DataCell(
                  Text(key: Key('tb_${r.code}'), '${r.code} · ${r.name}'),
                ),
                DataCell(Text(formatSigned(r.openingMinor))),
                DataCell(Text(PtAoFormatters.currency(r.debitMinor))),
                DataCell(Text(PtAoFormatters.currency(r.creditMinor))),
                DataCell(Text(formatSigned(r.closingMinor))),
              ],
            ),
          DataRow(
            cells: [
              const DataCell(Text('Totais')),
              const DataCell(Text('')),
              DataCell(
                Text(
                  key: const Key('tb_total_debit'),
                  PtAoFormatters.currency(tb.totalDebitMinor),
                ),
              ),
              DataCell(
                Text(
                  key: const Key('tb_total_credit'),
                  PtAoFormatters.currency(tb.totalCreditMinor),
                ),
              ),
              const DataCell(Text('')),
            ],
          ),
        ],
      ),
    ),
  );
}
