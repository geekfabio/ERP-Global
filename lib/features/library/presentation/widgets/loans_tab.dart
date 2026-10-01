import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/library_models.dart';
import '../providers/library_providers.dart';
import 'library_form_dialog.dart';
import 'library_table.dart';

/// Empréstimos e devoluções; o empréstimo identifica o leitor pelo cartão.
class LoansTab extends ConsumerStatefulWidget {
  const LoansTab({super.key});

  @override
  ConsumerState<LoansTab> createState() => _LoansTabState();
}

class _LoansTabState extends ConsumerState<LoansTab> {
  void _refresh() => ref
    ..invalidate(loanListProvider)
    ..invalidate(bookListProvider)
    ..invalidate(fineListProvider)
    ..invalidate(reservationListProvider);

  Future<void> _checkout() async {
    final v = await showLibraryForm(
      context,
      title: 'Novo empréstimo',
      subtitle: 'Leia o cartão do leitor e o código de barras do exemplar.',
      submitLabel: 'Emprestar',
      fields: const [
        LibraryField('cardUid', 'Cartão do leitor'),
        LibraryField('barcode', 'Código de barras do exemplar'),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(circulationRepositoryProvider)
        .checkout(
          cardUid: v['cardUid']! as String,
          barcode: v['barcode']! as String,
        );
    if (reportResult(ref, result, done: 'Empréstimo registado')) _refresh();
  }

  Future<void> _giveBack(LoanModel loan) async {
    if (loan.status == LoanStatus.returned) return;
    final result = await ref
        .read(circulationRepositoryProvider)
        .giveBack(loan.id);
    final fine = result.valueOrNull?.fineCents ?? 0;
    final done = fine > 0
        ? 'Devolvido com multa de ${PtAoFormatters.currency(fine)}'
        : 'Devolução registada';
    if (reportResult(ref, result, done: done)) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(loanListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'library.loan.create',
              child: AppButton(
                label: 'Novo empréstimo',
                icon: Icons.add,
                onPressed: _checkout,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<LoanModel>>(
            value: loans,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.swap_horiz,
              title: 'Sem empréstimos',
            ),
            data: (items) => LibraryTable<LoanModel>(
              items: items,
              rowId: (l) => l.id,
              emptyText: 'Sem empréstimos',
              columns: [
                AppColumn(
                  label: 'Obra',
                  text: (l) => l.bookTitle,
                  sortValue: (l) => l.bookTitle,
                ),
                AppColumn(label: 'Exemplar', text: (l) => l.barcode),
                AppColumn(
                  label: 'Leitor',
                  text: (l) => l.borrowerName,
                  sortValue: (l) => l.borrowerName,
                ),
                AppColumn(
                  label: 'Emprestado em',
                  text: (l) => PtAoFormatters.date(l.loanedAt),
                  sortValue: (l) => l.loanedAt,
                ),
                AppColumn(
                  label: 'Devolver até',
                  text: (l) => PtAoFormatters.date(l.dueAt),
                  sortValue: (l) => l.dueAt,
                ),
                statusColumn<LoanModel>(
                  label: (l) => loanStatusLabel(l.status),
                  badge: (l) => loanStatusBadge(l.status),
                  order: (l) => l.status.index,
                ),
              ],
              rowActions: [
                if (can('library.loan.create'))
                  RowAction(
                    label: 'Devolver',
                    icon: Icons.assignment_return_outlined,
                    onTap: _giveBack,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
