import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../app/theme/app_tokens.dart';
import 'reduce_motion.dart';

/// Número máximo de itens de lista animados em stagger (ver design system).
const int kMaxStaggerItems = 8;

extension AppAnimate on Widget {
  /// Entrada padrão: fade + subida ligeira. Devolve o widget intacto se
  /// [reduce] for `true`.
  Widget appEnter({bool reduce = false, Duration delay = Duration.zero}) {
    if (reduce) return this;
    return animate(delay: delay)
        .fadeIn(duration: AppMotion.standard, curve: AppMotion.curve)
        .slideY(
          begin: 0.05,
          end: 0,
          duration: AppMotion.standard,
          curve: AppMotion.curve,
        );
  }

  /// Entrada escalonada; só anima os primeiros [kMaxStaggerItems] itens.
  Widget appStagger(int index, {bool reduce = false}) =>
      index >= kMaxStaggerItems
      ? this
      : appEnter(reduce: reduce, delay: AppMotion.micro * index);

  /// Abanão leve para feedback de erro.
  Widget appShake({bool reduce = false}) {
    if (reduce) return this;
    return animate().shakeX(
      hz: 4,
      amount: 4,
      duration: AppMotion.page,
      curve: AppMotion.curve,
    );
  }
}

/// Check animado de sucesso (círculo que cresce + visto).
class SuccessCheck extends StatelessWidget {
  const SuccessCheck({super.key, required this.color, this.size = 48});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final icon = Icon(Icons.check_circle, color: color, size: size);
    if (shouldReduceMotion(context)) return icon;
    return icon
        .animate()
        .scale(
          begin: const Offset(0.4, 0.4),
          duration: AppMotion.page,
          curve: Curves.elasticOut,
        )
        .fadeIn(duration: AppMotion.micro);
  }
}
