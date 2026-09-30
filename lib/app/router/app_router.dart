import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/animations/app_transitions.dart';
import '../../core/animations/reduce_motion.dart';
import '../../core/widgets/layout/app_shell.dart';

/// Única rota pública: `/login`. Não existe registo (ver docs/07-mock-api.md).
/// Placeholder até às issues de auth (#19, #20).
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        pageBuilder: (context, state) => fadeThroughPage(
          state: state,
          reduceMotion: ref.read(reduceMotionProvider),
          child: const Scaffold(body: Center(child: Text('ERP-Global'))),
        ),
      ),
      // Rotas autenticadas partilham o shell; os módulos registam-se aqui (#22).
      ShellRoute(
        builder: (context, state, child) =>
            AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const Center(child: Text('Painel')),
          ),
        ],
      ),
    ],
  );
});
