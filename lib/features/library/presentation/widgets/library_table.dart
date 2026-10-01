import 'package:flutter/material.dart';

import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/library_models.dart';

String copyStatusLabel(CopyStatus s) => switch (s) {
  CopyStatus.available => 'Disponível',
  CopyStatus.loaned => 'Emprestado',
  CopyStatus.reserved => 'Reservado',
  CopyStatus.lost => 'Perdido',
  CopyStatus.damaged => 'Danificado',
};

BadgeStatus copyStatusBadge(CopyStatus s) => switch (s) {
  CopyStatus.available => BadgeStatus.success,
  CopyStatus.loaned => BadgeStatus.info,
  CopyStatus.reserved => BadgeStatus.warning,
  CopyStatus.lost || CopyStatus.damaged => BadgeStatus.danger,
};

String loanStatusLabel(LoanStatus s) => switch (s) {
  LoanStatus.active => 'Em curso',
  LoanStatus.overdue => 'Em atraso',
  LoanStatus.returned => 'Devolvido',
};

BadgeStatus loanStatusBadge(LoanStatus s) => switch (s) {
  LoanStatus.active => BadgeStatus.info,
  LoanStatus.overdue => BadgeStatus.danger,
  LoanStatus.returned => BadgeStatus.neutral,
};

String fineStatusLabel(FineStatus s) => switch (s) {
  FineStatus.pending => 'Por pagar',
  FineStatus.paid => 'Paga',
};

BadgeStatus fineStatusBadge(FineStatus s) => switch (s) {
  FineStatus.pending => BadgeStatus.danger,
  FineStatus.paid => BadgeStatus.success,
};

String reservationStatusLabel(ReservationStatus s) => switch (s) {
  ReservationStatus.pending => 'Em espera',
  ReservationStatus.ready => 'Pronta a levantar',
  ReservationStatus.fulfilled => 'Concluída',
  ReservationStatus.cancelled => 'Cancelada',
};

BadgeStatus reservationStatusBadge(ReservationStatus s) => switch (s) {
  ReservationStatus.pending => BadgeStatus.warning,
  ReservationStatus.ready => BadgeStatus.success,
  ReservationStatus.fulfilled => BadgeStatus.neutral,
  ReservationStatus.cancelled => BadgeStatus.neutral,
};

/// Coluna "Estado" com selo, partilhada pelas tabelas do módulo.
AppColumn<T> statusColumn<T>({
  required String Function(T) label,
  required BadgeStatus Function(T) badge,
  required int Function(T) order,
}) => AppColumn<T>(
  label: 'Estado',
  text: label,
  sortValue: order,
  cell: (row) => StatusBadge(label: label(row), status: badge(row)),
);

/// Tabela do módulo: recria o controller quando as linhas mudam.
class LibraryTable<T> extends StatefulWidget {
  const LibraryTable({
    super.key,
    required this.items,
    required this.rowId,
    required this.columns,
    required this.emptyText,
    this.rowActions = const [],
  });

  final List<T> items;
  final String Function(T) rowId;
  final List<AppColumn<T>> columns;
  final String emptyText;
  final List<RowAction<T>> rowActions;

  @override
  State<LibraryTable<T>> createState() => _LibraryTableState<T>();
}

class _LibraryTableState<T> extends State<LibraryTable<T>> {
  late final TableController<T> _table = TableController(
    rows: widget.items,
    rowId: widget.rowId,
    columns: widget.columns,
  );

  @override
  void didUpdateWidget(LibraryTable<T> old) {
    super.didUpdateWidget(old);
    if (old.items != widget.items) _table.setRows(widget.items);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<T>(
    controller: _table,
    selectable: false,
    emptyText: widget.emptyText,
    rowActions: widget.rowActions,
  );
}
