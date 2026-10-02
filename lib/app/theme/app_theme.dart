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
      borderSide: BorderSide(color: scheme.outlineVariant),
    );
    // Superfícies em dois níveis: fundo da página ligeiramente tingido e
    // cartões planos com contorno subtil (mais legível que sombras).
    final light = brightness == Brightness.light;
    final pageBackground = light
        ? scheme.surfaceContainerLow
        : scheme.surfaceContainerLowest;
    final cardColor = light
        ? scheme.surfaceContainerLowest
        : scheme.surfaceContainer;
    return base.copyWith(
      materialTapTargetSize: MaterialTapTargetSize.padded,
      scaffoldBackgroundColor: pageBackground,
      extensions: [light ? AppColors.light : AppColors.dark],
      appBarTheme: AppBarTheme(
        backgroundColor: pageBackground,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: AppElevation.none,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: pageBackground,
      ),
      cardTheme: CardThemeData(
        elevation: AppElevation.none,
        color: cardColor,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.6)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: scheme.outlineVariant.withValues(alpha: 0.6),
        space: 1,
      ),
      dataTableTheme: DataTableThemeData(
        headingTextStyle: base.textTheme.labelLarge?.copyWith(
          color: scheme.onSurfaceVariant,
        ),
        dividerThickness: 1,
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: const WidgetStatePropertyAll(AppElevation.none),
        backgroundColor: WidgetStatePropertyAll(cardColor),
        side: WidgetStatePropertyAll(BorderSide(color: scheme.outlineVariant)),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        elevation: AppElevation.high,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.modal),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
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
