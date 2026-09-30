import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/states/app_states.dart';
import 'presentation/pages/student_file_page.dart';
import 'presentation/pages/students_list_page.dart';

/// Rotas do módulo `students` (ligadas em `app/router/module_routes.dart`).
/// O cadastro (#37) substitui o placeholder de "Novo aluno".
List<RouteBase> studentsRoutes() => [
  GoRoute(
    path: '/students',
    builder: (context, state) => const StudentsListPage(),
    routes: [
      GoRoute(
        path: 'new',
        builder: (context, state) => const EmptyState(
          icon: Icons.person_add_alt_outlined,
          title: 'Novo aluno',
          message: 'O cadastro em passos chega com a issue #37.',
        ),
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
