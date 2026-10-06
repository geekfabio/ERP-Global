import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_tokens.dart';
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

/// Única rota pública. Sem registo nem recuperação de palavra-passe.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.redirectTo = '/dashboard'});

  final String redirectTo;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _identifier = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;
  bool _passwordVisible = false;
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
        if (ref.read(activeRoleProvider) != null) context.go(widget.redirectTo);
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= AppBreakpoints.expanded;
            final form = needsRole
                ? _RoleSelector(roles: session.roles, onSelected: _selectRole)
                : _buildForm(context);
            if (isDesktop) {
              return Row(
                children: [
                  const Expanded(flex: 11, child: _BrandPanel()),
                  Expanded(flex: 9, child: _FormArea(child: form)),
                ],
              );
            }
            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: constraints.maxWidth < AppBreakpoints.medium
                    ? AppSpacing.xl
                    : AppSpacing.xxxl,
                vertical: AppSpacing.xl,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: _FormArea(compact: true, child: form),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectRole(String role) {
    ref.read(activeRoleProvider.notifier).select(role);
    context.go(widget.redirectTo);
  }

  Widget _buildForm(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Form(
      key: _form,
      child: AutofillGroup(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (MediaQuery.sizeOf(context).width < AppBreakpoints.expanded)
              const Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.xxxl),
                child: _BrandMark(),
              ),
            Text(
              'Bem-vindo(a)',
              style: text.displaySmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Entre na sua conta',
              style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Use o seu e-mail ou telefone e senha para continuar.',
              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (_error != null) ...[
              _ErrorBanner(_error!),
              const SizedBox(height: AppSpacing.lg),
            ],
            _LoginField(
              label: 'E-mail ou telefone',
              controller: _identifier,
              icon: Icons.mail_outline_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: validateLoginIdentifier,
            ),
            const SizedBox(height: AppSpacing.lg),
            _LoginField(
              label: 'Senha',
              controller: _password,
              icon: Icons.lock_outline_rounded,
              obscureText: !_passwordVisible,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Indique a palavra-passe' : null,
              suffixIcon: IconButton(
                tooltip: _passwordVisible ? 'Ocultar senha' : 'Mostrar senha',
                icon: Icon(
                  _passwordVisible
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                ),
                onPressed: () =>
                    setState(() => _passwordVisible = !_passwordVisible),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            SizedBox(
              height: 60,
              child: FilledButton(
                onPressed: _loading ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                ),
                child: _loading
                    ? const SizedBox.square(
                        dimension: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Entrar',
                            style: text.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(Icons.arrow_forward_rounded),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset('assets/brand/school-campus.png', fit: BoxFit.cover),
        DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                colors.surface.withValues(alpha: 0.96),
                colors.surface.withValues(alpha: 0.86),
                colors.surface.withValues(alpha: 0.12),
                colors.primary.withValues(alpha: 0.18),
              ],
              stops: const [0, 0.42, 0.72, 1],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(56, 40, 40, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _BrandMark(),
              const Spacer(),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Text.rich(
                  TextSpan(
                    text: 'Simplificando\n',
                    style: text.displayMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: colors.onSurface,
                      height: 1.05,
                    ),
                    children: [
                      TextSpan(
                        text: 'a gestão escolar.',
                        style: text.displayMedium?.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.w800,
                          height: 1.05,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Uma plataforma completa para alunos, turmas, avaliações, financeiro, refeitório, biblioteca e muito mais.',
                style: text.titleMedium?.copyWith(
                  color: colors.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              const _FeatureGrid(),
            ],
          ),
        ),
      ],
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/brand/symbol.png', width: 58, height: 58),
        const SizedBox(width: AppSpacing.md),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ERP-Global',
              style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
            ),
            Text(
              'Gestão Escolar Completa',
              style: text.bodyLarge?.copyWith(color: colors.onSurfaceVariant),
            ),
          ],
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  static const _items = [
    (Icons.groups_rounded, 'Alunos e Turmas', 'Matrículas e gestão'),
    (Icons.assignment_rounded, 'Avaliações', 'Notas e relatórios'),
    (Icons.account_balance_wallet_rounded, 'Financeiro', 'Facturação completa'),
    (Icons.restaurant_rounded, 'Refeitório', 'Cartão e saldo pré-pago'),
    (Icons.menu_book_rounded, 'Biblioteca', 'Inventário e empréstimos'),
    (Icons.bar_chart_rounded, 'Relatórios', 'Indicadores em tempo real'),
  ];

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final colors = Theme.of(context).colorScheme;
    return Wrap(
      spacing: AppSpacing.xxl,
      runSpacing: AppSpacing.lg,
      children: [
        for (final item in _items)
          SizedBox(
            width: 220,
            child: Row(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.primaryContainer.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: SizedBox.square(
                    dimension: 54,
                    child: Icon(item.$1, color: colors.primary),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.$2,
                        style: text.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        item.$3,
                        style: text.bodySmall?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _FormArea extends StatelessWidget {
  const _FormArea({required this.child, this.compact = false});

  final Widget child;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Padding(
          padding: EdgeInsets.all(compact ? 0 : AppSpacing.xxxl),
          child: compact
              ? child
              : Card(
                  elevation: 2,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.modal),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xxxl),
                    child: child,
                  ),
                ),
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.label,
    required this.controller,
    required this.icon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.suffixIcon,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final FormFieldValidator<String>? validator;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUnfocus,
      decoration: InputDecoration(
        hintText: label,
        prefixIcon: Icon(icon, color: colors.onSurfaceVariant),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: colors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.lg,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          borderSide: BorderSide(color: colors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          borderSide: BorderSide(color: colors.primary, width: 2),
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
