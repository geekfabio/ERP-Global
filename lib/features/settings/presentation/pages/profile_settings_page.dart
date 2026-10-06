import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../auth/presentation/providers/active_role.dart';
import '../../../auth/presentation/providers/auth_state.dart';
import '../../../../core/widgets/app_avatar.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/cards/app_cards.dart';
import '../../../../core/widgets/feedback/toasts.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(currentSessionProvider);
    if (session == null) return const SizedBox.shrink();
    final user = session.user;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          children: [
            Text('Perfil', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: AppSpacing.xl),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Row(
                  children: [
                    AppAvatar(name: user.name, radius: 32),
                    const SizedBox(width: AppSpacing.lg),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (user.email != null) Text(user.email!),
                          if (user.phone != null) Text(user.phone!),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ListCard(
              title: 'Perfis atribuídos',
              children: [
                for (final role in session.roles)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(
                      role == ref.watch(activeRoleProvider)
                          ? Icons.verified_outlined
                          : Icons.badge_outlined,
                    ),
                    title: Text(roleLabels[role] ?? role),
                    subtitle: Text(
                      role == ref.watch(activeRoleProvider)
                          ? 'Perfil activo'
                          : 'Perfil disponível',
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Alterar palavra-passe',
              icon: Icons.password_outlined,
              onPressed: () => _showChangePassword(context, ref),
            ),
            const SizedBox(height: AppSpacing.lg),
            EntityCard(
              title: 'Gerir utilizadores',
              subtitle: 'Criar contas, atribuir perfis e repor acessos.',
              leading: const Icon(Icons.manage_accounts_outlined),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/settings/users'),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _showChangePassword(BuildContext context, WidgetRef ref) async {
  final values = await showDialog<(String, String)>(
    context: context,
    builder: (_) => const _ChangePasswordDialog(),
  );
  if (values == null) return;
  final result = await ref
      .read(authStateProvider.notifier)
      .changePassword(currentPassword: values.$1, newPassword: values.$2);
  if (!context.mounted) return;
  result.when(
    ok: (_) =>
        ref.read(toastProvider.notifier).success('Palavra-passe actualizada.'),
    err: (failure) => ref.read(toastProvider.notifier).error(failure.message),
  );
}

class _ChangePasswordDialog extends StatefulWidget {
  const _ChangePasswordDialog();

  @override
  State<_ChangePasswordDialog> createState() => _ChangePasswordDialogState();
}

class _ChangePasswordDialogState extends State<_ChangePasswordDialog> {
  final _formKey = GlobalKey<FormState>();
  final _current = TextEditingController();
  final _next = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Alterar palavra-passe'),
    content: Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _current,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Palavra-passe actual',
            ),
            validator: _required,
          ),
          const SizedBox(height: AppSpacing.md),
          TextFormField(
            controller: _next,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Nova palavra-passe'),
            validator: (value) {
              if (value == null || value.length < 8) {
                return 'Use pelo menos 8 caracteres';
              }
              return null;
            },
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancelar'),
      ),
      FilledButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            Navigator.pop(context, (_current.text, _next.text));
          }
        },
        child: const Text('Guardar'),
      ),
    ],
  );

  String? _required(String? value) =>
      value == null || value.isEmpty ? 'Campo obrigatório' : null;
}
