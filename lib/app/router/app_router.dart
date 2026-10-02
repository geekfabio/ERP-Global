import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/app_transitions.dart';
import '../../core/animations/reduce_motion.dart';
import '../../core/modules/license_gate.dart';
import '../../core/modules/module_catalog.dart';
import '../../core/security/permission_providers.dart';
import '../../core/widgets/layout/app_shell.dart';
import '../../core/widgets/license/license_widgets.dart';
import '../../core/widgets/states/app_states.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import 'dashboard_home.dart';
import 'module_routes.dart';
import '../../features/auth/presentation/providers/active_role.dart';
import '../../features/auth/presentation/providers/auth_state.dart';

/// Destino seguro a partir do parâmetro `from` (só caminhos internos).
String safeRedirectTarget(String? from) {
  if (from == null || !from.startsWith('/') || from.startsWith('//')) {
    return '/dashboard';
  }
  final path = Uri.tryParse(from)?.path ?? '';
  return const {'/login', '/splash', '/forbidden'}.contains(path)
      ? '/dashboard'
      : from;
}

/// Perfis que só usam o portal (sem painel de gestão).
const portalOnlyRoles = {'encarregado', 'aluno'};

/// Perfis docentes: abrem na vista do professor (`/portal/teacher`).
const teacherRoles = {'professor', 'diretor_turma'};

/// Decide o redirect global. Sem sessão só existe `/login`; com sessão, as rotas
/// de módulo exigem alguma permissão do módulo (senão `/forbidden`).
String? appRedirect(Ref ref, GoRouterState state) {
  final location = state.uri.path;
  final auth = ref.read(authStateProvider);
  String withFrom(String route) =>
      '$route?from=${Uri.encodeComponent(state.uri.toString())}';

  // A restaurar a sessão: aguarda em /splash em vez de mostrar conteúdo protegido.
  if (auth.isLoading && !auth.hasValue) {
    return location == '/splash' ? null : withFrom('/splash');
  }

  final session = auth.value;
  if (session == null) {
    if (location == '/login') return null;
    return location == '/splash'
        ? '/login?from=${Uri.encodeComponent(state.uri.queryParameters['from'] ?? '/dashboard')}'
        : withFrom('/login');
  }

  // A validar a licença: aguarda em /splash antes de decidir acessos a módulos.
  if (ref.read(licenseGateProvider).loading) {
    return location == '/splash' ? null : withFrom('/splash');
  }

  // Vários perfis: tem de escolher o activo antes de entrar.
  final needsRole =
      session.roles.length > 1 && ref.read(activeRoleProvider) == null;
  if (needsRole) return location == '/login' ? null : withFrom('/login');

  if (location == '/login' || location == '/splash') {
    return safeRedirectTarget(state.uri.queryParameters['from']);
  }

  // Contas só de portal (encarregado/aluno) abrem no portal, não no painel.
  final enabled = ref.read(enabledModulesProvider);
  if (location == '/dashboard' &&
      enabled.contains('guardian_portal') &&
      session.roles.every(portalOnlyRoles.contains)) {
    return '/portal';
  }
  if ((location == '/dashboard' || location == '/portal') &&
      enabled.contains('guardian_portal') &&
      session.roles.every(teacherRoles.contains)) {
    return '/portal/teacher';
  }

  final registry = ref.read(moduleRegistryProvider);
  final permissions = ref.read(permissionServiceProvider);
  for (final m in registry.all) {
    final inModule = location == m.path || location.startsWith('${m.path}/');
    if (!inModule) continue;
    // ModuleGuard: módulo fora da licença → ecrã "não licenciado".
    if (!enabled.contains(m.code)) return '/not-licensed?module=${m.code}';
    if (!permissions.canAccessNamespace(m.namespace)) return '/forbidden';
  }
  return null;
}

/// Rotas da app. Única rota pública: `/login` (sem registo — docs/07-mock-api.md).
final appRouterProvider = Provider<GoRouter>((ref) {
  final registry = ref.watch(moduleRegistryProvider);

  // Reavalia o redirect quando a sessão ou o perfil activo mudam.
  final refresh = ValueNotifier<int>(0);
  ref.listen(authStateProvider, (_, _) => refresh.value++);
  ref.listen(activeRoleProvider, (_, _) => refresh.value++);
  ref.listen(sessionPermissionsProvider, (_, _) => refresh.value++);
  ref.listen(licenseGateProvider, (_, _) => refresh.value++);
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: refresh,
    redirect: (context, state) => appRedirect(ref, state),
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => fadeThroughPage(
          state: state,
          reduceMotion: ref.read(reduceMotionProvider),
          child: LoginPage(
            redirectTo: safeRedirectTarget(state.uri.queryParameters['from']),
          ),
        ),
      ),
      // Rotas autenticadas partilham o shell; os módulos registam-se aqui.
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardHome(),
          ),
          GoRoute(
            path: '/not-licensed',
            builder: (context, state) => NotLicensedPage(
              moduleCode: state.uri.queryParameters['module'],
            ),
          ),
          GoRoute(
            path: '/forbidden',
            builder: (context, state) => EmptyState(
              icon: Icons.lock_outline,
              title: 'Sem permissão',
              message: 'O seu perfil não tem acesso a esta área.',
              actionLabel: 'Ir para o Painel',
              onAction: () => context.go('/dashboard'),
            ),
          ),
          ...buildModuleRoutes(registry, featureRoutes: featureModuleRoutes),
        ],
      ),
    ],
  );
});
