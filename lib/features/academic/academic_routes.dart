import 'package:go_router/go_router.dart';

import 'presentation/pages/academic_page.dart';

/// Rotas do módulo `academic` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> academicRoutes() => [
  GoRoute(path: '/academic', builder: (context, state) => const AcademicPage()),
];
