import 'package:go_router/go_router.dart';

import 'presentation/pages/portal_attendance_page.dart';
import 'presentation/pages/portal_card_page.dart';
import 'presentation/pages/portal_documents_page.dart';
import 'presentation/pages/portal_finance_page.dart';
import 'presentation/pages/portal_grades_page.dart';
import 'presentation/pages/portal_home_page.dart';
import 'presentation/pages/portal_justification_page.dart';
import 'presentation/pages/portal_schedule_page.dart';
import 'presentation/pages/portal_teacher_page.dart';

/// Rotas do módulo `guardian_portal` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> portalRoutes() => [
  GoRoute(path: '/portal', builder: (context, state) => const PortalHomePage()),
  GoRoute(
    path: '/portal/grades',
    builder: (context, state) => const PortalGradesPage(),
  ),
  GoRoute(
    path: '/portal/attendance',
    builder: (context, state) => const PortalAttendancePage(),
  ),
  GoRoute(
    path: '/portal/schedule',
    builder: (context, state) => const PortalSchedulePage(),
  ),
  GoRoute(
    path: '/portal/justifications',
    builder: (context, state) => const PortalJustificationPage(),
  ),
  GoRoute(
    path: '/portal/documents',
    builder: (context, state) => const PortalDocumentsPage(),
  ),
  GoRoute(
    path: '/portal/financeiro',
    builder: (context, state) => const PortalFinancePage(),
  ),
  GoRoute(
    path: '/portal/cartao',
    builder: (context, state) => const PortalCardPage(),
  ),
  GoRoute(
    path: '/portal/teacher',
    builder: (context, state) => const PortalTeacherPage(),
  ),
];
