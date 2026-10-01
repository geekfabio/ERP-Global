import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/accounting_models.dart';
import '../../data/models/journal_models.dart';
import '../../domain/journal_rules.dart';
import '../providers/accounting_providers.dart';
import 'accounting_form_dialog.dart';

/// Contas a pagar (fornecedores) e a receber (encarregados).
class OpenItemsTab extends ConsumerStatefulWidget {
  const OpenItemsTab({super.key});

  @override
  ConsumerState<OpenItemsTab> createState() => _OpenItemsTabState();
}

class _OpenItemsTabState extends ConsumerState<OpenItemsTab> {
  OpenItemKind _kind = OpenItemKind.receivable;

  void _refresh() => ref.invalidate(openItemListProvider);

  Map<String, String> _options(bool Function(AccountModel) test) => {
    for (final a
        in ref.read(accountListProvider).value ?? const <AccountModel>[])
      if (a.postable && a.isActive && test(a)) a.id: '${a.code} · ${a.name}',
  };

  Future<void> _create() async {
    final payable = _kind == OpenItemKind.payable;
    final v = await showAccountingForm(
      context,
      title: payable ? 'Nova conta a pagar' : 'Nova conta a receber',
      fields: [
        FormFieldSpec('party', payable ? 'Fornecedor' : 'Encarregado / turma'),
        const FormFieldSpec('description', 'Descrição'),
        const FormFieldSpec('amount', 'Valor (Kz)'),
        const FormFieldSpec('issueDate', 'Emissão', kind: FieldKind.date),
        const FormFieldSpec('dueDate', 'Vencimento', kind: FieldKind.date),
        FormFieldSpec(
          'counter',
          payable ? 'Conta de custos' : 'Conta de proveitos',
          kind: FieldKind.choice,
          options: _options(
            (a) =>
                a.type == (payable ? AccountType.expense : AccountType.income),
          ),
        ),
      ],
    );
    if (v == null) return;
    final amount = JournalRules.parseMinor(v['amount']! as String);
    if (amount == null || amount <= 0) {
      ref.read(toastProvider.notifier).error('Valor inválido');
      return;
    }
    final result = await ref
        .read(openItemRepositoryProvider)
        .create(
          OpenItemModel(
            id: '',
            kind: _kind,
            party: v['party']! as String,
            description: v['description']! as String,
            amountMinor: amount,
            issueDate: v['issueDate']! as DateTime,
            dueDate: v['dueDate']! as DateTime,
            counterAccountId: v['counter']! as String,
          ),
        );
    if (reportResult(ref, result, done: 'Título registado')) _refresh();
  }

  Future<void> _settle(OpenItemModel item) async {
    final payable = item.kind == OpenItemKind.payable;
    final v = await showAccountingForm(
      context,
      title: payable ? 'Registar pagamento' : 'Registar recebimento',
      subtitle:
          'Em dívida: ${PtAoFormatters.currency(item.amountMinor - item.paidMinor)}',
      fields: [
        const FormFieldSpec('amount', 'Valor (Kz)'),
        const FormFieldSpec('date', 'Data', kind: FieldKind.date),
        FormFieldSpec(
          'cash',
          'Caixa / banco',
          kind: FieldKind.choice,
          options: _options(
            (a) => a.type == AccountType.asset && a.code.startsWith('4'),
          ),
        ),
      ],
    );
    if (v == null) return;
    final amount = JournalRules.parseMinor(v['amount']! as String);
    if (amount == null || amount <= 0) {
      ref.read(toastProvider.notifier).error('Valor inválido');
      return;
    }
    final result = await ref
        .read(openItemRepositoryProvider)
        .settle(
          item.id,
          amountMinor: amount,
          date: v['date']! as DateTime,
          cashAccountId: v['cash']! as String,
        );
    if (reportResult(ref, result, done: 'Liquidação registada')) {
      _refresh();
      ref.invalidate(journalEntriesProvider);
    }
  }

  (String, BadgeStatus) _badge(OpenItemModel i) => switch (i.status) {
    OpenItemStatus.paid => ('Liquidado', BadgeStatus.success),
    OpenItemStatus.partiallyPaid => ('Parcial', BadgeStatus.warning),
    OpenItemStatus.open => ('Em aberto', BadgeStatus.info),
  };

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(openItemListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Row(
            children: [
              SegmentedButton<OpenItemKind>(
                key: const Key('open_items_kind'),
                segments: const [
                  ButtonSegment(
                    value: OpenItemKind.receivable,
                    label: Text('A receber'),
                  ),
                  ButtonSegment(
                    value: OpenItemKind.payable,
                    label: Text('A pagar'),
                  ),
                ],
                selected: {_kind},
                onSelectionChanged: (s) => setState(() => _kind = s.first),
              ),
              const Spacer(),
              Can(
                permission: 'accounting.entry.create',
                child: AppButton(
                  label: _kind == OpenItemKind.payable
                      ? 'Nova conta a pagar'
                      : 'Nova conta a receber',
                  icon: Icons.add,
                  onPressed: _create,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: AsyncValueView<List<OpenItemModel>>(
            value: items,
            onRetry: _refresh,
            data: (all) {
              final list = [
                for (final i in all)
                  if (i.kind == _kind) i,
              ];
              if (list.isEmpty) {
                return const EmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: 'Sem títulos',
                );
              }
              return ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final item = list[i];
                  final (label, status) = _badge(item);
                  return ListTile(
                    key: Key('open_item_${item.description}'),
                    title: Text('${item.party} · ${item.description}'),
                    subtitle: Text(
                      'Vence ${PtAoFormatters.date(item.dueDate)} · '
                      '${PtAoFormatters.currency(item.paidMinor)} de '
                      '${PtAoFormatters.currency(item.amountMinor)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        StatusBadge(label: label, status: status),
                        if (item.status != OpenItemStatus.paid &&
                            can('accounting.entry.create'))
                          TextButton(
                            onPressed: () => _settle(item),
                            child: Text(
                              item.kind == OpenItemKind.payable
                                  ? 'Pagar'
                                  : 'Receber',
                            ),
                          ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
