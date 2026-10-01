import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../app/theme/app_tokens.dart';
import '../../errors/failure.dart';
import '../../errors/result.dart';

/// Lista de esqueletos (loading). Anima só se o sistema permitir.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'A carregar',
    child: Skeletonizer(
      enabled: true,
      enableSwitchAnimation: false,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: itemCount,
        itemBuilder: (_, i) => const ListTile(
          leading: CircleAvatar(),
          title: Text('Título do registo'),
          subtitle: Text('Descrição do registo em carregamento'),
        ),
      ),
    ),
  );
}

/// Cartão de esqueleto (loading de KPI/cartão).
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({super.key, this.height = 96});

  final double height;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'A carregar',
    child: Skeletonizer(
      child: Card(
        child: SizedBox(
          height: height,
          child: const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text('Indicador'), Text('0000')],
            ),
          ),
        ),
      ),
    ),
  );
}

/// Estado vazio com ícone (ilustração), mensagem e CTA opcional.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ExcludeSemantics(
              child: Icon(icon, size: 64, color: scheme.onSurfaceVariant),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(title, style: text.titleMedium, textAlign: TextAlign.center),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(message!, textAlign: TextAlign.center),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.lg),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

/// Estado de erro com mensagem do [Failure] e "Tentar novamente".
class ErrorState extends StatelessWidget {
  const ErrorState({
    super.key,
    required this.failure,
    this.onRetry,
    this.retryLabel = 'Tentar novamente',
  });

  final Failure failure;
  final VoidCallback? onRetry;
  final String retryLabel;

  @override
  Widget build(BuildContext context) {
    final offline = failure is NetworkFailure;
    return EmptyState(
      icon: offline ? Icons.cloud_off_outlined : Icons.error_outline,
      title: failure.message,
      actionLabel: onRetry == null ? null : retryLabel,
      onAction: onRetry,
    );
  }
}

/// Converte um `AsyncValue<T>` (Riverpod) em loading/erro/vazio/dados.
/// [isEmpty] decide o estado vazio; sem ele os dados são sempre mostrados.
class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    super.key,
    required this.value,
    required this.data,
    this.onRetry,
    this.isEmpty,
    this.loading,
    this.empty,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;
  final bool Function(T data)? isEmpty;
  final Widget? loading;
  final Widget? empty;

  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnReload: true,
    loading: () => loading ?? const SkeletonList(),
    error: (e, st) => ErrorState(
      failure: value.failure ?? UnknownFailure(cause: e),
      onRetry: onRetry,
    ),
    data: (d) => (isEmpty?.call(d) ?? false)
        ? (empty ?? const EmptyState(title: 'Sem registos'))
        : data(d),
  );
}
