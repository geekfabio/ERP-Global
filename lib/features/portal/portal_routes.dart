import 'package:go_router/go_router.dart';

import 'presentation/pages/portal_home_page.dart';

/// Rotas do módulo `guardian_portal` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> portalRoutes() => [
  GoRoute(path: '/portal', builder: (context, state) => const PortalHomePage()),
];
