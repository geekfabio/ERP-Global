import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../providers/accounting_providers.dart';

/// Saldo em débito − crédito como `1 500,00 D` / `1 500,00 C`.
String formatSigned(int minor) => minor == 0
    ? PtAoFormatters.currency(0)
    : '${PtAoFormatters.currency(minor.abs())} ${minor > 0 ? 'D' : 'C'}';

/// Selector de período (de/até) dos relatórios; ambos opcionais.
class PeriodBar extends StatelessWidget {
  const PeriodBar({super.key, required this.period, required this.onChanged});

  final ReportPeriod period;
  final ValueChanged<ReportPeriod> onChanged;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      SizedBox(
        width: 180,
        child: AppDateField(
          key: const Key('period_from'),
          label: 'De',
          value: period.from,
          onChanged: (d) => onChanged((from: d, to: period.to)),
        ),
      ),
      const SizedBox(width: AppSpacing.md),
      SizedBox(
        width: 180,
        child: AppDateField(
          key: const Key('period_to'),
          label: 'Até',
          value: period.to,
          onChanged: (d) => onChanged((from: period.from, to: d)),
        ),
      ),
      if (period.from != null || period.to != null)
        IconButton(
          tooltip: 'Limpar período',
          icon: const Icon(Icons.clear),
          onPressed: () => onChanged((from: null, to: null)),
        ),
    ],
  );
}
