import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_tokens.dart';

/// Cor da marca por omissão (white-label: configurável por instituição).
const Color defaultBrandColor = Color(0xFF0B3D91);

const String appFontFamily = 'Inter';
const String appMonoFontFamily = 'monospace';

/// Constrói o tema Material 3 claro/escuro a partir da cor da marca.
abstract final class AppTheme {
  static ThemeData light([Color brand = defaultBrandColor]) =>
      _build(brand, Brightness.light);

  static ThemeData dark([Color brand = defaultBrandColor]) =>
      _build(brand, Brightness.dark);

  static ThemeData _build(Color brand, Brightness brightness) {
    final scheme = ColorScheme.fromSeed(
      seedColor: brand,
      brightness: brightness,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: appFontFamily,
    );
    final inputBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.input),
    );
    return base.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [
        brightness == Brightness.light ? AppColors.light : AppColors.dark,
      ],
      cardTheme: CardThemeData(
        elevation: AppElevation.low,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: AppElevation.high,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: inputBorder,
        enabledBorder: inputBorder,
        focusedBorder: inputBorder.copyWith(
          borderSide: BorderSide(color: scheme.primary, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, AppSizes.minTouchTarget),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, AppSizes.minTouchTarget),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(0, AppSizes.minTouchTarget),
        ),
      ),
    );
  }
}

/// Estilo monoespaçado para números e códigos.
extension AppMonoText on TextTheme {
  TextStyle get mono => (bodyMedium ?? const TextStyle()).copyWith(
    fontFamily: appMonoFontFamily,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
