import 'package:go_router/go_router.dart';

import 'presentation/pages/academic_years_page.dart';
import 'presentation/pages/general_settings_page.dart';
import 'presentation/pages/institution_page.dart';
import 'presentation/pages/printed_documents_page.dart';
import 'presentation/pages/profile_settings_page.dart';
import 'presentation/pages/rules_page.dart';
import 'presentation/pages/settings_home_page.dart';

/// Rotas de `core` da área Definições (ligadas em `app/router/module_routes.dart`,
/// ao lado de `coreRoutes`).
List<RouteBase> settingsRoutes() => [
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsHomePage(),
    routes: [
      GoRoute(
        path: 'general',
        builder: (context, state) => const GeneralSettingsPage(),
      ),
      GoRoute(
        path: 'company',
        builder: (context, state) => const InstitutionPage(),
      ),
      GoRoute(
        path: 'profile',
        builder: (context, state) => const ProfileSettingsPage(),
      ),
      GoRoute(
        path: 'documents',
        builder: (context, state) => const PrintedDocumentsPage(),
      ),
    ],
  ),
  GoRoute(
    path: '/settings/institution',
    builder: (context, state) => const InstitutionPage(),
  ),
  GoRoute(
    path: '/settings/academic-year',
    builder: (context, state) => const AcademicYearsPage(),
  ),
  GoRoute(
    path: '/settings/rules',
    builder: (context, state) => const RulesPage(),
  ),
];
