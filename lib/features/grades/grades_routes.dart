import 'package:go_router/go_router.dart';

import 'presentation/pages/grade_statistics_page.dart';
import 'presentation/pages/grades_page.dart';
import 'presentation/pages/pauta_page.dart';
import 'presentation/pages/report_card_page.dart';

/// Rotas do módulo `grades` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> gradesRoutes() => [
  GoRoute(path: '/grades', builder: (context, state) => const GradesPage()),
  GoRoute(
    path: '/grades/report-cards',
    builder: (context, state) => const ReportCardPage(),
  ),
  GoRoute(
    path: '/grades/pautas',
    builder: (context, state) => const PautaPage(),
  ),
  GoRoute(
    path: '/grades/statistics',
    builder: (context, state) => const GradeStatisticsPage(),
  ),
];
