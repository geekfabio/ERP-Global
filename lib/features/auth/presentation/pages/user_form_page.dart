import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/widgets/feedback/toasts.dart';
import '../../../../core/widgets/forms/stepper_form.dart';
import '../../../../core/widgets/inputs/app_inputs.dart';
import '../../../../core/widgets/states/app_states.dart';
import '../../data/models/managed_user.dart';
import '../../data/models/scope_model.dart';
import '../providers/active_role.dart';
import '../providers/users_providers.dart';
import '../widgets/temporary_password_dialog.dart';

/// Criar (`userId == null`) ou editar uma conta, em passos: dados → perfis e
/// âmbito → resumo. Só `super_admin` ou `users.account.create`.
class UserFormPage extends ConsumerWidget {
  const UserFormPage({super.key, this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(canManageUsersProvider)) {
      return const EmptyState(
        icon: Icons.lock_outline,
        title: 'Sem permissão',
        message: 'Não tem permissão para gerir contas de utilizador.',
      );
    }
    final id = userId;
    if (id == null) return const _UserFormBody();
    return AsyncValueView<ManagedUser>(
      value: ref.watch(managedUserProvider(id)),
      onRetry: () => ref.invalidate(managedUserProvider(id)),
      data: (account) => _UserFormBody(account: account),
    );
  }
}

class _UserFormBody extends ConsumerStatefulWidget {
  const _UserFormBody({this.account});

  final ManagedUser? account;

  @override
  ConsumerState<_UserFormBody> createState() => _UserFormBodyState();
}

class _UserFormBodyState extends ConsumerState<_UserFormBody> {
  late final StepperFormController _form = StepperFormController(
    initial: {
      'name': widget.account?.user.name ?? '',
      'email': widget.account?.user.email ?? '',
      'phone': widget.account?.user.phone ?? '',
      'roles': widget.account?.roles ?? const <String>[],
      'campusId': widget.account?.scope.campusId,
      'gradeId': widget.account?.scope.gradeId,
    },
  );

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _submit(Map<String, Object?> values) async {
    final phone = (values['phone'] as String?)?.trim() ?? '';
    final input = UserInput(
      name: (values['name'] as String).trim(),
      email: (values['email'] as String).trim(),
      phone: phone.isEmpty ? null : AppPhoneField.normalize(phone),
      roles: List<String>.of(values['roles']! as List<String>),
      scope: ScopeModel(
        campusId: values['campusId'] as String?,
        gradeId: values['gradeId'] as String?,
      ),
    );
    final repo = ref.read(usersRepositoryProvider);
    final id = widget.account?.user.id;
    final result = id == null
        ? await repo.create(input)
        : await repo.update(id, input);
    if (!mounted) return;
    final toast = ref.read(toastProvider.notifier);
    final failure = result.failureOrNull;
    if (failure != null) {
      toast.error(_describe(failure));
      return;
    }
    final password = result.valueOrNull?.temporaryPassword;
    if (password != null) {
      await showTemporaryPasswordDialog(
        context,
        userName: input.name,
        password: password,
      );
    } else {
      toast.success('Conta actualizada');
    }
    if (!mounted) return;
    ref.read(usersRevisionProvider.notifier).bump();
    context.go('/settings/users');
  }

  String _describe(Failure f) => f is ValidationFailure && f.fields.isNotEmpty
      ? f.fields.values.join(' · ')
      : f.message;

  @override
  Widget build(BuildContext context) {
    final editing = widget.account != null;
    final scopes = ref.watch(scopeOptionsProvider);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  IconButton(
                    tooltip: 'Voltar',
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.go('/settings/users'),
                  ),
                  Text(
                    editing ? 'Editar conta' : 'Nova conta',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ],
              ),
              Expanded(
                child: StepperForm(
                  controller: _form,
                  submitLabel: editing ? 'Guardar' : 'Criar conta',
                  summaryTitle: 'Resumo',
                  onSubmit: _submit,
                  summaryBuilder: (context, v) => _Summary(values: v),
                  steps: [
                    FormStepDef(title: 'Dados', builder: _detailsStep),
                    FormStepDef(
                      title: 'Perfis e âmbito',
                      builder: (context, form) =>
                          _rolesStep(context, form, scopes),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailsStep(BuildContext context, StepperFormController form) =>
      Column(
        children: [
          AppTextField(
            label: 'Nome completo',
            initialValue: form.get<String>('name'),
            onChanged: (v) => form.set('name', v),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Campo obrigatório' : null,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            label: 'E-mail (identificador de acesso)',
            initialValue: form.get<String>('email'),
            keyboardType: TextInputType.emailAddress,
            onChanged: (v) => form.set('email', v),
            validator: (v) {
              final s = v?.trim() ?? '';
              if (s.isEmpty) return 'Campo obrigatório';
              return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s)
                  ? null
                  : 'Formato inválido';
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppPhoneField(
            initialValue: form.get<String>('phone'),
            onChanged: (v) => form.set('phone', v),
          ),
        ],
      );

  Widget _rolesStep(
    BuildContext context,
    StepperFormController form,
    ScopeOptions scopes,
  ) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FormField<List<String>>(
          initialValue: form.get<List<String>>('roles'),
          validator: (v) =>
              v == null || v.isEmpty ? 'Atribua pelo menos um perfil' : null,
          builder: (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: [
                  for (final role in roleLabels.entries)
                    FilterChip(
                      label: Text(role.value),
                      selected: field.value!.contains(role.key),
                      onSelected: (on) {
                        final roles = [...field.value!];
                        on ? roles.add(role.key) : roles.remove(role.key);
                        form.set('roles', roles);
                        field.didChange(roles);
                      },
                    ),
                ],
              ),
              if (field.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.sm),
                  child: Text(
                    field.errorText!,
                    style: TextStyle(color: scheme.error),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          'Âmbito (opcional): restringe os perfis a um campus ou classe.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: AppSpacing.md),
        AppSearchableSelect<String>(
          label: 'Campus',
          options: scopes.campuses,
          value: form.get<String>('campusId'),
          onSelected: (v) => form.set('campusId', v),
        ),
        const SizedBox(height: AppSpacing.md),
        AppSearchableSelect<String>(
          label: 'Classe',
          options: scopes.grades,
          value: form.get<String>('gradeId'),
          onSelected: (v) => form.set('gradeId', v),
        ),
      ],
    );
  }
}

class _Summary extends ConsumerWidget {
  const _Summary({required this.values});

  final Map<String, Object?> values;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scopes = ref.watch(scopeOptionsProvider);
    final roles = (values['roles'] as List<String>?) ?? const [];
    final phone = (values['phone'] as String?)?.trim() ?? '';
    final lines = {
      'Nome': values['name'],
      'E-mail': values['email'],
      if (phone.isNotEmpty) 'Telefone': phone,
      'Perfis': roles.map((r) => roleLabels[r] ?? r).join(', '),
      if (values['campusId'] != null)
        'Campus': scopes.campuses[values['campusId']],
      if (values['gradeId'] != null) 'Classe': scopes.grades[values['gradeId']],
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final e in lines.entries)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Text('${e.key}: ${e.value ?? '—'}'),
          ),
      ],
    );
  }
}
