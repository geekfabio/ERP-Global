import 'package:go_router/go_router.dart';

import 'presentation/pages/accounting_page.dart';

/// Rotas do módulo `accounting` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> accountingRoutes() => [
  GoRoute(
    path: '/accounting',
    builder: (context, state) => const AccountingPage(),
  ),
];
