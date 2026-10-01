import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/billing_enums.dart';
import '../../data/models/cash_register.dart';
import '../../data/models/cash_session.dart';
import '../providers/cash_providers.dart';
import '../widgets/cash_dialogs.dart';

/// Caixa: abertura/fecho por operador, sangrias, reforços, conferência e
/// relatório de fecho em PDF.
class CashPage extends ConsumerStatefulWidget {
  const CashPage({super.key});

  @override
  ConsumerState<CashPage> createState() => _CashPageState();
}

class _CashPageState extends ConsumerState<CashPage> {
  void _refresh() => ref.invalidate(cashSessionsProvider);

  Future<void> _open() async {
    final toast = ref.read(toastProvider.notifier);
    final registers = (await ref.read(cashRepositoryProvider).registers()).when(
      ok: (r) => r,
      err: (_) => <CashRegister>[],
    );
    if (!mounted) return;
    final req = await showOpenCashDialog(context, registers);
    if (req == null) return;
    final result = await ref
        .read(cashRepositoryProvider)
        .open(
          cashRegisterId: req.cashRegisterId,
          operatorId: ref.read(cashOperatorIdProvider),
          openingMinor: req.openingMinor,
        );
    result.when(
      ok: (_) => toast.success('Caixa aberto'),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final sessions = ref.watch(cashSessionsProvider);
    final registers =
        ref.watch(cashRegistersProvider).asData?.value ?? const [];
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Caixa',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  Can(
                    permission: cashWritePermission,
                    child: AppButton(
                      label: 'Abrir caixa',
                      icon: Icons.lock_open_outlined,
                      onPressed: _open,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<CashSession>>(
                  value: sessions,
                  onRetry: _refresh,
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.point_of_sale_outlined,
                    title: 'Sem sessões de caixa',
                  ),
                  data: (d) => _SessionTable(sessions: d, registers: registers),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionTable extends ConsumerStatefulWidget {
  const _SessionTable({required this.sessions, required this.registers});

  final List<CashSession> sessions;
  final List<CashRegister> registers;

  @override
  ConsumerState<_SessionTable> createState() => _SessionTableState();
}

class _SessionTableState extends ConsumerState<_SessionTable> {
  String _registerName(String id) =>
      widget.registers
          .where((r) => r.id == id)
          .map((r) => r.name)
          .firstOrNull ??
      cashShortId(id);

  late final TableController<CashSession> _table = TableController(
    rows: widget.sessions,
    rowId: (s) => s.id,
    columns: [
      AppColumn(
        label: 'Abertura',
        text: (s) => PtAoFormatters.dateTime(s.openedAt),
        sortValue: (s) => s.openedAt,
      ),
      AppColumn(label: 'Caixa', text: (s) => _registerName(s.cashRegisterId)),
      AppColumn(label: 'Operador', text: (s) => cashShortId(s.operatorId)),
      AppColumn(
        label: 'Estado',
        text: (s) => s.status == CashSessionStatus.open ? 'Aberta' : 'Fechada',
      ),
      AppColumn(
        label: 'Fundo',
        text: (s) => PtAoFormatters.currency(s.openingMinor),
        numeric: true,
      ),
      AppColumn(
        label: 'Contado',
        text: (s) => s.countedMinor == null
            ? '-'
            : PtAoFormatters.currency(s.countedMinor!),
        numeric: true,
      ),
      AppColumn(
        label: 'Diferença',
        text: (s) => s.differenceMinor == null
            ? '-'
            : PtAoFormatters.currency(s.differenceMinor!),
        numeric: true,
      ),
    ],
  );

  @override
  void didUpdateWidget(_SessionTable old) {
    super.didUpdateWidget(old);
    if (old.sessions != widget.sessions) _table.setRows(widget.sessions);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final can = ref.watch(permissionServiceProvider).canAny;
    return AppDataTable<CashSession>(
      controller: _table,
      selectable: false,
      emptyText: 'Sem sessões de caixa',
      rowActions: [
        if (can(cashReadPermission))
          RowAction(
            label: 'Movimentos',
            icon: Icons.receipt_long_outlined,
            onTap: (s) => showCashSessionDialog(context, s),
          ),
        if (can(cashReadPermission))
          RowAction(
            label: 'Fecho em PDF',
            icon: Icons.picture_as_pdf_outlined,
            onTap: (s) {
              if (s.status == CashSessionStatus.closed) {
                ref.read(cashReportPdfServiceProvider).exportClosing(s);
              } else {
                ref
                    .read(toastProvider.notifier)
                    .error('Feche o caixa para gerar o relatório.');
              }
            },
          ),
      ],
    );
  }
}
