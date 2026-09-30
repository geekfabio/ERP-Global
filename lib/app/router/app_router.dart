import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Única rota pública: `/login`. Não existe registo (ver docs/07-mock-api.md).
/// Placeholder até às issues de auth (#19, #20).
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('ERP-Global'))),
      ),
    ],
  );
});
