import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/network/mock/mock_reference_data.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/debtor.dart';
import '../../domain/debt.dart';
import '../providers/debt_providers.dart';
import '../widgets/debt_dialogs.dart';
import '../widgets/payment_dialogs.dart' show shortId;

/// Rótulo da turma (ex.: `3.ª classe A`) a partir do id de referência.
String classroomLabel(String? id) {
  if (id == null) return '-';
  for (var g = 0; g < MockRef.gradeCount; g++) {
    for (var l = 0; l < MockRef.classroomLetters.length; l++) {
      if (MockRef.classroomId(g, l) == id) {
        return '${MockRef.gradeLabel(g)} ${MockRef.classroomLetters[l]}';
      }
    }
  }
  return shortId(id);
}

/// Cobrança: devedores com filtros por turma e mês, avisos automáticos
/// pré/pós-vencimento e acordos de pagamento.
class DebtorsPage extends ConsumerStatefulWidget {
  const DebtorsPage({super.key});

  @override
  ConsumerState<DebtorsPage> createState() => _DebtorsPageState();
}

class _DebtorsPageState extends ConsumerState<DebtorsPage> {
  Future<void> _sendNotices() async {
    final result = await ref.read(noticeServiceProvider).run();
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (r) => toast.success(
        r.notices.isEmpty
            ? 'Sem avisos por enviar'
            : '${r.notices.length} aviso(s) enviado(s)'
                  '${r.viaCommunication ? ' pela comunicação' : ''}',
      ),
      err: (f) => toast.error(f.message),
    );
    ref.invalidate(noticeListProvider);
  }

  Future<void> _agree(Debtor d) async {
    if (d.hasAgreement) {
      ref
          .read(toastProvider.notifier)
          .error('Este aluno já tem um acordo em curso.');
      return;
    }
    final draft = await showAgreementDialog(context, studentId: d.studentId);
    if (draft == null) return;
    final result = await ref
        .read(debtRepositoryProvider)
        .createAgreement(
          studentId: d.studentId,
          installmentCount: draft.installments,
          firstDueDate: draft.firstDue,
        );
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success('Acordo criado'),
      err: (f) => toast.error(f.message),
    );
    if (result.isOk) {
      ref
        ..invalidate(debtorListProvider)
        ..invalidate(agreementListProvider);
    }
  }

  @override
  Widget build(BuildContext context) {
    final debtors = ref.watch(debtorListProvider);
    final canManage = ref
        .watch(permissionServiceProvider)
        .canAny(debtorManagePermission);
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
                      'Devedores',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  IconButton(
                    tooltip: 'Avisos enviados',
                    icon: const Icon(Icons.history_outlined),
                    onPressed: () => showNoticesDialog(context),
                  ),
                  IconButton(
                    tooltip: 'Acordos',
                    icon: const Icon(Icons.handshake_outlined),
                    onPressed: () =>
                        showAgreementsDialog(context, canManage: canManage),
                  ),
                  Can(
                    permission: debtorManagePermission,
                    child: IconButton(
                      tooltip: 'Enviar avisos',
                      icon: const Icon(Icons.notifications_active_outlined),
                      onPressed: _sendNotices,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              const _Filters(),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: AsyncValueView<List<Debtor>>(
                  value: debtors,
                  onRetry: () => ref.invalidate(debtorListProvider),
                  isEmpty: (d) => d.isEmpty,
                  empty: const EmptyState(
                    icon: Icons.verified_outlined,
                    title: 'Sem devedores',
                  ),
                  data: (d) => _DebtorTable(
                    debtors: d,
                    canManage: canManage,
                    onAgree: _agree,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Filters extends ConsumerWidget {
  const _Filters();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(debtorFilterProvider);
    final notifier = ref.read(debtorFilterProvider.notifier);
    final now = DateTime.now();
    final months = [
      for (var i = 0; i < 12; i++)
        addMonths(DateTime.utc(now.year, now.month), -i),
    ];
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: [
        SizedBox(
          width: 240,
          child: DropdownButtonFormField<String?>(
            key: const Key('filter_classroom'),
            initialValue: filter.classroomId,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Turma'),
            items: [
              const DropdownMenuItem<String?>(child: Text('Todas')),
              for (var g = 0; g < MockRef.gradeCount; g++)
                for (var l = 0; l < MockRef.classroomLetters.length; l++)
                  DropdownMenuItem<String?>(
                    value: MockRef.classroomId(g, l),
                    child: Text(
                      '${MockRef.gradeLabel(g)} ${MockRef.classroomLetters[l]}',
                    ),
                  ),
            ],
            onChanged: notifier.setClassroom,
          ),
        ),
        SizedBox(
          width: 240,
          child: DropdownButtonFormField<String?>(
            key: const Key('filter_month'),
            initialValue: filter.month,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Mês de vencimento'),
            items: [
              const DropdownMenuItem<String?>(child: Text('Todos')),
              for (final m in months)
                DropdownMenuItem<String?>(
                  value: monthKey(m),
                  child: Text('${monthNamesPt[m.month - 1]} ${m.year}'),
                ),
            ],
            onChanged: notifier.setMonth,
          ),
        ),
      ],
    );
  }
}

class _DebtorTable extends StatefulWidget {
  const _DebtorTable({
    required this.debtors,
    required this.canManage,
    required this.onAgree,
  });

  final List<Debtor> debtors;
  final bool canManage;
  final void Function(Debtor) onAgree;

  @override
  State<_DebtorTable> createState() => _DebtorTableState();
}

class _DebtorTableState extends State<_DebtorTable> {
  late final TableController<Debtor> _table = TableController(
    rows: widget.debtors,
    rowId: (d) => d.studentId,
    columns: [
      AppColumn(label: 'Aluno', text: (d) => shortId(d.studentId)),
      AppColumn(
        label: 'Turma',
        text: (d) => classroomLabel(d.classroomId),
        sortValue: (d) => classroomLabel(d.classroomId),
      ),
      AppColumn(
        label: 'Em atraso',
        text: (d) => PtAoFormatters.currency(d.overdueMinor),
        sortValue: (d) => d.overdueMinor,
        numeric: true,
      ),
      AppColumn(
        label: 'Cobranças',
        text: (d) => '${d.overdueCount}',
        sortValue: (d) => d.overdueCount,
        numeric: true,
      ),
      AppColumn(
        label: 'Dias',
        text: (d) => '${d.daysOverdue}',
        sortValue: (d) => d.daysOverdue,
        numeric: true,
      ),
      AppColumn(
        label: 'Acordo',
        text: (d) => d.hasAgreement ? 'Em curso' : '-',
        cell: (d) => d.hasAgreement
            ? const StatusBadge(label: 'Em curso', status: BadgeStatus.info)
            : const Text('-'),
      ),
    ],
  );

  @override
  void didUpdateWidget(_DebtorTable old) {
    super.didUpdateWidget(old);
    if (old.debtors != widget.debtors) _table.setRows(widget.debtors);
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AppDataTable<Debtor>(
    controller: _table,
    selectable: false,
    emptyText: 'Sem devedores',
    rowActions: [
      if (widget.canManage)
        RowAction(
          label: 'Criar acordo',
          icon: Icons.handshake_outlined,
          onTap: widget.onAgree,
        ),
    ],
  );
}
