import 'package:go_router/go_router.dart';

import 'presentation/pages/academic_dashboard_page.dart';
import 'presentation/pages/dashboard_page.dart';

/// Rotas do módulo `reports` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> reportsRoutes() => [
  GoRoute(path: '/reports', builder: (context, state) => const DashboardPage()),
  GoRoute(
    path: '/reports/academic',
    builder: (context, state) => const AcademicDashboardPage(),
  ),
];
