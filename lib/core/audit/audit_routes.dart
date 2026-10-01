import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/states/app_states.dart';
import '../sync/sync_page.dart';
import 'audit_page.dart';

/// Rotas do módulo `core` (Definições), ligadas em `app/router/module_routes.dart`.
List<RouteBase> coreRoutes() => [
  GoRoute(
    path: '/settings',
    builder: (context, state) => EmptyState(
      icon: Icons.settings_outlined,
      title: 'Definições',
      message: 'As restantes definições chegam com as próximas issues.',
      actionLabel: 'Auditoria',
      onAction: () => context.go('/settings/audit'),
    ),
    routes: [
      GoRoute(path: 'audit', builder: (context, state) => const AuditPage()),
      GoRoute(path: 'sync', builder: (context, state) => const SyncPage()),
    ],
  ),
];
