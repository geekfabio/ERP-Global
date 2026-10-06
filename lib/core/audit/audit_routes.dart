import 'package:go_router/go_router.dart';

import '../sync/sync_page.dart';
import 'audit_page.dart';

/// Rotas do módulo `core` (Definições), ligadas em `app/router/module_routes.dart`.
List<RouteBase> coreRoutes() => [
  GoRoute(
    path: '/settings/audit',
    builder: (context, state) => const AuditPage(),
  ),
  GoRoute(
    path: '/settings/sync',
    builder: (context, state) => const SyncPage(),
  ),
];
