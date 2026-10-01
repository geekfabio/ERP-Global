import 'package:go_router/go_router.dart';

import 'presentation/pages/billing_page.dart';
import 'presentation/pages/cash_page.dart';
import 'presentation/pages/debtors_page.dart';
import 'presentation/pages/discounts_page.dart';
import 'presentation/pages/invoices_page.dart';
import 'presentation/pages/payments_page.dart';
import 'presentation/pages/reports_page.dart';

/// Rotas do módulo `billing` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> billingRoutes() => [
  GoRoute(path: '/billing', builder: (context, state) => const BillingPage()),
  GoRoute(
    path: '/billing/invoices',
    builder: (context, state) => const InvoicesPage(),
  ),
  GoRoute(path: '/billing/cash', builder: (context, state) => const CashPage()),
  GoRoute(
    path: '/billing/payments',
    builder: (context, state) => const PaymentsPage(),
  ),
  GoRoute(
    path: '/billing/debtors',
    builder: (context, state) => const DebtorsPage(),
  ),
  GoRoute(
    path: '/billing/discounts',
    builder: (context, state) => const DiscountsPage(),
  ),
  GoRoute(
    path: '/billing/reports',
    builder: (context, state) => const ReportsPage(),
  ),
];
