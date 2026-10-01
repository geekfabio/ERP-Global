import 'package:go_router/go_router.dart';

import 'presentation/pages/enrollment_flow_page.dart';
import 'presentation/pages/renewal_page.dart';
import 'presentation/pages/student_file_page.dart';
import 'presentation/pages/student_wizard_page.dart';
import 'presentation/pages/students_list_page.dart';

/// Rotas do módulo `students` (ligadas em `app/router/module_routes.dart`).
List<RouteBase> studentsRoutes() => [
  GoRoute(
    path: '/students',
    builder: (context, state) => const StudentsListPage(),
    routes: [
      GoRoute(
        path: 'new',
        builder: (context, state) => const StudentWizardPage(),
      ),
      GoRoute(
        path: 'enrollments',
        builder: (context, state) => const EnrollmentFlowPage(),
        routes: [
          GoRoute(
            path: 'renewal',
            builder: (context, state) => const RenewalPage(),
          ),
        ],
      ),
      GoRoute(
        path: ':id',
        builder: (context, state) => StudentFilePage(
          studentId: state.pathParameters['id']!,
          initialTab: state.uri.queryParameters['tab'],
        ),
      ),
    ],
  ),
];
