import 'package:go_router/go_router.dart';

import 'presentation/pages/billing_page.dart';
import 'presentation/pages/invoices_page.dart';

/// Rotas do módulo `billing` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> billingRoutes() => [
  GoRoute(path: '/billing', builder: (context, state) => const BillingPage()),
  GoRoute(
    path: '/billing/invoices',
    builder: (context, state) => const InvoicesPage(),
  ),
];
