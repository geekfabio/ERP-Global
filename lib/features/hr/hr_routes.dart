import 'package:go_router/go_router.dart';

import 'presentation/pages/hr_page.dart';

/// Rotas do módulo `hr` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> hrRoutes() => [
  GoRoute(path: '/hr', builder: (context, state) => const HrPage()),
];
