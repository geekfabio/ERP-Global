import 'package:go_router/go_router.dart';

import 'presentation/pages/attendance_page.dart';

/// Rotas do módulo `attendance` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> attendanceRoutes() => [
  GoRoute(
    path: '/attendance',
    builder: (context, state) => const AttendancePage(),
  ),
];
