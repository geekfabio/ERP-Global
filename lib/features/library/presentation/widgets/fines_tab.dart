import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/library_models.dart';
import '../providers/library_providers.dart';
import 'library_form_dialog.dart';
import 'library_table.dart';

/// Multas por atraso; o leitor com multas por pagar fica sem novos empréstimos.
class FinesTab extends ConsumerStatefulWidget {
  const FinesTab({super.key});

  @override
  ConsumerState<FinesTab> createState() => _FinesTabState();
}

class _FinesTabState extends ConsumerState<FinesTab> {
  void _refresh() => ref.invalidate(fineListProvider);

  Future<void> _pay(FineModel fine) async {
    if (fine.status == FineStatus.paid) return;
    final ok = await showConfirmDialog(
      context: context,
      title: 'Registar pagamento',
      message:
          'Receber ${PtAoFormatters.currency(fine.amountCents)} de '
          '${fine.borrowerName}?',
      confirmLabel: 'Receber',
    );
    if (!ok) return;
    final result = await ref
        .read(circulationRepositoryProvider)
        .payFine(fine.id);
    if (reportResult(ref, result, done: 'Multa paga')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final fines = ref.watch(fineListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AsyncValueView<List<FineModel>>(
        value: fines,
        onRetry: _refresh,
        isEmpty: (d) => d.isEmpty,
        empty: const EmptyState(
          icon: Icons.payments_outlined,
          title: 'Sem multas',
        ),
        data: (items) => LibraryTable<FineModel>(
          items: items,
          rowId: (f) => f.id,
          emptyText: 'Sem multas',
          columns: [
            AppColumn(
              label: 'Leitor',
              text: (f) => f.borrowerName,
              sortValue: (f) => f.borrowerName,
            ),
            AppColumn(label: 'Obra', text: (f) => f.bookTitle),
            AppColumn(
              label: 'Dias de atraso',
              text: (f) => '${f.daysLate}',
              sortValue: (f) => f.daysLate,
              numeric: true,
            ),
            AppColumn(
              label: 'Valor',
              text: (f) => PtAoFormatters.currency(f.amountCents),
              sortValue: (f) => f.amountCents,
              numeric: true,
            ),
            statusColumn<FineModel>(
              label: (f) => fineStatusLabel(f.status),
              badge: (f) => fineStatusBadge(f.status),
              order: (f) => f.status.index,
            ),
          ],
          rowActions: [
            if (can('library.fine.pay'))
              RowAction(
                label: 'Registar pagamento',
                icon: Icons.paid_outlined,
                onTap: _pay,
              ),
          ],
        ),
      ),
    );
  }
}
