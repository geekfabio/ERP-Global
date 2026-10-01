import 'package:go_router/go_router.dart';

import 'presentation/pages/library_page.dart';

/// Rotas do módulo `library` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> libraryRoutes() => [
  GoRoute(path: '/library', builder: (context, state) => const LibraryPage()),
];
