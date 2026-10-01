import 'package:go_router/go_router.dart';

import 'presentation/pages/import_page.dart';

/// Rotas do módulo `import_export` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> importExportRoutes() => [
  GoRoute(
    path: '/import-export',
    builder: (context, state) => const ImportPage(),
  ),
];
