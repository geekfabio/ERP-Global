import 'package:flutter/material.dart';

/// Tokens semânticos e cores de módulo, como extensão do tema.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.danger,
    required this.onDanger,
    required this.info,
    required this.onInfo,
    required this.academic,
    required this.finance,
    required this.canteen,
    required this.access,
  });

  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;
  final Color danger;
  final Color onDanger;
  final Color info;
  final Color onInfo;

  // Acento por módulo.
  final Color academic;
  final Color finance;
  final Color canteen;
  final Color access;

  static const light = AppColors(
    success: Color(0xFF1B6B3A),
    onSuccess: Color(0xFFFFFFFF),
    warning: Color(0xFF8A5300),
    onWarning: Color(0xFFFFFFFF),
    danger: Color(0xFFB3261E),
    onDanger: Color(0xFFFFFFFF),
    info: Color(0xFF0B5CAD),
    onInfo: Color(0xFFFFFFFF),
    academic: Color(0xFF0B3D91),
    finance: Color(0xFF00695C),
    canteen: Color(0xFF9A4A00),
    access: Color(0xFF5B3E9E),
  );

  static const dark = AppColors(
    success: Color(0xFF7FD6A0),
    onSuccess: Color(0xFF00391A),
    warning: Color(0xFFFFB95C),
    onWarning: Color(0xFF462A00),
    danger: Color(0xFFFFB4AB),
    onDanger: Color(0xFF690005),
    info: Color(0xFFA4C9FF),
    onInfo: Color(0xFF00315C),
    academic: Color(0xFFADC6FF),
    finance: Color(0xFF6FD9C6),
    canteen: Color(0xFFFFB77C),
    access: Color(0xFFD0BCFF),
  );

  @override
  AppColors copyWith({
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
    Color? danger,
    Color? onDanger,
    Color? info,
    Color? onInfo,
    Color? academic,
    Color? finance,
    Color? canteen,
    Color? access,
  }) {
    return AppColors(
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      academic: academic ?? this.academic,
      finance: finance ?? this.finance,
      canteen: canteen ?? this.canteen,
      access: access ?? this.access,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AppColors(
      success: l(success, other.success),
      onSuccess: l(onSuccess, other.onSuccess),
      warning: l(warning, other.warning),
      onWarning: l(onWarning, other.onWarning),
      danger: l(danger, other.danger),
      onDanger: l(onDanger, other.onDanger),
      info: l(info, other.info),
      onInfo: l(onInfo, other.onInfo),
      academic: l(academic, other.academic),
      finance: l(finance, other.finance),
      canteen: l(canteen, other.canteen),
      access: l(access, other.access),
    );
  }
}

extension AppColorsContext on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
