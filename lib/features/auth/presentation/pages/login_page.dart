import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../providers/active_role.dart';
import '../providers/auth_state.dart';

/// E-mail (`x@y.z`) ou telefone angolano.
String? validateLoginIdentifier(String? v) {
  final value = v?.trim() ?? '';
  if (value.isEmpty) return 'Indique o e-mail ou telefone';
  final isEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
  if (isEmail || AppPhoneField.normalize(value) != null) return null;
  return 'E-mail ou telefone inválido';
}

/// Única rota pública. Sem registo nem recuperação de palavra-passe
/// (contas são criadas por administração — docs/07-mock-api.md).
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.redirectTo = '/dashboard'});

  /// Destino após autenticar (e escolher o perfil, se houver vários).
  final String redirectTo;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _identifier.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    final result = await ref
        .read(authStateProvider.notifier)
        .login(identifier: _identifier.text.trim(), password: _password.text);
    if (!mounted) return;
    setState(() => _loading = false);
    result.when(
      ok: (_) {
        // Vários perfis: o selector aparece até escolher; senão segue.
        if (ref.read(activeRoleProvider) != null) {
          context.go(widget.redirectTo);
        }
      },
      err: (failure) => setState(() => _error = failure.message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(currentSessionProvider);
    final needsRole =
        session != null &&
        session.roles.length > 1 &&
        ref.watch(activeRoleProvider) == null;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: needsRole
                      ? _RoleSelector(
                          roles: session.roles,
                          onSelected: (role) {
                            ref.read(activeRoleProvider.notifier).select(role);
                            context.go(widget.redirectTo);
                          },
                        )
                      : _buildForm(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Form(
      key: _form,
      child: AutofillGroup(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ERP-Global', style: text.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text('Entre na sua conta', style: text.bodyMedium),
            const SizedBox(height: AppSpacing.xl),
            if (_error != null) ...[
              _ErrorBanner(_error!),
              const SizedBox(height: AppSpacing.lg),
            ],
            AppTextField(
              label: 'E-mail ou telefone',
              controller: _identifier,
              keyboardType: TextInputType.emailAddress,
              validator: validateLoginIdentifier,
              autovalidateMode: AutovalidateMode.onUnfocus,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppPasswordField(
              controller: _password,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Indique a palavra-passe' : null,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppButton(label: 'Entrar', loading: _loading, onPressed: _submit),
          ],
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return Semantics(
      liveRegion: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.danger.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(AppRadius.input),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: colors.danger),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(message)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleSelector extends StatelessWidget {
  const _RoleSelector({required this.roles, required this.onSelected});

  final List<String> roles;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Escolha o perfil',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: AppSpacing.md),
      for (final role in roles)
        ListTile(
          title: Text(roleLabels[role] ?? role),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => onSelected(role),
        ),
    ],
  );
}
