import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/security/permission_providers.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/permissions/can.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../data/models/accounting_models.dart';
import '../providers/accounting_providers.dart';
import 'accounting_form_dialog.dart';

String accountTypeLabel(AccountType t) => switch (t) {
  AccountType.asset => 'Activo',
  AccountType.liability => 'Passivo',
  AccountType.equity => 'Capital próprio',
  AccountType.income => 'Proveitos',
  AccountType.expense => 'Custos',
};

/// Conta com a profundidade na árvore (para indentar).
typedef AccountNode = ({AccountModel account, int depth});

/// Percorre a árvore em profundidade (filhos ordenados por código).
List<AccountNode> flattenAccounts(List<AccountModel> accounts) {
  final byParent = <String?, List<AccountModel>>{};
  for (final a in accounts) {
    (byParent[a.parentId] ??= []).add(a);
  }
  for (final list in byParent.values) {
    list.sort((a, b) => a.code.compareTo(b.code));
  }
  final out = <AccountNode>[];
  void walk(String? parentId, int depth) {
    for (final a in byParent[parentId] ?? const <AccountModel>[]) {
      out.add((account: a, depth: depth));
      walk(a.id, depth + 1);
    }
  }

  walk(null, 0);
  return out;
}

/// Plano de contas (PGC-AO configurável): árvore com CRUD de contas.
class AccountsTab extends ConsumerStatefulWidget {
  const AccountsTab({super.key});

  @override
  ConsumerState<AccountsTab> createState() => _AccountsTabState();
}

class _AccountsTabState extends ConsumerState<AccountsTab> {
  void _refresh() => ref.invalidate(accountListProvider);

  Future<void> _create({AccountModel? parent}) async {
    final v = await showAccountingForm(
      context,
      title: parent == null ? 'Nova conta' : 'Nova subconta',
      subtitle: parent == null
          ? null
          : 'Conta-mãe: ${parent.code} · ${parent.name}',
      fields: [
        FormFieldSpec('code', 'Código', initial: parent?.code),
        const FormFieldSpec('name', 'Designação'),
        if (parent == null)
          FormFieldSpec(
            'type',
            'Natureza',
            kind: FieldKind.choice,
            options: {
              for (final t in AccountType.values) t.name: accountTypeLabel(t),
            },
          ),
      ],
    );
    if (v == null) return;
    final result = await ref
        .read(accountRepositoryProvider)
        .create(
          AccountModel(
            id: '',
            code: v['code']! as String,
            name: v['name']! as String,
            type:
                parent?.type ?? AccountType.values.byName(v['type']! as String),
            parentId: parent?.id,
          ),
        );
    if (reportResult(ref, result, done: 'Conta criada')) _refresh();
  }

  Future<void> _rename(AccountModel a) async {
    final v = await showAccountingForm(
      context,
      title: 'Editar conta',
      subtitle: a.code,
      fields: [FormFieldSpec('name', 'Designação', initial: a.name)],
    );
    if (v == null) return;
    final result = await ref
        .read(accountRepositoryProvider)
        .update(a.id, name: v['name']! as String);
    if (reportResult(ref, result, done: 'Conta actualizada')) _refresh();
  }

  Future<void> _toggle(AccountModel a) async {
    final result = await ref
        .read(accountRepositoryProvider)
        .update(a.id, isActive: !a.isActive);
    if (reportResult(
      ref,
      result,
      done: a.isActive ? 'Conta desactivada' : 'Conta activada',
    )) {
      _refresh();
    }
  }

  Future<void> _delete(AccountModel a) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Eliminar conta',
      message: 'Eliminar a conta ${a.code} · ${a.name}?',
      confirmLabel: 'Eliminar',
      destructive: true,
    );
    if (!ok) return;
    final result = await ref.read(accountRepositoryProvider).delete(a.id);
    if (reportResult(ref, result, done: 'Conta eliminada')) _refresh();
  }

  @override
  Widget build(BuildContext context) {
    final accounts = ref.watch(accountListProvider);
    final can = ref.watch(permissionServiceProvider).canAny;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: Align(
            alignment: Alignment.centerRight,
            child: Can(
              permission: 'accounting.account.create',
              child: AppButton(
                label: 'Nova conta',
                icon: Icons.add,
                onPressed: _create,
              ),
            ),
          ),
        ),
        Expanded(
          child: AsyncValueView<List<AccountModel>>(
            value: accounts,
            onRetry: _refresh,
            isEmpty: (d) => d.isEmpty,
            empty: const EmptyState(
              icon: Icons.account_tree_outlined,
              title: 'Sem contas no plano',
            ),
            data: (items) {
              final nodes = flattenAccounts(items);
              return ListView.separated(
                itemCount: nodes.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final (:account, :depth) = nodes[i];
                  return ListTile(
                    key: Key('account_${account.code}'),
                    contentPadding: EdgeInsetsDirectional.only(
                      start: AppSpacing.md + depth * AppSpacing.xl,
                      end: AppSpacing.sm,
                    ),
                    leading: Icon(
                      account.postable
                          ? Icons.description_outlined
                          : Icons.folder_outlined,
                    ),
                    title: Text('${account.code} · ${account.name}'),
                    subtitle: Text(accountTypeLabel(account.type)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!account.isActive)
                          const StatusBadge(
                            label: 'Inactiva',
                            status: BadgeStatus.neutral,
                          ),
                        PopupMenuButton<VoidCallback>(
                          tooltip: 'Acções',
                          onSelected: (run) => run(),
                          itemBuilder: (_) => [
                            if (can('accounting.account.create'))
                              PopupMenuItem(
                                value: () => _create(parent: account),
                                child: const Text('Nova subconta'),
                              ),
                            if (can('accounting.account.update')) ...[
                              PopupMenuItem(
                                value: () => _rename(account),
                                child: const Text('Editar designação'),
                              ),
                              PopupMenuItem(
                                value: () => _toggle(account),
                                child: Text(
                                  account.isActive ? 'Desactivar' : 'Activar',
                                ),
                              ),
                            ],
                            if (can('accounting.account.delete'))
                              PopupMenuItem(
                                value: () => _delete(account),
                                child: const Text('Eliminar'),
                              ),
                          ],
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
