import 'package:go_router/go_router.dart';

import 'presentation/pages/user_form_page.dart';
import 'presentation/pages/users_page.dart';

/// Rotas de gestão de contas, no módulo `core` (Definições). Ligadas em
/// `app/router/module_routes.dart`; o ModuleGuard/permissões vêm do prefixo `/settings`.
List<RouteBase> usersRoutes() => [
  GoRoute(
    path: '/settings/users',
    builder: (context, state) => const UsersPage(),
    routes: [
      GoRoute(path: 'new', builder: (context, state) => const UserFormPage()),
      GoRoute(
        path: ':id',
        builder: (context, state) =>
            UserFormPage(userId: state.pathParameters['id']),
      ),
    ],
  ),
];
