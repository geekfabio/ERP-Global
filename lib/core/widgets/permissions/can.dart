import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../security/permission_providers.dart';
import '../../security/permission_service.dart';

/// Mostra [child] só se o utilizador tiver [permission] (no [scope], se indicado);
/// caso contrário mostra [fallback] (nada por omissão). É só apresentação —
/// o router e o repository também validam.
class Can extends ConsumerWidget {
  const Can({
    super.key,
    required this.permission,
    required this.child,
    this.scope,
    this.fallback = const SizedBox.shrink(),
  });

  final String permission;
  final PermissionScope? scope;
  final Widget child;
  final Widget fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(permissionServiceProvider);
    final allowed = scope == null
        ? service.canAny(permission)
        : service.can(permission, scope: scope);
    return allowed ? child : fallback;
  }
}

/// Como [Can], mas mantém o [child] visível e desactivado (sem interacção),
/// com uma dica a explicar a falta de permissão.
class Restricted extends ConsumerWidget {
  const Restricted({
    super.key,
    required this.permission,
    required this.child,
    this.scope,
    this.message = 'Sem permissão para esta acção',
  });

  final String permission;
  final PermissionScope? scope;
  final Widget child;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.watch(permissionServiceProvider);
    final allowed = scope == null
        ? service.canAny(permission)
        : service.can(permission, scope: scope);
    if (allowed) return child;
    return Tooltip(
      message: message,
      child: IgnorePointer(
        child: ExcludeFocus(child: Opacity(opacity: 0.4, child: child)),
      ),
    );
  }
}
