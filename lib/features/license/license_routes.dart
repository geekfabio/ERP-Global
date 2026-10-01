import 'package:go_router/go_router.dart';

import 'presentation/pages/license_page.dart';

/// Rota do ecrã de licença, no módulo `core` (Definições). Ligada em
/// `app/router/module_routes.dart`; `core` é obrigatório, por isso continua
/// acessível mesmo sem licença (é onde se activa uma).
List<RouteBase> licenseRoutes() => [
  GoRoute(
    path: '/settings/license',
    builder: (context, state) => const LicenseOverviewPage(),
  ),
];
