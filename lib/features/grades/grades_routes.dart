import 'package:go_router/go_router.dart';

import 'presentation/pages/grades_page.dart';

/// Rotas do módulo `grades` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> gradesRoutes() => [
  GoRoute(path: '/grades', builder: (context, state) => const GradesPage()),
];
