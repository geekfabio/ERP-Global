import 'package:go_router/go_router.dart';

import 'presentation/pages/institution_page.dart';

/// Rotas de `core` da área Definições (ligadas em `app/router/module_routes.dart`,
/// ao lado de `coreRoutes`).
List<RouteBase> settingsRoutes() => [
  GoRoute(
    path: '/settings/institution',
    builder: (context, state) => const InstitutionPage(),
  ),
];
