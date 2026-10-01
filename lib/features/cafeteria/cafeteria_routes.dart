import 'package:go_router/go_router.dart';

import 'presentation/pages/wallets_page.dart';

/// Rotas do módulo `cafeteria` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> cafeteriaRoutes() => [
  GoRoute(path: '/cafeteria', builder: (context, state) => const WalletsPage()),
];
