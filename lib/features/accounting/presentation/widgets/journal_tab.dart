import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/utils/pt_ao_formatters.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/accounting_models.dart';
import '../../data/models/journal_models.dart';
import '../../domain/journal_rules.dart';
import '../providers/accounting_providers.dart';
import 'accounting_form_dialog.dart';
import 'entry_form_dialog.dart';

/// Diário: lançamentos por ordem cronológica, criação manual e estorno.
class JournalTab extends ConsumerStatefulWidget {
  const JournalTab({super.key});

  @override
  ConsumerState<JournalTab> createState() => _JournalTabState();
}

class _JournalTabState extends ConsumerState<JournalTab> {
  void _refresh() => ref.invalidate(journalEntriesProvider);

  Future<void> _create(List<AccountModel> accounts) async {
    final entry = await showEntryForm(context, accounts: accounts);
    if (entry == null) return;
    final result = await ref.read(journalRepositoryProvider).create(entry);
    if (reportResult(ref, result, done: 'Lançamento registado')) _refresh();
  }

  Future<void> _reverse(JournalEntryModel e) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Estornar lançamento',
      message: 'Estornar o lançamento n.º ${e.number}?',
      confirmLabel: 'Estornar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref.read(journalRepositoryProvider).reverse(e.id);
    if (reportResult(ref, result, done: 'Lançamento estornado')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final entries = ref.watch(journalEntriesProvider);
    final accounts = ref.watch(accountListProvider).value ?? const [];
    final byId = {for (final a in accounts) a.id: a};
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'accounting.entry.create',
              child: AppButton(
                label: 'Novo lançamento',
                icon: Icons.add,
                onPressed: accounts.isEmpty ? null : () => _create(accounts),
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<JournalEntryModel>>(
            value: entries,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.menu_book_outlined,
              title: 'Sem lançamentos',
            ),
            data: (items) => ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final e = items[i];
                final reversible =
                    e.status == JournalEntryStatus.posted &&
                    e.reversalOfId == null &&
                    can('accounting.entry.create');
                return ExpansionTile(
                  key: Key('entry_${e.number}'),
                  title: Text(
                    'N.º ${e.number} · ${PtAoFormatters.date(e.date)} · ${e.description}',
                  ),
                  subtitle: Text(
                    PtAoFormatters.currency(JournalRules.totalDebit(e.lines)),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (e.source == JournalSource.billing)
                        const StatusBadge(
                          label: 'Billing',
                          status: BadgeStatus.info,
                        ),
                      if (e.status == JournalEntryStatus.reversed)
                        const StatusBadge(
                          label: 'Estornado',
                          status: BadgeStatus.neutral,
                        ),
                      if (reversible)
                        IconButton(
                          key: Key('reverse_${e.number}'),
                          tooltip: 'Estornar',
                          icon: const Icon(Icons.undo),
                          onPressed: () => _reverse(e),
                        ),
                    ],
                  ),
                  children: [
                    for (final l in e.lines)
                      ListTile(
                        dense: true,
                        title: Text(
                          '${byId[l.accountId]?.code ?? '?'} · '
                          '${byId[l.accountId]?.name ?? ''}',
                        ),
                        trailing: Text(
                          l.debitMinor > 0
                              ? 'D ${PtAoFormatters.currency(l.debitMinor)}'
                              : 'C ${PtAoFormatters.currency(l.creditMinor)}',
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
