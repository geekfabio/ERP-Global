import 'package:go_router/go_router.dart';

import 'presentation/pages/communication_page.dart';

/// Rotas do módulo `communication` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> communicationRoutes() => [
  GoRoute(
    path: '/communication',
    builder: (context, state) => const CommunicationPage(),
  ),
];
