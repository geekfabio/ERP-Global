import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../domain/pauta.dart';

/// Pauta no ecrã: mesmos cabeçalhos e linhas do PDF e do Excel. Na pauta final
/// (`termIndex == null`) a coluna de resultado abre a decisão do conselho
/// quando [onDecide] é fornecido.
class PautaView extends StatelessWidget {
  const PautaView({
    super.key,
    required this.data,
    required this.termIndex,
    this.onDecide,
  });

  final PautaData data;
  final int? termIndex;
  final void Function(PautaRow row)? onDecide;

  @override
  Widget build(BuildContext context) {
    final headers = data.tableHeaders(termIndex);
    final rows = data.tableRows(termIndex);
    final scheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        key: const Key('pauta_table'),
        columns: [
          for (var i = 0; i < headers.length; i++)
            DataColumn(label: Text(headers[i]), numeric: i > 1),
        ],
        rows: [
          for (var r = 0; r < rows.length; r++)
            DataRow(
              cells: [
                for (var c = 0; c < headers.length; c++)
                  if (c == headers.length - 1 &&
                      termIndex == null &&
                      onDecide != null)
                    DataCell(
                      TextButton(
                        key: Key('pauta_decide_${data.rows[r].student.id}'),
                        onPressed: () => onDecide!(data.rows[r]),
                        child: Text(
                          rows[r][c],
                          style: TextStyle(
                            color: data.rows[r].decision != null
                                ? scheme.primary
                                : null,
                            fontWeight: data.rows[r].decision != null
                                ? FontWeight.bold
                                : null,
                          ),
                        ),
                      ),
                    )
                  else
                    DataCell(Text(rows[r][c])),
              ],
            ),
        ],
        columnSpacing: AppSpacing.lg,
      ),
    );
  }
}
