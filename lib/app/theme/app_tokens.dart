import 'package:flutter/animation.dart';

/// Escala de espaçamento (múltiplos de 4 px).
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

/// Raios de esquina: inputs, cards e modais.
abstract final class AppRadius {
  static const double input = 6;
  static const double card = 12;
  static const double modal = 20;
}

/// Níveis de elevação.
abstract final class AppElevation {
  static const double none = 0;
  static const double low = 1;
  static const double medium = 2;
  static const double high = 4;
}

/// Durações e curva de movimento.
abstract final class AppMotion {
  static const Duration micro = Duration(milliseconds: 120);
  static const Duration standard = Duration(milliseconds: 220);
  static const Duration page = Duration(milliseconds: 360);
  static const Curve curve = Curves.easeOutCubic;
}

/// Breakpoints responsivos: compact < 600, medium 600–1024, expanded > 1024.
abstract final class AppBreakpoints {
  static const double medium = 600;
  static const double expanded = 1024;
}

/// Tamanho mínimo de alvo de toque (acessibilidade).
abstract final class AppSizes {
  static const double minTouchTarget = 44;
}
