import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/library_models.dart';
import '../providers/library_providers.dart';
import 'library_form_dialog.dart';
import 'library_table.dart';

/// Reservas de obras sem exemplar disponível (criam-se no acervo).
class ReservationsTab extends ConsumerStatefulWidget {
  const ReservationsTab({super.key});

  @override
  ConsumerState<ReservationsTab> createState() => _ReservationsTabState();
}

class _ReservationsTabState extends ConsumerState<ReservationsTab> {
  void _refresh() => ref
    ..invalidate(reservationListProvider)
    ..invalidate(bookListProvider);

  Future<void> _cancel(ReservationModel r) async {
    if (r.status == ReservationStatus.fulfilled ||
        r.status == ReservationStatus.cancelled) {
      return;
    }
    final result = await ref
        .read(circulationRepositoryProvider)
        .cancelReservation(r.id);
    if (reportResult(ref, result, done: 'Reserva cancelada')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final reservations = ref.watch(reservationListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md),
      child: AsyncValueView<List<ReservationModel>>(
        value: reservations,
        onRetry: _refresh,
        isEmpty: (d) => d.isEmpty,
        empty: const EmptyState(
          icon: Icons.bookmark_outline,
          title: 'Sem reservas',
        ),
        data: (items) => LibraryTable<ReservationModel>(
          items: items,
          rowId: (r) => r.id,
          emptyText: 'Sem reservas',
          columns: [
            AppColumn(
              label: 'Obra',
              text: (r) => r.bookTitle,
              sortValue: (r) => r.bookTitle,
            ),
            AppColumn(
              label: 'Leitor',
              text: (r) => r.borrowerName,
              sortValue: (r) => r.borrowerName,
            ),
            AppColumn(
              label: 'Reservada em',
              text: (r) => PtAoFormatters.date(r.createdAt),
              sortValue: (r) => r.createdAt,
            ),
            statusColumn<ReservationModel>(
              label: (r) => reservationStatusLabel(r.status),
              badge: (r) => reservationStatusBadge(r.status),
              order: (r) => r.status.index,
            ),
          ],
          rowActions: [
            if (can('library.loan.create'))
              RowAction(
                label: 'Cancelar reserva',
                icon: Icons.bookmark_remove_outlined,
                onTap: _cancel,
              ),
          ],
        ),
      ),
    );
  }
}
