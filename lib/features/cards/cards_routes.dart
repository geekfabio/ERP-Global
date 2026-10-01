import 'package:go_router/go_router.dart';

import 'presentation/pages/cards_page.dart';

/// Rotas do módulo `cards` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> cardsRoutes() => [
  GoRoute(path: '/cards', builder: (context, state) => const CardsPage()),
];
