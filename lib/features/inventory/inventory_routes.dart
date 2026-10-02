import 'package:go_router/go_router.dart';

import 'presentation/pages/inventory_page.dart';

/// Rotas do módulo `inventory` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> inventoryRoutes() => [
  GoRoute(
    path: '/inventory',
    builder: (context, state) => const InventoryPage(),
  ),
];
