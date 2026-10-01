import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/feedback/app_dialogs.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../core/widgets/table/app_data_table.dart';
import '../../../../core/widgets/table/table_controller.dart';
import '../../data/models/managed_user.dart';
import '../providers/active_role.dart';
import '../providers/users_providers.dart';
import '../providers/users_table_controller.dart';
import '../widgets/temporary_password_dialog.dart';

/// Gestão de contas: lista, criar/editar, desactivar e repor password.
/// Só `super_admin` ou quem tem `users.account.create`.
class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canViewUsersProvider)) {
      return const EmptyState(
        icon: Icons.lock_outline,
        title: 'Sem permissão',
        message: 'Só o super administrador gere contas de utilizador.',
      );
    }
    return const _UsersBody();
  }
}

class _UsersBody extends ConsumerStatefulWidget {
  const _UsersBody();

  @override
  ConsumerState<_UsersBody> createState() => _UsersBodyState();
}

class _UsersBodyState extends ConsumerState<_UsersBody> {
  late final UsersTableController _table = UsersTableController(
    ref.read(usersRepositoryProvider),
    columns: [
      AppColumn<ManagedUser>(
        label: 'Nome',
        text: (a) => a.user.name,
        sortValue: (a) => a.user.name,
      ),
      AppColumn<ManagedUser>(
        label: 'E-mail',
        text: (a) => a.user.email ?? '',
        sortValue: (a) => a.user.email ?? '',
      ),
      AppColumn<ManagedUser>(
        label: 'Perfis',
        text: (a) => a.roles.map((r) => roleLabels[r] ?? r).join(', '),
      ),
      AppColumn<ManagedUser>(
        label: 'Estado',
        text: (a) => a.user.isActive ? 'Activo' : 'Inactivo',
        cell: (a) => StatusBadge(
          label: a.user.isActive ? 'Activo' : 'Inactivo',
          status: a.user.isActive ? BadgeStatus.success : BadgeStatus.neutral,
        ),
      ),
    ],
  );

  @override
  void initState() {
    super.initState();
    unawaited(_table.load());
  }

  @override
  void dispose() {
    _table.dispose();
    super.dispose();
  }

  void _create() => context.push('/settings/users/new');

  void _edit(ManagedUser a) => context.push('/settings/users/${a.user.id}');

  Future<void> _toggleActive(ManagedUser a) async {
    final active = !a.user.isActive;
    final verb = active ? 'Activar' : 'Desactivar';
    final ok = await showConfirmDialog(
      context: context,
      title: '$verb conta',
      message: active
          ? 'Activar a conta de "${a.user.name}"?'
          : '"${a.user.name}" deixa de poder iniciar sessão.',
      confirmLabel: verb,
      destructive: !active,
    );
    if (!ok || !mounted) return;
    final result = await ref
        .read(usersRepositoryProvider)
        .setActive(a.user.id, active: active);
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    result.when(
      ok: (_) => toast.success(active ? 'Conta activada' : 'Conta desactivada'),
      err: (f) => toast.error(f.message),
    );
    unawaited(_table.load());
  }

  Future<void> _resetPassword(ManagedUser a) async {
    final ok = await showConfirmDialog(
      context: context,
      title: 'Repor palavra-passe',
      message:
          'Gerar uma palavra-passe temporária para "${a.user.name}"? '
          'A sessão actual é terminada e a mudança é obrigatória no próximo início de sessão.',
      confirmLabel: 'Repor',
      destructive: true,
    );
    if (!ok || !mounted) return;
    final result = await ref
        .read(usersRepositoryProvider)
        .resetPassword(a.user.id);
    if (!mounted) return;
    final password = result.valueOrNull?.temporaryPassword;
    if (password == null) {
      ref
          .read(toastProvider.notifier)
          .error(result.failureOrNull?.message ?? 'Erro');
      return;
    }
    await showTemporaryPasswordDialog(
      context,
      userName: a.user.name,
      password: password,
    );
  }

  @override
  Widget build(BuildContext context) {
    final canManage = ref.watch(canManageUsersProvider);
    ref.listen(usersRevisionProvider, (_, _) => unawaited(_table.load()));
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1400),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: AppSpacing.lg),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Utilizadores',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    AppButton(
                      label: 'Nova conta',
                      icon: Icons.person_add_alt_outlined,
                      onPressed: canManage ? _create : null,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: ListenableBuilder(
                  listenable: _table,
                  builder: (context, _) {
                    final failure = _table.failure;
                    if (failure != null) {
                      return ErrorState(
                        failure: failure,
                        onRetry: () => unawaited(_table.load()),
                      );
                    }
                    return Column(
                      children: [
                        if (_table.loading) const LinearProgressIndicator(),
                        Expanded(
                          child: AppDataTable<ManagedUser>(
                            controller: _table,
                            selectable: false,
                            emptyText: 'Nenhuma conta encontrada',
                            rowActions: canManage
                                ? [
                                    RowAction(
                                      label: 'Editar',
                                      icon: Icons.edit_outlined,
                                      onTap: _edit,
                                    ),
                                    RowAction(
                                      label: 'Estado',
                                      icon: Icons.block_outlined,
                                      onTap: _toggleActive,
                                    ),
                                    RowAction(
                                      label: 'Repor acesso',
                                      icon: Icons.password_outlined,
                                      onTap: _resetPassword,
                                    ),
                                  ]
                                : const [],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
