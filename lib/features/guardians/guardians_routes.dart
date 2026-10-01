import 'package:go_router/go_router.dart';

import 'presentation/pages/guardian_file_page.dart';
import 'presentation/pages/guardians_list_page.dart';

/// Rotas do módulo `guardians` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> guardiansRoutes() => [
  GoRoute(
    path: '/guardians',
    builder: (context, state) => const GuardiansListPage(),
    routes: [
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            GuardianFilePage(guardianId: state.pathParameters['id']!),
      ),
    ],
  ),
];
