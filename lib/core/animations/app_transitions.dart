import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme/app_tokens.dart';
import 'reduce_motion.dart';

/// Transição fade-through entre módulos (fade + leve escala), com duração e
/// curva dos tokens. Sem movimento quando [reduceMotion] ou o sistema o pedem.
CustomTransitionPage<T> fadeThroughPage<T>({
  required GoRouterState state,
  required Widget child,
  bool reduceMotion = false,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  child: child,
  transitionDuration: reduceMotion ? Duration.zero : AppMotion.page,
  reverseTransitionDuration: reduceMotion ? Duration.zero : AppMotion.standard,
  transitionsBuilder: (context, animation, secondary, child) {
    if (reduceMotion || shouldReduceMotion(context)) return child;
    final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
    return FadeTransition(
      opacity: curved,
      child: ScaleTransition(
        scale: Tween(begin: 0.96, end: 1.0).animate(curved),
        child: child,
      ),
    );
  },
);

/// Transição slide horizontal para drill-down (lista → detalhe).
CustomTransitionPage<T> slidePage<T>({
  required GoRouterState state,
  required Widget child,
  bool reduceMotion = false,
}) => CustomTransitionPage<T>(
  key: state.pageKey,
  child: child,
  transitionDuration: reduceMotion ? Duration.zero : AppMotion.page,
  reverseTransitionDuration: reduceMotion ? Duration.zero : AppMotion.standard,
  transitionsBuilder: (context, animation, secondary, child) {
    if (reduceMotion || shouldReduceMotion(context)) return child;
    final curved = CurvedAnimation(parent: animation, curve: AppMotion.curve);
    return SlideTransition(
      position: Tween(
        begin: const Offset(0.08, 0),
        end: Offset.zero,
      ).animate(curved),
      child: FadeTransition(opacity: curved, child: child),
    );
  },
);
