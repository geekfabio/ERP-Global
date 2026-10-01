import 'package:go_router/go_router.dart';

import 'presentation/pages/access_control_page.dart';

/// Rotas do módulo `access_control` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> accessControlRoutes() => [
  GoRoute(
    path: '/access',
    builder: (context, state) => const AccessControlPage(),
  ),
];
